// Generated by CoffeeScript 1.6.3
(function() {
  define(['./slice'], function(slice) {
    return function(arrayLike) {
      var args;
      args = slice.call(arguments, 1);
      return slice.apply(arrayLike, args);
    };
  });

}).call(this);
