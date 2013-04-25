App.Views.User_Nav = Backbone.View.extend({
	
	list_btn : $("list_space"),
	search : $(".search-area"),
	model: App.User,
	el: $("#nav"),

	events : {
		"click #find_space" : "show_search",
	},

	initialize : function() {
		console.log("initialized");
		console.log(this.el);
		this.listenTo(this.model, "change", this.render);
	},

	render : function() {
		if (this.model.get("loggedIn")){
			this.list_btn.removeClass("hidden");;
		} else {
			this.list_btn.addClass("hidden");
		}
	},

	show_search : function() {
		console.log("showing");
		this.search.removeClass("hidden");
	},

	hide_search : function() {
		this.search.addClass("hidden");
	}

	
});