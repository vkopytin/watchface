function renderContextCreate() as RenderContext {
    var inst = new RenderContext();

    return inst;
}

class RenderContext {
    var lastColor = [Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT];

    function setColor(dc, foreColor, backColor) {
        if (self.lastColor[0] != foreColor or self.lastColor[1] != backColor) {
            dc.setColor(foreColor, backColor);
            self.lastColor[0] = foreColor;
            self.lastColor[1] = backColor;
        }
    }
}
