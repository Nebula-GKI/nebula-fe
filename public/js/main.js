(function() {
  var r = React.DOM;
  var d = ReactDOM;

  window.Main = React.createFactory(React.createClass({
    getInitialState: function() {
      return {
        name: null,
        chatHistory: [],
        debug: false
      }
    },
    render: function() {
      if (this.state.name != null) {
        return ChatBox({name: this.state.name});
      } else {
        return Login({setName: this.setName});
      }
    },
    setName: function(name) {
      this.setState({name: name});
    }
  }));

  return ReactDOM.render(Main(), document.getElementById('main'));
})();
