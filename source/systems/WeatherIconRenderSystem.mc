import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Application;
import Toybox.Weather;

function weatherIconRenderSystemCreate(components) as WeatherIconRenderSystem {
    var inst = new WeatherIconRenderSystem(components);

    return inst;
}

function weatherIconRenderSystemIsCompatible(entity) {
    return entity.hasKey(:weather);
}

function weatherConditionToChar(condition) {
    switch (condition) {
        case Weather.CONDITION_CLEAR:
        case Weather.CONDITION_MOSTLY_CLEAR:
        case Weather.CONDITION_PARTLY_CLEAR:
            return "{";
        case Weather.CONDITION_MOSTLY_CLOUDY:
        case Weather.CONDITION_PARTLY_CLOUDY:
            return "B";
        case Weather.CONDITION_CLOUDY:
            return "F";
        case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
            return "Q";
        case Weather.CONDITION_CHANCE_OF_SHOWERS:
            return "o";
        case Weather.CONDITION_CHANCE_OF_SNOW:
            return "u";
        case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
            return "f";
        case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
            return "l";
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
            return "V";
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
            return "P";
        case Weather.CONDITION_LIGHT_RAIN_SNOW:
            return "t";
        case Weather.CONDITION_SCATTERED_SHOWERS:
        case Weather.CONDITION_LIGHT_SHOWERS:
            return "o";
        case Weather.CONDITION_LIGHT_SNOW:
            return "u";
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
            return "5";
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

class WeatherIconRenderSystem {
    var engine;
    var weather as WeatherComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (5 * 1000) as Long; // skip updates for 5 secs
    var accumulatedTime = self.fastUpdate + 1 as Long;

    var weatherFont;

    function initialize(components) {
        self.engine = components[:engine];
        self.weather = components[:weather];
        self.stats = components[:stats];
    }

    function init() {
        self.weatherFont = Application.loadResource(Rez.Fonts.weather32);
    }

    function update(deltaTime) {
        self.accumulatedTime += deltaTime;
        if (self.accumulatedTime < self.fastUpdate) {
            return;
        }

        self.accumulatedTime = 0;

        var screenCenterPoint = self.engine.centerPoint;
        var moveMatrix = [screenCenterPoint];
        self.weather.point = add([self.weather.position], moveMatrix)[0];

        var cond = Toybox.Weather.getCurrentConditions();
        if (cond == null) {
            return;
        }

        if (cond.condition != null) {
            self.weather.weatherChar = weatherConditionToChar(cond.condition);
        }

        try {
            self.weather.temperature = temperatureInCelcius(cond.temperature);
            self.weather.temperatureChar = temperatureToChar(self.weather.temperature);
            self.weather.temperatureUnitChar = temperatureUnitToChar(System.getDeviceSettings().temperatureUnits);
        } catch (ex) {

        }
    }

    function render(dc, context) {
        var point = self.weather.point;

        dc.setColor(self.weather.color, Graphics.COLOR_TRANSPARENT);

        if (self.weather.weatherChar != "-") {
            dc.drawText(point[0], point[1], self.weatherFont, self.weather.weatherChar, Graphics.TEXT_JUSTIFY_CENTER);
        }

        if (self.weather.temperatureChar != "-") {
            dc.drawText(point[0] - 10, point[1] + 28, self.weatherFont, self.weather.temperatureChar, Graphics.TEXT_JUSTIFY_RIGHT);
        }

        dc.drawText(point[0] + 10, point[1] + 28, self.weatherFont, self.weather.temperatureUnitChar, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(point[0] + 1, point[1] + 30, Graphics.FONT_SYSTEM_TINY, self.weather.temperature, Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class UpdateWeather {
function exec(entity, components) {
    var context = components[:context] as EngineContextComponent;
    var weather = components[:weather] as WeatherComponent;
    var titles = components[:titles];

    weather.accumulatedTime -= context.deltaTime;
    if (weather.accumulatedTime > 0) {
        return;
    }

    weather.accumulatedTime = weather.updateEvery;

    var screenCenterPoint = context.centerPoint;
    var moveMatrix = [screenCenterPoint];
    weather.point = add([weather.position], moveMatrix)[0];

    var cond = Toybox.Weather.getCurrentConditions();
    if (cond == null) {
        return;
    }

    if (cond.condition != null) {
        weather.weatherChar = weatherConditionToChar(cond.condition);
    }

    try {
        weather.temperature = temperatureInCelcius(cond.temperature);
        weather.temperatureChar = temperatureToChar(weather.temperature);
        weather.temperatureUnitChar = temperatureUnitToChar(System.getDeviceSettings().temperatureUnits);

        titles.color = weather.color;
        titles.titles = [];
        if (weather.weatherChar != "-") {
            titles.titles.add([weather.point[0], weather.point[1], weather.weatherFont, weather.weatherChar, Graphics.TEXT_JUSTIFY_CENTER]);
        }

        if (weather.temperatureChar != "-") {
            titles.titles.add([weather.point[0] - 10, weather.point[1] + 28, weather.weatherFont, weather.temperatureChar, Graphics.TEXT_JUSTIFY_RIGHT]);
        }

        titles.titles.add([weather.point[0] + 10, weather.point[1] + 28, weather.weatherFont, weather.temperatureUnitChar, Graphics.TEXT_JUSTIFY_LEFT]);
        titles.titles.add([weather.point[0] + 1, weather.point[1] + 30, Graphics.FONT_SYSTEM_TINY, weather.temperature, Graphics.TEXT_JUSTIFY_CENTER]);
    } catch (ex) {

    }
}
}

function makeUpdateWeatherDelegate() {
    return new UpdateWeather();
}

class RenderWeather {
function exec(entity, components) {
    var weather = components[:weather];
    var context = components[:context];
    var dc = context.dc;

    if (dc == null) {
        return;
    }

    var point = weather.point;
    dc.setColor(weather.color, Graphics.COLOR_TRANSPARENT);

    if (weather.weatherChar != "-") {
        dc.drawText(point[0], point[1], weather.weatherFont, weather.weatherChar, Graphics.TEXT_JUSTIFY_CENTER);
    }

    if (weather.temperatureChar != "-") {
        dc.drawText(point[0] - 10, point[1] + 28, weather.weatherFont, weather.temperatureChar, Graphics.TEXT_JUSTIFY_RIGHT);
    }

    dc.drawText(point[0] + 10, point[1] + 28, weather.weatherFont, weather.temperatureUnitChar, Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(point[0] + 1, point[1] + 30, Graphics.FONT_SYSTEM_TINY, weather.temperature, Graphics.TEXT_JUSTIFY_CENTER);
}
}

function makeRenderWeatherDelegate() {
    return new RenderWeather();
}

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
