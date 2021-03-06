// Generated by CoffeeScript 1.6.3
(function() {
  define(['./data', '../promise/type', '../array/str2arr'], function(data, type, str2arr) {
    var extend;
    return extend = function(cCss, funcs) {
      var css, _i, _id, _len, _results;
      cCss = str2arr(cCss);
      _id = cCss.join('0');
      funcs._id = _id;
      _results = [];
      for (_i = 0, _len = cCss.length; _i < _len; _i++) {
        css = cCss[_i];
        _results.push(data[css] = funcs);
      }
      return _results;
    };
  });

}).call(this);
