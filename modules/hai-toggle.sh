#!/bin/bash
# ============================================================
#  hai-toggle — Switch Claude Code between proxy and direct mode
#
#  Cross-platform: macOS, Linux, and Windows via WSL or Git Bash.
#
#  Usage:
#    hai-toggle proxy [IP]  → Route Claude Code through LAN proxy
#    hai-toggle direct      → Route Claude Code directly to Anthropic
#    hai-toggle status      → Show current routing mode
#    hai-toggle             → Toggle between modes
#
#  Install (macOS / Linux / WSL):
#    cp hai-toggle.sh ~/.local/bin/hai-toggle && chmod +x ~/.local/bin/hai-toggle
#
#  Install (Git Bash on Windows):
#    mkdir -p ~/bin && cp hai-toggle.sh ~/bin/hai-toggle
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ─── CONFIG ─────────────────────────────────────────────────────────

BRIDGE_PORT=6656
STATE_FILE="$HOME/.hai-toggle-state"

# Claude Code settings file location — same on all platforms
CLAUDE_SETTINGS_DIR="$HOME/.claude"
CLAUDE_SETTINGS_FILE="$CLAUDE_SETTINGS_DIR/settings.json"

# ─── OS DETECTION ───────────────────────────────────────────────────

detect_os() {
  case "$(uname -s)" in
    Darwin)  echo "macos" ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*) echo "gitbash" ;;
    *) echo "unknown" ;;
  esac
}

OS=$(detect_os)

# ─── HELPERS ────────────────────────────────────────────────────────

get_current_mode() {
  if [ -f "$STATE_FILE" ]; then
    cat "$STATE_FILE"
  else
    echo "direct"
  fi
}

# Scan the LAN for the HAI bridge. Tries the cached IP first, then a
# parallel TCP port scan via Node.js (cross-platform, no nmap needed).
get_proxy_ip() {
  # Fast path: cached IP still responsive
  if [ -f "$STATE_FILE.ip" ]; then
    CACHED_IP=$(cat "$STATE_FILE.ip")
    if curl -s --connect-timeout 2 "http://${CACHED_IP}:${BRIDGE_PORT}/" 2>/dev/null | grep -q "Hai Proxy"; then
      echo "$CACHED_IP"
      return 0
    fi
  fi

  echo -e "  ${DIM}Scanning network for HAI bridge on port ${BRIDGE_PORT}...${NC}" >&2

  # Build list of subnet prefixes to scan
  PREFIXES=""
  case "$OS" in
    macos)
      for iface in en0 en1; do
        IP=$(ipconfig getifaddr "$iface" 2>/dev/null || true)
        [ -n "$IP" ] && PREFIXES="$PREFIXES $(echo "$IP" | sed 's/\.[0-9]*$//')"
      done
      ;;
    wsl|linux)
      while IFS= read -r ip; do
        PREFIXES="$PREFIXES $(echo "$ip" | sed 's/\.[0-9]*$//')"
      done < <(ip -4 addr show 2>/dev/null | grep -oP 'inet \K[\d.]+' | grep -v '^127\.')
      ;;
    gitbash)
      while IFS= read -r ip; do
        PREFIXES="$PREFIXES $(echo "$ip" | sed 's/\.[0-9]*$//')"
      done < <(ipconfig 2>/dev/null | grep -oP '(?<=IPv4 Address[. :]+)[\d.]+' | grep -v '^169\.')
      ;;
  esac

  # Always include common home/office subnets as fallback
  PREFIXES="$PREFIXES 10.0.0 192.168.0 192.168.1 192.168.4"
  PREFIXES=$(echo "$PREFIXES" | tr ' ' '\n' | sort -u | grep -v '^$' | tr '\n' ' ')

  # Parallel scan via Node.js — works on every platform that has node
  FOUND_IP=$(node -e "
    const net = require('net');
    const http = require('http');
    const prefixes = '${PREFIXES}'.trim().split(/\s+/).filter(Boolean);
    const port = ${BRIDGE_PORT};
    const timeout = 800;
    const maxParallel = 80;

    async function probe(ip) {
      return new Promise(resolve => {
        const sock = new net.Socket();
        sock.setTimeout(timeout);
        sock.on('connect', () => { sock.destroy(); resolve(ip); });
        sock.on('timeout', () => { sock.destroy(); resolve(null); });
        sock.on('error', () => { sock.destroy(); resolve(null); });
        sock.connect(port, ip);
      });
    }

    async function verify(ip) {
      return new Promise(resolve => {
        http.get('http://'+ip+':'+port+'/', {timeout:2000}, res => {
          let d=''; res.on('data',c=>d+=c);
          res.on('end',()=>resolve(d.includes('Hai Proxy')?ip:null));
        }).on('error',()=>resolve(null))
          .on('timeout',function(){this.destroy();resolve(null);});
      });
    }

    async function main() {
      for (const prefix of prefixes) {
        const batch = [];
        for (let i = 1; i <= 254; i++) {
          batch.push(probe(prefix+'.'+i));
          if (batch.length >= maxParallel) {
            const hits = (await Promise.all(batch)).filter(Boolean);
            for (const ip of hits) {
              const ok = await verify(ip);
              if (ok) { console.log(ok); process.exit(0); }
            }
            batch.length = 0;
          }
        }
        if (batch.length) {
          const hits = (await Promise.all(batch)).filter(Boolean);
          for (const ip of hits) {
            const ok = await verify(ip);
            if (ok) { console.log(ok); process.exit(0); }
          }
        }
      }
      process.exit(1);
    }
    main();
  " 2>/dev/null) && STATUS=$? || STATUS=$?

  if [ "$STATUS" -eq 0 ] && [ -n "$FOUND_IP" ]; then
    echo "$FOUND_IP" > "$STATE_FILE.ip"
    echo "$FOUND_IP"
    return 0
  fi

  return 1
}

