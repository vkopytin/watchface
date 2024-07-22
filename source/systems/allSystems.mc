import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
using Toybox.WatchUi;
import Toybox.Position;
using Toybox.UserProfile;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;
using Toybox.Weather;
using Toybox.Application;
using Toybox.Activity;

// ===== Weather system ========

/*
A - cloud moon
B - cloud sun
C - cloud wind moon
D - cloud wind sun
E - cloud wind
F - cloud
G - compas east
H - compas north
I - compas south
J - compas west
K - compas
L - degree celcius
M - degree farenheit
N - download
O - drizzle alt moon
P - drizzle alt sun
Q - drizzle alt
R - drizzle moon
S - drizzle sun
T - drizzle
U - fog moon
V - fog sun
W - fog
X - hail moon
Y - hail sun
Z - hail
a - hurricane
b - light
c - lightning moon
d - lightning rain moon
e - lightning rain sun
f - lightning rain
g - lightning sun
h - lightning
i - moon
j - rain alt moon
k - rain alt sun
l - rain alt
m - rain moon
n - rain sun
o - rain
p - snow alt moon
q - snow alt sun
r - snow alt
s - snow moon
t - snow sun
u - snow
v - sunrise
w - sunset
x - umbrella
y - upload
z - wind moon
{ - sun
0 - thermometr 0
1 - thermometr 1
2 - thermometr 2
3 - thermometr 3
4 - thrmometr full
5 - wind sun
6 - wind
7 - 
8 - 
9 - 
0 - 
*/
function weatherConditionToChar(condition, isDay as Boolean) {
    switch (condition) {
        case Weather.CONDITION_CLEAR:
        case Weather.CONDITION_MOSTLY_CLEAR:
            return isDay ? "i" : "{";
        case Weather.CONDITION_PARTLY_CLOUDY:
        case Weather.CONDITION_PARTLY_CLEAR:
            return isDay ? "B" : "A";
        case Weather.CONDITION_MOSTLY_CLOUDY:
        case Weather.CONDITION_CLOUDY:
            return "F";
        case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
            return "Q";
        case Weather.CONDITION_CHANCE_OF_SHOWERS:
            return "o";
        case Weather.CONDITION_CHANCE_OF_SNOW:
            return isDay ? "t" : "s";
        case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
            return "f";
        case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
            return isDay ? "k" : "j";
        case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
            return "Q";
        case Weather.CONDITION_DRIZZLE:
            return "T";
        case Weather.CONDITION_DUST:
            return "6";
        case Weather.CONDITION_FAIR:
            return "x";
        case Weather.CONDITION_FLURRIES:
            return "t";
        case Weather.CONDITION_FOG:
            return "W";
        case Weather.CONDITION_FREEZING_RAIN:
            return "r";
        case Weather.CONDITION_HAIL:
            return "Z";
        case Weather.CONDITION_HAZE:
            return "W";
        case Weather.CONDITION_HAZY:
            return isDay ? "V" : "U";
        case Weather.CONDITION_HEAVY_RAIN:
            return "f";
        case Weather.CONDITION_HEAVY_RAIN_SNOW:
            return "q";
        case Weather.CONDITION_TROPICAL_STORM:
        case Weather.CONDITION_HEAVY_SHOWERS:
            return "o";
        case Weather.CONDITION_HEAVY_SNOW:
            return "r";
        case Weather.CONDITION_HURRICANE:
            return "a";
        case Weather.CONDITION_ICE:
            return "r";
        case Weather.CONDITION_ICE_SNOW:
            return "r";
        case Weather.CONDITION_LIGHT_RAIN:
            return isDay ? "P" : "O";
        case Weather.CONDITION_LIGHT_RAIN_SNOW:
            return "t";
        case Weather.CONDITION_SCATTERED_SHOWERS:
        case Weather.CONDITION_LIGHT_SHOWERS:
            return "o";
        case Weather.CONDITION_LIGHT_SNOW:
            return isDay ? "t" : "s";
        case Weather.CONDITION_MIST:
            return "W";
        case Weather.CONDITION_RAIN:
            return "o";
        case Weather.CONDITION_RAIN_SNOW:
            return "Z";
        case Weather.CONDITION_SAND:
            return "6";
        case Weather.CONDITION_SANDSTORM:
            return "5";
        case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
            return "f";
        case Weather.CONDITION_TORNADO:
            return "a";
        case Weather.CONDITION_WINDY:
            return isDay ? "5" : "z";
        case Weather.CONDITION_WINTRY_MIX:
            return "E";
        default:
            return "-";
    }
}

function temperatureToChar(temperature) {
    if (temperature < 1) {
        return "0";
    } else if (temperature < 6) {
        return "1";
    } else if (temperature < 16) {
        return "2";
    } else if (temperature < 21) {
        return "3";
    } else {
        return "4";
    }
}

function temperatureUnitToChar(unit) {
    if (unit == System.UNIT_METRIC) {
        return "L"; // C - celcius
    }

    return "M"; // F - farenheit
}

function temperatureInCelcius(temperature) {
    if (System.getDeviceSettings().temperatureUnits == System.UNIT_METRIC) {
        return temperature;
    }

    return (temperature * 9/5) + 32; 
}

function initWeatherInfoSystem(components, api) {
    var weather = components[:weather];
    weather.weatherFont = Application.loadResource(Rez.Fonts.weather32);
}

function updateWaetherInfoSystem(components) {
    var deltaTime = components[:deltaTime];
    var weather = components[:weather];
    var sunPosition = components[:sunPosition];

    weather.accumulatedTime -= deltaTime;
    if (weather.accumulatedTime > 0) {
        return;
    }

    weather.accumulatedTime = weather.fastUpdate;

    var cond = Toybox.Weather.getCurrentConditions();
    if (cond == null) {
        return;
    }

    if (cond.condition != null) {
        weather.weatherChar = weatherConditionToChar(cond.condition, sunPosition.isDay);
    }

    try {
        weather.temperature = temperatureInCelcius(cond.temperature);
        weather.temperatureChar = temperatureToChar(weather.temperature);
        weather.temperatureUnitChar = temperatureUnitToChar(System.getDeviceSettings().temperatureUnits);
    } catch (ex) {

    }
}

function renderWeatherInfoSystem(components) {
    var dc = components[:dc];
    var context = components[:context];
    var weather = components[:weather];

    context.dc.setColor(weather.color, Graphics.COLOR_TRANSPARENT);

    if (weather.weatherChar != "-") {
        context.dc.drawText(weather.position[0], weather.position[1],
            weather.weatherFont, weather.weatherChar, Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    if (weather.temperatureChar != "-") {
        context.dc.drawText(
            weather.position[0] - 10, weather.position[1] + 28,
            weather.weatherFont, weather.temperatureChar, Graphics.TEXT_JUSTIFY_RIGHT
        );
    }

    context.dc.drawText(
        weather.position[0] + 10, weather.position[1] + 28,
        weather.weatherFont, weather.temperatureUnitChar, Graphics.TEXT_JUSTIFY_LEFT
    );
    context.dc.drawText(
        weather.position[0] + 1, weather.position[1] + 30,
        Graphics.FONT_SYSTEM_TINY, weather.temperature, Graphics.TEXT_JUSTIFY_CENTER
    );
}

function setupWeatherInfoSystem(systems, components) {
    if (components.hasKey(:weather) and components.hasKey(:update)) {
        systems.add([
            components,
            new Method({}, :updateWaetherInfoSystem),
            new Method({}, :initWeatherInfoSystem),
        ]);
    }
    if (components.hasKey(:weather) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderWeatherInfoSystem),
        ]);
    }
}

// ========= Barometer sensor system =======
function initBarometerSensorSystem(components, api) {
    var barometer = components[:barometer] as BarometerSensorComponent;

    barometer.temperatureUnits = System.getDeviceSettings().temperatureUnits;
}

