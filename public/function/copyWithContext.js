// Generated by CoffeeScript 1.6.3
(function() {
  define(['../array/str2arr'], function(str2arr) {
    var copy;
    return copy = function(orig, targ, funcs) {
      var func, name, _i, _len, _results, _results1;
      if (funcs) {
        funcs = str2arr(funcs);
        _results = [];
        for (_i = 0, _len = funcs.length; _i < _len; _i++) {
          func = funcs[_i];
          _results.push(orig[func] = (function(func) {
            return function() {
              return targ[func].apply(targ, arguments);
            };
          })(func));
        }
        return _results;
      } else {
        _results1 = [];
        for (name in targ) {
          func = targ[name];
          _results1.push(orig[name] = (function(func) {
            return function() {
              return func.apply(targ, arguments);
            };
          })(func));
        }
        return _results1;
      }
    };
  });

}).call(this);