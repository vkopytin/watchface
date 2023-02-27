import Toybox.System;
import Toybox.Lang;

function timeComponentCreate() {
    var clockTime = System.getClockTime();
    var inst = new TimeComponent();

    inst.hours = 1.0 * clockTime.hour;
    inst.minutes = 1.0 * clockTime.min;
    inst.seconds = 1.0 * clockTime.sec;
    inst.offset = clockTime.timeZoneOffset;

    return inst;
}

class TimeComponent {
    var hours = 0.0 as Float;
    var minutes = 0.0 as Float;
    var seconds = 0.0 as Float;
    var offset = 0;
}
