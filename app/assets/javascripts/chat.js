jQuery(function($){
  //if (typeof Juggernaut == "undefined") return;
  var Channel = function(channelId, chat){
      this.channelId = channelId;
      this.channelDOM = $('#' + this.channelId);
      console.log("connecting to channel", this.channelId);
    	chat.getSocket().subscribe(this.channelId, $.proxy(this.receive, this));
      this.channelDOM.find('form').bind('submit', $.proxy(this.submit, this));
      this.scrollToBottom();
    }
  
  Channel.prototype = {
    channelId: null,
    channelDOM: null,
    receive: function(msg) {
      console.log("got a message:");
      console.log(msg);
      this.channelDOM.find('.messages').append(msg);
      this.scrollToBottom();
    },
    submit: function(){
      var inp = this.channelDOM.find('.chat-input');
      $.post('/chat/messages', { body: inp.val(), channel:this.channelId } );
      inp.val('');
      return false;
    },
    scrollToBottom: function() {
      var container = this.channelDOM.find('.messages-container');
      container.animate({ scrollTop: container.prop("scrollHeight") - container.height() }, 100);
    }

  };

  var Chat = {
    socket: null,
    init: function() {
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
      $('.channel').each(function() {
        // TODO: create a real class and instantiate it,
        // now it only supports one chatroom
        // Channel.init(this.id, Chat);
        new Channel(this.id, Chat);
      })
    },
    getSocket: function() {
      return(this.socket);
    },
    connect: function() {
      console.log('connected!');
    },
    disconnect: function() {
      console.log('disconnected :-(');
    },
    reconnect: function() {
      console.log('reconnecting');
    }
  };

  Chat.init();
});
