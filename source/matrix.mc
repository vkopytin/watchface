using Toybox.Lang;

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