function updateBarometerSensorSystem(components) {
    var deltaTime = components[:deltaTime];
    var engine = components[:engine];
    var barometer = components[:barometer] as BarometerSensorComponent;

    barometer.accumulatedTime -= deltaTime;
    if (barometer.accumulatedTime > 0) {
        return;
    }

    barometer.accumulatedTime = barometer.fastUpdate;

    var screenCenterPoint = engine.centerPoint;
    var moveMatrix = [screenCenterPoint];
    barometer.point = add([barometer.position], moveMatrix)[0];

    var pressure = barometer.pressure;
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

    if (barometer.temperatureUnits == System.UNIT_METRIC) {
        pressure = pressure / 100.0;
    } else {
        pressure = pressure / 100.0 * 0.02953; // inches of mercury
    }

    barometer.pressure = pressure;
    barometer.pressureStr = barometer.pressure.format("%.1f");
}

function renderBarometerSensorSystem(components) {
    var engine = components[:engine];
    var barometer = components[:barometer] as BarometerSensorComponent;
    var context = components[:context];
    var point = barometer.point;

    context.dc.setColor(barometer.color, Graphics.COLOR_TRANSPARENT);
    context.dc.drawText(point[0], point[1], Graphics.FONT_SYSTEM_XTINY, barometer.pressureStr, Graphics.TEXT_JUSTIFY_LEFT); // pressure in hPa

    var point2 = engine.centerPoint;
    var degrees = 1.0 * barometer.pressure;
    var radius = 130;

    //drawGauge(dc, point2, degrees, 125, 170, 60, self.barometer.ranges, self.barometer.colors);
    drawArrow(context.dc, point2, degrees, radius);
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

function setupBarometerSensorSystem(systems, components) {
    if (components.hasKey(:barometer) and components.hasKey(:update)) {
        systems.add([
            components,
            new Method({}, :updateBarometerSensorSystem),
            new Method({}, :initBarometerSensorSystem)
        ]);
    }
    if (components.hasKey(:barometer) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderBarometerSensorSystem)
        ]);
    }
}

// ========= Stress sensor system =======
function initStressSensorSystem(components) {
    var stress = components[:stress] as StressSensorComponent;
    //stress.stressRuler = WatchUi.loadResource(Rez.Drawables.stressRuler);
}

function updateStressSensorSystem(components) {
    var deltaTime = components[:deltaTime];
    var stress = components[:stress] as StressSensorComponent;

    stress.accumulatedTime -= deltaTime;
    if (stress.accumulatedTime > 0) {
        return;
    }

    stress.accumulatedTime = stress.fastUpdate;

    var stressIterator = Toybox.SensorHistory.getStressHistory({ :period => 1 });
    var sample = stressIterator.next();
    if (sample == null) {
        return;
    }

    stress.value = sample.data;
    var step = 12;
    var offset = stress.position[1];

    if (stress.value > 95) {
        stress.deltaIndex = offset;
    } else if (stress.value > 90) {
        stress.deltaIndex = offset - step;
    } else if (stress.value > 85){
        stress.deltaIndex = offset - 2 * step;
    } else if (stress.value > 80) {
        stress.deltaIndex = offset - 3 * step;
    } else if (stress.value > 75) {
        stress.deltaIndex = offset - 4 * step;
    } else if (stress.value > 70) {
        stress.deltaIndex = offset - 5 * step;
    } else if (stress.value > 65) {
        stress.deltaIndex = offset - 6 * step;
    } else if (stress.value > 60) {
        stress.deltaIndex = offset - 7 * step;
    } else if (stress.value > 54){
        stress.deltaIndex = offset - 8 * step;
    } else if (stress.value > 48) {
        stress.deltaIndex = offset - 9 * step;
    } else if (stress.value > 42) {
        stress.deltaIndex = offset - 10 * step;
    } else if (stress.value > 36) {
        stress.deltaIndex = offset - 11 * step;
    } else if (stress.value > 30) {
        stress.deltaIndex = offset - 12 * step;
    } else if (stress.value > 24) {
        stress.deltaIndex = offset - 13 * step;
    } else if (stress.value > 18){
        stress.deltaIndex = offset - 14 * step;
    } else if (stress.value > 12) {
        stress.deltaIndex = offset - 15 * step;
    } else if (stress.value > 6) {
        stress.deltaIndex = offset - 16 * step;
    } else {
        stress.deltaIndex = offset - 17 * step;
    }

    stress.strValue = sample.data.format("%d");
    stress.currentWidth = (stress.width / 100.0 * stress.value).toNumber();
}

function renderStressSensorSystem(components) {
    var dc = components[:dc];
    var context = components[:context];
    var stress = components[:stress] as StressSensorComponent;
    //dc.setClip(stress.position[0], stress.position[1], 103, 12);
    //dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    //dc.drawRectangle(stress.position[0], stress.position[1], 103, 12);
    //dc.drawBitmap(stress.position[0], stress.deltaIndex, stressRuler);
    //dc.clearClip();
    context.dc.setColor(0x005555, Graphics.COLOR_TRANSPARENT);
    context.dc.fillRectangle(
        stress.position[0], stress.position[1],
        stress.currentWidth,
        stress.height
    );
    context.dc.setColor(0x55ffff, Graphics.COLOR_TRANSPARENT);
    context.dc.fillRectangle(
        stress.position[0] + stress.currentWidth, stress.position[1],
        stress.width - stress.currentWidth,
        stress.height
    );
}

function setupStressSensorSystem(systems, components) {
    if (components.hasKey(:stress) and components.hasKey(:update)) {
        systems.add([
            components,
            new Method({}, :updateStressSensorSystem),
            new Method({}, :initStressSensorSystem)
        ]);
    }
    if (components.hasKey(:stress) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderStressSensorSystem)
        ]);
    }
}

// ====== Compas sensor system ===========
function updateCompassSensorSystem(components) {
    var deltaTime = components[:deltaTime];
    var engine = components[:engine];
    var compass = components[:compass];

    compass.accumulatedTime -= deltaTime;
    if (compass.accumulatedTime > 0) {
        return;
    }

    compass.accumulatedTime = compass.fastUpdate;

    var screenCenterPoint = engine.centerPoint;
    var moveMatrix = [screenCenterPoint];

    compass.point = add([compass.position], moveMatrix)[0];
}

function renderCompassSensorSystem(components) {
    var context = components[:context];
    var compass = components[:compass];

    var point = compass.point;
    context.dc.drawText(point[0], point[1], Graphics.FONT_SYSTEM_XTINY, compass.spStr, Graphics.TEXT_JUSTIFY_CENTER); // Using Font
}

function setupCompassSensorSystem(systems, components) {
    if (components.hasKey(:compass) and components.hasKey(:update)) {
        systems.add([
            components,
            new Method({}, : updateCompassSensorSystem)
        ]);
    }
    if (components.hasKey(:compass) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderCompassSensorSystem)
        ]);
    }
}

// ==== Digitaltime system ==========

function initDigitalTimeSystem(components, api) {
    var digitalTime = components[:digitalTime] as DigitalTimeComponent;

    digitalTime.lcdDisplayFont = WatchUi.loadResource(Rez.Fonts.lcdDisplay24);
    //digitalTime.lcdDisplayFont = Graphics.FONT_LARGE;
}

function updateDigitalTimeSystem(components) {
    var time = components[:time];
    var deltaTime = components[:deltaTime];
    var digitalTime = components[:digitalTime] as DigitalTimeComponent;

    digitalTime.accumulatedTime -= deltaTime;
    if (digitalTime.accumulatedTime > 0) {
        return;
    }

    digitalTime.accumulatedTime = digitalTime.fastUpdate;

    var timeFormat = "$1$:$2$";
    if (time.secondsNumber % 2 == 0) {
        timeFormat = "$1$ $2$";
    }
    digitalTime.timeTitle = Lang.format(timeFormat, [
        time.hours.format("%02d"),
        time.minutes.format("%02d")
    ]);
}

