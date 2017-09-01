
function widRectNumPage(width) {
    if(1 <= width <= 9) return 40
    else if(10 <= width <= 99) return 64
    else if(100 <= width <= 999) return 200
}
