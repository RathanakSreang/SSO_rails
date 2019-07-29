# README

This is a sample ROR app for SSO login.

### Setup
```
bundle install
rails db:create
rails db:migrate
rails s
```

### Account for SSO login,

Go to account and create new account with
- email: user email
- content: the idp meta data for SSO

### Login/Signup with SSO

On homepage input email(the email in account record) in input field.
It should redirect you to login page of IDP then it redirect back and it done.
