import Toybox.Graphics;
import Toybox.ActivityMonitor;
import Toybox.UserProfile;
import Toybox.SensorHistory;
import Toybox.Math;
import Toybox.Lang;

class RenderHeartRateGraphSystem {
    static function setup(systems, entity, api) {
        if (entity.hasKey(:heartRateGraph)) {
			systems.add(new RenderHeartRateGraphSystem(entity));
		}
    }

	var engine;
	var heartRate as HeartRateComponent;

	var fastUpdate = (5 * 1000) as Long; // keep fast updates for 5 secs
    var accumulatedTime = 0 as Long;

	var arrayColours = [Graphics.COLOR_DK_GRAY, Graphics.COLOR_RED, Graphics.COLOR_DK_RED, Graphics.COLOR_ORANGE, Graphics.COLOR_YELLOW, Graphics.COLOR_GREEN, Graphics.COLOR_DK_GREEN, Graphics.COLOR_BLUE, Graphics.COLOR_DK_BLUE, Graphics.COLOR_PURPLE, Graphics.COLOR_PINK];
	var heartRateZones = [];
	var useZonesColour = true;
	var graphColour = 1;
	var position = [50, 168];
	var totHeight = 40;
	var totWidth = 40;
	var moveBarLevel;

	function initialize(components) {
		self.engine = components[:engine];
		self.heartRate = components[:heartRate];
	}

	function init() {
		self.heartRateZones = UserProfile.getHeartRateZones(UserProfile.getCurrentSport());
		self.moveBarLevel = ActivityMonitor.getInfo().moveBarLevel;
	}

	function update(deltaTime as Long) as Void {
		self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;
		var sample = SensorHistory.getHeartRateHistory({ :order => SensorHistory.ORDER_NEWEST_FIRST });
		if (sample == null) {
			return;
		}
		
		var res = [];
		var binPixels = 1;

		var curHeartMin = 0;
		var curHeartMax = 0;
		var heartNow = 0;
		var heartMin = 0;
		var heartMax = 220;
		var graphLength = 100;
		var width = self.engine.width;
		var showMoveBar = true;

		if (sample != null) {		    	
			var heart = sample.next();
			if (heart.data != null) {
				heartNow = heart.data;
			}
		
			curHeartMin = heartMin;
			curHeartMax = heartMax;
			heartMin = 1000;
			heartMax = 0;

			var maxSecs = graphLength * 60;
			//if (maxSecs < 900) {
				maxSecs = 900; // 900sec = 15min
			//} else if (maxSecs > 14355) {
			//	maxSecs = 14355; // 14400sec = 4hrs
			//}

			var totBins = Math.ceil(totWidth / binPixels).toNumber();
			var binWidthSecs = Math.floor(binPixels * maxSecs / totWidth).toNumber();	

			var heartSecs;
			var heartValue = 0;
			var secsBin = 0;
			var lastHeartSecs = sample.getNewestSampleTime().value();
			var heartBinMax;
			var heartBinMin;

			var finished = false;

			for (var i = 0; i < totBins; ++i) {

				heartBinMax = 0;
				heartBinMin = 0;

				if (!finished) {
					// deal with carryover values
					if (secsBin > 0 && heartValue != null) {
						heartBinMax = heartValue;
						heartBinMin = heartValue;
					}

					// deal with new values in this bin
					while (!finished && secsBin < binWidthSecs) {
						heart = sample.next();
						if (heart != null) {
							heartValue = heart.data;
							if (heartValue != null) {
								if (heartBinMax == 0) {
									heartBinMax = heartValue;
									heartBinMin = heartValue;
								} else {
									if (heartValue > heartBinMax) {
										heartBinMax = heartValue;
									}
									
									if (heartValue < heartBinMin) {
										heartBinMin = heartValue;
									}
								}
							}
							
							// keep track of time in this bin
							heartSecs = lastHeartSecs - heart.when.value();
							lastHeartSecs = heart.when.value();
							secsBin += heartSecs;

//							Sys.println(i + ":   " + heartValue + " " + heartSecs + " " + secsBin + " " + heartBinMin + " " + heartBinMax);
						} else {
							finished = true;
						}
						
					} // while secsBin < binWidthSecs

					if (secsBin >= binWidthSecs) {
						secsBin -= binWidthSecs;
					}

					// only plot bar if we have valid values
					if (heartBinMax > 0 && heartBinMax >= heartBinMin) {
						if (curHeartMax > 0 && curHeartMax > curHeartMin) {
							var heartBinMid = (heartBinMax + heartBinMin) / 2;
							var height = (heartBinMid - curHeartMin * 0.9) / (curHeartMax - curHeartMin * 0.9) * totHeight;
							var xVal = (width - totWidth) / 2 + totWidth - i * binPixels - position[0];
							var yVal = height / 2 + position[1] + totHeight - height;

							var color = Graphics.COLOR_RED;
							if (showMoveBar && self.moveBarLevel > 0) {
								if (graphColour == 1) {
									color = Graphics.COLOR_ORANGE;
								}
							} else {
								color = arrayColours[getHRColour(heartBinMid)];
							}
							
							res.add([color, xVal, yVal, binPixels, height]);
						}

						if (heartBinMin < heartMin) {
							heartMin = heartBinMin;
						}
						if (heartBinMax > heartMax) {
							heartMax = heartBinMax;
						}
					}				
					
				}
				
			}
			self.heartRate.data = res;
			self.heartRate.dataLength = res.size();
		}
	}

	function render(dc, context) {
		for (var index = 0; index < self.heartRate.dataLength; index++) {
			var row = self.heartRate.data[index];
			dc.setColor(row[0], Graphics.COLOR_TRANSPARENT);
			dc.fillRectangle(row[1], row[2], row[3], row[4]);
		}
	}

	function getHRColour(heartrate)
	{
		if (!useZonesColour || heartrate == null || heartrate < heartRateZones[1])
			{ return graphColour; } 
//		else if (heartrate >= heartRateZones[0] && heartrate < heartRateZones[1])
//			{ return 0; } 
		else if (heartrate >= heartRateZones[1] && heartrate < heartRateZones[2])
			{ return 7; } 
		else if (heartrate >= heartRateZones[2] && heartrate < heartRateZones[3])
			{ return 5; } 
		else if (heartrate >= heartRateZones[3] && heartrate < heartRateZones[4])
			{ return 3; } 
		else
			{ return 2; }
	}
}
