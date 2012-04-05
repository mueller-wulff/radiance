jQuery(function($){
  //if (typeof Juggernaut == "undefined") return;
  
  var Chat = {
    init: function(){
      this.socket = new Juggernaut;
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
    		})   	
      
      this.socket.on("connect", this.connect);
    	this.socket.on("disconnect", this.disconnect);
    	this.socket.on("reconnect", this.reconnect);
    	this.socket.subscribe("/observer", this.receive);
      $('#chat-form').submit(this.onSubmit);	
      // $("body").bind("ajaxSend", this.proxy(function(e, xhr){
      //   xhr.setRequestHeader("X-Session-ID", this.socket.sessionID);
      // }));
      //$('#chat-msg').
    },
    onSubmit: function() {
      $.post('/chat/message', { message: $('#chat-msg').val()} );
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

  window.chat = Chat.init();
});
