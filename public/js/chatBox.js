(function() {
  var r = React.DOM;

  window.ChatBox = React.createFactory(React.createClass({
    getInitialState: function() {
      console.log(this.props);
      return {
        history: [],
        debug: false,
        name: this.props.name,
      };
    },
    componentWillMount: function() {
      // override callback to receive updates
      chatApi.onHistoryUpdate = this.setHistory.bind(this);
      chatApi.refresh();
    },
    setHistory: function(history) {
      this.setState({history: history});
    },
    setMessage: function(e) {
      this.setState({
        message: e.target.value
      });
    },
    sendMessage: function() {
      var _this = this;
      var _id, i, len, ref;

      if (this.state.message === ':debug') {
        this.setState({
          debug: this.state.debug !== true,
          message: '',
        });
      }

      } else if (this.state.message !== '') {
        chatApi.sendChat({
          name: this.state.name,
          message: this.state.message
        });

        this.setState({
          message: ''
        }, function() {
          // lame timing issues
          setTimeout(_this.scrollToBottom, 1);
        });
      }
    },
    scrollToBottom: function() {
      var pane = ReactDOM.findDOMNode(this.refs.history);
      pane.scrollTop = pane.scrollHeight;
    },
    submitIfEnter: function(e) {
      if (e.charCode === 13) {
        this.sendMessage();
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
      var pane = ReactDOM.findDOMNode(this.refs.chatInput).focus();
      this.scrollToBottom();
    },
    componentDidUpdate: function() {
      this.scrollToBottom();
    }
  }));

})();
