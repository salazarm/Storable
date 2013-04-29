App.Views.User_Nav = Backbone.View.extend({
	model: App.User,
	el: $("#top-wrapper"),

	events : {
		"click #find_space" : "show_search",
		"click #close_search" : "hide_search",
		"mouseenter #user-area" : "show_user_dropdown",
		"mouseleave  #user-area" : "hide_user_dropdown",
		"click #logoutbtn" : "logout",
		"click #profile" : "go_to_profile",
		"click #notif" : "go_to_conversations"
	},

	go_to_profile : function() {
		window.location = "/users/"+this.model.get("id");
	},

	show_user_dropdown : function() {
		this.user_dropdown.slideDown(100);
	},

	hide_user_dropdown : function() {
		this.user_dropdown.slideUp(100);
	},

	initialize : function() {
		this.email = this.$("#user-email");
		this.search = this.$(".search-area");
		this.list_btn = this.$("#list_space");
		this.user_area = this.$("#user-area");
		this.user_dropdown = this.$("#user-nav");

		this.search.removeClass("hidden").fadeOut(0);
		this.listenTo(this.model, "change", this.render);
		this.render();
	},

	render : function() {
		console.log("rendering");
		if (this.model.get("loggedIn")){
			this.user_area.removeClass("hidden");
			this.list_btn.removeClass("hidden");
			this.email.html(this.model.get("email"));
		} else {
			this.user_area.addClass("hidden");
			this.list_btn.addClass("hidden");
		}
	},

	show_search : function(ev) {
		ev.preventDefault();
		this.search.fadeIn(400).slideDown(400);
	},

	hide_search : function(ev) {
		ev.preventDefault();
		this.search.fadeOut(400).slideUp(400);
	},

	logout : function() {
		App.User.base = "sessions";
		that = this;
		App.User.destroy({
			success: function(model, response, options) {
				App.User.set({
					email: null,
					id: null,
					loggedIn: false,
				});
				window.location=window.location;
			}
		});
	}

	
});