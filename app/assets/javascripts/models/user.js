App.Models.User = Backbone.Model.extend({
	
  defaults: {
		loggedIn: false,
		email: "Not logged in"
	},


	url : function() {
      var base = "/"+this.base; 
      if (!this.get("loggedIn")){
        return base;
      } else {
        return  base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id;
      }
  }

});