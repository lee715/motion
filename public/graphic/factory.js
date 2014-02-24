// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['../array/slice', '../promise/type', '../object/create', '../function/wrap', './graphic', './line', './log', './lg', './parabola', './point'], function(slice, type, create, wrap) {
    var basic, custom, factory, funcs, i, name, names, _i, _len;
    names = 'graphic line log lg parabola point'.split(' ');
    funcs = slice.call(arguments, -6);
    basic = {};
    for (i = _i = 0, _len = names.length; _i < _len; i = ++_i) {
      name = names[i];
      basic[name] = wrap(funcs[i]);
    }
    custom = {};
    return factory = {
      get: function(name) {
        if (typeof name === 'string') {
          return (basic[name] || custom[name]).apply(null, slice.call(arguments, 1));
        } else {
          return name;
        }
      },
      "class": function(name, ctor, statics, parent) {
        var Pnt, X, _class, _ref;
        parent = parent && parent.toLowerCase() || 'graphic';
        Pnt = this.get(parent);
        X = (function(_super) {
          __extends(X, _super);

          function X() {
            _ref = _class.apply(this, arguments);
            return _ref;
          }

          _class = ctor;

          return X;

        })(Pnt);
        $.extend(X.__super__, statics);
        custom[name] = wrap(X);
        return true;
      }
    };
  });

}).call(this);