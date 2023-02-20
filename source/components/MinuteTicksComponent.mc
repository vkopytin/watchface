import Toybox.Lang;

function minuteTicksCreate() as MinuteTicksComponent {
    var inst = new MinuteTicksComponent();

    return inst;
}

class MinuteTicksComponent {
    var fastUpdate = (60 * 60 * 1000) as Long; // skip updates for hour
    var accumulatedTime = 1000 as Long;

    var color = Graphics.COLOR_GREEN;

    var mesh = [
        [-1, 124],
        [-1, 127],
        [1, 127],
        [1, 124],
    ];
}
