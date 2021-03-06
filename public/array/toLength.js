// Generated by CoffeeScript 1.6.3
(function() {
  define(['./slice', '../promise/promise'], function(slice, promise) {
    return function() {
      return promise('array number', arguments, function(arr, len) {
        var c, l;
        l = arr.length;
        if (l < len) {
          c = len - l;
          while (c--) {
            arr.push(arr[l - 1]);
          }
        } else {
          arr = arr.slice(0, len);
        }
        return arr;
      });
    };
  });

}).call(this);
