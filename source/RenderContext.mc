import Toybox.Graphics;

function renderContextCreate() as RenderContext {
    var inst = new RenderContext();

    return inst;
}

class RenderContext {
    var lastColor = [Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT];
    var buffer as Graphics.BufferedBitmapReference;
    var dc;

    function initialize() {
        self.buffer = Graphics.createBufferedBitmap({
            :width => 260,
            :height => 260,
        });
        self.dc = self.buffer.get().getDc();
    }

    function setColor(dc, foreColor, backColor) {
        if (self.lastColor[0] != foreColor or self.lastColor[1] != backColor) {
            dc.setColor(foreColor, backColor);
            self.lastColor[0] = foreColor;
            self.lastColor[1] = backColor;
        }
    }
}
