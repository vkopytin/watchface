function barometerSensorComponentCreate() as BarometerSensorComponent {
    var inst = new BarometerSensorComponent();

    return inst;
}

class BarometerSensorComponent {
    var color = Graphics.COLOR_GREEN;
    var position = [40, -72];
    
    var pressure = 1000.0;
    var pressureStr = "--.-";
    var point = [0, 0];

    var gaugeMesh = [];
    var ranges = [950.0, 966.0, 984.0, 1000.0, 1027.0, 1041.0, 1055.0, 1070.0];
    var colors = [Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLUE, Graphics.COLOR_DK_BLUE, Graphics.COLOR_YELLOW, Graphics.COLOR_ORANGE, Graphics.COLOR_RED, Graphics.COLOR_PINK];
}
