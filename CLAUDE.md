# Working in this repo

`README.md` describes the app. This file is the operating rules.

## Every command runs in a container

There is no Ruby on the host. Use the compose services:

```bash
docker compose up -d db                          # infra first
docker compose run --rm app bundle exec rspec    # tests (needs the chrome service; compose starts it)
docker compose run --rm app bin/ci               # the full check: RuboCop, audits, Brakeman, RSpec
docker compose run --rm app bin/rails console
docker compose up app                            # dev server :3000
```

Gems live in the `bundle` named volume and `tmp/` in `tmp`, not on the
Windows bind mount. After changing the Gemfile, run `bundle install` through
the container. Docker Desktop's daemon is often stopped: check `docker info`
first.

Text files are stored with LF (`.gitattributes`); scripts in `bin/` break in
the Linux container with CRLF.

## Conventions

- Tests must pass on an empty database; `rails_helper` truncates tables
  before the suite because `db:prepare` seeds the test DB too.
- Failed form submissions render with `status: :unprocessable_content` and
  destructive redirects use `status: :see_other`; Turbo ignores anything else.
- No rails-ujs: anything that isn't a GET is a `button_to`, never
  `link_to ... method:`.
- JavaScript is Stimulus controllers in `app/javascript/controllers`, loaded
  by importmap. No jQuery, no build step.
- The Clean Blog theme expects each page to open with the `shared/header`
  image banner; pages without one get navbar fixes from `blog.css`
  (`body:not(:has(.intro-header))`).
- No secrets in the repo: production reads `SECRET_KEY_BASE` and mail
  credentials from the environment.
