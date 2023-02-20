import Toybox.System;
import Toybox.Lang;

function dateComponentCreate() {
    var inst = new DateComponent();

    return inst;
}

class DateComponent {
    var fastUpdate = (60 * 1000) as Long; // keep fast updates for min
    var accumulatedTime = 0 as Long;

    var color = Graphics.COLOR_GREEN;
    var dayOfWeek = 0;
    var month = 0;
    var day = 0;
    var position = [90, -10];
    var point = [0, 0];
}
