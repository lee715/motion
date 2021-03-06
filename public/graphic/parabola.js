// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['./graphic', '../util/util'], function(G, U) {
    var Parabola;
    return Parabola = (function(_super) {
      __extends(Parabola, _super);

      function Parabola(a, b) {
        Parabola.__super__.constructor.apply(this, arguments);
        this.a = +a || 0;
        this.b = +b || 0;
        this;
      }

      Parabola.prototype._getY = function(x) {
        return this.a * U.power(x, 2) + this.b;
      };

      Parabola.prototype._getS = function(x) {
        return this.a * U.power(x, 3) / 3 + this.b * x;
      };

      return Parabola;

    })(G);
  });

}).call(this);