function renderDigitalTimeSystem(components) {
    var context = components[:context];
    var digitalTime = components[:digitalTime] as DigitalTimeComponent;

    context.dc.setColor(digitalTime.color, Graphics.COLOR_TRANSPARENT);
    context.dc.drawText(
        digitalTime.position[0], digitalTime.position[1],
        digitalTime.lcdDisplayFont, digitalTime.timeTitle,
        Graphics.TEXT_JUSTIFY_CENTER
    );

    //self.engine.clipArea[0][0] = self.digitalTime.position[0] + 13;
    //self.engine.clipArea[0][1] = self.digitalTime.position[1] + 1;
    //self.engine.clipArea[1][0] = 31;
    //self.engine.clipArea[1][1] = 16;
}

function setupDigitalTimeSystem(systems, components) {
    if (components.hasKey(:time) and components.hasKey(:digitalTime) and components.hasKey(:update)) {
        systems.add([
            components,
            new Lang.Method({}, : updateCurrentDateSystem)
        ]);
    }
    if (components.hasKey(:digitalTime) and components.hasKey(:render)) {
        systems.add([
            components,
            new Lang.Method({}, :renderCurrentDateSystem)
        ]);
    }
}

// ===== Current date system ===========
function updateCurrentDateSystem(components) {
    var deltaTime = components[:deltaTime];
    var date = components[:date] as DateComponent;

    date.accumulatedTime -= deltaTime;
    if (date.accumulatedTime > 0) {
        return;
    }

    date.accumulatedTime = date.fastUpdate;

    var info = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
    date.dayOfWeek = info.day_of_week;
    date.year = info.year;
    date.month = info.month;
    date.day = info.day;

    date.strValue = Lang.format("$1$, $3$", [
        date.dayOfWeek, date.month, date.day
    ]);
}

function renderCurrentDateSystem(components) {
    var context = components[:context];
    var date = components[:date] as DateComponent;

    context.dc.setColor(date.color, Graphics.COLOR_TRANSPARENT);
    context.dc.drawText(date.position[0], date.position[1], Graphics.FONT_SYSTEM_XTINY, date.strValue, Graphics.TEXT_JUSTIFY_CENTER);
}

function setupCurrentDateSystem(systems, components) {
    if (components.hasKey(:date) and components.hasKey(:update)) {
        systems.add([
            components,
            new Method({}, : updateCurrentDateSystem)
        ]);
    }
    if (components.hasKey(:date) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderCurrentDateSystem)
        ]);
    }
}

// ===== Alt time system ================
function createAltTimeInit() {
    return new Method({}, :initAltTime);
}

function initAltTime(components, api) as Void {
    var altTime = components[:altTime] as AltTimeComponent;

    altTime.api = api;
    altTime.lcdDisplayFont = WatchUi.loadResource(Rez.Fonts.lcdDisplay12);
    altTime.where = new Position.Location({
        :latitude => altTime.location[0],
        :longitude => altTime.location[1],
        :format => :degrees,
    });

    var timezoneDiffSecs = altTime.api.getLocationTimeOffset(altTime.where);
    altTime.timezoneDiffDuration = new Time.Duration(timezoneDiffSecs.toNumber());
}

function createUpdateAltTimeSystem(components) {
    var inst = new Method({}, :updateAltTimeSystem);

    return inst;
}

function isCompatibleUpdateAltTimeSystem(entity) as Boolean {
    return entity.hasKey(:altTime);
}

function updateAltTimeSystem(components) {
    var deltaTime = components[:deltaTime];
    var altTime =components[:altTime];

    altTime.accumulatedTime -= deltaTime;
    if (altTime.accumulatedTime > 0) {
        return;
    }

    altTime.accumulatedTime = altTime.fastUpdate;

    // Based on today's time offset at this location, calculate the local
    // time, by adding the offset to the current UTC time.
    var epochTimeNow = Time.now();
    //var epochTimeNow = Gregorian.moment({
    //    :year => self.date.year, :month => self.date.month, :day => self.date.day,
    //    :hour => self.time.hours, :minute => self.time.minutes, :second => self.time.seconds
    //});
    var secondaryTimeNow = epochTimeNow.add(altTime.timezoneDiffDuration);
    var info = Time.Gregorian.utcInfo(secondaryTimeNow, Time.FORMAT_MEDIUM);

    altTime.value = altTime.api.timeFormat(altTime.format, info);
}

function createRenderAltTimeSystem(components) {
    var inst = new Method({}, :renderAltTimeSystem);

    return inst;
}

function isCompatibleRenderAltTimeSystem(entity) as Boolean {
    return entity.hasKey(:altTime);
}

function renderAltTimeSystem(components) {
    var dc = components[:dc];
    var context = components[:context];
    var altTime = components[:altTime];

    context.dc.setColor(altTime.color, Graphics.COLOR_TRANSPARENT);
    context.dc.drawText(
        altTime.position[0], altTime.position[1],
        altTime.lcdDisplayFont,
        altTime.value,
        Graphics.TEXT_JUSTIFY_LEFT
    );
}

// ========= Steps systems =======

function initStepsSystem(components, api as API_Functions) {
    var steps = components[:steps] as StepsComponent;
    steps.distanceUnits = System.getDeviceSettings().distanceUnits;
}

function updateStepsSystem(components) {
    var deltaTime = components[:deltaTime];
    var steps = components[:steps] as StepsComponent;

    steps.accumulatedTime -= deltaTime;
    if (steps.accumulatedTime > 0) {
        return;
    }

    steps.accumulatedTime = steps.fastUpdate;

    var activityInfo = ActivityMonitor.getInfo();
    if (activityInfo == null) {
        return;
    }

    var distStr = activityInfo.steps;
    steps.value = distStr;

    var stepDistance = activityInfo.distance;//.toString();
    var unit = "?";

    if (stepDistance != null) {
        if (steps.distanceUnits == System.UNIT_METRIC) {
            unit = " km";
            stepDistance = stepDistance * 0.00001;
        } else {
            unit = " mi";
            stepDistance = stepDistance * 0.00001 * 0.621371;
        }
    } else {
        stepDistance = 0;
    }

    if (stepDistance >= 100) {
        distStr = stepDistance.format("%.0f");
    } else {
        distStr = stepDistance.format("%.1f");
    }
    steps.distance = distStr + unit;    		
}

function renderStepsSystem(components) {
    var dc = components[:dc];
    var context = components[:context];
    var steps = components[:steps] as StepsComponent;

    context.dc.setColor(steps.color, Graphics.COLOR_TRANSPARENT);
    context.dc.drawText(
        steps.position[0], steps.position[1],
        Graphics.FONT_SYSTEM_XTINY,
        steps.value,
        Graphics.TEXT_JUSTIFY_LEFT
    );
    context.dc.drawText(
        steps.position[0], steps.position[1] + 14,
        Graphics.FONT_SYSTEM_XTINY,
        steps.distance,
        Graphics.TEXT_JUSTIFY_LEFT
    );
}

function setupStepsSystem(systems, components) {
    if (components.hasKey(:steps) and components.hasKey(:update)) {
        systems.add([
            components,
            new Method({}, :updateStepsSystem),
            new Method({}, :initStepsSystem)
        ]);
    }
    if (components.hasKey(:steps) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderStepsSystem)
        ]);
    }
}

// ======== Update current time system ==========
function createUpdateCurrentTimeSystem(components) {
    var inst = new Method({}, :updateCurrentTime);

    return inst;
}

function isCompatibleUpdateCurrentTimeSystem(entity) as Boolean {
    return entity.hasKey(:time) and entity.hasKey(:oneTime);
}

