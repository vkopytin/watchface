import Toybox.Lang;
import Toybox.Graphics;

function polygonRenderSystemCreate(components) as PolygonRenderSystem {
    var inst = new PolygonRenderSystem(components);

    return inst;
}

function polygonRenderSystemCreateIsCompatible(entity) {
    return entity.hasKey(:polygon);
}

class PolygonRenderSystem {
    var polygon as ShapeComponent;
    var stats as PerformanceStatisticsComponent;

    function initialize(components) {
        self.polygon = components[:polygon];
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime) {

    }
    
    function render(dc, context) {
        dc.setColor(self.polygon.color, Graphics.COLOR_TRANSPARENT);
        var length = self.polygon.mesh.size();
        for (var index = 0; index < length; index += 1) {
            var mesh = self.polygon.mesh[index];
            dc.fillPolygon(mesh);
        }
    }
}

class RenderPolygon {
function exec(entity, components) {
    var context = components[:context];
    var polygon = components[:polygon];
    if (context.dc == null) {
        return;
    }

    var dc = context.dc;

    dc.setColor(polygon.color, Graphics.COLOR_TRANSPARENT);
    var length = polygon.mesh.size();
    for (var index = 0; index < length; index += 1) {
        var mesh = polygon.mesh[index];
        dc.fillPolygon(mesh);
    }
}
}

function makeRenderPolygonDelegate() {
    var inst = new RenderPolygon();

    return inst;
}
