// Generated by CoffeeScript 1.4.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var $, BaseForm, LoginForm, ResetForm, SignInForm, SignOutForm, SignUpForm, Spine, User, templates;
    $ = require('jQuery');
    Spine = require('Spine');
    User = require('zooniverse/models/User');
    templates = require('zooniverse/views/LoginForm');
    BaseForm = (function(_super) {

      __extends(BaseForm, _super);

      BaseForm.prototype.events = {
        submit: 'onSubmit',
        keydown: 'onInputChange',
        change: 'onInputChange'
      };

      BaseForm.prototype.elements = {
        '.errors': 'errors',
        'input[name="username"]': 'usernameField',
        'input[name="email"]': 'emailField',
        'input[name="password"]': 'passwordField',
        'input[name="password-confirm"]': 'passwordConfirmField',
        'input[name="policy"]': 'policyCheckbox',
        'button[type="submit"]': 'submitButton',
        '.progress': 'progress',
        'input[required]': 'requiredInputs'
      };

      function BaseForm() {
        this.onSignIn = __bind(this.onSignIn, this);

        this.onError = __bind(this.onError, this);

        this.onInputChange = __bind(this.onInputChange, this);

        this.onSubmit = __bind(this.onSubmit, this);
        BaseForm.__super__.constructor.apply(this, arguments);
        this.html(this.template);
        User.bind('sign-in', this.onSignIn);
        this.onInputChange();
        this.onSignIn();
      }

      BaseForm.prototype.onSubmit = function(e) {
        e.preventDefault();
        this.errors.hide();
        this.errors.empty();
        return this.progress.show();
      };

      BaseForm.prototype.onInputChange = function() {
        var _this = this;
        return setTimeout(function() {
          var allFilledIn;
          allFilledIn = Array.prototype.every.call(_this.requiredInputs, function(el) {
            if (el.type === 'checkbox') {
              return el.checked;
            } else {
              return !!el.value;
            }
          });
          return _this.submitButton.attr({
            disabled: !allFilledIn
          });
        });
      };

      BaseForm.prototype.onError = function(error) {
        this.progress.hide();
        this.errors.append(error);
        return this.errors.show();
      };

      BaseForm.prototype.onSignIn = function() {
        return this.progress.hide();
      };

      return BaseForm;

    })(Spine.Controller);
    SignInForm = (function(_super) {

      __extends(SignInForm, _super);

      function SignInForm() {
        this.onSignIn = __bind(this.onSignIn, this);

        this.onSubmit = __bind(this.onSubmit, this);
        return SignInForm.__super__.constructor.apply(this, arguments);
      }

      SignInForm.prototype.className = 'sign-in';

      SignInForm.prototype.template = templates.signIn;

      SignInForm.prototype.onSubmit = function() {
        var auth;
        SignInForm.__super__.onSubmit.apply(this, arguments);
        auth = User.authenticate({
          username: this.usernameField.val(),
          password: this.passwordField.val()
        });
        return auth.fail(this.onError);
      };

      SignInForm.prototype.onSignIn = function() {
        SignInForm.__super__.onSignIn.apply(this, arguments);
        return this.usernameField.add(this.passwordField).val('');
      };

      return SignInForm;

    })(BaseForm);
    SignUpForm = (function(_super) {

      __extends(SignUpForm, _super);

      function SignUpForm() {
        this.onSubmit = __bind(this.onSubmit, this);
        return SignUpForm.__super__.constructor.apply(this, arguments);
      }

      SignUpForm.prototype.className = 'sign-in';

      SignUpForm.prototype.template = templates.signUp;

      SignUpForm.prototype.onSubmit = function() {
        var signUp;
        SignUpForm.__super__.onSubmit.apply(this, arguments);
        if (this.passwordField.val() !== this.passwordConfirmField.val()) {
          this.onError('Both passwords must match!');
          this.passwordField.focus();
          return;
        }
        signUp = User.signUp({
          username: this.usernameField.val(),
          email: this.emailField.val(),
          password: this.passwordField.val()
        });
        return signUp.fail(this.onError);
      };

      return SignUpForm;

    })(BaseForm);
    ResetForm = (function(_super) {

      __extends(ResetForm, _super);

      function ResetForm() {
        this.onSubmit = __bind(this.onSubmit, this);
        return ResetForm.__super__.constructor.apply(this, arguments);
      }

      ResetForm.prototype.className = 'reset';

      ResetForm.prototype.template = templates.reset;

      ResetForm.prototype.onSubmit = function() {};

      return ResetForm;

    })(BaseForm);
    SignOutForm = (function(_super) {

      __extends(SignOutForm, _super);

      function SignOutForm() {
        this.onSignIn = __bind(this.onSignIn, this);

        this.onSubmit = __bind(this.onSubmit, this);
        return SignOutForm.__super__.constructor.apply(this, arguments);
      }

      SignOutForm.prototype.className = 'sign-out';

      SignOutForm.prototype.template = templates.signOut;

      SignOutForm.prototype.onSubmit = function() {
        SignOutForm.__super__.onSubmit.apply(this, arguments);
        return User.deauthenticate();
      };

      SignOutForm.prototype.onSignIn = function() {
        var _ref;
        SignOutForm.__super__.onSignIn.apply(this, arguments);
        return this.el.find('.current').html(((_ref = User.current) != null ? _ref.name : void 0) || '');
      };

      return SignOutForm;

    })(BaseForm);
    LoginForm = (function(_super) {

      __extends(LoginForm, _super);

      LoginForm.prototype.className = 'zooniverse-login-form';

      LoginForm.prototype.events = {
        'click button[name="sign-in"]': 'signIn',
        'click button[name="sign-up"]': 'signUp',
        'click button[name="reset"]': 'reset'
      };

      LoginForm.prototype.elements = {
        '.sign-in': 'signInContainer',
        '.sign-up': 'signUpContainer',
        '.reset': 'resetContainer',
        '.picker': 'signInPickers',
        'button[name="sign-in"]': 'signInButton',
        'button[name="sign-up"]': 'signUpButton',
        'button[name="reset"]': 'resetButton',
        '.picker button': 'pickerButtons',
        '.sign-out': 'signOutContainer'
      };

      function LoginForm() {
        this.onSignIn = __bind(this.onSignIn, this);

        this.reset = __bind(this.reset, this);

        this.signUp = __bind(this.signUp, this);

        this.signIn = __bind(this.signIn, this);
        LoginForm.__super__.constructor.apply(this, arguments);
        this.html(templates.login);
        this.signInForm = new SignInForm({
          el: this.signInContainer
        });
        this.signUpForm = new SignUpForm({
          el: this.signUpContainer
        });
        this.signInForms = $().add(this.signInContainer.add(this.signUpContainer.add(this.resetContainer)));
        this.signOutForm = new SignOutForm({
          el: this.signOutContainer
        });
        User.bind('sign-in', this.onSignIn);
        this.onSignIn();
      }

      LoginForm.prototype.signIn = function() {
        this.signInForms.hide();
        this.signInContainer.show();
        this.pickerButtons.show();
        return this.signInButton.hide();
      };

      LoginForm.prototype.signUp = function() {
        this.signInForms.hide();
        this.signUpContainer.show();
        this.pickerButtons.show();
        return this.signUpButton.hide();
      };

      LoginForm.prototype.reset = function() {
        this.signInForms.hide();
        this.resetContainer.show();
        this.pickerButtons.show();
        return this.resetButton.hide();
      };

      LoginForm.prototype.onSignIn = function() {
        if (User.current) {
          this.signInForms.hide();
          this.signInPickers.hide();
          return this.signOutContainer.show();
        } else {
          this.signIn();
          this.signInPickers.show();
          return this.signOutContainer.hide();
        }
      };

      return LoginForm;

    })(Spine.Controller);
    return module.exports = LoginForm;
  });

}).call(this);
