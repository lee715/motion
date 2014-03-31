// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['./controller', '../function/copyWithContext'], function(Controller, copy) {
    var Story;
    return Story = (function(_super) {
      __extends(Story, _super);

      function Story(opts) {
        Story.__super__.constructor.apply(this, arguments);
        opts = opts || {};
        this._ins = opts.ins || [];
        this.initTotalT();
        this.timeCosted = 0;
        if (opts.autoStart) {
          this.start();
        }
      }

      Story.prototype.promise = function() {
        var res;
        res = Story.__super__.promise.apply(this, arguments);
        copy(res, this, 'start add');
        return res;
      };

      Story.prototype.initTotalT = function() {
        var ins, obj, total, _i, _len;
        ins = this._ins;
        total = 0;
        for (_i = 0, _len = ins.length; _i < _len; _i++) {
          obj = ins[_i];
          if (obj.endT > total) {
            total = obj.endT;
          }
        }
        this.t = total;
        return this;
      };

      Story.prototype.add = function(trackCtrl, startT, endT) {
        if (endT > this.t) {
          this.t = endT;
        }
        this._ins.push({
          ins: trackCtrl,
          startT: startT,
          endT: endT
        });
        return this;
      };

      Story.prototype.start = function() {
        var m,
          _this = this;
        this["switch"]('moving');
        this.timer = m = setInterval(function() {
          _this._step();
          if (_this.timeCosted / 1000 >= _this.t) {
            return clearInterval(_this.timer);
          }
        }, 20);
        return this;
      };

      Story.prototype._step = function(alway) {
        var ins, now, obj, _i, _len;
        if (this.status === 'stop' && !always) {
          return clearInterval(this.timer);
        }
        now = this.current();
        ins = this._ins;
        for (_i = 0, _len = ins.length; _i < _len; _i++) {
          obj = ins[_i];
          if (obj.endT >= now && obj.startT <= now) {
            if (obj.startT === now) {
              this.trigger('start', obj.ins);
            } else if (obj.endT === now) {
              this.trigger('end', obj.ins);
            }
            obj.ins.toSecond(now - obj.startT);
          }
        }
        return this.triggerCE(now);
      };

      return Story;

    })(Controller);
  });

}).call(this);