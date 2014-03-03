if (Meteor.isClient) {
  Template.hello.greeting = function () {
    return "Welcome to myapp.";
  };

  Template.hello.events({
    'click input' : function () {
      // template data, if any, is available in 'this'
      if (typeof console !== 'undefined')
        console.log("You pressed the button");
    }
  });
}

if (Meteor.isServer) {
  
  Meteor.startup(function() {
      var Client = require('mysql').Client;
      var client = new Client();
      client.user = 'root';
      client.password = 'root';
      console.log("connecting...");
      client.connect(function(err, results) {
          if (err) {
              console.log("ERROR: " + err.message);
              throw err;
          }
          console.log("connected.");
          clientConnected(client);
      });

      clientConnected = function(client)
      {
      }

      connection.end();
  });
}
