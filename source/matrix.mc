using Toybox.Lang;
using Toybox.Math;

function multiply(left as Lang.Array<Lang.Array<Lang.Numeric>>, right as Lang.Array<Lang.Array<Lang.Numeric>>) as Lang.Array<Lang.Array<Lang.Numeric>> {
    var aRows = left.size();
    var aCols = left[0].size();
    var bCols = right[0].size();
    var result = new [aRows];
    for (var r = 0; r < aRows; ++r) {
        var row = new [bCols];
        result[r] = row;
        var ar = left[r];
        for (var c = 0; c < bCols; ++c) {
            var sum = 0.0;
            for (var i = 0; i < aCols; ++i) {
                try {
                    sum += ar[i] * right[i][c];
                } catch (ex) {
                    throw ex;
                }
            }
            row[c] = sum;
        }
    }
    return result;
}

function arrayMultiply(
    result as Lang.Array<Lang.Array<Lang.Numeric>>,
    left as Lang.Array<Lang.Array<Lang.Numeric>>,
    right as Lang.Array<Lang.Array<Lang.Numeric>>,
    aRows as Lang.Number,
    aCols as Lang.Number,
    bCols as Lang.Number
) as Lang.Array<Lang.Array<Lang.Numeric>> {
    var r = 0;
    var n = aRows % 8;

    if (n > 0) {
        do {
            var row = result[r];
            var ar = left[r];
            for (var c = 0; c < bCols; ++c) {
                var sum = 0.0;
                for (var i = 0; i < aCols; ++i) {
                    sum += ar[i] * right[i][c];
                }
                row[c] = sum;
            }
            r += 1;
            n -= 1;
        }
        while (n > 0); // n must be greater than 0 here
    }

    n = Math.floor(aRows / 8);
    if (n > 0) { // if iterations < 8 an infinite loop, added for safety in second printing
        do {
            var row = result[r];
            var ar = left[r];
            for (var c = 0; c < bCols; ++c) {
                var sum = 0.0;
                for (var i = 0; i < aCols; ++i) {
                    sum += ar[i] * right[i][c];
                }
                row[c] = sum;
            }
            r += 1;
            row = result[r];
            ar = left[r];
            for (var c = 0; c < bCols; ++c) {
                var sum = 0.0;
                for (var i = 0; i < aCols; ++i) {
                    sum += ar[i] * right[i][c];
                }
                row[c] = sum;
            }
            r += 1;
            row = result[r];
            ar = left[r];
            for (var c = 0; c < bCols; ++c) {
                var sum = 0.0;
                for (var i = 0; i < aCols; ++i) {
                    sum += ar[i] * right[i][c];
                }
                row[c] = sum;
            }
            r += 1;
            row = result[r];
            ar = left[r];
            for (var c = 0; c < bCols; ++c) {
                var sum = 0.0;
                for (var i = 0; i < aCols; ++i) {
                    sum += ar[i] * right[i][c];
                }
                row[c] = sum;
            }
            r += 1;
            row = result[r];
            ar = left[r];
            for (var c = 0; c < bCols; ++c) {
                var sum = 0.0;
                for (var i = 0; i < aCols; ++i) {
                    sum += ar[i] * right[i][c];
                }
                row[c] = sum;
            }
            r += 1;
            row = result[r];
            ar = left[r];
            for (var c = 0; c < bCols; ++c) {
                var sum = 0.0;
                for (var i = 0; i < aCols; ++i) {
                    sum += ar[i] * right[i][c];
                }
                row[c] = sum;
            }
            r += 1;
            row = result[r];
            ar = left[r];
            for (var c = 0; c < bCols; ++c) {
                var sum = 0.0;
                for (var i = 0; i < aCols; ++i) {
                    sum += ar[i] * right[i][c];
                }
                row[c] = sum;
            }
            r += 1;
            row = result[r];
            ar = left[r];
            for (var c = 0; c < bCols; ++c) {
                var sum = 0.0;
                for (var i = 0; i < aCols; ++i) {
                    sum += ar[i] * right[i][c];
                }
                row[c] = sum;
            }
            r += 1;
            n -= 1;
        }
        while (n > 0); // n must be greater than 0 here also
    }
    return result;
}

function add(left as Lang.Array<Lang.Array<Lang.Numeric>>, right as Lang.Array<Lang.Array<Lang.Numeric>>) as Lang.Array<Lang.Array<Lang.Numeric>> {
    var aRows = left.size();
    var aCols = left[0].size();
    var bCols = right[0].size();
    var result = new [aRows];
    for (var r = 0; r < aRows; ++r) {
        var row = new [bCols];
        result[r] = row;
        var ar = left[r];
        for (var c = 0; c < bCols; ++c) {
            var sum = ar[c] + right[r][c];
            row[c] = sum;
        }
    }
    return result;
}

function max(left, right) {
    if (left > right) {
        return left;
    }
    return right;
}

function min(left, right) {
    if (left < right) {
        return left;
    }
    return right;
}
