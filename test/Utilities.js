// Generated by CoffeeScript 1.6.3
(function() {
  define(['jquery'], function($) {
    var ACCUR, Map, Queue, U, _math, _util;
    ACCUR = 6;
    _math = {
      isInt: function(x) {
        return x === parseInt(x);
      },
      isOdd: function(x) {
        return !this.isInt(x / 2);
      },
      getAccuracy: function(num) {
        var _ref;
        return ((_ref = (num + '').split('.')[1]) != null ? _ref.length : void 0) || 0;
      },
      beAccuracy: function(num, accur) {
        var curAccur, k, res;
        accur = accur || ACCUR;
        curAccur = this.getAccuracy(num);
        if (curAccur <= accur) {
          res = num;
        } else {
          k = this.power(10, accur);
          res = Math.round(num * k) / k;
        }
        return res;
      },
      power: function(x, n, accuracy) {
        var bA, isInt, isRec, isSqrt, res;
        res = x;
        isInt = this.isInt;
        bA = this.beAccuracy;
        isRec = false;
        isSqrt = false;
        if (n === 0) {
          return 1;
        }
        if (n < 0) {
          isRec = true;
          n = Math.abs(n);
        }
        if (!isInt(n) && isInt(2 * n)) {
          n = n * 2;
          isSqrt = true;
        }
        if (!isInt(2 * n)) {
          n = parseInt(n);
        }
        while (--n > 0) {
          res = res * x;
        }
        if (isSqrt) {
          res = bA(Math.sqrt(res));
        }
        if (isRec) {
          res = bA(1 / res);
        }
        return res;
      },
      getDeg: function(sin, cos) {
        var bA, degC, degS, p, res, _degC, _degS, _ref;
        bA = this.beAccuracy;
        degS = Math.asin(sin) * 180 / Math.PI;
        degC = Math.acos(cos) * 180 / Math.PI;
        _degS = (_ref = degS >= 0) != null ? _ref : 180 - {
          degS: -degS - 180
        };
        _degC = -degC;
        p = parseInt;
        if ((p(degS) === p(degC)) || (p(degS) === p(_degC))) {
          res = degS;
        } else {
          res = _degS;
        }
        return bA(res);
      },
      getUnit: function(arr) {
        var match, reg, res, str, unit, _i, _len;
        if (!$.isArray(arr)) {
          arr = [arr];
        }
        res = false;
        unit = function(val) {
          return val;
        };
        match = false;
        reg = /[\d|.]+/g;
        for (_i = 0, _len = arr.length; _i < _len; _i++) {
          str = arr[_i];
          if (typeof str === 'string') {
            str.replace(reg, function(match) {
              match = true;
              return '{num}';
            });
            if (match && str.length > 5) {
              res = str;
              break;
            }
          }
        }
        if (res) {
          unit = function(num) {
            return res.replace('{num}', num);
          };
        }
        return unit;
      },
      withOutUnit: function(arr) {
        var reg, res;
        res = [];
        reg = /[a-zA-Z]+/g;
        if (!$.isArray(arr)) {
          arr = [arr];
        }
        $.each(arr, function(index, item) {
          if (!item) {
            item = 0;
          } else {
            item = (typeof item.replace === "function" ? item.replace(reg, '') : void 0) || item;
          }
          return res.push(+item);
        });
        return res;
      },
      identity: function(val) {
        return val;
      },
      compact: function(arr) {
        var item, res, _i, _len;
        res = [];
        for (_i = 0, _len = arr.length; _i < _len; _i++) {
          item = arr[_i];
          if (this.identity(item)) {
            res.push(item);
          } else {
            res.push(0);
          }
        }
        return res;
      },
      awu: function(type) {
        var args, item, res, step, unit;
        args = [].slice.call(arguments, 1);
        args = this.compact(args);
        unit = this.getUnit(args);
        args = this.withOutUnit(args);
        switch (type) {
          case '+':
            step = function(a, b) {
              return a + b;
            };
            break;
          case '-':
            step = function(a, b) {
              return a - b;
            };
            break;
          case '*':
            step = function(a, b) {
              return a * b;
            };
            break;
          case '/':
            step = function(a, b) {
              return a / b;
            };
            break;
        }
        res = args.shift();
        while (args.length) {
          item = args.shift();
          res = step(res, item);
        }
        return unit(res);
      }
    };
    _util = {
      cCtr: function(ctor, statics) {
        $.extend(ctor.prototype, statics);
        return ctor;
      },
      getArrSum: function(arr, n) {
        var i, sum;
        i = 0;
        sum = 0;
        while (i < n) {
          sum += arr[i];
          i++;
        }
        return sum;
      },
      getSumArr: function(arr) {
        var len, ts;
        ts = [];
        len = arr.length;
        while (len) {
          ts[len - 1] = this.getSum(arr, len);
          len--;
        }
        return ts;
      },
      getSum: function(arr, n) {
        var a, i, res, _i, _len;
        res = 0;
        n = n || arr.length;
        for (i = _i = 0, _len = arr.length; _i < _len; i = ++_i) {
          a = arr[i];
          if (i < n) {
            res += a;
          }
        }
        return res;
      },
      firstLetterUpper: function(str) {
        return str.replace(/^[a-z]{1}/, function(match) {
          return match.toUpperCase();
        });
      },
      firstLetterLower: function(str) {
        return str.replace(/^[A-Z]{1}/, function(match) {
          return match.toLowerCase();
        });
      }
    };
    Map = (function() {
      function Map(opts) {
        this._data = opts.data || {};
        this._root = opts.root || window;
        this.defaultDomain = opts.defaultDomain || 'Custom';
        this;
      }

      Map.prototype.set = function() {
        var func;
        switch (typeof arguments[0]) {
          case 'string':
            func = '_set';
            break;
          default:
            func = '_setObj';
        }
        return this[func].apply(this, arguments);
      };

      Map.prototype._setObj = function(obj, domain) {
        var key, value;
        for (key in obj) {
          value = obj[key];
          this._set(key, value, domain);
        }
        return this;
      };

      Map.prototype._set = function(name, ctor, domain) {
        var arr, root, target, _name;
        domain = domain || this.defaultDomain;
        name = "" + domain + "." + name;
        _name = '';
        name = name.replace(/[a-zA-Z]+$/, function(match) {
          _name = U.firstLetterLower(match);
          return U.firstLetterUpper(match);
        });
        this._data[_name] = name;
        arr = name.split('.');
        target = arr.pop();
        root = this._root;
        while ((name = arr.shift())) {
          if (!root[name]) {
            root[name] = {};
          }
          root = root[name];
        }
        if (root[target]) {
          this.onError("namespace conflict at " + target);
        }
        root[target] = ctor;
        return this;
      };

      Map.prototype.get = function(name) {
        var arr, ctor;
        name = U.firstLetterLower(name);
        arr = this._data[name].split('.');
        ctor = this._root;
        while ((name = arr.shift())) {
          ctor = ctor[name];
        }
        return ctor;
      };

      Map.prototype.onError = function(msg) {
        return console.log(msg);
      };

      return Map;

    })();
    Queue = (function() {
      function Queue(opts) {
        this._q = {};
        this._order = [];
        this;
      }

      Queue.prototype.find = function(name) {
        return name && this._q[name];
      };

      Queue.prototype.push = function(name, func) {
        var args, exist;
        args = [].slice.call(arguments, 2);
        exist = this.find(name);
        if (exist) {
          if (exist.length === 2 && typeof exist[1] === 'object' && args.length === 1 && typeof args[0] === 'object') {
            return exist[1] = $.extend({}, exist[1], args[0]);
          } else {
            return exist.concat(args);
          }
        } else {
          this._order.push(name);
          args.unshift(func);
          return this._q[name] = args;
        }
      };

      Queue.prototype.next = function() {
        var callback, handle, name,
          _this = this;
        callback = function() {
          return _this.next();
        };
        if (this._order.length) {
          name = this._order.shift();
          handle = this.find(name);
          if (handle) {
            handle.push(callback);
            handle.shift().apply(null, handle);
            return this["delete"](name);
          } else {
            return this.next();
          }
        }
      };

      Queue.prototype["delete"] = function(name) {
        return delete this._q[name];
      };

      return Queue;

    })();
    return U = $.extend({}, _math, _util, {
      Map: Map,
      Queue: Queue
    });
  });

}).call(this);
