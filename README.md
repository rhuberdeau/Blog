# Blog

Robert Huberdeau's personal blog: articles written in Markdown (with
syntax-highlighted code), tags, an about page, a contact form, an XML sitemap
and Disqus comments. One admin account writes and publishes from `/admin`.

Rails 8.1 on Ruby 4.0 with PostgreSQL. Front end: Propshaft, importmap,
Turbo and Stimulus over the [Clean Blog](https://startbootstrap.com/theme/clean-blog)
theme (Bootstrap 3 CSS, Font Awesome 4). Authentication is Devise.

It originally ran on Heroku as a Rails 4.2 app; the `rails-8-upgrade`
history walks it forward one Rails version at a time.

## Running it

Everything runs in Docker; nothing needs installing on the host.

```bash
docker compose up -d db                              # Postgres
docker compose run --rm app bundle install           # gems go in a named volume
docker compose run --rm app bin/rails db:prepare db:seed
docker compose up app                                # http://localhost:3000
```

The seed creates an admin, `admin@example.com` / `password123`, plus a few
articles. Sign in at `/users/sign_in`, then go to `/admin`.

Sign-up is open only until the first user exists. To create the first admin
on a fresh production database instead of seeding it:

```bash
bin/rails runner 'User.create!(email: "you@example.com", password: "…", admin: true)'
```

## Tests and checks

```bash
docker compose run --rm app bundle exec rspec   # models, controllers, requests, system
docker compose run --rm app bin/ci              # RuboCop, audits, Brakeman, RSpec
```

System specs (`spec/system`) drive headless Chromium in the `chrome` compose
service, so they exercise the Turbo forms and Stimulus controllers for real.

## Production

`Dockerfile` builds a production image (the Rails 8 template). It runs
`db:prepare` on start and answers `/up` for health checks. It expects to sit
behind a TLS-terminating proxy (`assume_ssl` / `force_ssl`).

| Variable | Purpose |
| --- | --- |
| `DATABASE_URL` | PostgreSQL connection |
| `SECRET_KEY_BASE` | session and token signing; `bin/rails secret` makes one |
| `APP_HOST` | host for links in emails |
| `MY_EMAIL`, `EMAIL_PASSWORD` | SMTP login; contact-form messages are sent to `MY_EMAIL` |
| `SMTP_ADDRESS`, `SMTP_PORT` | default `smtp.gmail.com:587` |

Contact messages are always stored (listed at `/contacts` for the admin);
email is sent only when `MY_EMAIL` is set.
