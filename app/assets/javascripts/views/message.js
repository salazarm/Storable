App.Views.Messages = Backbone.View.extend({

		el: $("#message"),

		initialize: function() {
			App.Message = this.message;
		},

		message: function(message, _class, css) {
			var message  = $("<div/>", {
				"class" : _class,
				text: message,	
				"style" :  css || "display: inline; float:right; height: 10px" 
			});
			$("#message").append(message[0].outerHTML);
			$("#message").children().last().hide().fadeIn(500).delay(1000).fadeOut(500, function(){
				this.remove();
			});
			
		}
});