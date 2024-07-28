import Toybox.Math;
import Toybox.Lang;

class RenderMinutesRulerSystem {
    static function create(components) as RenderMinutesRulerSystem {
        return new RenderMinutesRulerSystem(components);
    }

    static function isCompatible(entity) {
        return entity.hasKey(:minutesRuler);
    }

    var engine;
    var time;
    var ruler;
    var minutesOncesRuler;
    var minutesDescRuler;

    function initialize(components) {
        self.engine = components[:engine];
        self.ruler = components[:minutesRuler];
    }

    function init() {
        self.minutesOncesRuler = WatchUi.loadResource(Rez.Drawables.minutesOncesRuler);
        self.minutesDescRuler = WatchUi.loadResource(Rez.Drawables.minutesDescRuler);
    }

    function render(dc, context) {
        context.dc.setColor(0xaaffff, 0xaaffff);
        context.dc.setClip(146, 97, 73, 76);
        context.dc.clear();
        context.dc.drawBitmap(146, self.ruler.deltaIndex, self.minutesOncesRuler);
        context.dc.drawBitmap(150, self.ruler.deltaDecIndex, self.minutesDescRuler);
        context.dc.clearClip();
    }
}
