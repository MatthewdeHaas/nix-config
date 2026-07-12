local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = { { name = "luasnip" } },
})

local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

ls.setup({
	enable_autosnippets = true,
})

ls.add_snippets("tex", {
	s({trig = "mk", wordTrig = true, snippetType = "autosnippet"},
	  fmta("$<>$", { i(1) })
	),

	s({trig = "dm", snippetType = "autosnippet"},
	  fmta("\\[\n\t<>\n\\]", { i(1) })
	),

	s({trig = "ali", snippetType = "autosnippet"},
	  fmta("\\begin{align*}\n\t<>\n\\end{align*}", { i(1) })
	),

	s({trig = "([%w_^]+)/", trigEngine = "pattern", snippetType = "autosnippet"},
		fmta("\\frac{<>}{<>}", {
			f(function(_, snip) return snip.captures[1] end),
			i(1),
		})
	),
})
