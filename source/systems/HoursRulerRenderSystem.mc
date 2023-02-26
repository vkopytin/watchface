import Toybox.Math;
import Toybox.Lang;

class HoursRulerRenderSystem {
    static function create(components) as HoursRulerRenderSystem {
        return new HoursRulerRenderSystem(components);
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

    function update(deltaTime) {

    }

    function render(dc, context) {
        dc.setColor(0, Graphics.COLOR_BLACK);
        dc.setClip(56, 77, 80, 62);
        dc.clear();
        dc.drawBitmap(56, self.ruler.deltaIndex, self.rulerRes);
        dc.clearClip();
    }
}
