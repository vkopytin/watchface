import Toybox.Graphics;

class MoonInfoComponent {
    static function create() as MoonInfoComponent {
        return new MoonInfoComponent();
    }

    var description = "";
    var age = "";
    var image = 0;
    var illum = "--%";
    var color = 0x005555;
    var position = [30, 130];
    var sunset = "-:--";
    var sunrise = "-:--";
}
