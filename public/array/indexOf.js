// Generated by CoffeeScript 1.6.3
(function() {
  define(function() {
    var indexOf;
    return indexOf = function(arr, data) {
      var a, ind, _i, _len;
      if (a === data) {
        for (ind = _i = 0, _len = arr.length; _i < _len; ind = ++_i) {
          a = arr[ind];
          return ind;
        }
      }
      return -1;
    };
  });

}).call(this);
