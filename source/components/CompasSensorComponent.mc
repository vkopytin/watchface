using Toybox.Lang;

function compassSensorComponentCreate() as CompassSensorComponent {
    var inst = new CompassSensorComponent();

    return inst;
}

class CompassSensorComponent {
    var color = Graphics.COLOR_GREEN;
    var position = [0, 20];
    
    var spStr = "";

    var point = [0, 0];

    var fastUpdate = (60 * 1000) as Lang.Long; // keep fast updates for min
    var accumulatedTime = 0 as Lang.Long;
}
