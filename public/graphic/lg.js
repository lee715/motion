// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['./log'], function(Log) {
    var Lg;
    return Lg = (function(_super) {
      __extends(Lg, _super);

      function Lg() {
        Lg.__super__.constructor.apply(this, arguments);
        this.p = 10;
        this;
      }

      return Lg;

    })(Log);
  });

}).call(this);
