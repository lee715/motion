// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['../graphic/factory', '../promise/type', '../array/str2arr', '../array/slice'], function(F, type, str2arr, slice) {
    var G, Mix, Mixin, mixs, _ref;
    mixs = {};
    G = F.get('graphic');
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

    })(G);
    return Mix = {
      get: function(name) {
        if (type('string', name)) {
          return mixs[name] && mixs[name].apply(null, slice.call(arguments, 1));
        } else {
          return err('Mix.get requires a string parameter');
        }
      },
      mix: function() {
        var X, arg, args, ins, name, _i, _len;
        args = slice.call(arguments);
        ins = [];
        if (type('string', args[0])) {
          name = args.shift();
        }
        for (_i = 0, _len = args.length; _i < _len; _i++) {
          arg = args[_i];
          if (type('array', arg)) {
            ins.push(F.get.apply(F, arg));
          } else if (type('graphic', arg)) {
            ins.push(arg);
          } else {
            err('Unrecognized Parameter', arg);
            continue;
          }
        }
        X = (function(_super) {
          __extends(X, _super);

          function X(opts, tArr) {
            var i, insArr, _j, _k, _len1, _len2;
            X.__super__.constructor.apply(this, arguments);
            this.insArr = insArr = this._insArr.slice();
            if (tArr) {
              this.tArr = tArr;
              for (i = _j = 0, _len1 = insArr.length; _j < _len1; i = ++_j) {
                ins = insArr[i];
                ins._t = this.tArr[i];
              }
            } else {
              this.tArr = [];
              for (_k = 0, _len2 = insArr.length; _k < _len2; _k++) {
                ins = insArr[_k];
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
        if (name) {
          mixs[name] = X;
          return Mix;
        } else {
          return X;
        }
      }
    };
  });

}).call(this);