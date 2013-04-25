var App = {
    Views: {},
    Routers: {},
    Models: {},
    init: function(user) {
        App.User = user;

        /*  Wasn't sure how to connect the login flow with my router since
            I created them separately. So I created a global user variable
            that everone knows about which might not be good design?
            For next phase I will try to clean up code.
        */
        Backbone.View.prototype.goTo = function (loc) {
          scr = document.body.scrollTop;
          appRouter.navigate(loc, true);
          document.body.scrollTop = scr;
        };

        new App.Views.User_Nav({ model: App.User, el: $("#top-wrapper") });
        new App.Views.Messages({ el: $("#message") });
        new App.Views.Auth({ model: App.User, el: $("#auth") });

        Backbone.history.start();
    },
};