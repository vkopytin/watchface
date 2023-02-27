import Toybox.Graphics;

class SunPositionComponent {
    static function create() {
        return new SunPositionComponent();
    }
    var color = Graphics.COLOR_GREEN;
    var position = [85, 35];
    var sunset = "-:--";
    var sunrise = "-:--";
    var locationDegrees = [51.107883, 17.038538];
}
