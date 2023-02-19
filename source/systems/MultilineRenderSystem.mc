using Toybox.Lang;

function multilineRenderSystemCreate(components) as MultilineRenderSystem {
    var inst = new MultilineRenderSystem(components);

    return inst;
}

function multilineRenderSystemIsCompatible(entity) {
    return entity.hasKey(:polygon) and entity.hasKey(:multiline);
}

class MultilineRenderSystem {
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
        dc.setColor(0xaaffaa, Graphics.COLOR_TRANSPARENT);
        var length = self.polygon.mesh.size();
        for (var index = 0; index < length; index += 1) {
            var mesh = self.polygon.mesh[index];
            drawMultiLine(dc, mesh);
        }
    }
}

function drawMultiLine(dc, polygon as Lang.Array<Lang.Array<Lang.Numeric>>) as Void {
    var length = polygon.size();
    if (length < 2) {
        return;
    }

    var pointTo = [];
    for (var index = 1; index < length; index += 1) {
        var pointFrom = polygon[index - 1];
        pointTo = polygon[index];

        dc.drawLine(pointFrom[0], pointFrom[1], pointTo[0], pointTo[1]);
    }

    dc.setPenWidth(1);
    dc.drawLine(pointTo[0], pointTo[1], polygon[0][0], polygon[0][1]);
}
