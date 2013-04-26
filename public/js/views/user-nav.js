App.Views.User_Nav = Backbone.View.extend({
	
	list_btn : $("list_space"),
	search : $(".search-area"),
	model: App.User,
	el: $("#top-wrapper"),

	events : {
		"click #find_space" : "show_search",
		"click #close_search" : "hide_search"
	},

	initialize : function() {
		this.search.removeClass("hidden").fadeOut(0);
		this.listenTo(this.model, "change", this.render);
	},

	render : function() {
		console.log("rendering");
		if (this.model.get("loggedIn")){
			this.list_btn.removeClass("hidden");;
		} else {
			this.list_btn.addClass("hidden");
		}
	},

	show_search : function(ev) {
		ev.preventDefault();
		this.search.fadeIn(400);
	},

	hide_search : function(ev) {
		ev.preventDefault();
		this.search.fadeOut(400);
	}

	
});