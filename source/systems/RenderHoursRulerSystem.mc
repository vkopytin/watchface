import Toybox.Math;
import Toybox.Lang;
import Toybox.Graphics;

class RenderHoursRulerSystem {
    static function create(components) as RenderHoursRulerSystem {
        return new RenderHoursRulerSystem(components);
    }

    static function isCompatible(entity) {
        return entity.hasKey(:hoursRuler);
    }

    var engine;
    var time;
    var ruler;
    var rulerRes;

    function initialize(components) {
        self.engine = components[:engine];
        self.ruler = components[:hoursRuler];
    }

    function init() {
        self.rulerRes = WatchUi.loadResource(Rez.Drawables.hoursRuler);
    }

    function render(dc, context) {
        dc.setColor(0xaaffff, 0xaaffff);
        dc.setClip(56, 97, 80, 62);
        dc.clear();
        dc.drawBitmap(56, self.ruler.deltaIndex, self.rulerRes);
        dc.clearClip();
    }
}