function updateCurrentTime(components) {
    var deltaTime = components[:deltaTime];
    var time = components[:time];

    var delta = deltaTime.toFloat() / 1000.0;
    time.accumulatedTime -= deltaTime;
    time.secondsNumber = (time.seconds + delta).toNumber();
    if (time.accumulatedTime > 0) {
        if (time.secondsNumber > 59) {
            time.secondsNumber = 0;
        }

        time.seconds = time.seconds + delta;
        time.minutes = time.minutes + delta / 60.0;
        time.hours = (time.hours + delta / 60.0 / 60.0);

        return;
    }
    time.accumulatedTime = time.fastUpdate;

    var clockTime = System.getClockTime();

    time.hours = clockTime.hour.toFloat();
    time.minutes = clockTime.min.toFloat();
    time.secondsNumber = clockTime.sec;
    time.seconds = clockTime.sec.toFloat();
}

// ===== render polygon system ===============
function createRenderPolygon(components) {
    var inst = new Method({}, :renderPolygon);

    return inst;
}

function isCompatibleRenderPolygon(entity) {
    return entity.hasKey(:engine) and entity.hasKey(:polygon);
}

function renderPolygon(components) {
    var polygon = components[:polygon];
    var buffer = components[:buffer];
    var engine = components[:engine];
    var context = components[:context];
    var dc = components[:dc];

    var length = polygon.mesh.size();

    if (buffer) {
        for (var index = 0; index < length; index += 1) {
            var mesh = polygon.mesh[index];
            context.dc.setColor(mesh[0], Graphics.COLOR_TRANSPARENT);
            context.dc.fillPolygon(mesh[1]);
        }
    } else {
        //dc.drawBitmap(0, 0, engine.context.buffer);
        for (var index = 0; index < length; index += 1) {
            var mesh = polygon.mesh[index];
            dc.setColor(mesh[0], Graphics.COLOR_TRANSPARENT);
            dc.fillPolygon(mesh[1]);
        }
    }
}

