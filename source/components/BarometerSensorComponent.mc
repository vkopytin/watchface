function barometerSensorComponentCreate() as BarometerSensorComponent {
    var inst = new BarometerSensorComponent();

    return inst;
}

class BarometerSensorComponent {
    var color = Graphics.COLOR_GREEN;
    var position = [-80, -10];
    
    var pressure = 1000.0;
    var point = [0, 0];
}
