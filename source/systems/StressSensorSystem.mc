import Toybox.Lang;
import Toybox.Math;
import Toybox.WatchUi;

function stressSensorSystemCreate(components) as StressSensorSystem {
    var inst = new StressSensorSystem(components);

    return inst;
}

function stressSensorSystemIsCompatible(entity) as Boolean {
    return entity.hasKey(:stress);
}

class StressSensorSystem {
    var engine as Engine;
    var stress as StressSensorComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (5 * 1000) as Long; // keep fast updates for 5 secs
    var accumulatedTime = 0 as Long;
    var stressRuler;

    function initialize(components) {
        self.engine = components[:engine] as Engine;
        self.stress = components[:stress] as StressSensorComponent;
        self.stats = components[:stats];
    }

    function init() {
        self.stressRuler = WatchUi.loadResource(Rez.Drawables.stressRuler);
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var stressIterator = Toybox.SensorHistory.getStressHistory({ :period => 1 });
		var sample = stressIterator.next();
        if (sample == null) {
            return;
        }

        self.stress.value = sample.data;
        var step = 12;
        var offset = self.stress.position[1];

        if (self.stress.value > 95) {
            self.stress.deltaIndex = offset;
        } else if (self.stress.value > 90) {
            self.stress.deltaIndex = offset - step;
        } else if (self.stress.value > 85){
            self.stress.deltaIndex = offset - 2 * step;
        } else if (self.stress.value > 80) {
            self.stress.deltaIndex = offset - 3 * step;
        } else if (self.stress.value > 75) {
            self.stress.deltaIndex = offset - 4 * step;
        } else if (self.stress.value > 70) {
            self.stress.deltaIndex = offset - 5 * step;
        } else if (self.stress.value > 65) {
            self.stress.deltaIndex = offset - 6 * step;
        } else if (self.stress.value > 60) {
            self.stress.deltaIndex = offset - 7 * step;
        } else if (self.stress.value > 54){
            self.stress.deltaIndex = offset - 8 * step;
        } else if (self.stress.value > 48) {
            self.stress.deltaIndex = offset - 9 * step;
        } else if (self.stress.value > 42) {
            self.stress.deltaIndex = offset - 10 * step;
        } else if (self.stress.value > 36) {
            self.stress.deltaIndex = offset - 11 * step;
        } else if (self.stress.value > 30) {
            self.stress.deltaIndex = offset - 12 * step;
        } else if (self.stress.value > 24) {
            self.stress.deltaIndex = offset - 13 * step;
        } else if (self.stress.value > 18){
            self.stress.deltaIndex = offset - 14 * step;
        } else if (self.stress.value > 12) {
            self.stress.deltaIndex = offset - 15 * step;
        } else if (self.stress.value > 6) {
            self.stress.deltaIndex = offset - 16 * step;
        } else {
            self.stress.deltaIndex = offset - 17 * step;
        }

        self.stress.strValue = sample.data.format("%d");
        self.stress.currentWidth = (self.stress.width / 100.0 * self.stress.value).toNumber();
    }

    function render(dc, context) {
        //dc.setClip(self.stress.position[0], self.stress.position[1], 103, 12);
        //dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        //dc.drawRectangle(self.stress.position[0], self.stress.position[1], 103, 12);
        //dc.drawBitmap(self.stress.position[0], self.stress.deltaIndex, self.stressRuler);
        //dc.clearClip();
        dc.setColor(0x005555, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(
            self.stress.position[0], self.stress.position[1],
            self.stress.currentWidth,
            self.stress.height
        );
        dc.setColor(0xaaffff, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(
            self.stress.position[0] + self.stress.currentWidth, self.stress.position[1],
            self.stress.width - self.stress.currentWidth,
            self.stress.height
        );
    }
}
