import Toybox.Lang;

function hourTicksCreate() as HourTicksComponent {
    var inst = new HourTicksComponent();

    return inst;
}

class HourTicksComponent {
    var fastUpdate = (60 * 60 * 1000) as Long; // skip updates for hour
    var accumulatedTime = 1000 as Long;
    
    var color = Graphics.COLOR_DK_GREEN;

    var mesh = [
        [-2, 120],
        [-2, 128],
        [2, 128],
        [2, 120],
    ];
}
