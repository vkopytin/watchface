import Toybox.Graphics;

class DigitalTimeComponent {
    static function create() as DigitalTimeComponent {
        return new DigitalTimeComponent();
    }

    var color = Graphics.COLOR_GREEN;
    var position = [92, 140];
    var timeTitle = "00:00:00";
}
