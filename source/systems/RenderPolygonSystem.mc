using Toybox.Lang;

class RenderPolygonSystem {
    static function setup(systems, entity, api) {
        if (entity.hasKey(:engine) and entity.hasKey(:polygon)) {
            systems.add(new RenderPolygonSystem(entity));
        }
    }

    var components;
    var engine as Engine;
    var polygon as ShapeComponent;
    var buffer = true;

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
        self.polygon = components[:polygon];
        if (components.hasKey(:buffer)) {
            self.buffer = components[:buffer];
        }
    }

    function init() {
        
    }

    function render(dc, context) {
        var length = self.polygon.mesh.size();
        if (self.buffer) {
            for (var index = 0; index < length; index += 1) {
                var mesh = self.polygon.mesh[index];
                context.dc.setColor(mesh[0], Graphics.COLOR_TRANSPARENT);
                context.dc.fillPolygon(mesh[1]);
            }
        } else {
            dc.drawScaledBitmap(0, 0, self.engine.width, self.engine.height, self.engine.context.buffer);
            for (var index = 0; index < length; index += 1) {
                var mesh = self.polygon.mesh[index];
                dc.setColor(mesh[0], Graphics.COLOR_TRANSPARENT);
                dc.fillPolygon(mesh[1]);
            }
        }
    }
}