// ======= render multiline system =======
function renderMultilineRenderSystem(components) {
    var context = components[:context];
    var polygon = components[:polygon];

    context.dc.setColor(0xaaffaa, Graphics.COLOR_TRANSPARENT);
    var length = polygon.mesh.size();
    for (var index = 0; index < length; index += 1) {
        var mesh = polygon.mesh[index];
        drawMultiLine(context.dc, mesh[1]);
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

    dc.drawLine(pointTo[0], pointTo[1], polygon[0][0], polygon[0][1]);
}

function setupMultilineRenderSystem(systems, components) {
    if (components.hasKey(:polygon) and components.hasKey(:multiline)) {
        systems.add([
            components,
            new Lang.Method({}, :renderMultilineRenderSystem)
        ]);
    }
}

// ======= hours hand system ===========
function updateHoursHandSystem(components) {
    var deltaTime = components[:deltaTime];
    var engine = components[:engine];
    var time = components[:time];
    var hand = components[:hoursHand];
    var polygon = components[:polygon];

    hand.accumulatedTime -= deltaTime;
    if (hand.accumulatedTime > 0) {
        return;
    }

    hand.accumulatedTime = hand.fastUpdate;

    var screenCenterPoint = engine.centerPoint;

    var angle = Math.PI/6 * (1.0*time.hours + time.minutes / 60.0);

    var length = hand.coordinates.size();
    var result = new [length];

    var sinCos = [Math.cos(angle), Math.sin(angle)];
    var transformMatrix = [
        sinCos,
        [-sinCos[1], sinCos[0]],
    ];
    var moveMatrix = [screenCenterPoint];

    var oldPoint = new [1];
    for (var index = 0; index < length; index += 1) {
        var idxLength = hand.coordinates[index][1].size();
        var res = new [idxLength];
        for (var idx = 0; idx < idxLength; idx++) {
            oldPoint[0] = hand.coordinates[index][1][idx];
            var point = add(multiply(oldPoint, transformMatrix), moveMatrix);
            res[idx] = point[0];
        }
        result[index] = [hand.coordinates[index][0], res];
    }

    polygon.color = hand.color;
    polygon.mesh = result;
}

function setupHoursHandSystem(systems, components) {
    if (components.hasKey(:hoursHand) and components.hasKey(:time) and components.hasKey(:update)) {
        systems.add([
            components,
            new Lang.Method({}, :updateHoursHandSystem)
        ]);
    }
}

// ========== Seconds hand system =============
function createSecondsHandSystem(components) {
    var inst = new Method({}, :updateSecondsHandSystem);

    return inst;
}

function isCompatibleSecondsHandSystem(entity) {
    return entity.hasKey(:time) and entity.hasKey(:secondsHand) and entity.hasKey(:polygon);
}

const mathPiDiv30 = Math.PI / 30.0;

function updateSecondsHandSystem(components) {
    var deltaTime = components[:deltaTime];
    var engine = components[:engine];
    var time = components[:time];
    var hand = components[:secondsHand];
    var polygon = components[:polygon];

    var length = hand.coordinates.size();

    var angle = time.seconds * mathPiDiv30;

    var sinCos = [Math.cos(angle), Math.sin(angle)];
    var transformMatrix = [
        sinCos,
        [-sinCos[1], sinCos[0]],
    ];

    var result = new [length];
    var oldPoint = new [1];
    for (var index = 0; index < length; index += 1) {
        var idxLength = hand.coordinates[index][1].size();
        var res = new [idxLength];
        for (var idx = 0; idx < idxLength; idx++) {
            oldPoint[0] = hand.coordinates[index][1][idx];
            var point = add(multiply(oldPoint, transformMatrix), engine.screenCenterPoint);
            res[idx] = point[0];
        }
        result[index] = [hand.coordinates[index][0], res];
    }

    polygon.color = hand.color;
    polygon.mesh = result;

    if (polygon.mesh.size() > 1) {
        var minX = engine.width;
        var minY = engine.height;
        var maxX = 0;
        var maxY = 0;
        for (var index = 0; index < length; index += 1) {
            var idxLength = polygon.mesh[index][1].size();
            var res = new [idxLength];
            for (var idx = 0; idx < idxLength; idx++) {
                var point = polygon.mesh[index][1][idx];
                minX = min(minX, point[0]);
                minY = min(minY, point[1]);
                maxX = max(maxX, point[0]);
                maxY = max(maxY, point[1]);
            }
        }
        engine.clipArea[0][0] = max(0, minX - 15);
        engine.clipArea[0][1] = max(0, minY - 15);
        engine.clipArea[1][0] = min(engine.width, maxX - engine.clipArea[0][0] + 15);
        engine.clipArea[1][1] = min(engine.height, maxY - engine.clipArea[0][1] + 15);
    }
}

// ====== heart rate system =======
function updateHeartRateSystem(components) {
    var deltaTime = components[:deltaTime];
    var heartRate = components[:heartRate] as HeartRateComponent;

    heartRate.accumulatedTime -= deltaTime;
    if (heartRate.accumulatedTime > 0) {
        return;
    }

    heartRate.accumulatedTime = heartRate.fastUpdate;

    var heartActivity = Activity.getActivityInfo().currentHeartRate; 
    if (heartActivity == null) {
        var HRH = ActivityMonitor.getHeartRateHistory(1, true);
        var HRS = HRH.next();
        if (HRS != null && HRS.heartRate != ActivityMonitor.INVALID_HR_SAMPLE){
            heartActivity = HRS.heartRate;
        }
    }

    if (heartActivity == null) {
        return;
    }

    heartRate.value = heartActivity.format("%02d");
}

function renderHeartRateSystem(components) {
    var context = components[:context];
    var heartRate = components[:heartRate] as HeartRateComponent;

    context.dc.setColor(heartRate.color, Graphics.COLOR_TRANSPARENT);
    context.dc.drawText(
        heartRate.position[0], heartRate.position[1],
        Graphics.FONT_SYSTEM_XTINY,
        heartRate.value,
        Graphics.TEXT_JUSTIFY_LEFT
    );

}

function setupHeartRateSystem(systems, components) {
    if (components.hasKey(:heartRate) and components.hasKey(:update)) {
        systems.add([
            components,
            new Lang.Method({}, :updateHeartRateSystem)
        ]);
    }
    if (components.hasKey(:heartRate) and components.hasKey(:render)) {
        systems.add([
            components,
            new Lang.Method({}, :renderHeartRateSystem)
        ]);
    }
}

// ======= moon info system =======
function initMoonInfoSystem(components, api) {
    var moon = components[:moon];
    moon.api = api;

    moon.myInfo = Position.getInfo();
    moon.images[Rez.Drawables.Phase00] = WatchUi.loadResource(Rez.Drawables.Phase00);
    moon.images[Rez.Drawables.Phase17] = WatchUi.loadResource(Rez.Drawables.Phase17);
    moon.images[Rez.Drawables.Phase26] = WatchUi.loadResource(Rez.Drawables.Phase26);
    moon.images[Rez.Drawables.Phase35] = WatchUi.loadResource(Rez.Drawables.Phase35);
    moon.images[Rez.Drawables.Phase44] = WatchUi.loadResource(Rez.Drawables.Phase44);
    moon.images[Rez.Drawables.Phase53] = WatchUi.loadResource(Rez.Drawables.Phase53);
    moon.images[Rez.Drawables.Phase62] = WatchUi.loadResource(Rez.Drawables.Phase62);
    moon.images[Rez.Drawables.Phase71] = WatchUi.loadResource(Rez.Drawables.Phase71);
}

function updateMoonInfoSystem(components) {
    var deltaTime = components[:deltaTime];
    var time = components[:time];
    var date = components[:date] as DateComponent;
    var moon = components[:moon] as MoonInfoComponent;

    moon.accumulatedTime -= deltaTime;
    if (moon.accumulatedTime > 0) {
        return;
    }

    moon.accumulatedTime = moon.fastUpdate;

    var today = Gregorian.utcInfo(Time.now(), Time.FORMAT_SHORT);
    var p = moon.api.getPhase(today.year, today.month, today.day, today.hour, today.min, today.sec);
    var south = false;
    if (moon.myInfo != null) {
        south = (moon.myInfo.accuracy != null &&
            moon.myInfo.accuracy > Position.QUALITY_NOT_AVAILABLE &&
            moon.myInfo.position != null &&
            moon.myInfo.position.toDegrees()[0] < 0
        );
    }

    var desc = moon.api.phaseDescription(south, p["phase"]);
    var illum = (p["illuminated"] * 100).format("%.1f") + "%";
    if (illum.equals("100.0%")) {
        illum = "100%";
    }
    var days = (p["age"].format("%.1f"));
    moon.age = days + " days";
    moon.description = desc[0];
    moon.image = desc[1];
    moon.illum = illum;
}

function renderMoonInfoSystem(components) {
    var context = components[:context];
    var moon = components[:moon];

    var bitmap = moon.images[moon.image];
    context.dc.drawBitmap(moon.position[0], moon.position[1], bitmap);
    context.dc.setColor(moon.color, Graphics.COLOR_TRANSPARENT);
    context.dc.drawText(moon.position[0] + 26, moon.position[1],
        Graphics.FONT_SYSTEM_XTINY,
        moon.age,
        Graphics.TEXT_JUSTIFY_LEFT
    );
}

function setupMoonInfoSystem(systems, components) {
    if (components.hasKey(:time) and components.hasKey(:date) and components.hasKey(:moon) and components.hasKey(:update)) {
        systems.add([
            components,
            new Lang.Method({}, :updateMoonInfoSystem),
            new Lang.Method({}, :initMoonInfoSystem)
        ]);
    }
    if (components.hasKey(:moon) and components.hasKey(:render)) {
        systems.add([
            components,
            new Lang.Method({}, :renderMoonInfoSystem)
        ]);
    }
}

// ====== body battery system =======
function initBodyBatterySystem(components) {
    var bodyBattery = components[:bodyBattery] as BodyBatteryComponent;
    bodyBattery.chargeAmount = WatchUi.loadResource(Rez.Drawables.chargeAmount);
}

function updateBodyBatterySystem(components) {
    var deltaTime = components[:deltaTime];
    var bodyBattery = components[:bodyBattery] as BodyBatteryComponent;

    bodyBattery.accumulatedTime -= deltaTime;
    if (bodyBattery.accumulatedTime > 0) {
        return;
    }

    bodyBattery.accumulatedTime = bodyBattery.fastUpdate;

    var bbIterator = Toybox.SensorHistory.getBodyBatteryHistory({ :period => 1 });
    if (bbIterator == null) {
        return;
    }
    var sample = bbIterator.next();

    if (sample == null) {
        return;
    }

    var pwr = sample.data;
    var step = 12;
    var offset = bodyBattery.position[1];

    if (pwr > 95) {
        bodyBattery.deltaIndex = offset;
    } else if (pwr > 90) {
        bodyBattery.deltaIndex = offset - step;
    } else if (pwr > 85){
        bodyBattery.deltaIndex = offset - 2 * step;
    } else if (pwr > 80) {
        bodyBattery.deltaIndex = offset - 3 * step;
    } else if (pwr > 75) {
        bodyBattery.deltaIndex = offset - 4 * step;
    } else if (pwr > 70) {
        bodyBattery.deltaIndex = offset - 5 * step;
    } else if (pwr > 65) {
        bodyBattery.deltaIndex = offset - 6 * step;
    } else if (pwr > 60) {
        bodyBattery.deltaIndex = offset - 7 * step;
    } else if (pwr > 55){
        bodyBattery.deltaIndex = offset - 8 * step;
    } else if (pwr > 50) {
        bodyBattery.deltaIndex = offset - 9 * step;
    } else if (pwr > 45) {
        bodyBattery.deltaIndex = offset - 10 * step;
    } else if (pwr > 40) {
        bodyBattery.deltaIndex = offset - 11 * step;
    } else if (pwr > 35) {
        bodyBattery.deltaIndex = offset - 12 * step;
    } else if (pwr > 30) {
        bodyBattery.deltaIndex = offset - 13 * step;
    } else if (pwr > 25){
        bodyBattery.deltaIndex = offset - 14 * step;
    } else if (pwr > 20) {
        bodyBattery.deltaIndex = offset - 15 * step;
    } else if (pwr > 15) {
        bodyBattery.deltaIndex = offset - 16 * step;
    } else if (pwr > 10) {
        bodyBattery.deltaIndex = offset - 17 * step;
    } else if (pwr > 5) {
        bodyBattery.deltaIndex = offset - 18 * step;
    } else {
        bodyBattery.deltaIndex = offset - 19 * step;
    }
}

function renderBodyBatterySystem(components) {
    var dc = components[:dc];
    var context = components[:context];
    var bodyBattery = components[:bodyBattery] as BodyBatteryComponent;

    context.dc.setClip(bodyBattery.position[0], bodyBattery.position[1], 115, 12);
    context.dc.drawBitmap(bodyBattery.position[0], bodyBattery.deltaIndex, bodyBattery.chargeAmount);
    context.dc.clearClip();
}

function setupBodyBatterySystem(systems, components) {
    if (components.hasKey(:bodyBattery) and components.hasKey(:update)) {
        systems.add([
            components,
            new Method({}, :updateBodyBatterySystem),
            new Method({}, :initBodyBatterySystem)
        ]);
    }
    if (components.hasKey(:bodyBattery) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderBodyBatterySystem)
        ]);
    }
}

// ====== charge battary system =====
function initUpdateChargeSystem(components, api) {
    var charge = components[:charge] as ChargeComponent;
    charge.chargeAmount = WatchUi.loadResource(Rez.Drawables.chargeAmountV);
}

