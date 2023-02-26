import Toybox.Math;
import Toybox.Lang;

class SecondsRulerRenderSystem {
    static function create(components) as SecondsRulerRenderSystem {
        return new SecondsRulerRenderSystem(components);
    }

    static function isCompatible(entity) {
        return entity.hasKey(:ruler);
    }

    var engine;
    var time;
    var ruler;
    var rulerRes;

    function initialize(components) {
        self.engine = components[:engine];
        self.ruler = components[:ruler];
    }

    function init() {
        self.rulerRes = WatchUi.loadResource(Rez.Drawables.ruler);
    }

    function update(deltaTime) {

    }

    function render(dc, context) {
        dc.setColor(0, Graphics.COLOR_BLACK);
        dc.setClip(58, 180, 166, 16);
        dc.clear();
        dc.drawBitmap(ruler.deltaIndex, 180, self.rulerRes);
        dc.clearClip();
    }
}
