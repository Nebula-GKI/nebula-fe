# Nebula FE (Front End)

Proof of concept local server to allow easy graphical editing of data in Nebula.

# Install / Run

Requires Ruby 2.2.1

```bash
bundle install
ruby nebula_fe.rb /tmp
```

# Mock out front end for UI development

This will check out a version of the chat API that's independent of the backend:

```bash
git checkout 4c0cf54 -- public/js/chatApi.js
```
