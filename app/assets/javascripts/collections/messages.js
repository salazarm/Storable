App.Collections.Conversations = Backbone.Collection.extend({

	user: App.User,
	url: "/conversations",

	initialize : function(){
		model = App.Models.Message;
	},

	all_messages : function(){
		return this.models	
	},

	renting_messages : function(){
		return this.models.filter(function(message){
			return !message.get("is_host");
		});
	},

	hosting_messages : function(){
		return this.filter(function(message){
			return message.get("is_host");
		});
	},

	unread_messages : function(){
		return this.filter(function(message){
			return message.get("read");
		});
	},

	starred_messages : function(){
		return this.filter(function(message){
			return message.get("starred")
		});
	}


});