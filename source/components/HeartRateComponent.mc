import Toybox.Graphics;

class HeartRateComponent {
    static function create() {
        return new HeartRateComponent();
    }
    var data = [];
    var dataLength = 0;
    var color = 0x005555;
    var position = [16, 90];
    var value = "--";
}
