import Toybox.Lang;
import Toybox.Math;
import Toybox.Activity;
import Toybox.Graphics;

function barometerSensorSystemCreate(components) as BarometerSensorSystem {
    var inst = new BarometerSensorSystem(components);

    return inst;
}

function barometerSensorSystemIsCompatible(entity) as Boolean {
    return entity.hasKey(:barometer);
}

class BarometerSensorSystem {
    var engine as Engine;
    var barometer as BarometerSensorComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (60 * 1000) as Long; // keep fast updates for min
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.engine = components[:engine] as Engine;
        self.barometer = components[:barometer] as BarometerSensorComponent;
        self.stats = components[:stats];
    }

    function init() {
        self.barometer.temperatureUnits = System.getDeviceSettings().temperatureUnits;
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var screenCenterPoint = self.engine.centerPoint;
        var moveMatrix = [screenCenterPoint];
        self.barometer.point = add([self.barometer.position], moveMatrix)[0];

        var pressure = self.barometer.pressure;
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
            var pressureHistory = Toybox.SensorHistory.getPressureHistory({});
            var sample = pressureHistory.next();
            pressure = sample.data;
        } else {
            var activity = Activity.getActivityInfo();
            if (activity.rawAmbientPressure != null) {
                pressure = activity.rawAmbientPressure;
            } else if (activity.ambientPressure != null) {
                pressure = activity.ambientPressure;
            }
        }

        if (self.barometer.temperatureUnits == System.UNIT_METRIC) {
            pressure = pressure / 100.0;
        } else {
            pressure = pressure / 100.0 * 0.02953; // inches of mercury
        }

        self.barometer.pressure = pressure;
        self.barometer.pressureStr = self.barometer.pressure.format("%.1f");
    }

    function render(dc, context) {
        var point = self.barometer.point;

        context.dc.setColor(self.barometer.color, Graphics.COLOR_TRANSPARENT);
		context.dc.drawText(point[0], point[1], Graphics.FONT_SYSTEM_XTINY, self.barometer.pressureStr, Graphics.TEXT_JUSTIFY_LEFT); // pressure in hPa

        var point2 = self.engine.centerPoint;
        var degrees = 1.0 * self.barometer.pressure;
        var radius = 130;

        //drawGauge(dc, point2, degrees, 125, 170, 60, self.barometer.ranges, self.barometer.colors);
        drawArrow(context.dc, point2, degrees, radius);
    }
}

function drawArrow(dc, point, value, radius) {
    var maxRangeDegree = 52;
    var minValue = 950.0;
    var maxValue = 1070.0;
    var range = maxValue - minValue;
    var gaugeArrowCoords = [
        [-3, radius + 2],
        [-3, radius - 2],
        [0, radius - 7],
        [3, radius - 2],
        [3, radius + 2],
    ];
    var arrowLength = gaugeArrowCoords.size();
    var arrowDegree = -88 -maxRangeDegree / range * (value - minValue);
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

    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.fillPolygon(arrowMesh);
    dc.setColor(0x005555, Graphics.COLOR_TRANSPARENT);
    drawMultiLine(dc, arrowMesh);
}

function drawGauge(dc, point, value, radius, startDegree, rangeDegree, gaugeRanges, gaugeColors) {
    var colorsLength = gaugeColors.size();
    var minValue = 930.0;
    var maxValue = 1070.0;
    var range = maxValue - minValue;
    var stroke = 6;
    var minDegree = startDegree;
    var maxRangeDegree = rangeDegree;

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

    drawArrow(dc, point, value, radius);
}
