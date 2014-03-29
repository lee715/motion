// Generated by CoffeeScript 1.6.3
(function() {
  define(['./array/str2arr'], function(str2arr) {
    var E;
    return E = {
      on: function(event, callback, context) {
        var evt, evts, _e, _i, _len;
        if (!this._events) {
          this._events = {};
        }
        _e = this._events;
        evts = str2arr(event);
        for (_i = 0, _len = evts.length; _i < _len; _i++) {
          evt = evts[_i];
          _e[evt] = _e[evt] || [];
          _e[evt].push([callback, context]);
        }
        return this;
      },
      trigger: function(event, data) {
        var cb, cbs, _i, _len, _results;
        if (!this._events) {
          return false;
        }
        if (cbs = this._events[event]) {
          _results = [];
          for (_i = 0, _len = cbs.length; _i < _len; _i++) {
            cb = cbs[_i];
            _results.push(cb[0].call(cb[1], data));
          }
          return _results;
        }
      }
    };
  });

}).call(this);
