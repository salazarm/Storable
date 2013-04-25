App.Models.User = Backbone.Model.extend({
	
  defaults: {
		loggedIn: false,
		email: "Not logged in"
	},


	url : function() {
        return this.base;
      }

});