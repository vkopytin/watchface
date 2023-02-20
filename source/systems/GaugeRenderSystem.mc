import Toybox.Lang;
import Toybox.Math;
import Toybox.Graphics;

function makeRenderGaugeDelegate() {
    return new RenderGauge();
}

class RenderGauge {
function exec(entity, components) {
    var context = components[:context];
    var gauge = components[:gauge];

    if (context.dc == null) {
        return;
    }
    var dc = context.dc;

    var point2 = context.centerPoint;
    var degrees = 1.0 * gauge.value;
    var radius = gauge.radius;

    drawGauge1(dc, gauge.point, degrees, gauge.radius, -120, 120, gauge.ranges, gauge.colors);
}
}

function drawGauge1(dc, point, value, radius, start, end, gaugeRanges, gaugeColors) {
    var colorsLength = gaugeColors.size();
    var minValue = 930.0;
    var maxValue = 1070.0;
    var range = maxValue - minValue;
    var stroke = 6;
    var minDegree = 120;
    var maxRangeDegree = 120;

    for (var index = colorsLength; index > 0; index -= 1) {
        dc.setPenWidth(stroke);
        var color = gaugeColors[index - 1];
        var currentValue = gaugeRanges[index];
        var valueToDegree = maxRangeDegree / range * (currentValue - minValue);
        var minToDegree = maxRangeDegree / range * (gaugeRanges[index - 1] - minValue);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
            point[0], point[1],
            radius,
            Graphics.ARC_CLOCKWISE , -minDegree -minToDegree, -minDegree -valueToDegree
        );
    }

    dc.setPenWidth(1);

    var gaugeArrowCoords = [
        [-2, radius - 10],
        [0, radius + 10],
        [2, radius - 10],
    ];
    var arrowLength = gaugeArrowCoords.size();
    var arrowDegree = 30 + maxRangeDegree / range * (value - minValue);
    var angle = Math.PI * arrowDegree / 180;
    
    var sinCos = [Math.cos(angle), Math.sin(angle)];
    var transformMatrix = [
        sinCos,
        [-sinCos[1], sinCos[0]],
    ];
    var moveMatrix = [point];

    var arrowMesh = new [arrowLength];
    for (var index = 0; index < arrowLength; index += 1) {
        arrowMesh[index] = add(multiply([gaugeArrowCoords[index]], transformMatrix), moveMatrix)[0];
    }

    dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
    dc.fillPolygon(arrowMesh);
}
