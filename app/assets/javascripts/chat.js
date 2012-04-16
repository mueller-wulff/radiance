jQuery(function($){
  //if (typeof Juggernaut == "undefined") return;
  var Channel = function(channelId, chat){
      this.channelId = channelId;
      this.channelDOM = $('#' + this.channelId);
      console.log("connecting to channel", this.channelId);
    	chat.getSocket().subscribe(this.channelId, $.proxy(this.receive, this));
      this.channelDOM.find('form').bind('submit', $.proxy(this.submit, this));
      this.channelDOM.find('input').bind('keydown', $.proxy(this.startTyping, this));
      this.scrollToBottom();
    }
  
  Channel.prototype = {
    channelId: null,
    channelDOM: null,
    typingTimer: null,
    isTyping: false,
    receive: function(msg) {
      console.log("got a message:");
      console.log(msg);
      if (msg.meta) {
        this.processMeta(msg);
      } else {
        this.channelDOM.find('.messages').append(msg.message);
        this.scrollToBottom();
      }
    },
    show: function(){
      $('.tab').each(function(elem) { elem.hide(); });
    }
    submit: function(){
      var inp = this.channelDOM.find('.chat-input');
      this.stopTyping();
      $.post('/chat/messages', { body: inp.val(), channel:this.channelId } );
      inp.val('');
      return false;
    },
    processMeta: function(message){
      if (message.meta == 'start_typing') {
        this.channelDOM.find('.messages').append("<div class='typing typing"+ message.profile_id+"'>" +
                                                 message.profile_name + " is typing...</div>")

      } else if (message.meta == 'stop_typing') {
        this.channelDOM.find('.messages').find(".typing" + message.profile_id).remove();
      }
    },
    startTyping: function(){
      console.log("started typing");
      if (!this.isTyping) {
        $.post('/chat/messages', { meta:'start_typing', channel:this.channelId } );
      }
      if (this.typingTimer != null) {
        window.clearTimeout(this.typingTimer);
      }
      this.typingTimer = window.setTimeout($.proxy(this.stopTyping, this), 1000);
      this.isTyping = true;
    },
    stopTyping: function(){
      this.isTyping = false;
      $.post('/chat/messages', { meta:'stop_typing', channel:this.channelId } );
      console.log("stopped typing");
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
