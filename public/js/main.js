(function() {
  var r = React.DOM;

  window.Main = ReactMeteor.createClass({
    getMeteorState: function() {
      return {
        name: Session.get('name')
      };
    },
    render: function() {
      if (this.state.name != null) {
        return ChatBox();
      } else {
        return Login();
      }
    }
  });

  return React.renderComponent(Main(), document.getElementById('main'));

})();
