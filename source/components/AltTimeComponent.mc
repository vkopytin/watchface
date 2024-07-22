import Toybox.Graphics;
import Toybox.Lang;

class AltTimeComponent {
    function createInNewYork() as AltTimeComponent {
        var inst = new AltTimeComponent();

        inst.position = [180, 160];
        inst.location = [40.730610, -73.935242];
        inst.format = "NYhh:mm";

        return inst;
    }

    function createInKyiv() as AltTimeComponent {
        var inst = new AltTimeComponent();

        inst.position = [180, 140];
        inst.location = [50.450001, 30.523333];
        inst.format = "KYhh:mm";

        return inst;
    }

    var color = 0x000000;
    var format = "NY hh:mm";
    var position = [50, 200];
    var location = [40.730610, -73.935242]; // New York
    var value = "00:00";

    var lcdDisplayFont;
    var timezoneDiffDuration;
    var where;

    var fastUpdate = (60 * 1000) as Long; // keep fast updates for minute
    var accumulatedTime = 0 as Long;
    var api;
}
