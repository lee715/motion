// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['./graphic'], function(G) {
    var Line;
    return Line = (function(_super) {
      __extends(Line, _super);

      function Line(a, b) {
        Line.__super__.constructor.apply(this, arguments);
        this.a = +a || 0;
        this.b = +b || 0;
        this;
      }

      Line.prototype.getY = function(x) {
        x = x * this.times;
        return this.a * x + this.b;
      };

      Line.prototype.getS = function(x) {
        x = x * this.times;
        return this.a * x * x / 2 + this.b * x;
      };

      return Line;

    })(G);
  });

}).call(this);
