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
}
