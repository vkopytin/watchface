import Toybox.Lang;

function weatherComponentCreate() as WeatherComponent {
    var inst = new WeatherComponent();

    return inst;
}

class WeatherComponent {
    var updateEvery = (5 * 1000) as Long; // keep fast updates for 5 secs
    var accumulatedTime = 0 as Long;
    
    var color = Graphics.COLOR_GREEN;
    var position = [0, -100];

    var weatherChar = "-";
    var temperature = 0;
    var temperatureChar = "-";
    var temperatureUnitChar = "L";
    var point = [0, -100];

    var weatherFont = Application.loadResource(Rez.Fonts.weather32);
}
