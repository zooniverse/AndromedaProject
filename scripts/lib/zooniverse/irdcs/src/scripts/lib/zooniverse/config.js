// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty;

  define(function(require, exports, module) {
    var config;
    config = {
      dev: +location.port > 1023 || !!~location.hostname.indexOf('.dev'),
      apiHost: 'https://api.zooniverse.org',
      authHost: 'https://zooniverse-login.s3.amazonaws.com',
      authPath: '/login.html'
    };
    config.set = function(options) {
      var key, value, _results;
      _results = [];
      for (key in options) {
        if (!__hasProp.call(options, key)) continue;
        value = options[key];
        if (key === 'set') {
          throw new Error('Don\'t overwrite "set" in config.');
        }
        _results.push(config[key] = value);
      }
      return _results;
    };
    if (config.dev) {
      config.set({
        apiHost: "http://" + location.hostname + ":3000",
        authHost: "http://" + location.host,
        authPath: '/src/scripts/lib/zooniverse/login-frame/login.html'
      });
    }
    return module.exports = config;
  });

}).call(this);
