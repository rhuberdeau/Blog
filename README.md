# Blog

Robert Huberdeau's personal blog: articles written in Markdown (with
syntax-highlighted code), tags, an About page and an XML sitemap. One author
writes and publishes from `/admin`.

Rails 8.1 on Ruby 4.0, SQLite, Rails' built-in authentication. Front end:
one hand-written stylesheet (`app/assets/stylesheets/application.css`, light and
dark from the reader's system setting) served by Propshaft, plus Turbo via
importmap. No CSS framework, no Node, no build step.

It began as a Rails 4.2 app on Heroku; the `rails-8-upgrade` history walks it
forward one version at a time, then trims it to what a single-author blog needs.

## Running it

Everything runs in Docker; nothing needs installing on the host.

```bash
docker compose run --rm app bundle install          # gems go in a named volume
docker compose run --rm app bin/rails db:prepare db:seed
docker compose up app                               # http://localhost:3001
```

The seed creates the author, `admin@example.com` / `password123`, plus a few
articles. Sign in at `/session/new`; the nav then shows **Admin**. Set
`BLOG_PORT` to serve on a port other than 3001.

## The author account

There is no sign-up and no emailed password reset. Create or reset the author
from the console:

```bash
bin/rails runner 'User.find_or_initialize_by(email_address: "you@example.com").update!(password: "…")'
```

Or set `ADMIN_EMAIL` and `ADMIN_PASSWORD` and run `bin/rails db:seed` (in
production it only creates the author, no sample articles).

## Tests and checks

```bash
docker compose run --rm app bundle exec rspec   # models, requests, system specs
docker compose run --rm app bin/ci              # RuboCop, audits, Brakeman, RSpec
```

System specs (`spec/system`) drive headless Chromium in the `chrome` compose
service, so the Turbo forms and the phone layout are exercised for real.

## Production

`Dockerfile` builds a production image. It runs `db:prepare` on start, answers
`/up` for health checks, and keeps the SQLite database in `/rails/storage`:
mount a volume there and back that volume up.

```bash
docker build -t blog .
docker run -p 3000:3000 -v blog_storage:/rails/storage \
  -e SECRET_KEY_BASE=$(openssl rand -hex 64) blog
```

It expects to sit behind a TLS-terminating proxy (`assume_ssl` / `force_ssl`).

| Variable | Purpose |
| --- | --- |
| `SECRET_KEY_BASE` | signs session cookies; generate once and keep it |
| `ADMIN_EMAIL`, `ADMIN_PASSWORD` | the author, created by `db:seed` |
| `CONTACT_EMAIL` | optional; shown as a mailto on the About page |
