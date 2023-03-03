import Toybox.Graphics;

class SunPositionComponent {
    static function create() {
        return new SunPositionComponent();
    }
    var isDay = true;
    var color = 0x005555;
    var position = [85, 15];
    var sunset = "-:--";
    var sunrise = "-:--";
    var locationDegrees = [51.107883, 17.038538];
}
