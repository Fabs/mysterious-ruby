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

- Devise vs Warden: 


## TODO
- [x] Setup Rails App on Github (+postgres)
- [x] Setup Rspec

- [ ] It must be API (REST, JSON).
- [x] It must be secured by basic auth.
- [ ] It must contain User mode - with different roles (admin, user, guest).
- [ ] It must limit access to given part of API depending on User role.
- [ ] Admin has access to everything.
- [ ] User can read all, create all, but update and deleted only his records.
- [ ] Guest has only read access.
- [ ] There should be at least 2 different models except User.
- [ ] Those models should be in relation (1 to many).
- [ ] Seeds file with at least one record of sample data for each model.

## Extra
- [ ] Frontend
- [ ] Deploy Heroku


