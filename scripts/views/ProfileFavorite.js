// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require, exports, module) {
    var formatDate;
    formatDate = require('zooniverse/util').formatDate;
    return module.exports = function(favorite) {
      var subject;
      subject = favorite.subjects[0];
      return "<li>\n  <button data-favorite=\"" + favorite.id + "\" class=\"delete\">&times;</button>\n  <a href=\"" + (subject.talkHref()) + "\">\n    <img src=\"" + subject.location.thumbnail + "\" class=\"thumbnail\" />\n    <span class=\"info\">\n      <span class=\"visited\">" + (formatDate(favorite.createdAt)) + "</span>\n    </span>\n  </a>\n</li>";
    };
  });

}).call(this);
