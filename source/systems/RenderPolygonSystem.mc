using Toybox.Lang;

class RenderPolygonSystem {
    static function create(components) as RenderPolygonSystem {
        var inst = new RenderPolygonSystem(components);

        return inst;
    }

    static function isCompatible(entity) {
        return entity.hasKey(:polygon);
    }

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
