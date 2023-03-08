using Toybox.Graphics;
using Toybox.Lang;

class DigitalTimeComponent {
    static function create() as DigitalTimeComponent {
        return new DigitalTimeComponent();
    }

    var color = 0x005555;
    var position = [200, 95];
    var timeTitle = "00:00";

    var lcdDisplayFont;

    var fastUpdate = 500 as Lang.Long; // keep fast updates for minute
    var accumulatedTime = 0 as Lang.Long;
}
