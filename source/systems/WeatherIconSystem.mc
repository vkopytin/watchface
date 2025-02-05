import Toybox.Lang;
using Toybox.System;
using Toybox.Application;
using Toybox.Weather;


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

class WeatherIconSystem {
    static function create(components) as WeatherIconSystem {
        var inst = new WeatherIconSystem(components);

        return inst;
    }

    static function isCompatible(entity) {
        return entity.hasKey(:weather) and entity.hasKey(:sunPosition);
    }

    var engine as Engine;
    var weather as WeatherComponent;
    var sunPosition as SunPositionComponent;

    var fastUpdate = (5 * 1000) as Long; // skip updates for 5 secs
    var accumulatedTime = 0 as Long;

    var weatherFont;

    function initialize(components) {
        self.engine = components[:engine];
        self.weather = components[:weather];
        self.sunPosition = components[:sunPosition];
    }

    function init() {
        self.weatherFont = Application.loadResource(Rez.Fonts.weather32);
    }

    function update(deltaTime) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var cond = Toybox.Weather.getCurrentConditions();
        if (cond == null) {
            return;
        }

        if (cond.condition != null) {
            self.weather.weatherChar = weatherConditionToChar(cond.condition, self.sunPosition.isDay);
        }

        try {
            self.weather.temperature = temperatureInCelcius(cond.temperature);
            self.weather.temperatureChar = temperatureToChar(self.weather.temperature);
            self.weather.temperatureUnitChar = temperatureUnitToChar(System.getDeviceSettings().temperatureUnits);
        } catch (ex) {

        }
    }

    function render(dc, context) {
        dc.setColor(self.weather.color, Graphics.COLOR_TRANSPARENT);

        if (self.weather.weatherChar != "-") {
            dc.drawText(self.weather.position[0], self.weather.position[1],
                self.weatherFont, self.weather.weatherChar, Graphics.TEXT_JUSTIFY_CENTER
            );
        }

        if (self.weather.temperatureChar != "-") {
            dc.drawText(
                self.weather.position[0] - 10, self.weather.position[1] + 28,
                self.weatherFont, self.weather.temperatureChar, Graphics.TEXT_JUSTIFY_RIGHT
            );
        }

        dc.drawText(
            self.weather.position[0] + 10, self.weather.position[1] + 28,
            self.weatherFont, self.weather.temperatureUnitChar, Graphics.TEXT_JUSTIFY_LEFT
        );
        dc.drawText(
            self.weather.position[0] + 1, self.weather.position[1] + 30,
            Graphics.FONT_SYSTEM_TINY, self.weather.temperature, Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}