function updateChargeSystem(components) {
    var deltaTime = components[:deltaTime];
    var charge = components[:charge] as ChargeComponent;
    var engine = components[:engine] as Engine;
    var watchStatus = components[:watchStatus];

    charge.accumulatedTime -= deltaTime;
    if (charge.accumulatedTime > 0) {
        return;
    }

    charge.accumulatedTime = charge.fastUpdate;

    var pwr = watchStatus.battery;
    var step = 14;
    var offset = 1;

    if (pwr > 95) {
        charge.deltaIndex = offset;
    } else if (pwr > 90) {
        charge.deltaIndex = offset - step;
    } else if (pwr > 80){
        charge.deltaIndex = offset - 2 * step;
    } else if (pwr > 70) {
        charge.deltaIndex = offset - 3 * step;
    } else if (pwr > 60) {
        charge.deltaIndex = offset - 4 * step;
    } else if (pwr > 50) {
        charge.deltaIndex = offset - 5 * step;
    } else if (pwr > 40) {
        charge.deltaIndex = offset - 6 * step;
    } else if (pwr > 30) {
        charge.deltaIndex = offset - 7 * step;
    } else if (pwr > 20){
        charge.deltaIndex = offset - 8 * step;
    } else if (pwr > 10) {
        charge.deltaIndex = offset - 9 * step;
    } else {
        charge.deltaIndex = offset - 10 * step;
    }
}

function setupUpdateChargeSystem(systems, components) {
    if (components.hasKey(:charge) and components.hasKey(:watchStatus) and components.hasKey(:update)) {
        systems.add([
            components,
            new Method({}, :updateChargeSystem),
            new Method({}, :initUpdateChargeSystem)
        ]);
    }
}

function renderChargeSystem(components) {
    var context = components[:context];
    var charge = components[:charge];
    
    context.dc.drawBitmap(charge.deltaIndex, charge.position[1], charge.chargeAmount);
    context.dc.clearClip();
}

function setupRenderChargeSystem(systems, components) {
    if (components.hasKey(:charge) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderChargeSystem)
        ]);
    }
}

// ========= Render alpha background system =======
function initRenderBackgroundAlphaSystem(components, api) {
    var background = components[:backgroundAlpha];
    background.background = WatchUi.loadResource(Rez.Fonts.backgroundAlpha);
}

function renderRenderBackgroundAlphaSystem(components) {
    var context = components[:context];
    var bg = components[:backgroundAlpha];
    context.dc.setColor(0xaaffff, Graphics.COLOR_TRANSPARENT);
    context.dc.drawText(0, 0, bg.background, "6", Graphics.TEXT_JUSTIFY_LEFT);
}

function setupRenderBackgroundAlphaSystem(systems, components) {
    if (components.hasKey(:backgroundAlpha) and components.hasKey(:render)) {
        systems.add([
            components,
            new Lang.Method({}, :renderRenderBackgroundAlphaSystem),
            new Lang.Method({}, :initRenderBackgroundAlphaSystem)
        ]);
    }
}

// ========= Render background system =======
function initRenderBackgroundSystem(components, api) {
    components[:background] = WatchUi.loadResource(Rez.Drawables.watchBackground);
}

function renderBackgroundSystem(components) {
    var engine = components[:engine];
    var context = components[:context];
    var background = components[:background];

    context.dc.drawBitmap(0, 0, background);
}

function setupRenderBackgroundSystem(systems, components) {
    if (components.hasKey(:background)) {
        systems.add([
            components,
            new Method({}, :renderBackgroundSystem),
            new Method({}, :initRenderBackgroundSystem),
        ]);
    }
}

// ======== watch status system =======

function createUpdateWatchStatusSystem(components) {
    var inst = new Method({}, :updateWatchStatusSystem);

    return inst;
}

function isCompatibleUpdateWatchStatusSystem(entity) as Boolean {
    return entity.hasKey(:watchStatus) and entity.hasKey(:update);
}

function createUpdateWatchStatusInit() {
    return new Method({}, :initUpdateWatchStatusSystem);
}

function initUpdateWatchStatusSystem(components, api) {
    var watchStatus = components[:watchStatus];
    watchStatus.statusIcons = WatchUi.loadResource(Rez.Fonts.system12);
}

function updateWatchStatusSystem(components) {
    var deltaTime = components[:deltaTime];
    var watchStatus = components[:watchStatus];

    watchStatus.accumulatedTime -= deltaTime;
    if (watchStatus.accumulatedTime > 0) {
        return;
    }

    watchStatus.accumulatedTime = watchStatus.fastUpdate;

    var stats = System.getSystemStats();
    if (stats != null) {
        watchStatus.battery = stats.battery;
        watchStatus.solarIntensity = stats.solarIntensity;
        watchStatus.isSolarCharging = stats.solarIntensity > 0;
        if (watchStatus.solarIntensity > 49) {
            watchStatus.color = watchStatus.enabledColor;
            watchStatus.solarStatusIcon = "7";
        } else if (watchStatus.solarIntensity > 24) {
            watchStatus.color = watchStatus.enabledColor;
            watchStatus.solarStatusIcon = "6";
        } else if (watchStatus.solarIntensity > 0) {
            watchStatus.color = watchStatus.enabledColor;
            watchStatus.solarStatusIcon = "5";
        } else {
            watchStatus.color = watchStatus.disabledColor;
            watchStatus.solarStatusIcon = "5";
        }
    }

    var settings = System.getDeviceSettings();
    if (settings == null) {
        return;
    }
    watchStatus.phoneConnected = settings.phoneConnected;
    watchStatus.vibrateOn = settings.vibrateOn;
    watchStatus.tonesOn = settings.tonesOn;
}

// ======== heart rate graph system ==========
function initRenderHeartRateGraphSystem(components) {
	var heartRate = components[:heartRate];
	heartRate.heartRateZones = UserProfile.getHeartRateZones(UserProfile.getCurrentSport());
	heartRate.moveBarLevel = ActivityMonitor.getInfo().moveBarLevel;
}

function updateRenderHeartRateGraphSystem(components) as Void {
	var engine = components[:engine];
	var deltaTime = components[:deltaTime];
	var heartRate = components[:heartRate] as HeartRateComponent;

	heartRate.accumulatedTime -= deltaTime;
	if (heartRate.accumulatedTime > 0) {
		return;
	}

	heartRate.accumulatedTime = heartRate.fastUpdate;
	var sample = SensorHistory.getHeartRateHistory({ :order => SensorHistory.ORDER_NEWEST_FIRST });
	if (sample == null) {
		return;
	}
	
	var res = [];
	var binPixels = 1;

	var curHeartMin = 0;
	var curHeartMax = 0;
	var heartNow = 0;
	var heartMin = 0;
	var heartMax = 220;
	var graphLength = 100;
	var width = engine.width;
	var showMoveBar = true;

	if (sample != null) {		    	
		var heart = sample.next();
		if (heart.data != null) {
			heartNow = heart.data;
		}
	
		curHeartMin = heartMin;
		curHeartMax = heartMax;
		heartMin = 1000;
		heartMax = 0;

		var maxSecs = graphLength * 60;
		//if (maxSecs < 900) {
			maxSecs = 900; // 900sec = 15min
		//} else if (maxSecs > 14355) {
		//	maxSecs = 14355; // 14400sec = 4hrs
		//}

		var totBins = Math.ceil(heartRate.totWidth / binPixels).toNumber();
		var binWidthSecs = Math.floor(binPixels * maxSecs / heartRate.totWidth).toNumber();	

		var heartSecs;
		var heartValue = 0;
		var secsBin = 0;
		var lastHeartSecs = sample.getNewestSampleTime().value();
		var heartBinMax;
		var heartBinMin;

		var finished = false;

		for (var i = 0; i < totBins; ++i) {

			heartBinMax = 0;
			heartBinMin = 0;

			if (!finished) {
				// deal with carryover values
				if (secsBin > 0 && heartValue != null) {
					heartBinMax = heartValue;
					heartBinMin = heartValue;
				}

				// deal with new values in this bin
				while (!finished && secsBin < binWidthSecs) {
					heart = sample.next();
					if (heart != null) {
						heartValue = heart.data;
						if (heartValue != null) {
							if (heartBinMax == 0) {
								heartBinMax = heartValue;
								heartBinMin = heartValue;
							} else {
								if (heartValue > heartBinMax) {
									heartBinMax = heartValue;
								}
								
								if (heartValue < heartBinMin) {
									heartBinMin = heartValue;
								}
							}
						}
						
						// keep track of time in this bin
						heartSecs = lastHeartSecs - heart.when.value();
						lastHeartSecs = heart.when.value();
						secsBin += heartSecs;

//							Sys.println(i + ":   " + heartValue + " " + heartSecs + " " + secsBin + " " + heartBinMin + " " + heartBinMax);
					} else {
						finished = true;
					}
					
				} // while secsBin < binWidthSecs

				if (secsBin >= binWidthSecs) {
					secsBin -= binWidthSecs;
				}

				// only plot bar if we have valid values
				if (heartBinMax > 0 && heartBinMax >= heartBinMin) {
					if (curHeartMax > 0 && curHeartMax > curHeartMin) {
						var heartBinMid = (heartBinMax + heartBinMin) / 2;
						var height = (heartBinMid - curHeartMin * 0.9) / (curHeartMax - curHeartMin * 0.9) * heartRate.totHeight;
						var xVal = (width - heartRate.totWidth) / 2 + heartRate.totWidth - i * binPixels - heartRate.position[0];
						var yVal = height / 2 + heartRate.position[1] + heartRate.totHeight - height;

						var color = Graphics.COLOR_RED;
						if (showMoveBar && heartRate.moveBarLevel > 0) {
							if (heartRate.graphColour == 1) {
								color = Graphics.COLOR_ORANGE;
							}
						} else {
							color = heartRate.arrayColours[getHRColour(heartBinMid,
								heartRate.useZonesColour, heartRate.heartRateZones, heartRate.graphColour
							)];
						}
						
						res.add([color, xVal, yVal, binPixels, height]);
					}

					if (heartBinMin < heartMin) {
						heartMin = heartBinMin;
					}
					if (heartBinMax > heartMax) {
						heartMax = heartBinMax;
					}
				}				
				
			}
			
		}
		heartRate.data = res;
		heartRate.dataLength = res.size();
	}
}

