var App = {
    Collections: {},
    Views: {},
    Routers: {},
    Models: {},
    init: function(user) {
        App.User = user;
        new App.Views.User_Nav({ model: App.User, el: $("#top-wrapper") });
        new App.Views.Auth({ model: App.User, el: $("#auth") });
        App.Conversations = new App.Views.Conversations({ model: App.User, el: $("#conversations-container") });
        Backbone.history.start();
    },
};


$(function() {
    $( ".ui-datepicker-target" ).datepicker();
      var sub_wrapper2 = $("#search-bar");
    $(".listing-icon").hover(function(){
         $(($(this)[0].children[0])).slideUp(200, 'swing');
    }, function(){
        $(($(this)[0].children[0])).slideDown(200, 'swing');
    })
});