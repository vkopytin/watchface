import Toybox.Math;
import Toybox.Lang;

class SecondsHandSystem {
    static function setup(systems, entity, api) {
        if (entity.hasKey(:time) and entity.hasKey(:secondsHand) and entity.hasKey(:polygon)) {
            systems.add(new SecondsHandSystem(entity));
        }
    }

    var components;
    var engine as Engine;
    var time as TimeComponent;
    var hand as HandComponent;
    var polygon as ShapeComponent;
    var light = false;

    var PIDiv30 = Math.PI / 30.0;
    var oldPoint = new [1];
    var length = 0;
    var cacheClipArea = new [60];
    var transformMatrix = [[0, 0], [0, 0]];
    var coordinates;
    var idxLength = 0;

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
        self.time = components[:time];
        self.hand = components[:secondsHand];
        self.polygon = components[:polygon];
        self.light = components[:light];
    }

    function init() {
        self.hand.clipAreas = self.light ? self.hand.clipAreas : Application.loadResource(Rez.JsonData.clipAreas);
        self.coordinates = self.light ? self.hand.sleepModeCoordinates : self.hand.coordinates;
        self.length = coordinates.size();

        var result = new [self.length];
        for (var index = 0; index < self.length; index += 1) {
            var idxLength = self.coordinates[index][1].size();
            var res = new [idxLength];
            for (var idx = 0; idx < idxLength; idx++) {
                res[idx] = [0,0];
            }
            result[index] = [self.coordinates[index][0], res, idxLength];
        }

        self.polygon.mesh = result;
        self.polygon.length = result.size();
    }

    function update(deltaTime) {
        var angle = self.time.seconds * self.PIDiv30;

        self.transformMatrix[0][0] = Math.cos(angle);
        self.transformMatrix[0][1] = Math.sin(angle);
        self.transformMatrix[1][0] = -self.transformMatrix[0][1];
        self.transformMatrix[1][1] = self.transformMatrix[0][0];

        for (var index = 0; index < self.length; index += 1) {
            self.idxLength = self.polygon.mesh[index][2];
            var res = self.polygon.mesh[index][1];
            arrayMultiply(res, self.coordinates[index][1], self.transformMatrix, self.idxLength, 2, 2);
            for (var idx = 0; idx < idxLength; idx += 1) {
                res[idx][0] = res[idx][0] + self.engine.centerPoint[0];
                res[idx][1] = res[idx][1] + self.engine.centerPoint[1];
            }
        }

        self.engine.clipArea = self.hand.clipAreas[self.time.secondsNumber];
        /*if (self.light == null) {
            return;
        }
        if (self.cacheClipArea[self.time.secondsNumber] != null) {
            self.engine.clipArea = self.cacheClipArea[self.time.secondsNumber];
            System.println(self.cacheClipArea);
            return;
        }
        var minX = self.engine.width;
        var minY = self.engine.height;
        var maxX = 0;
        var maxY = 0;
        for (var index = 0; index < self.length; index += 1) {
            var idxLength = self.polygon.mesh[index][1].size();
            var res = new [idxLength];
            for (var idx = 0; idx < idxLength; idx++) {
                var point = self.polygon.mesh[index][1][idx];
                minX = min(minX, point[0]);
                minY = min(minY, point[1]);
                maxX = max(maxX, point[0]);
                maxY = max(maxY, point[1]);
            }
        }
        self.cacheClipArea[self.time.secondsNumber] = [
            [max(0, minX - 12).toNumber(),
            max(0, minY - 12).toNumber()],
            [min(self.engine.width - max(0, minX - 12), maxX - self.engine.clipArea[0][0] + 12).toNumber(),
            min(self.engine.height - max(0, minY - 12), maxY - self.engine.clipArea[0][1] + 12).toNumber()]
        ];
        self.engine.clipArea = self.cacheClipArea[self.time.secondsNumber];*/
    }
}
