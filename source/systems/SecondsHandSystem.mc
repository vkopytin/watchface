import Toybox.Math;
import Toybox.Lang;

class SecondsHandSystem {
    function setup(systems, entity, api) {
        if (entity.hasKey(:time) and entity.hasKey(:secondsHand) and entity.hasKey(:polygon)) {
            systems.add(new SecondsHandSystem(entity));
        }
    }

    var components;
    var engine as Engine;
    var time as TimeComponent;
    var hand as HandComponent;
    var polygon as ShapeComponent;
    var stats as PerformanceStatisticsComponent;

    var PIDiv30 = Math.PI / 30.0;
    var oldPoint = new [1];
    var length = 0;
    var cacheClipArea = new [60];
    var transformMatrix = [[0, 0], [0, 0]];
    var clipAreas;

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
        self.time = components[:time];
        self.hand = components[:secondsHand];
        self.polygon = components[:polygon];
        self.stats = components[:stats];
    }

    function init() {
        self.clipAreas = Application.loadResource(Rez.JsonData.clipAreas);
        var screenCenterPoint = self.engine.centerPoint;
        self.length = self.hand.coordinates.size();

        var result = new [self.length];
        for (var index = 0; index < self.length; index += 1) {
            var idxLength = self.hand.coordinates[index][1].size();
            var res = new [idxLength];
            for (var idx = 0; idx < idxLength; idx++) {
                res[idx] = [0,0];
            }
            result[index] = [self.hand.coordinates[index][0], res, idxLength];
        }

        self.polygon.mesh = result;
    }

    function update(deltaTime) {
        var angle = self.time.seconds * self.PIDiv30;

        self.transformMatrix[0][0] = Math.cos(angle);
        self.transformMatrix[0][1] = Math.sin(angle);
        self.transformMatrix[1][0] = -self.transformMatrix[0][1];
        self.transformMatrix[1][1] = self.transformMatrix[0][0];

        var result = self.polygon.mesh;
        for (var index = 0; index < self.length; index += 1) {
            var idxLength = self.polygon.mesh[index][2]; //self.hand.coordinates[index][1].size();
            var res = self.polygon.mesh[index][1]; // new [idxLength]
            var turnedMesh = arrayMultiply(res, self.hand.coordinates[index][1], self.transformMatrix, idxLength, 2, 2);
            for (var idx = 0; idx < idxLength; idx += 1) {
                res[idx][0] = turnedMesh[idx][0] + self.engine.centerPoint[0];
                res[idx][1] = turnedMesh[idx][1] + self.engine.centerPoint[1];
            }
        }

        self.engine.clipArea = self.clipAreas[self.time.secondsNumber];
    }
}
