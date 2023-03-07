import Toybox.Math;
import Toybox.Lang;
import Toybox.Graphics;

class RenderBackgroundSystem {
    static function create(components) as RenderBackgroundSystem {
        return new RenderBackgroundSystem(components);
    }

    static function isCompatible(entity) {
        return entity.hasKey(:background);
    }

    var components;
    var engine;
    var background;

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
    }

    function init() {
        self.background = WatchUi.loadResource(Rez.Drawables.watchBackground);
    }

    function render(dc, context) {
        context.dc.drawBitmap(0, 0, self.background);
    }
}
