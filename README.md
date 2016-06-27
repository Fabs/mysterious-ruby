[![Issue Count](https://codeclimate.com/repos/5770ad2787e992006c002f20/badges/c8bef36bd9fe94cc209b/issue_count.svg)](https://codeclimate.com/repos/5770ad2787e992006c002f20/feed)
[![Test Coverage](https://codeclimate.com/repos/5770ad2787e992006c002f20/badges/c8bef36bd9fe94cc209b/coverage.svg)](https://codeclimate.com/repos/5770ad2787e992006c002f20/coverage)
[![Code Climate](https://codeclimate.com/repos/5770ad2787e992006c002f20/badges/c8bef36bd9fe94cc209b/gpa.svg)](https://codeclimate.com/repos/5770ad2787e992006c002f20/feed)
[![CI](https://circleci.com/gh/Fabs/mysterious-ruby.svg?style=shield&circle-token=7747d26213bdd9d2460d4322a886dcdb89ed7781)]()

## API documentation
https://mist-api.herokuapp.com/apipie/1.html

## Development

You can run guard for `rspec` and `rubocop linting`. 
```
$ guard
```

## A brief world

In the end I wanted to do much much more. But I believe this result was
more akin to life in the real world. I believe though one could see a lot
of how I think and design, specially the auth part that I build from scratch
thinking about what there is around, and past experience. 

My vision was to build a ranking app for images, that would (oh dream!)
calculate which other users are similar to you (it is not far, and the
similarity matrix I planned to implement is not that hard). 

It is in the end the API, of the MVP, that could fit a weekend's work.

I hope you enjoy!

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

- Warden Comments: By using warden, and warden scopes we ended up having
for the admin 3 active scopes (guest: {}, user: the_user, admin: the_user).
On one hand, for this assignment this is too much, on the other hand
it is made in a way to support capabilities like the admin being able
to have a different user on that scope, thus impersonating an user. 

- Sessions, Users and Auth: Why not put the token on the user. First, on
a mobile world, an user can have many different sessions from different
devices. Second the sessions could have information such as ip, browser and
etc. Also we do not destroy the sessions unless the user signs out, that
is to me for the moment a design flaw.

- TDD: I focused most on unit testing, and I did not refactored to dry
the specs. For instance, at the beginning I did not have should-matchers
(in retrospect a bad ide). I believe many specs (specially the permissions
one) could benefit of custom matchers, and also many of the boilerplate
necessary to mock dependencies could be better engineered. 

- No Feature Branches: On a real world scenario there would be lots of
feature branches, PRs and etc. I left showing that I can follow a rebase
or merge workflow with features branch out of the scope of this project.

- Errors: I was expecting to build the front-end too. During that process
I would take care of better error messages, and a more standardized error,
also capturing exceptions instead of throwing 500 and returning then as
better errors. 

## Work In Progress

There are a couple apis and things I did not implemented but miss in the end

- Scores for instance could have an index that shows all scores of an image.
I planned inicially some sort of aggregations (average, total and etc) and 
to send them along with the image. 

- Queue processing: I really wanted to dispatch a job to validate the url
and calculate something with the scores. Also I planned to use websockets
to have some sort of feed or 'live' updates, probabbly play with ActionCable
since I pretty much love Meteor.js :)

- On scores again, right now an user can add more than one score to each
Image, the initial was to not allow that.

- I wanted to do the front-end part, but I did not had time. If you want
you can see a work I made in react, on the weekends, couple months ago:

SOURCE: https://github.com/Fabs/react-apps/board
(It is the board folder inside this repository)

RUNNING AT: http://placar.reativo.com/
(Also if you sign up using facebook, there is an approval step I have to make, and then you will be able to add points to other users.)


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
- [x] Deploy Heroku
- [x] Seeds file with at least one record of sample data for each model.
- [x] Finish this document
