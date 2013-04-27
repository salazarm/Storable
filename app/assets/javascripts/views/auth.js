App.Views.Auth = Backbone.View.extend({
	
	el: $("#auth"),

	// Caching jQuery results
	default_login_btn: $("#login1"),
	default_signup_btn: $("#signup1"),
	or_login_btn: $("#login2"),
	or_signup_btn: $("#signup2"),
	login_form: $("#login_form"),
	signup_form: $("#signup_form"),
	login_email_field : $("[name=email]"),
	login_password_field : $("[name=password]"),
	signup_email_field : $("[name=user\\[email\\]]"),
	signup_password_field : $("[name=user\\[password\\]]"),
	signup_passwordc_field : $("[name=user\\[password_confirmation\\]]"),

	events : {
		"click .login" : "show_login",
		"click .signup" : "show_signup",
		"click .loginbtn" : "do_login",
		"click .signupbtn" : "do_signup",
	},

	// submit: function(e) {
	// 	if (e.keyCode == 13){
	// 		if (this.$("login_form").is(":visible")){
	// 			this.do_login(e);
	// 		} else {
	// 			this.do_signup(e);
	// 		}
	// 	}
	// },

	initialize : function() {
		this.$el.show();
		this.listenTo(this.model, "change", this.render);
		this.render();
	},

	render : function() {
		console.log("render in auth");
		if (this.model.get("loggedIn")) {
			this.disable();
		} else {
			this.$el.show();
			this.show_login();
			this.delegateEvents();
		}
	},

	show_login : function() {
		this.signup_form.hide();
		this.default_signup_btn.hide();
		this.default_login_btn.hide();
		this.or_login_btn.hide();
		this.or_signup_btn.show();
		this.login_form.show();
	},

	show_signup : function() {
		this.login_form.hide();
		this.default_signup_btn.hide();
		this.default_login_btn.hide();
		this.or_login_btn.show();	
		this.or_signup_btn.hide();
		this.signup_form.show();
	},

	do_login : function(ev) {
		that = this;
		ev.preventDefault();	
		this.model.base = "sessions";
		this.model.save({
			email: this.login_email_field.val(),
			password: this.login_password_field.val()
		}, {
			success : function(model, response, options) {
				App.User.set({
					loggedIn: true,
					password: null,
					email: response.email
				});
				that.login_email_field.val("");
				that.login_password_field.val("");
				App.Message("Successful Login", "success")
			}, 
			error : function(model, response, options) {
				that.login_email_field.addClass("error");
				that.login_password_field.addClass("error");
			}

		});
	},

	do_logout : function(ev) {
		ev.preventDefault();
		console.log("logout procedure");
	},

	do_signup : function(ev) {
		that = this;
		ev.preventDefault();
		this.model.base = "users";
		this.model.save({
			email: this.signup_email_field.val(),
			password: this.signup_password_field.val(),
			password_confirmation: this.signup_passwordc_field.val()
		}, {
			success : function(model, response, options) {
				App.User.set({
					loggedIn: true,
					password: null, 
					email: response.email
				});
				that.signup_passwordc_field.val("");
				that.signup_password_field.val("");
				that.signup_email_field.val("");
				App.Message("Successful Signup", "success");
			},
			error : function(model, response, options) {
				that.signup_password_field.removeClass("error");
		    that.signup_passwordc_field.removeClass("error");
		    that.signup_email_field.removeClass("error");
				r = JSON.parse(response.responseText);
		    for (var re in r){
		    	if (re == "password_digest" || re == "password"){
		    		that.signup_password_field.addClass("error");
		    		that.signup_passwordc_field.addClass("error");
		    	} else if (re == "email") {
		    		that.signup_email_field.addClass("error");
		    	}
				}
			}
		});

	},

	disable : function() {
		this.$el.hide();
		this.undelegateEvents();
	}

});