import Toybox.Graphics;

class AltTimeComponent {
    static function createInNewYork() as AltTimeComponent {
        var inst = new AltTimeComponent();

        inst.position = [180, 160];
        inst.location = [40.730610, -73.935242];
        inst.format = "NYhh:mm";

        return inst;
    }

    static function createInKyiv() as AltTimeComponent {
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
}
