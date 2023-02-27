import Toybox.Graphics;

class BodyBatteryComponent {
    static function create() {
        return new BodyBatteryComponent();
    }
    var value = "";
    var color = Graphics.COLOR_GREEN;
    var position = [130, 220];
}
