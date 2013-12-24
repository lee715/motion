// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'util'], function($, U) {
    var Image, Lg, Line, Log, Mixin, Parabola, T, Track, _ref;
    Image = (function() {
      function Image(opts) {
        this.opts = opts = opts || {};
        this._i = opts.interval || [0, Infinity];
        this._offX = this._i[0];
        this._t = this._i[1];
        this._r = opts.reverse;
        this.opts.type = this.opts.type || 'stop';
      }

      Image.prototype.getLast = function() {
        var ins;
        if (this.insArr) {
          ins = this.insArr[this.insArr.length - 1];
        } else {
          ins = this;
        }
        return ins;
      };

      Image.prototype.isOnEnd = function(x) {
        return this._t && x > this._t;
      };

      Image.prototype._checkT = function(x, method) {
        if (this.isOnEnd(x)) {
          return this._check(x, method);
        } else {
          return false;
        }
      };

      Image.prototype._check = function(x, method) {
        var cT, ins, p, times, _ref, _ref1, _ref2;
        switch (this.opts.type) {
          case 'stay':
            return this[method](this._t);
          case 'circle':
          case 'circle-last':
            cT = x - this._t;
            ins = this.getLast();
            cT = cT % ins._t;
            return this[method](cT);
          case 'circle-all':
            cT = U.beAccuracy(x % this._t, 2);
            return this[method](cT);
          case 'decay':
          case 'decay-last':
            p = ((_ref = this.opts.data) != null ? _ref.decay : void 0) || 2;
            x = x - this._t;
            ins = this.getLast();
            cT = x % ins._t;
            times = parseInt(x / ins._t);
            if (times > (this.decay_times || 0)) {
              this.a = U.beAccuracy(this.a / p, 2);
              this.decay_times = times;
            }
            return this[method](cT);
          case 'decay-all':
            p = ((_ref1 = this.opts.data) != null ? _ref1.decay : void 0) || 2;
            ins = this;
            cT = x % ins._t;
            times = parseInt(x / ins._t);
            if (times > (this.decay_times || 0)) {
              this.a = U.beAccuracy(this.a / p, 2);
              this.decay_times = times;
            }
            return this[method](cT);
          case 'decay-t':
            p = ((_ref2 = this.opts.data) != null ? _ref2.decay : void 0) || 1.2;
            cT = x % this._t;
            times = parseInt(x / this._t);
            this._decay = U.power(0.8, times);
            return this[method](cT);
          default:
            return 0;
        }
      };

      Image.prototype.getY = function(x) {
        var res;
        res = this._checkT(x, 'getY');
        if (res !== false) {
          return res;
        } else {
          if (this._r) {
            return this._getYR(x);
          } else {
            return this._getY(x);
          }
        }
      };

      Image.prototype.getBaseLine = function(type) {
        var ins, isDecay, name, res, _i, _len, _ref;
        type = type.toUpperCase();
        name = 'baseline' + type;
        isDecay = /decay/.test(this.opts.type);
        if (this[name]) {
          if (isDecay) {
            return U.power(2, this.decay_times || 0) * this[name];
          } else {
            return this[name];
          }
        }
        if (this.opts[name]) {
          this[name] = this.opts[name];
          if (isDecay) {
            return U.power(2, this.decay_times || 0) * this[name];
          } else {
            return this[name];
          }
        } else {
          if (this.insArr) {
            res = [];
            _ref = this.insArr;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              ins = _ref[_i];
              res.push(ins.getBaseLine(type));
            }
            this[name] = Math.max.apply(Math, res);
          } else {
            this[name] = this['get' + type](this._t);
          }
        }
        return this[name];
      };

      Image.prototype.getYp = function(x) {
        var res, s, _endY;
        s = this.getY(x);
        _endY = this.getBaseLine('Y');
        res = s / _endY;
        if (this._decay) {
          res = U.beAccuracy(res * this._decay);
        }
        return res;
      };

      Image.prototype.getS = function(x) {
        var res;
        res = this._checkT(x, 'getS');
        if (res !== false) {
          return res;
        } else {
          if (this._r) {
            return this._getSR(x);
          } else {
            return this._getS(x);
          }
        }
      };

      Image.prototype.getSp = function(x) {
        var res, s, _endS;
        s = this.getS(x);
        _endS = this.getBaseLine('S');
        res = s / _endS;
        if (this._decay) {
          res = U.beAccuracy(res * this._decay);
        }
        return res;
      };

      Image.prototype._getYR = function(x) {
        if (this._t === Infinity) {
          return 0;
        } else {
          return this._getY(this._t - x);
        }
      };

      Image.prototype._getSR = function(x) {
        return this._getS(this._t) - this._getS(this._t - x);
      };

      return Image;

    })();
    Parabola = (function(_super) {
      __extends(Parabola, _super);

      function Parabola(opts) {
        Parabola.__super__.constructor.apply(this, arguments);
        this.a = opts.a;
        this.b = opts.b;
        this;
      }

      Parabola.prototype._getY = function(x) {
        x += this._offX;
        return this.a * U.power(x, 2) + this.b;
      };

      Parabola.prototype._getS = function(x) {
        x += this._offX;
        return this.a * U.power(x, 3) / 3 + this.b * x;
      };

      return Parabola;

    })(Image);
    Log = (function(_super) {
      __extends(Log, _super);

      function Log(opts) {
        Log.__super__.constructor.apply(this, arguments);
        this.a = opts.a;
        this.b = opts.b;
        this.p = opts.p;
        this;
      }

      Log.prototype._getY = function(x) {
        return this.a * Math.log(x) / Math.log(this.p) + this.b;
      };

      Log.prototype._getS = function(x) {
        return 0;
      };

      return Log;

    })(Image);
    Lg = (function(_super) {
      __extends(Lg, _super);

      function Lg(opts) {
        Lg.__super__.constructor.apply(this, arguments);
        this.p = 10;
        this;
      }

      return Lg;

    })(Log);
    Line = (function(_super) {
      __extends(Line, _super);

      function Line(opts) {
        Line.__super__.constructor.apply(this, arguments);
        this.a = opts.a;
        this.b = opts.b;
        this;
      }

      Line.prototype._getY = function(x) {
        x += this._offX;
        return this.a * x + this.b;
      };

      Line.prototype._getS = function(x) {
        x += this._offX;
        return this.a * x * x / 2 + this.b * x;
      };

      return Line;

    })(Image);
    Mixin = (function(_super) {
      __extends(Mixin, _super);

      function Mixin() {
        _ref = Mixin.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Mixin.prototype._getPos = function(x) {
        var arr, i, res;
        arr = this.tArr;
        i = arr.length;
        res = 0;
        while (i--) {
          if (x > arr[i]) {
            res = i + 1;
            break;
          }
        }
        return res;
      };

      Mixin.prototype.getY = function(x) {
        var iss, pos, res, ts;
        res = this._checkT(x, 'getY');
        if (res !== false) {
          return res;
        } else {
          pos = this._getPos(x);
          ts = this.tArr;
          iss = this.insArr;
          x -= ts[pos - 1] || 0;
          res = iss[pos].getY(x);
          return res;
        }
      };

      Mixin.prototype.getS = function(x) {
        var pos, res, sArr;
        res = this._checkT(x, 'getS');
        if (res !== false) {
          return res;
        } else {
          pos = this._getPos(x);
          sArr = this._getSArr();
          res = sArr[pos - 1] || 0;
          x -= this.tArr[pos - 1] || 0;
          res += this.insArr[pos].getS(x);
          return res;
        }
      };

      Mixin.prototype._getSArr = function() {
        var i, iss, ss, t, ts, _i, _len;
        if (this.sArr) {
          return this.sArr;
        }
        ts = this.tArr;
        iss = this.insArr;
        ss = [];
        for (i = _i = 0, _len = ts.length; _i < _len; i = ++_i) {
          t = ts[i];
          ss.push(iss[i].getS(ts[i] - (ts[i - 1] || 0)));
        }
        ss = U.getSumArr(ss);
        this.sArr = ss;
        return ss;
      };

      return Mixin;

    })(Image);
    T = Track = {
      mix: function(arr, opts) {
        var X, insArr;
        insArr = [];
        $.each(arr, function(index, item) {
          var Ctor, name, options;
          name = item[0];
          options = item[1];
          Ctor = this.get(name);
          return Ctor && insArr.push(new Ctor(options));
        });
        X = (function(_super) {
          __extends(X, _super);

          function X(opts, tArr) {
            var i, ins, _i, _j, _len, _len1;
            X.__super__.constructor.apply(this, arguments);
            this.insArr = insArr = this._insArr.slice();
            if (tArr) {
              this.tArr = tArr;
              for (i = _i = 0, _len = insArr.length; _i < _len; i = ++_i) {
                ins = insArr[i];
                ins._t = this.tArr[i];
              }
            } else {
              this.tArr = [];
              for (_j = 0, _len1 = insArr.length; _j < _len1; _j++) {
                ins = insArr[_j];
                this.tArr.push(ins._t);
              }
            }
            this._t = U.getSum(this.tArr);
            this.tArr = U.getSumArr(this.tArr);
            this;
          }

          X.prototype._insArr = insArr;

          return X;

        })(Mixin);
        return X;
      },
      push: function() {
        return this.map.set.apply(this.map, arguments);
      },
      get: function(name) {
        return this.map.get.apply(this.map, arguments);
      },
      extend: function() {
        var args;
        args = arguments;
        if ($.isArray(args[1])) {
          return this._extendMixin.apply(this, args);
        } else {
          return this._extendBasic.apply(this, args);
        }
      },
      _extendMixin: function(name, arr, opts) {
        return this.push(name, this.mix(opts, arr));
      },
      _extendBasic: function(name, ctor, statics, parent) {
        var Pnt, X, _class, _ref1;
        if (parent) {
          parent = parent.toLowerCase();
          Pnt = this.get(parent);
        } else {
          Pnt = Image;
        }
        X = (function(_super) {
          __extends(X, _super);

          function X() {
            _ref1 = _class.apply(this, arguments);
            return _ref1;
          }

          _class = ctor;

          return X;

        })(Pnt);
        $.extend(X.__super__, statics);
        return this.push(name, X);
      }
    };
    Track.map = new U.Map({
      root: Track
    });
    Track.push({
      'line': Line,
      'parabola': Parabola,
      'log': Log,
      'lg': Lg,
      'image': Image
    }, 'Math');
    return Track;
  });

}).call(this);
