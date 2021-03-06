// Generated by CoffeeScript 1.3.3
(function() {
  var $, apiHost, issueCommand, localHosts, postBack, recipient, validMessageOrigins,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  $ = window.jQuery || parent.jQuery;

  $.support.cors = true;

  $(function() {
    return parent.postMessage('READY', '*');
  });

  apiHost = 'https://api.zooniverse.org';

  if (!(+location.port < 1024)) {
    apiHost = "//" + location.hostname + ":3000";
  }

  localHosts = [/^https?:\/\/localhost:?\d*$/, /^https?:\/\/hosthost:?\d*$/, /^https?:\/\/\w+\.dev:?\d*$/, /^https?:\/\/0.0.0.0:?\d*$/, /^file:/];

  validMessageOrigins = ['http://www.seafloorexplorer.org'];

  recipient = '';

  issueCommand = function(command, params, options) {
    var request;
    if (params == null) {
      params = {};
    }
    if (options == null) {
      options = {};
    }
    request = $.getJSON("" + apiHost + "/" + command + "?callback=?", params);
    request.done(function(response) {
      return postBack(options.postAs || command, response);
    });
    return request.fail(function(response) {
      if (options.ignoreFailure) {
        return;
      }
      return postBack(command, {
        success: false,
        message: 'Couldn\'t connect to the server'
      });
    });
  };

  postBack = function(command, response) {
    var data;
    data = JSON.stringify({
      command: command,
      response: response
    });
    return parent.postMessage(data, recipient);
  };

  $(window).on('message', function(_arg) {
    var command, data, e, isLocal, isValid, params, re, _ref, _results;
    e = _arg.originalEvent;
    isValid = (_ref = e.origin, __indexOf.call(validMessageOrigins, _ref) >= 0);
    isLocal = ((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = localHosts.length; _i < _len; _i++) {
        re = localHosts[_i];
        if (re.test(e.origin)) {
          _results.push(true);
        }
      }
      return _results;
    })()).length > 0;
    if (!(isValid || isLocal)) {
      throw new Error('Invalid message origin');
      return;
    }
    recipient = e.origin;
    data = JSON.parse(e.data);
    if ('current_user' in data) {
      issueCommand('current_user', {}, {
        postAs: 'login',
        ignoreFailure: true
      });
      return;
    }
    _results = [];
    for (command in data) {
      params = data[command];
      _results.push(issueCommand(command, params));
    }
    return _results;
  });

}).call(this);
