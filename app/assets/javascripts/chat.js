jQuery(function($){
  //if (typeof Juggernaut == "undefined") return;
  
  var Chat = {
    init: function(){
      this.socket = new Juggernaut();
      this.offline = $("<div></div>")
    		.html("The connection has been disconnected! <br /> " + 
    		      "Please go back online to use this service.")
    		.dialog({
    			autoOpen: false,
    			modal:    true,
    			width:    330,
    			resizable: false,
    			closeOnEscape: false,
    			title: "Connection"
    		});   	
      
      this.socket.on("connect", this.connect);
    	this.socket.on("disconnect", this.disconnect);
    	this.socket.on("reconnect", this.reconnect);
    	this.socket.subscribe("/observer", this.receive);

      $('#chat-form').bind('submit', function(){alert('dupa');})

    },
    onSubmit: function() {
      $.post('/chat/messages', { body: $('#chat-msg').val()} );
      $('#chat-msg').val('');
      return false;
    },
    connect: function() {
      console.log('connected!');
    },
    disconnect: function() {
      console.log('disconnected :-(');
    },
    reconnect: function() {
      console.log('reconnecting');
    },
    receive: function(msg) {
      console.log("got a message:");
      console.log(msg);
      $('#chat .log').append(msg);
    }
  };

  $(function() {
      $('#chat-form').bind('submit', function(){alert('dupa');})//submit(this.onSubmit);
      console.log('stuff loaded');
  });

  window.chat = Chat.init();
});
