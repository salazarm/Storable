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
  $(window).resize(function(){
    console.log("resize");
    var w = $(window).width();
    var newW = Math.max(10,Math.floor((w-961)/2)) + "px";
    sub_wrapper2.css("margin-left", newW);
    sub_wrapper2.css("margin-top", "20px")
  });
  $(window).trigger("resize");
    $(".fancybox").fancybox({
            'type': 'image',  
             'transitionIn' : 'elastic',
             'transitionOut' : 'elastic',
           });
      _.templateSettings = {
        interpolate: /\[\[\=(.+?)\]\]/g,
        evaluate: /\[\[(.+?)\]\]/g
    };
    $(".listing-icon").hover(function(){
         $(($(this)[0].children[0])).slideDown(200, 'swing');
    }, function(){
        $(($(this)[0].children[0])).slideUp(200, 'swing');
    })
});