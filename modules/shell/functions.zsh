show() {
	echo ""
	kitty +kitten icat "$1"
	echo ""
}
compdef '_files -g "*.{png,jpg,jpeg,gif,webp,svg}"' show
