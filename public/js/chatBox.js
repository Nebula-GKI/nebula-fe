(function() {
  var r = React.DOM;

  window.ChatBox = ReactMeteor.createClass({
    getMeteorState: function() {
      return {
        history: ChatHistory.find().fetch(),
        debug: Session.get('debug'),
        name: Session.get('name')
      };
    },
    setMessage: function(e) {
      return this.setState({
        message: e.target.value
      });
    },
    sendMessage: function() {
      var _id, i, len, ref;
      if (this.state.message === ':debug') {
        Session.set('debug', Session.get('debug') !== true);
        return this.setState({
          message: ''
        });
      } else if (this.state.message === ':reset') {
        ref = ChatHistory.find({}).fetch();
        for (i = 0, len = ref.length; i < len; i++) {
          _id = ref[i]._id;
          ChatHistory.remove({
            _id: _id
          });
        }
        return this.setState({
          message: ''
        });
      } else if (this.state.message !== '') {
        ChatHistory.insert({
          name: this.state.name,
          message: this.state.message
        });
        return this.setState({
          message: ''
        }, (function(_this) {
          return function() {
            return setTimeout(_this.scrollToBottom, 1);
          };
        })(this));
      }
    },
    scrollToBottom: function() {
      var pane;
      pane = this.refs.history.getDOMNode();
      return pane.scrollTop = pane.scrollHeight;
    },
    submitIfEnter: function(e) {
      if (e.charCode === 13) {
        return this.sendMessage();
      }
    },
    renderChatMessage: function(message) {
      return r.span({
        className: 'chat'
      }, [
        r.span({
          className: 'chat-author'
        }, message.name + ':'), r.span({
          className: 'chat-message'
        }, message.message)
      ]);
    },
    render: function() {
      return r.div({
        className: 'chatbox'
      }, [
        this.state.debug ? r.pre({
          className: 'data-preview'
        }, r.code({}, JSON.stringify(this.state, null, '  '))) : void 0, r.div({
          ref: 'history',
          className: 'history'
        }, [
          this.renderChatMessage({
            name: 'System',
            message: "Welcome, " + this.state.name + "!"
          })
        ].concat(this.state.history.map(this.renderChatMessage))), r.div({
          className: 'controls'
        }, [
          r.input({
            ref: 'chatInput',
            className: 'chat-input',
            onKeyPress: this.submitIfEnter,
            onChange: this.setMessage,
            value: this.state.message
          }), r.button({
            className: 'sendButton',
            onClick: this.sendMessage
          }, 'Send')
        ])
      ]);
    },
    componentDidMount: function() {
      this.refs.chatInput.getDOMNode().focus();
      return this.scrollToBottom();
    },
    componentDidUpdate: function() {
      return this.scrollToBottom();
    }
  });

})();
