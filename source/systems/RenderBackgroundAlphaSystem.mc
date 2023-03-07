import Toybox.Math;
import Toybox.Lang;

class RenderBackgroundAlphaSystem {
    static function create(components) as RenderBackgroundAlphaSystem {
        return new RenderBackgroundAlphaSystem(components);
    }

    static function isCompatible(entity) {
        return entity.hasKey(:backgroundAlpha);
    }

    var components;
    var engine;
    var background;

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
    }

    function init() {
        self.background = WatchUi.loadResource(Rez.Fonts.backgroundAlpha);
    }

    function render(dc, context) {
        context.dc.setColor(0xaaffff, Graphics.COLOR_TRANSPARENT);
        context.dc.drawText(0, 0, self.background, "6", Graphics.TEXT_JUSTIFY_LEFT);
    }
}
