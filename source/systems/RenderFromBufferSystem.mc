import Toybox.Math;
import Toybox.Lang;

class RenderFromBufferSystem {
    static function setup(systems, entity, api) {
        if (entity.hasKey(:fromBuffer)) {
            systems.add(new RenderFromBufferSystem(entity));
        }
    }

    var components;
    var engine;

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
    }

    function init() {

    }

    function render(dc, context) {
        dc.drawScaledBitmap(
            0, 0,
            self.engine.width, self.engine.height,
            self.engine.context.buffer
        );
    }
}