function renderRenderHeartRateGraphSystem(components) {
	var heartRate = components[:heartRate];
	var dc = components[:dc];

	for (var index = 0; index < heartRate.dataLength; index++) {
		var row = heartRate.data[index];
		dc.setColor(row[0], Graphics.COLOR_TRANSPARENT);
		dc.fillRectangle(row[1], row[2], row[3], row[4]);
	}
}

function getHRColour(heartrate, useZonesColour, heartRateZones, graphColour)
{
	if (!useZonesColour || heartrate == null || heartrate < heartRateZones[1])
		{ return graphColour; } 
//		else if (heartrate >= heartRateZones[0] && heartrate < heartRateZones[1])
//			{ return 0; } 
	else if (heartrate >= heartRateZones[1] && heartrate < heartRateZones[2])
		{ return 7; } 
	else if (heartrate >= heartRateZones[2] && heartrate < heartRateZones[3])
		{ return 5; } 
	else if (heartrate >= heartRateZones[3] && heartrate < heartRateZones[4])
		{ return 3; } 
	else
		{ return 2; }
}

function setupRenderHeartRateGraphSystem(systems, components) {
	if (components.hasKey(:heartRateGraph) and components.hasKey(:heartRate) and components.hasKey(:update)) {
		systems.add([
			components,
			new Lang.Method({}, :updateRenderHeartRateGraphSystem),
			new Lang.Method({}, :initRenderHeartRateGraphSystem)
		]);
	}
	if (components.hasKey(:heartRateGraph) and components.hasKey(:heartRate) and components.hasKey(:render)) {
		systems.add([
			components,
			new Lang.Method({}, :renderRenderHeartRateGraphSystem)
		]);
	}
}

// ======== sun position system ========
function initSunPositionSystem(components, api) {
    var sunPosition = components[:sunPosition] as SunPositionComponent;
    sunPosition.api = api;
}

function updateSunPositionSystem(components) {
    var deltaTime = components[:deltaTime];
    var time = components[:time] as TimeComponent;
    var sunPosition = components[:sunPosition] as SunPositionComponent;

    var ONE_DAY = new Time.Duration(Time.Gregorian.SECONDS_PER_DAY);

    sunPosition.accumulatedTime -= deltaTime;
    if (sunPosition.accumulatedTime > 0) {
        return;
    }

    sunPosition.accumulatedTime = sunPosition.fastUpdate;

    var activitInfo = Activity.getActivityInfo();
    if (activitInfo != null && activitInfo.currentLocation != null) {
        sunPosition.locationDegrees = activitInfo.currentLocation.toDegrees();
    } else {
        var weather = Toybox.Weather.getCurrentConditions();
        if (weather != null) {
            var location = weather.observationLocationPosition;
            if (location != null) {
                sunPosition.locationDegrees = location.toDegrees();
            }
        }
    }
    var today = Time.today();
    var now = Time.now();
    var lat = sunPosition.locationDegrees[0];
    var lng = sunPosition.locationDegrees[1];
    var sunriseToday = sunPosition.api.calculate(today, new Position.Location({
        :latitude => lat,
        :longitude => lng,
        :format => :degrees
    }).toRadians(), SUNRISE);
    var sunsetToday = sunPosition.api.calculate(today, new Position.Location({
        :latitude => lat,
        :longitude => lng,
        :format => :degrees
    }).toRadians(), SUNSET);
    var sunriseTomorrow = sunPosition.api.calculate(today.add(ONE_DAY), new Position.Location({
        :latitude => lat,
        :longitude => lng,
        :format => :degrees
    }).toRadians(), SUNRISE);
    var sunSetInfo = Gregorian.info(sunsetToday, Time.FORMAT_MEDIUM);
    var sunRiseInfo = Gregorian.info(sunriseTomorrow, Time.FORMAT_MEDIUM);

    sunPosition.sunset = sunSetInfo.hour + ":" + sunSetInfo.min.format("%02d");
    sunPosition.sunrise = sunRiseInfo.hour + ":" + sunRiseInfo.min.format("%02d");
    if (sunriseToday.compare(now) > 0) {
        sunPosition.isDay = false;
    } else if (sunsetToday.compare(now) > 0) {
        sunPosition.isDay = true;
    } else if (sunriseTomorrow.compare(now) > 0) {
        sunPosition.isDay = false;
    }
}

function renderSunPositionSystem(components) {
    var dc = components[:dc];
    var context = components[:context];
    var sunPosition = components[:sunPosition];

    context.dc.setColor(sunPosition.color, Graphics.COLOR_TRANSPARENT);
    context.dc.drawText(
        sunPosition.position[0], sunPosition.position[1],
        Graphics.FONT_SYSTEM_XTINY,
        sunPosition.sunset,
        Graphics.TEXT_JUSTIFY_CENTER
    );
    context.dc.drawText(
        sunPosition.position[0] + 40, sunPosition.position[1],
        Graphics.FONT_SYSTEM_XTINY,
        sunPosition.sunrise,
        Graphics.TEXT_JUSTIFY_CENTER
    );
}

function setupSunPositionSystem(systems, components) {
    if (components.hasKey(:time) and components.hasKey(:sunPosition) and components.hasKey(:update)) {
        systems.add([
            components,
            new Method({}, :updateSunPositionSystem),
            new Method({}, :initSunPositionSystem),
        ]);
    }
    if (components.hasKey(:sunPosition) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderSunPositionSystem),
        ]);
    }
}

// ======== Watch status system ========
function initRenderWatchStatusSystem(components, api) {
    var watchStatus = components[:watchStatus] as WatchStatusComponent;
    watchStatus.statusIcons = WatchUi.loadResource(Rez.Fonts.system12);
}

