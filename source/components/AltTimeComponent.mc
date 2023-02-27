import Toybox.Graphics;

class AltTimeComponent {
    function createInNewYork() as AltTimeComponent {
        var inst = new AltTimeComponent();

        inst.position = [50, 200];
        inst.location = [40.730610, -73.935242];
        inst.format = "NY hh:mm";

        return inst;
    }

    function createInKyiv() as AltTimeComponent {
        var inst = new AltTimeComponent();

        inst.position = [50, 214];
        inst.location = [50.450001, 30.523333];
        inst.format = "KY hh:mm";

        return inst;
    }

    var color = Graphics.COLOR_GREEN;
    var format = "NY hh:mm";
    var position = [50, 200];
    var location = [40.730610, -73.935242]; // New York
    var value = "00:00";
}
