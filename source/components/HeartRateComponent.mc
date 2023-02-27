import Toybox.Graphics;

class HeartRateComponent {
    static function create() {
        return new HeartRateComponent();
    }
    var color = Graphics.COLOR_GREEN;
    var position = [20, 90];
    var value = "--";
}
