import Toybox.Math;
import Toybox.Time;
import Toybox.Lang;

enum {
    ASTRO_DAWN,
    NAUTIC_DAWN,
    DAWN,
    BLUE_HOUR_AM,
    SUNRISE,
    SUNRISE_END,
    GOLDEN_HOUR_AM,
    NOON,
    GOLDEN_HOUR_PM,
    SUNSET_START,
    SUNSET,
    BLUE_HOUR_PM,
    DUSK,
    NAUTIC_DUSK,
    ASTRO_DUSK,
    NUM_RESULTS
}

class API_Functions {
    static function create() {
        var inst = new API_Functions();

        return inst;
    }
    
    hidden const PI   = Math.PI,
        RAD  = Math.PI / 180.0,
        PI2  = Math.PI * 2.0,
        DAYS = Time.Gregorian.SECONDS_PER_DAY,
        J1970 = 2440588,
        J2000 = 2451545,
        J0 = 0.0009;

    hidden const TIMES = [
        -18 * RAD,    // ASTRO_DAWN
        -12 * RAD,    // NAUTIC_DAWN
        -6 * RAD,     // DAWN
        -4 * RAD,     // BLUE_HOUR
        -0.833 * RAD, // SUNRISE
        -0.3 * RAD,   // SUNRISE_END
        6 * RAD,      // GOLDEN_HOUR_AM
        null,         // NOON
        6 * RAD,
        -0.3 * RAD,
        -0.833 * RAD,
        -4 * RAD,
        -6 * RAD,
        -12 * RAD,
        -18 * RAD
        ];

    var lastD, lastLng;
    var	n, ds, M, sinM, C, L, sin2L, dec, Jnoon;

    function initialize() {
        lastD = null;
        lastLng = null;
    }

    function fromJulian(j) {
        return new Time.Moment((j + 0.5 - J1970) * DAYS);
    }

    function round(a) {
        if (a > 0) {
            return (a + 0.5).toNumber().toFloat();
        } else {
            return (a - 0.5).toNumber().toFloat();
        }
    }

    // lat and lng in radians
    function calculate(moment, pos, what) {
        var lat = pos[0];
        var lng = pos[1];

        var d = moment.value().toDouble() / DAYS - 0.5 + J1970 - J2000;
        if (lastD != d || lastLng != lng) {
            n = round(d - J0 + lng / PI2);
//			ds = J0 - lng / PI2 + n;
            ds = J0 - lng / PI2 + n - 1.1574e-5 * 68;
            M = 6.240059967 + 0.0172019715 * ds;
            sinM = Math.sin(M);
            C = (1.9148 * sinM + 0.02 * Math.sin(2 * M) + 0.0003 * Math.sin(3 * M)) * RAD;
            L = M + C + 1.796593063 + PI;
            sin2L = Math.sin(2 * L);
            dec = Math.asin( 0.397783703 * Math.sin(L) );
            Jnoon = J2000 + ds + 0.0053 * sinM - 0.0069 * sin2L;
            lastD = d;
            lastLng = lng;
        }

        if (what == NOON) {
            return fromJulian(Jnoon);
        }

        var x = (Math.sin(TIMES[what]) - Math.sin(lat) * Math.sin(dec)) / (Math.cos(lat) * Math.cos(dec));

        if (x > 1.0 || x < -1.0) {
            return null;
        }

        var ds = J0 + (Math.acos(x) - lng) / PI2 + n - 1.1574e-5 * 68;

        var Jset = J2000 + ds + 0.0053 * sinM - 0.0069 * sin2L;
        if (what > NOON) {
            return fromJulian(Jset);
        }

        var Jrise = Jnoon - (Jset - Jnoon);

        return fromJulian(Jrise);
    }

    function timeBetweenMomentsAsString(from, to) {
		var totalMinutes = to.subtract(from).value() / 60;
		var hours = totalMinutes / 60;
		var minutes = totalMinutes.toLong() % 60;
		return hours.format("%d") + ":" + minutes.format("%02d");
	}

    function getLocationTimeOffset(secondaryLocation) {
        var epochTimeNow = Time.now();
        var date = Time.Gregorian.info(epochTimeNow, Time.FORMAT_MEDIUM);

        var options = {
            :year   => date.year,
            :month  => date.month,
            :day    => date.day,
            :hour   => 0,
            :min    => 0
        };

        var when = Time.Gregorian.moment(options);

        var secsDiff = 0;
        try {
            // If build with SDK > 4.1.5, localMoment requires a Time.Gregorian.moment as a second argument.
            // However, when the app is running in the watch, localMoment requires a Number (when.value()).
            // For now, the only way to make both the simulator and the watch happy is to build with SDK 4.1.5.
            //var local = Time.Gregorian.localMoment(secondaryLocation, when.value());
            var local = Time.Gregorian.localMoment(secondaryLocation, when);
            // Difference in seconds from 00:00 UTC time (including daylight saving time offset)
            secsDiff = local.getOffset();
        } catch( ex ) {
            ex.printStackTrace();
        }

        return secsDiff;
    }

    function stringReplace(str, oldString, newString)
    {
        var result = str;

        while (true)
        {
            var index = result.find(oldString);

            if (index != null)
            {
                var index2 = index + oldString.length();
                result = result.substring(0, index) + newString + result.substring(index2, result.length());
            }
            else
            {
                return result;
            }
        }

        return null;
    }

    function timeFormat(template, time) {
        var res = template;
        res = self.stringReplace(res, "hh", time.hour.format("%02d"));
        res = self.stringReplace(res, "h", time.hour.format("%d"));
        res = self.stringReplace(res, "mm", time.min.format("%02d"));
        res = self.stringReplace(res, "m", time.min.format("%d"));

        return res;
    }

}
