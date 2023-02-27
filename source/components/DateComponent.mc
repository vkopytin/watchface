import Toybox.System;
import Toybox.Lang;

function dateComponentCreate() {
    var inst = new DateComponent();

    return inst;
}

class DateComponent {
    var color = 0x00ff00;
    var dayOfWeek = 0;
    var month = 0;
    var day = 0;
    var year = 0;
    var position = [-50, -72];

    var point = [0, 0];
    var strValue = "";
}
