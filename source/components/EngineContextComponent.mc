function makeEngineContextComponent() as EngineContextComponent {
    var inst = new EngineContextComponent();

    return inst;
}

class EngineContextComponent {
    var dc;

    var lastTime = System.getTimer();
    var deltaTime = 0;

    var width = 120;
    var height = 120;
    var centerPoint = [120, 120];
    var clipArea = [[100,100],[200,200]];
}
