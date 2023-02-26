class RulerComponent {
    static function create() as RulerComponent {
        var inst = new RulerComponent();
        return inst;
    }

    var lastStep = 0;
    var lastDecStep = 0;
    var deltaIndex = 0;
    var deltaDecIndex = 0;
}