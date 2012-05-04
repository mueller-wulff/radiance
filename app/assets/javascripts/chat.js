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
      if (msg.meta) {
        this.processMeta(msg);
      } else {
        this.channelDOM.find('.messages').append(msg.message);
        this.scrollToBottom();
        if (!this.channelDOM.is(":visible")) {
        this.increaseUnread(); 
        }
      }
    },
    submit: function(){
      var inp = this.channelDOM.find('.chat-input');
      this.stopTyping();
      $.post('/chat/messages', { body: inp.val(), channel:this.channelId } );
      inp.val('');
      return false;
    },

    increaseUnread: function(){
      var value = parseInt($('#badge-'+this.channelId).html());
      value++;
      $('#badge-'+this.channelId).html(value);
      $('#badge-'+this.channelId).show();
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
      setTimeout($.proxy(function(){
        var container = this.channelDOM.find('.container');
        container.animate({ scrollTop: container.prop("scrollHeight") - container.height() }, 100);
      }, this), 100);
    }

  };

  var Chat = {
    socket: null,
    channels: [],
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

      $('.tab a').click(function(e){
        var channelId = $(this).attr('data-channel-id')
        Chat.showChannel(channelId);
        $('#badge-'+channelId).html(0);
        $('#badge-'+channelId).hide();
        return false;
      });

      $('.channel').each(function() {
        Chat.channels.push(new Channel(this.id, Chat));
      })
      this.showChannel($('.channel').first().attr('id'));
    },
    showChannel: function(channelId){
      $('.tab').removeClass('active');
      $('.channel').hide();
      $('#tab' + channelId).addClass('active');
      $('#' + channelId).show();
      if (Chat.findChannel(channelId)){
          Chat.findChannel(channelId).scrollToBottom();
      }
    },
    findChannel: function(channelId) {
      console.log('findChannel'+this.channels.length);
      for(i=0;i<this.channels.length;i++) {
        if (this.channels[i].channelId == channelId) {
          return this.channels[i];
        }
      }
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
