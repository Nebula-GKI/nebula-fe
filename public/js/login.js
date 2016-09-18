(function() {
  var r = React.DOM;

  window.Login = ReactMeteor.createClass({
    getMeteorState: function() {
      return {
        name: Session.get('name')
      };
    },
    setName: function(e) {
      return this.setState({
        name: e.target.value
      });
    },
    setSessionName: function() {
      if (this.state.name !== '') {
        return Session.set('name', this.state.name);
      }
    },
    submitIfEnter: function(e) {
      if (e.charCode === 13) {
        return this.setSessionName();
      }
    },
    render: function() {
      return r.div({
        className: 'login'
      }, [
        r.h2({}, 'Hello!'), r.p({}, 'Please tell us your name before you join the chat.'), r.input({
          ref: 'loginInput',
          className: 'login-input',
          onChange: this.setName,
          value: this.state.name,
          onKeyPress: this.submitIfEnter
        }), r.button({
          onClick: this.setSessionName
        }, 'Login')
      ]);
    },
    componentDidMount: function() {
      return this.refs.loginInput.getDOMNode().focus();
    }
  });

})();
