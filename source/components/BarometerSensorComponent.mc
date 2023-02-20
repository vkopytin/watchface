import Toybox.Lang;
import Toybox.Graphics;

function barometerSensorComponentCreate() as BarometerSensorComponent {
    var inst = new BarometerSensorComponent();

    return inst;
}

class BarometerSensorComponent {
    var fastUpdate = (60 * 1000) as Long; // keep fast updates for min
    var accumulatedTime = 0 as Long;

    var color = Graphics.COLOR_GREEN;
    var position = [-80, -10];
    
    var pressure = 1000.0;
    var pressureStr = "--.-";
    var point = [0, 0];

    var gaugeMesh = [];
    var ranges = [930.0, 966.0, 984.0, 1000.0, 1027.0, 1041.0, 1055.0, 1070.0];
    var colors = [Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLUE, Graphics.COLOR_DK_BLUE, Graphics.COLOR_YELLOW, Graphics.COLOR_ORANGE, Graphics.COLOR_RED, Graphics.COLOR_PINK];
}
