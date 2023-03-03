import Toybox.Math;
import Toybox.Lang;

class RenderSecondsRulerSystem {
    static function create(components) as RenderSecondsRulerSystem {
        return new RenderSecondsRulerSystem(components);
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

    function render(dc, context) {
        dc.setColor(0xaaffff, 0xaaffff);
        dc.setClip(58, 180, 166, 16);
        dc.clear();
        dc.drawBitmap(ruler.deltaIndex, 180, self.rulerRes);
        dc.clearClip();
    }
}
