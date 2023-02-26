function weatherComponentCreate() as WeatherComponent {
    var inst = new WeatherComponent();

    return inst;
}

class WeatherComponent {
    var color = Graphics.COLOR_GREEN;
    var position = [0, -120];

    var weatherChar = "-";
    var temperature = 0;
    var temperatureChar = "-";
    var temperatureUnitChar = "L";
    var point = [0, -100];
}
