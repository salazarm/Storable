App.Views.Messages = Backbone.View.extend({

		el: $("#message"),

		initialize: function() {
			App.Message = this.message;
		},

		message: function(message, _class) {
			var message  = $("<div/>", {
				"class" : _class,
				text: message,	
				"style" : "display: inline; float:right; height: 10px"
			});
			$("#message").append(message[0].outerHTML);
			$("#message").children().last().hide().fadeIn(500).delay(1000).fadeOut(500, function(){
				this.remove();
			});
			this.remove();
		}
});