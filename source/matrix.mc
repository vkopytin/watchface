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

function remainder(a as Lang.Float, b as Lang.Float) as Lang.Float {
    // Handling negative values
    if (a < 0) {
        a = -a;
    }
    if (b < 0) {
        b = -b;
    }
    
    // Finding mod by repeated subtraction
    var mod = a;
    while (mod >= b) {
        mod = mod - b;
    }
    
    // Sign of result typically depends
    // on sign of a.
    if (a < 0) {
        return -mod;
    }
    
    return mod;
}

function arrayMap(arr, fn, args) {
    var length = arr.size();
    var result = new [length];
    var index = 0;
    var n = length % 8;

    if (n > 0) {
        do {
            result[index] = fn.invoke(arr[index], args);
            index += 1;
            n -= 1;
        }
        while (n > 0); // n must be greater than 0 here
    }

    n = Math.floor(length / 8);
    if (n > 0) { // if iterations < 8 an infinite loop, added for safety in second printing
        do {
            result[index] = fn.invoke(arr[index], args);
            index += 1;
            result[index] = fn.invoke(arr[index], args);
            index += 1;
            result[index] = fn.invoke(arr[index], args);
            index += 1;
            result[index] = fn.invoke(arr[index], args);
            index += 1;
            result[index] = fn.invoke(arr[index], args);
            index += 1;
            result[index] = fn.invoke(arr[index], args);
            index += 1;
            result[index] = fn.invoke(arr[index], args);
            index += 1;
            result[index] = fn.invoke(arr[index], args);
            index += 1;
            n -= 1;
        }
        while (n > 0); // n must be greater than 0 here also
    }

    return result;
}