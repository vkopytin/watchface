using Toybox.Lang;

function weatherComponentCreate() as WeatherComponent {
    var inst = new WeatherComponent();

    return inst;
}

class WeatherComponent {
    var color = 0x005555;
    var position = [60, 70];

    var weatherChar = "-";
    var temperature = 0;
    var temperatureChar = "-";
    var temperatureUnitChar = "L";

    var fastUpdate = (5 * 1000) as Lang.Long; // skip updates for 5 secs
    var accumulatedTime = 0 as Lang.Long;

    var weatherFont;
}
