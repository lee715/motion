// Generated by CoffeeScript 1.6.3
(function() {
  define(['../regex/rnotwhite'], function(rnw) {
    var str2arr;
    return str2arr = function(str) {
      if (typeof str === 'string') {
        return str.match(rnw);
      } else if (str instanceof Array) {
        return str;
      } else {
        return [];
      }
    };
  });

}).call(this);