discover_or_prompt() {
  HOST_IP=$(get_proxy_ip 2>/dev/null) || true

  if [ -z "$HOST_IP" ]; then
    echo ""
    echo -e "  ${YELLOW}Could not auto-discover HAI bridge.${NC}"
    echo -e "  ${DIM}Make sure the host machine has enable-share.sh running.${NC}"
    if [ "$OS" = "wsl" ]; then
      echo -e "  ${DIM}On WSL: the host IP is your Windows machine's LAN IP (not 127.0.0.1).${NC}"
    fi
    echo ""
    read -rp "  Enter host IP manually (or q to quit): " HOST_IP
    [ "$HOST_IP" = "q" ] || [ -z "$HOST_IP" ] && exit 1
    echo "$HOST_IP" > "$STATE_FILE.ip"
  fi

  echo "$HOST_IP"
}

# ─── ACTIVATE PROXY MODE ───────────────────────────────────────────

activate_proxy() {
  HOST_IP="$1"

  if [ -z "$HOST_IP" ]; then
    HOST_IP=$(discover_or_prompt)
  fi

  PROXY_URL="http://${HOST_IP}:${BRIDGE_PORT}/anthropic/"

  echo -e "  ${DIM}Testing ${PROXY_URL} ...${NC}"
  if ! curl -s --connect-timeout 3 "http://${HOST_IP}:${BRIDGE_PORT}/" 2>/dev/null | grep -q "Hai Proxy"; then
    echo -e "  ${RED}[ERROR]${NC} Cannot reach HAI bridge at ${HOST_IP}:${BRIDGE_PORT}"
    echo -e "  ${DIM}Is enable-share.sh running on the host?${NC}"
    if [ "$OS" = "wsl" ]; then
      echo -e "  ${DIM}Also check that Windows Firewall allows TCP ${BRIDGE_PORT} inbound.${NC}"
    fi
    exit 1
  fi
  echo -e "  ${GREEN}[OK]${NC} Bridge reachable"

  # Update ~/.claude/settings.json via Node.js (safe JSON manipulation)
  node -e "
    const fs = require('fs');
    const file = process.argv[1];
    let settings = {};
    try { settings = JSON.parse(fs.readFileSync(file, 'utf8')); } catch {}
    if (!settings.env) settings.env = {};
    settings.env.ANTHROPIC_BASE_URL = '$PROXY_URL';
    settings.env.ANTHROPIC_AUTH_TOKEN = '94986bba-d10c-4b33-833e-fbb4620c8960';
    fs.mkdirSync(require('path').dirname(file), { recursive: true });
    fs.writeFileSync(file, JSON.stringify(settings, null, 2));
  " "$CLAUDE_SETTINGS_FILE"

  # Write sourceable env file (for current shell session)
  cat > "$STATE_FILE.env" << ENVEOF
export ANTHROPIC_BASE_URL="${PROXY_URL}"
export ANTHROPIC_AUTH_TOKEN="94986bba-d10c-4b33-833e-fbb4620c8960"
ENVEOF

  echo "proxy" > "$STATE_FILE"
  echo "$HOST_IP" > "$STATE_FILE.ip"

  echo ""
  local line2="Claude Code -> ${HOST_IP}:${BRIDGE_PORT} -> HAI"
  echo -e "  ${GREEN}╔════════════════════════════════════════════════╗${NC}"
  printf "  ${GREEN}║${NC}  %-44s  ${GREEN}║${NC}\n" "PROXY MODE ACTIVE"
  printf "  ${GREEN}║${NC}  %-44s  ${GREEN}║${NC}\n" "$line2"
  echo -e "  ${GREEN}╚════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ${DIM}Restart Claude Code for changes to take effect.${NC}"
  echo -e "  ${DIM}Or source the env: source ${STATE_FILE}.env${NC}"
  echo ""
  echo -e "  To switch back: ${BOLD}hai-toggle direct${NC}"
  echo ""
}

