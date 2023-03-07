using Toybox.Lang;

class RenderPolygonSystem {
    static function create(components) as RenderPolygonSystem {
        var inst = new RenderPolygonSystem(components);

        return inst;
    }

    static function isCompatible(entity) {
        return entity.hasKey(:engine) and entity.hasKey(:polygon);
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
            dc.drawBitmap(0, 0, self.engine.context.buffer);
            for (var index = 0; index < length; index += 1) {
                var mesh = self.polygon.mesh[index];
                dc.setColor(mesh[0], Graphics.COLOR_TRANSPARENT);
                dc.fillPolygon(mesh[1]);
            }
        }
    }
}
