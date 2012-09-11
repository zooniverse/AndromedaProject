// Generated by CoffeeScript 1.3.3
(function() {

  define(function(require, exports, module) {
    var formatDate;
    formatDate = require('zooniverse/util').formatDate;
    return module.exports = function(recent) {
      var subject;
      subject = recent.subjects[0];
      return "<li>\n  <a href=\"" + (subject.talkHref()) + "\"> <img src=\"" + subject.location.thumbnail + "\" class=\"thumbnail\" /></a>\n\n  <div class=\"description\">\n    <div class=\"location\">\n      <div class=\"lat\">Lat: " + subject.coords[0] + "</div>\n      <div class=\"long\">Lng: " + subject.coords[1] + "</div>\n      <div class=\"visited\">Visited on " + (formatDate(recent.createdAt)) + "</div>\n    </div>\n  </div>\n</li>";
    };
  });

}).call(this);