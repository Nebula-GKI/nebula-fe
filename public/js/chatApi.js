(function() {
  var history = [];

  window.chatApi = {

    // stubbed out, overidden by chatBox.js
    onHistoryUpdate: function() {},

    // call API and call onHistoryUpdate
    refresh: function() {
      console.log('API refreshing');
      aja()
        .method('get')
        .header('Accepts', 'application/json')
        .url('/messages')
        .on('200', this.onHistoryUpdate)
        .go();
    },

    // send chat and call onHistoryUpdate
    sendChat: function(chat) {
      console.log('API sending chat:', chat);
      aja()
        .method('post')
        .header('Accepts', 'application/json')
        .url('/message')
        .on('201', this.onHistoryUpdate)
        .body(chat)
        .go();
    },
  }
})();