# ─── ACTIVATE DIRECT MODE ──────────────────────────────────────────

activate_direct() {
  node -e "
    const fs = require('fs');
    const file = process.argv[1];
    let settings = {};
    try { settings = JSON.parse(fs.readFileSync(file, 'utf8')); } catch { return; }
    if (settings.env) {
      delete settings.env.ANTHROPIC_BASE_URL;
      delete settings.env.ANTHROPIC_AUTH_TOKEN;
      if (Object.keys(settings.env).length === 0) delete settings.env;
    }
    fs.writeFileSync(file, JSON.stringify(settings, null, 2));
  " "$CLAUDE_SETTINGS_FILE"

  cat > "$STATE_FILE.env" << 'ENVEOF'
unset ANTHROPIC_BASE_URL
unset ANTHROPIC_AUTH_TOKEN
ENVEOF

  echo "direct" > "$STATE_FILE"

  echo ""
  echo -e "  ${CYAN}╔════════════════════════════════════════════════╗${NC}"
  printf "  ${CYAN}║${NC}  %-44s  ${CYAN}║${NC}\n" "DIRECT MODE ACTIVE"
  printf "  ${CYAN}║${NC}  %-44s  ${CYAN}║${NC}\n" "Claude Code -> api.anthropic.com"
  echo -e "  ${CYAN}╚════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ${DIM}Restart Claude Code for changes to take effect.${NC}"
  echo ""
  echo -e "  To switch back: ${BOLD}hai-toggle proxy${NC}"
  echo ""
}

# ─── STATUS ─────────────────────────────────────────────────────────

show_status() {
  MODE=$(get_current_mode)
  echo ""
  if [ "$MODE" = "proxy" ]; then
    IP=$(cat "$STATE_FILE.ip" 2>/dev/null || echo "unknown")
    echo -e "  ${GREEN}●${NC} Mode: ${GREEN}${BOLD}PROXY${NC}"
    echo -e "  ${DIM}  Routing through: ${IP}:${BRIDGE_PORT}${NC}"
    if curl -s --connect-timeout 2 "http://${IP}:${BRIDGE_PORT}/" 2>/dev/null | grep -q "Hai Proxy"; then
      echo -e "  ${GREEN}  Bridge: reachable${NC}"
    else
      echo -e "  ${RED}  Bridge: unreachable${NC}"
    fi
  else
    echo -e "  ${CYAN}●${NC} Mode: ${CYAN}${BOLD}DIRECT${NC}"
    echo -e "  ${DIM}  Routing: Claude Code → api.anthropic.com${NC}"
  fi
  echo ""
}

# ─── MAIN ───────────────────────────────────────────────────────────

case "${1:-}" in
  proxy|on|enable)
    activate_proxy "${2:-}"
    ;;
  direct|off|disable|reset)
    activate_direct
    ;;
  status|s)
    show_status
    ;;
  "")
    MODE=$(get_current_mode)
    if [ "$MODE" = "proxy" ]; then
      echo -e "  ${DIM}Currently: proxy → switching to direct${NC}"
      activate_direct
    else
      echo -e "  ${DIM}Currently: direct → switching to proxy${NC}"
      activate_proxy
    fi
    ;;
  -h|--help|help)
    echo ""
    echo -e "  ${BOLD}hai-toggle${NC} — Switch Claude Code between proxy and direct mode"
    echo ""
    echo "  Usage:"
    echo "    hai-toggle proxy [IP]   Route through LAN proxy (auto-discovers if no IP)"
    echo "    hai-toggle direct       Route directly to Anthropic"
    echo "    hai-toggle status       Show current mode"
    echo "    hai-toggle              Toggle between modes"
    echo ""
    echo "  Aliases: proxy/on/enable | direct/off/disable/reset"
    echo ""
    ;;
  *)
    echo -e "  ${RED}Unknown command:${NC} $1"
    echo "  Usage: hai-toggle [proxy|direct|status]"
    exit 1
    ;;
esac
