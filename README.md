## Development

You can run guard for `rspec` and `rubocop linting`. 
```
$ guard
```

## Decision Notes
A brief explanation for the decisions on this project.

- Rails 4.2.6, ruby 2.3.1: We are using the stable versions of ruby and 
rails. It would be nice to use rails 5.0, specially for `--api` in order
to simplify the setup and remove `sprockets` and other unused middleware
but we stick to the stable, and removed it manually when needed.

- Devise vs building myself with Warden: We could have used devise for
authentication and cancan for checking permissions. But I decided to do
it from scratch for two main reasons: (1) to show that I can do that
from scratch myself, (2) to learn how to do it. On a real application 
the pros and cons of adding a gem vs building from scratch should be 
weighted, most certainly,  according to different criteria. 

- session#status: It was not on the problem specification but this 
allows to check for a token you already have, and also check your level
of access ('guest', 'user', 'admin'). In a real world scenario it could
also be used to check the server status, hence it is the root path.

- Session and User for auth: ...

- Comments on specs: ... 

- No integration tests but: ...

- Test Refactoring: ...

- No Feature Branches: ...

## TODO
- [x] Setup Rails App on Github (+postgres)
- [x] Setup Rspec

- [x] It must be API (REST, JSON).
- [x] It must be secured by basic auth.
- [x] It must contain User model with different roles (admin, user, guest).
- [x] It must limit access to given part of API depending on User role.
    - [x] Guest has only read access.
    - [x] Admin has access to everything.
    - [x] User can read all, create all, but update and deleted only his records.
- [x] There should be at least 2 different models except User.
    - [x] Those models should be in relation (1 to many).
- [ ] Seeds file with at least one record of sample data for each model.
- [ ] Deploy Heroku

## NOTES
- APIPIE: Document image show image_url param