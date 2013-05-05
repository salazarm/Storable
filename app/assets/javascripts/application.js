var App = {
    Collections: {},
    Views: {},
    Routers: {},
    Models: {},
    init: function(user) {
        App.User = user;
        new App.Views.User_Nav({ model: App.User, el: $("#top-wrapper") });
        new App.Views.Messages({ el: $("#message") });
        new App.Views.Auth({ model: App.User, el: $("#auth") });
        App.Conversations = new App.Views.Conversations({ model: App.User, el: $("#conversations-container") });
        Backbone.history.start();
    },
};


$(function() {
    $( ".ui-datepicker-target" ).datepicker();
});