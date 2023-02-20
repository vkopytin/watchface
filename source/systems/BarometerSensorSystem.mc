import Toybox.Lang;
import Toybox.Math;
import Toybox.Activity;
import Toybox.Graphics;
import Toybox.System;

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
    var accumulatedTime = self.fastUpdate + 1 as Long;

    function initialize(components) {
        self.engine = components[:engine] as Engine;
        self.barometer = components[:barometer] as BarometerSensorComponent;
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime as Long) {
        self.accumulatedTime += deltaTime;
        if (self.accumulatedTime < self.fastUpdate) {
            return;
        }

        self.accumulatedTime = 0;

        var screenCenterPoint = self.engine.centerPoint;
        var moveMatrix = [screenCenterPoint];
        self.barometer.point = add([self.barometer.position], moveMatrix)[0];

        var pressure = self.barometer.pressure;
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
            var pressureHistory = Toybox.SensorHistory.getPressureHistory({});
            var sample = pressureHistory.next();
            pressure = sample.data;
        } else if (Activity.getActivityInfo().rawAmbientPressure != null) {
            pressure = Activity.getActivityInfo().rawAmbientPressure;
        } else if (Activity.getActivityInfo().ambientPressure != null) {
            pressure = Activity.getActivityInfo().ambientPressure;
        }

        if (System.getDeviceSettings().temperatureUnits == System.UNIT_METRIC) {
            pressure = pressure / 100.0;
        } else {
            pressure = pressure / 100.0 * 0.02953; // inches of mercury
        }

        self.barometer.pressure = pressure;
    }

    function render(dc, context) {
        var point = self.barometer.point;
        var pressureStr = self.barometer.pressure.format("%.1f");

        dc.setColor(self.barometer.color, Graphics.COLOR_TRANSPARENT);
		dc.drawText(point[0], point[1], Graphics.FONT_SYSTEM_XTINY, pressureStr, Graphics.TEXT_JUSTIFY_LEFT); // pressure in hPa

        var point2 = self.engine.centerPoint;
        var degrees = 1.0 * self.barometer.pressure;
        var radius = 100;

        drawGauge(dc, point2, degrees, 100, -120, 120, self.barometer.ranges, self.barometer.colors);
    }
}

function drawGauge(dc, point, value, radius, start, end, gaugeRanges, gaugeColors) {
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

class UpdateBarometerSensor {
    function exec(entitiy, components) {
        var context = components[:context];
        var barometer = components[:barometer];
        var gauge = components[:gauge];
        var titles = components[:titles];

        barometer.accumulatedTime -= context.deltaTime;
        if (barometer.accumulatedTime > 0) {
            return;
        }

        barometer.accumulatedTime = barometer.fastUpdate;

        var screenCenterPoint = context.centerPoint;
        var moveMatrix = [screenCenterPoint];
        barometer.point = add([barometer.position], moveMatrix)[0];

        var pressure = barometer.pressure;
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
            var pressureHistory = Toybox.SensorHistory.getPressureHistory({});
            var sample = pressureHistory.next();
            pressure = sample.data;
        } else if (Activity.getActivityInfo().rawAmbientPressure != null) {
            pressure = Activity.getActivityInfo().rawAmbientPressure;
        } else if (Activity.getActivityInfo().ambientPressure != null) {
            pressure = Activity.getActivityInfo().ambientPressure;
        }

        if (System.getDeviceSettings().temperatureUnits == System.UNIT_METRIC) {
            pressure = pressure / 100.0;
        } else {
            pressure = pressure / 100.0 * 0.02953; // inches of mercury
        }

        barometer.pressure = pressure;
        barometer.pressureStr = barometer.pressure.format("%.1f");

        titles.color = barometer.color;
        titles.titles = [
            [barometer.point[0], barometer.point[1], Graphics.FONT_SYSTEM_XTINY, barometer.pressureStr, Graphics.TEXT_JUSTIFY_LEFT]
        ]; // pressure in hPa

        gauge.color = barometer.color;
        gauge.point = context.centerPoint;
        gauge.value = 1.0 * barometer.pressure;
        gauge.radius = 100;
        gauge.ranges = barometer.ranges;
        gauge.colors = barometer.colors;
    }
}

function makeUpdateBarometerSensorDelegate() {
    return new UpdateBarometerSensor();
}
