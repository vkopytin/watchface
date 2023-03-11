import Toybox.Math;
import Toybox.Lang;
import Toybox.Graphics;

class RenderBackgroundSystem {
    static function setup(systems, entity, api) {
        if (entity.hasKey(:background)) {
            systems.add(new RenderBackgroundSystem(entity));
        }
    }

    var components;
    var engine;
    var background as Graphics.BitmapReference or Null;

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
