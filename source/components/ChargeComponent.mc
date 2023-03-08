using Toybox.Lang;

class ChargeComponent {
    static function create() {
        return new ChargeComponent();
    }

    var position = [100, 80];
    var deltaIndex = 0;

    var chargeAmount;

    var fastUpdate = (60 * 1000) as Lang.Long; // keep fast updates for hour
    var accumulatedTime = 0 as Lang.Long;
}
