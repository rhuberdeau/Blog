# Blog

Robert Huberdeau's personal blog: articles written in Markdown (with
syntax-highlighted code), tags, an About page, an Atom feed (`/feed`) and an
XML sitemap. One author writes and publishes from `/admin`.

Rails 8.1 on Ruby 4.0, SQLite, Rails' built-in authentication. Front end:
one hand-written stylesheet (`app/assets/stylesheets/application.css`, light and
dark from the reader's system setting) served by Propshaft, plus Turbo and
a little Stimulus via importmap. No CSS framework, no Node, no build step.

The editor at `/articles/new` shows a live preview beside the Markdown
(rendered by the server exactly as the article will look), a "Markdown help"
reference, word count and reading time; Ctrl/Cmd+S saves, and it warns before
leaving with unsaved changes. Spelling is checked by the browser (Edge's Enhanced
spell check adds grammar).

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

The blog runs on one AWS Lightsail instance (Ubuntu, 1 GB), deployed with
[Kamal](https://kamal-deploy.org) (`config/deploy.yml`):

- **kamal-proxy** terminates HTTPS with a Let's Encrypt certificate and
  redirects http to https. It health-checks `/up`.
- **The app container** is the production `Dockerfile` image (from
  `ghcr.io/rhuberdeau/blog`). It runs `db:prepare` on start. The SQLite
  database lives in `/var/lib/blog/storage` on the server.
- **The litestream accessory** streams every database change to S3
  (continuous backup).

The instance's launch script (`config/server/init.sh`) does what Kamal can't
do as the `ubuntu` user: it installs Docker, creates the storage directory,
adds swap, and turns on automatic security updates.

### Deploying

Kamal runs in a container (the `deploy` compose service), so the host needs
no Ruby. It reads `.env.deploy`: copy `.env.deploy.example` and fill it in. The
SSH key for the server is `~/.ssh/blog_lightsail`.

```bash
alias kamal='docker compose --profile deploy run --rm deploy bin/kamal'

kamal setup        # first time: proxy, certificate, app, backups
kamal deploy       # every release (zero downtime); deploys the committed HEAD
kamal rollback <version>
kamal logs         # follow app logs
kamal console      # Rails console on the server
kamal accessory logs litestream
```

### Backups and restore

Litestream writes to `s3://$LITESTREAM_BUCKET/blog`. To restore (for example
onto a new server, before `kamal setup`):

```bash
docker run --rm -v /var/lib/blog/storage:/rails/storage \
  -e AWS_ACCESS_KEY_ID=… -e AWS_SECRET_ACCESS_KEY=… -e AWS_REGION=us-east-1 \
  litestream/litestream:0.5.17 \
  restore -o /rails/storage/production.sqlite3 s3://BUCKET/blog
sudo chown 1000:1000 /var/lib/blog/storage/*
```

### Settings

| Variable (in `.env.deploy`) | Purpose |
| --- | --- |
| `BLOG_SERVER_IP` | the Lightsail static IP |
| `BLOG_HOSTS` | comma-separated names the blog serves, canonical first (the rest 301 to it); each needs a DNS A record to the IP |
| `SECRET_KEY_BASE` | signs session cookies; generate once (`bin/rails secret`) and keep it |
| `ADMIN_EMAIL`, `ADMIN_PASSWORD` | the author, created on first boot |
| `CONTACT_EMAIL` | optional; shown as a mailto on the About page |
| `KAMAL_REGISTRY_PASSWORD` | GitHub token with `write:packages` |
| `LITESTREAM_*` | backup bucket, region and an IAM key limited to that bucket |

The image also runs anywhere else with a volume on `/rails/storage` and
`SECRET_KEY_BASE` set, behind a TLS-terminating proxy.
