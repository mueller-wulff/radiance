(function($) {

    window.Message = Backbone.Model.extend({
      defaults : { sender : null, time : null, body : null }
      // url : function() {
      //   return this.id ? '/chat/messages/' + this.id : '/chat/messages';
      // } 
    });

    window.MessageView = Backbone.View.extend({
    	tagName: 'div',
    	className: 'message',

    	initialize: function(){},

    	render: function(){
    		var renderedContent = ich.message(this.model.toJSON());
    		$(this.el).html(renderedContent);
    		return this;
    	}
    });

    window.Messages = Backbone.Collection.extend({
      model: Message,
      url: "/chat/messages"
    });

    window.messagesList = new Messages();

    window.MessageListView = MessageView.extend({});

    window.MessagesView = Backbone.View.extend({
        tagName: 'section',
        className: 'messages-list-for-channel',

        initialize: function() {
            _.bindAll(this, 'render');
            this.collection.bind('reset', this.render);
        },

        render: function() {
            var messages,
                collection = this.collection;

            $(this.el).html( ich.messageslist() );
            messages = this.$(".messages");
            this.collection.each(function(msg) {
                var view = new MessageListView({ model: msg, 
                                                 collection: collection });
                messages.append(view.render().el);
            });

            return this;
        }
    });

    window.ChatApplication = Backbone.Router.extend({
        routes: {
            '': 'initialRoute'
        },

        initialize: function(){
            this.messagesView = new MessagesView({ 
                collection: messagesList 
            });
        },
    
        initialRoute: function(){
          var $container = $('#chat');
          $container.empty();
          $container.append(this.messagesView.render().el);
        }

    }); 

    $(function() {
        window.App = new ChatApplication();
        Backbone.history.start();
    });

})(jQuery);
