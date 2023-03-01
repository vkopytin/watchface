import Toybox.Graphics;

class DigitalTimeComponent {
    static function create() as DigitalTimeComponent {
        return new DigitalTimeComponent();
    }

    var color = 0x005555;
    var position = [62, 140];
    var timeTitle = "00:00:00";
}
