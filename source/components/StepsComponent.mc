import Toybox.Graphics;

class StepsComponent {
    static function create() as StepsComponent {
        var inst = new StepsComponent();
        return inst;
    }
    var color = Graphics.COLOR_GREEN;
    var position = [150, 195];
    var value = "0000";
    var distance = "0000";
}