function renderRenderWatchStatusSystem(components) {
    var dc = components[:dc];
    var context = components[:context];
    var watchStatus = components[:watchStatus] as WatchStatusComponent;

    context.dc.setColor(watchStatus.color, Graphics.COLOR_TRANSPARENT);
    context.dc.drawText(
        watchStatus.position[0], watchStatus.position[1],
        watchStatus.statusIcons, watchStatus.solarStatusIcon, Graphics.TEXT_JUSTIFY_LEFT
    );
    if (watchStatus.phoneConnected) {
        context.dc.setColor(0x005555, Graphics.COLOR_TRANSPARENT);
        context.dc.drawText(
            watchStatus.position[0], watchStatus.position[1] - 12,
            watchStatus.statusIcons, "2", Graphics.TEXT_JUSTIFY_LEFT
        );
    } else {
        context.dc.setColor(0x55ffff, Graphics.COLOR_TRANSPARENT);
        context.dc.drawText(
            watchStatus.position[0], watchStatus.position[1] - 12,
            watchStatus.statusIcons, "1", Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}

function setupRenderWatchStatusSystem(systems, components) {
    if (components.hasKey(:watchStatus) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderRenderWatchStatusSystem),
            new Method({}, :initRenderWatchStatusSystem)
        ]);
    }
}

// ======== Seconds ruler system ======
function initSecondsRulerSystem(components, api as API_Functions) {
    var ruler = components[:ruler];

    ruler.rulerRes = WatchUi.loadResource(Rez.Drawables.ruler);
}

function updateSecondsRulerSystem(components) {
    var deltaTime = components[:deltaTime];
    var time = components[:time];
    var ruler = components[:ruler];

    var scale = Math.PI * 10;
    ruler.lastStep = ruler.pid.update(ruler.lastStep);
    ruler.deltaIndex = -195 - ruler.lastStep * scale;

    ruler.accumulatedTime -= deltaTime;
    if (ruler.accumulatedTime > 0) {
        return;
    }
    ruler.accumulatedTime = ruler.fastUpdate;

    ruler.pid.setTarget(time.seconds);
    if (time.seconds < ruler.lastStep) {
        ruler.pid.reset();
        ruler.lastStep = time.seconds - 2.0;
    } else {
        ruler.lastStep = time.seconds;
    }
}

function setupSecondsRulerSystem(systems, components) {
    if (components.hasKey(:ruler) and components.hasKey(:time)) {
        systems.add([
            components,
            new Method({}, :updateSecondsRulerSystem),
            new Method({}, :initSecondsRulerSystem)
        ]);
    }
}

// ========= render seconds ruler system ===========
function initRenderSecondsRulerSystem(components) {
    var ruler = components[:secondsRuler];
    ruler.rulerRes = WatchUi.loadResource(Rez.Drawables.ruler);
}

function renderRenderSecondsRulerSystem(components) {
    var dc = components[:dc];
    var context = components[:context];
    var ruler = components[:secondsRuler];

    dc.setColor(0xaaffff, 0xaaffff);
    dc.setClip(58, 180, 166, 16);
    dc.clear();
    dc.drawBitmap(ruler.deltaIndex, 180, ruler.rulerRes);
    dc.clearClip();
}

function setupRenderSecondsRulerSystem(systems, components) {
    if (components.hasKey(:secondsRuler) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderRenderSecondsRulerSystem),
            new Method({}, :initRenderSecondsRulerSystem)
        ]);
    }
}

// ========= Render minutes ruler system ========
function initRenderMinutesRulerSystem(components) {
    var ruler = components[:minutesRuler];

    ruler.minutesOncesRuler = WatchUi.loadResource(Rez.Drawables.minutesOncesRuler);
    ruler.minutesDescRuler = WatchUi.loadResource(Rez.Drawables.minutesDescRuler);
}

function renderRenderMinutesRulerSystem(components) {
    var dc = components[:dc];
    var context = components[:context];
    var ruler = components[:minutesRuler];

    context.dc.setColor(0xaaffff, 0xaaffff);
    context.dc.setClip(146, 97, 73, 76);
    context.dc.clear();
    context.dc.drawBitmap(146, ruler.deltaIndex, ruler.minutesOncesRuler);
    context.dc.drawBitmap(150, ruler.deltaDecIndex, ruler.minutesDescRuler);
    context.dc.clearClip();
}

function setupRenderMinutesRulerSystem(systems, components) {
    if (components.hasKey(:minutesRuler) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderRenderMinutesRulerSystem),
            new Method({}, :initRenderMinutesRulerSystem)
        ]);
    }
}

// ========== Render hours ruler system =========
function initRenderHoursRulerSystem(components) {
    var ruler = components[:hoursRuler];
    ruler.rulerRes = WatchUi.loadResource(Rez.Drawables.hoursRuler);
}

function renderRenderHoursRulerSystem(components) {
    var dc = components[:dc];
    var context = components[:context];
    var ruler = components[:hoursRuler];

    context.dc.setColor(0xaaffff, 0xaaffff);
    context.dc.setClip(56, 97, 80, 62);
    context.dc.clear();
    context.dc.drawBitmap(56, ruler.deltaIndex, ruler.rulerRes);
    context.dc.clearClip();
}

function setupRenderHoursRulerSystem(systems, components) {
    if (components.hasKey(:hoursRuler) and components.hasKey(:render)) {
        systems.add([
            components,
            new Method({}, :renderRenderMinutesRulerSystem),
            new Method({}, :initRenderMinutesRulerSystem)
        ]);
    }
}

// ========= make systems ============
function makeSystemsFromEntites(entities, api as API_Functions) {
    var systems = [];
    var length = entities.size();

    for (var index = 0; index < length; index++) {
        var components = entities[index];
        if (isCompatibleUpdateCurrentTimeSystem(components)) {
            var system = createUpdateCurrentTimeSystem(components);
            systems.add([components, system]);
        }
        if (isCompatibleUpdateAltTimeSystem(components)) {
            var system = createUpdateAltTimeSystem(components);
            var init = createAltTimeInit();
            systems.add([components, system, init]);
        }
        if (isCompatibleRenderAltTimeSystem(components)) {
            var system = createRenderAltTimeSystem(components);
            systems.add([components, system]);
        }
        if (isCompatibleSecondsHandSystem(components)) {
            var system = createSecondsHandSystem(components);
            systems.add([components, system]);
        }
        if (isCompatibleRenderPolygon(components)) {
            var system = createRenderPolygon(components);
            systems.add([components, system]);
        }
        if (isCompatibleUpdateWatchStatusSystem(components)) {
            var system = createUpdateWatchStatusSystem(components);
            var init = createUpdateWatchStatusInit();
            systems.add([components, system, init]);
        }
        setupUpdateChargeSystem(systems, components);
        setupRenderChargeSystem(systems, components);
        setupRenderBackgroundSystem(systems, components);
        setupWeatherInfoSystem(systems, components);
        setupSunPositionSystem(systems, components);
        setupStressSensorSystem(systems, components);
        setupStepsSystem(systems, components);
        setupBarometerSensorSystem(systems, components);
        setupBodyBatterySystem(systems, components);
        setupBarometerSensorSystem(systems, components);
        setupCompassSensorSystem(systems, components);
        setupCurrentDateSystem(systems, components);
        setupDigitalTimeSystem(systems, components);
        setupHeartRateSystem(systems, components);
        setupHoursHandSystem(systems, components);
        setupMoonInfoSystem(systems, components);
        setupMultilineRenderSystem(systems, components);
        setupRenderBackgroundAlphaSystem(systems, components);
        setupRenderHeartRateGraphSystem(systems, components);
        setupRenderHoursRulerSystem(systems, components);
        setupRenderMinutesRulerSystem(systems, components);
        setupRenderSecondsRulerSystem(systems, components);
        setupRenderWatchStatusSystem(systems, components);
        setupSecondsRulerSystem(systems, components);
        //setupHoursRulerSystem(systems, components);
        //setupHourTicksSystem(systems, components);
        //setupMinuteTicksSystem(systems, components);
    }

    return systems;
}
