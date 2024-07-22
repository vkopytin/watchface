using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Position;

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

    var fastUpdate = (60 * 60 * 1000) as Lang.Long; // skip updates for 1 hour
    var accumulatedTime = 0 as Lang.Long;

    var myInfo as Position.Info or Null;
    var images = {
        Rez.Drawables.Phase00 => null,
        Rez.Drawables.Phase17 => null,
        Rez.Drawables.Phase26 => null,
        Rez.Drawables.Phase35 => null,
        Rez.Drawables.Phase44 => null,
        Rez.Drawables.Phase53 => null,
        Rez.Drawables.Phase62 => null,
        Rez.Drawables.Phase71 => null,
    };
    var api;
}
