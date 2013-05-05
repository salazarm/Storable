var i = 0;
App.Views.Conversations = Backbone.View.extend({

	model: App.User,
	collection: App.Collections.Conversations,
	showing : [],

	el: $("#conversations-container"),

	events : {
		"click #toggle-all-messages" : "all_messages",
		"click #toggle-hosting-messages" : "hosting_messages",
		"click #toggle-renting-messages" : "renting_messages",
		"click #toggle-starred-messages" : "starred_messages",
		"click #toggle-unread-messages" : "unread_messages",
	},

	initialize: function() {
		this.collection = new App.Collections.Conversations({});
		this.conversations = this.$("#conversations");
		that = this;
		this.toggle_all = this.$("#toggle-all-messages");
		this.toggle_host = this.$("#toggle-hosting-messages");
		this.toggle_renting = this.$("#toggle-renting-messages");
		this.toggle_unread = this.$("#toggle-unread-messages");
		this.toggle_starred = this.$("#toggle-starred-messages");
		this.tabs = [ this.toggle_all, this.toggle_starred, this.toggle_unread, this.toggle_host, this.toggle_renting ];
		this.all_messages();
		setInterval(function(){
			if (App.User.get("loggedIn")) {
				that.collection.fetch({
					success: function(data, response, options){
						that.render();
						data.models.filter(function(message){
							return (Date.now()-(new Date(message.attributes.update_at)) < 1000*10) && message.closed == null ;
						});

					},
					error: function(model, response, options){
						console.log(response);
					}
				});
			}
		}, 3000);
		if ($("#conversation-template").size()!=0){
			this.template = _.template($("#conversation-template").html());
		}
	},
	
	toggleIconClasses : function(bool, icon){
 	 	if (icon.hasClass("icon-star-empty")){
		 	icon.removeClass("icon-star-empty");
		 	icon.addClass("icon-star");
		  if(bool){
			 	var id = icon.parent().parent().parent()[0].id
			 	$.ajax({
			 		url: '/conversations' +'/'+ id,
			 		type: "PUT",
			 		data: {
			 			star: true
			 		}
			 	});
		  }
	    } else {
		 	icon.removeClass("icon-star");
		 	icon.addClass("icon-star-empty");
		 	if(bool){
		 		var id = icon.parent().parent().parent()[0].id
			 	$.ajax({
			 		type: "PUT",
			 		url: '/conversations' +'/'+id,
			 		data: {
			 			star : false
			 		}
			 	});
			}
		}
	},

	render : function(){
		if ($("#conversation-template").size()!=0){
			this.conversations.html('');
			that = this;
			_.each(this.showing, function(conversation) {	
				self = that;
				this.$(conversations).append(that.template(conversation.attributes));
				$(".star-icon").last().click(function(){
				 	self.toggleIconClasses(true, $(this));
				}).mouseover(function(){
				 	self.toggleIconClasses(false, $(this));
				}).mouseleave(function(){
				 	self.toggleIconClasses(false, $(this));
				});
			});
		}
	},

	clean : function(){
        _.each(this.tabs, function(d){ 
        	d.removeClass("active");
        });
	},

	all_messages : function(){
		this.clean();
		this.active = this.toggle_all;
		this.toggle_all.addClass("active");
		this.showing = this.collection.all_messages();
	},

	hosting_messages : function(){
		this.clean();
		this.active = this.toggle_host;
		this.toggle_host.addClass("active");
		this.showing = this.collection.hosting_messages();
	},

	renting_messages : function(){
		this.clean();
		this.active = this.toggle_renting;
		this.toggle_renting.addClass("active");
		this.showing = this.collection.renting_messages();
	},

	starred_messages : function(){
		this.clean();
		this.active = this.toggle_starred;
		this.toggle_starred.addClass("active");
		this.showing = this.collection.starred_messages();
	},

	unread_messages : function(){
		this.clean();
		this.active = this.toggle_unread;
		this.toggle_unread.addClass("active");
		this.showing = this.collection.unread_messages();
	},

});