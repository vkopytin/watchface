using Toybox.Lang;

class RulerComponent {
    static function create() as RulerComponent {
        var inst = new RulerComponent();
        return inst;
    }

    var lastStep = 0;
    var lastDecStep = 0;
    var deltaIndex = 0;
    var deltaDecIndex = 0;


    var pid = Controller.create(0.03, 0.1, 0.1);

    var fastUpdate = 1000 as Lang.Long; // skip updates for 5 secs
    var accumulatedTime = 0 as Lang.Long;
    var rulerRes;
}
