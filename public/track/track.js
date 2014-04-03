// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['../graphic/factory', './mix', './controller', '../array/slice', '../array/str2arr', '../filter/filter', '../filter/add', '../function/copyWithContext', '../promise/type'], function(F, Mix, Controller, slice, str2arr, filter, add, copy, type) {
    var Track, track;
    Track = (function(_super) {
      __extends(Track, _super);

      function Track(gpc, opts) {
        var bl, fil;
        Track.__super__.constructor.apply(this, arguments);
        this.opts = opts = opts || {};
        this.gpc = gpc;
        this.timeCircle = opts.delay && opts.delay * 1000 || 0;
        this.timeCosted = 0;
        this.t = opts.t || gpc.t || Infinity;
        this.total = opts.total || Infinity;
        this.baseline = bl = opts.baseline || gpc.getS(this.t);
        this.endType = opts.endType || gpc.endType || 'stop';
        if (!(fil = opts.filter)) {
          fil = [[], []];
        }
        fil[0] = str2arr(fil[0]);
        fil[0] = fil[0].concat(['translate', 'multi', 'beforeEnd', 'addtion']);
        fil[1].push('translate');
        fil[1].push('multi');
        fil[1].push(function() {
          var i, k, _i, _len;
          for (i = _i = 0, _len = this.length; _i < _len; i = ++_i) {
            k = this[i];
            this[i] /= bl;
          }
          return this;
        });
        fil[1].push('translate');
        this.filter = filter.apply(null, fil);
        this.filter.beforeEnd(1);
        opts.autoStart && this.start();
      }

      Track.prototype._reverse = false;

      Track.prototype._minus = false;

      Track.prototype.promise = function() {
        var res;
        res = Track.__super__.promise.apply(this, arguments);
        copy(res, this, 'start minus');
        copy(res, this.filter);
        return res;
      };

      Track.prototype.start = function() {
        var m,
          _this = this;
        this["switch"]('moving');
        this.trigger('start');
        this.timer = m = setInterval(function() {
          var val;
          val = _this._step();
          if (_this.timeCircle >= _this.t * 1000) {
            return _this.onEnd(m, val);
          }
        }, this.interval);
        return this;
      };

      Track.prototype._step = function(always) {
        var now, val;
        if (this.status === 'stop' && !always) {
          return clearInterval(this.timer);
        }
        console.log(this.timeCircle, this.timeCosted);
        now = this.current();
        val = this.gpc.getS(now);
        val = this.filter.filter([val])[0];
        this.trigger('progress', val);
        this.triggerCE(this.timeCircle / 1000, val);
        return val;
      };

      Track.prototype.minus = function() {
        this.filter.multi(-1);
        return this._minus = !this._minus;
      };

      Track.prototype.step = function(direction) {
        if (this.stopOrInit() && this.endType === 'step') {
          if (!!~direction === this._minus) {
            this.minus();
          }
          return this.start();
        }
      };

      Track.prototype.onEnd = function(timer, endVal) {
        var addVal, endType, gpc, st, times, vt;
        endType = this.endType;
        gpc = this.gpc;
        switch (endType) {
          case 'stop':
            return this.end();
          case 'stay':
            vt = gpc.getY(this.t);
            st = gpc.getS(this.t);
            times = gpc.times;
            this.gpc = void 0;
            this.gpc = F.get('line', 0, vt, times);
            this.filter.translate(st);
            this.t = Infinity;
            this.timeCircle = 0;
            this.stop();
            this.start();
            return this.trigger('stay');
          case 'repeat':
            this.timeCircle = 0;
            return this.trigger('repeat');
          case 'reverse':
            this._reverse = !this._reverse;
            this.timeCircle = 0;
            return this.trigger('reverse');
          case 'reverse-decay':
            this._reverse = !this._reverse;
            if (!this._reverse) {
              this.filter.multi(0.8);
            }
            this.timeCircle = 0;
            return this.trigger('reverse-decay');
          case 'step':
            this.timeCircle = 0;
            if (!this._stepVal) {
              this._stepVal = Math.abs(endVal);
            }
            addVal = this._minus ? -this._stepVal : this._stepVal;
            this.filter.addtion(addVal);
            this.stop();
            return this.trigger('step');
          case 'back':
            this.timeCircle = 0;
            this.stop();
            this.trigger('progress', 0);
            return this.trigger('back');
          default:
            if (gpc[endType]) {
              gpc[endType]();
              this.t = gpc.t;
              if (gpc.isEnded) {
                return this.end();
              }
            }
            this.timeCircle = 0;
            return this.trigger(endType);
        }
      };

      return Track;

    })(Controller);
    return track = {
      get: function(track, opts) {
        var ctl, gpc;
        track = str2arr(track);
        gpc = this.getGpc.apply(this, track);
        ctl = new Track(gpc, opts);
        return ctl;
      },
      getGpc: function(name) {
        var args, gpc;
        args = slice.call(arguments);
        if (type('array', args[0])) {
          if (args.length === 1) {
            args = args[0];
          } else {
            return;
          }
        }
        if (type('string', args[0])) {
          if (!(gpc = Mix.get.apply(Mix, args))) {
            gpc = F.get.apply(F, args);
          }
        }
        return gpc;
      },
      extendEvent: function(name, judgeFunc) {
        return Event[name] = judgeFunc;
      }
    };
  });

}).call(this);
