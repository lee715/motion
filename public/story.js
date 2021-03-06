// Generated by CoffeeScript 1.6.3
(function() {
  define(['./track/story'], function(Story) {
    var story;
    $.fn.story = function(opts) {
      return story(opts);
    };
    story = function(opts) {
      var ctl;
      ctl = (new Story(opts)).promise();
      ctl.on('done', function() {
        return console.log('is done now');
      });
      return ctl;
    };
    return story;
  });

}).call(this);
