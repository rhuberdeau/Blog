# Working in this repo

`README.md` describes the app. This file is the operating rules.

## Every command runs in a container

There is no Ruby on the host. Use the compose services:

```bash
docker compose run --rm app bundle exec rspec    # tests (compose starts the chrome service)
docker compose run --rm app bin/ci               # the full check: RuboCop, audits, Brakeman, RSpec
docker compose run --rm app bin/rails console
docker compose up app                            # dev server, host port 3001 (BLOG_PORT)
```

Gems (`bundle`), `tmp/` and the SQLite files (`storage`) are named volumes,
not the Windows bind mount; SQLite's locking is unreliable across it. After
changing the Gemfile, run `bundle install` through the container. Docker
Desktop's daemon is often stopped: check `docker info` first.

Text files are stored with LF (`.gitattributes`); scripts in `bin/` break in
the Linux container with CRLF.

Chrome in the `chrome` service upgrades single-label hostnames like
`http://app:3000` to HTTPS; reach the app by container IP (as
`spec/support/system.rb` does).

## Conventions

- One author, no roles. Every action requires sign-in unless its controller
  calls `allow_unauthenticated_access`; keep it that way rather than adding
  per-action checks.
- Drafts are articles with no `published_at`. Public reads go through
  `Article.published`; `ArticlesController#set_article` shows drafts only to
  the signed-in author.
- Markdown goes through `ApplicationHelper#markdown` (commonmarker), which
  drops raw HTML. Don't render article text any other way.
- Tests must pass on an empty database; `rails_helper` truncates tables
  before the suite because `db:prepare` seeds the test DB too.
- Failed form submissions render with `status: :unprocessable_content`;
  destructive redirects use `status: :see_other`. Turbo ignores anything else.
- No rails-ujs: anything that isn't a GET is a `button_to`.
- Views are ERB with semantic HTML. JavaScript is Turbo plus a few Stimulus
  controllers (importmap, no build step), currently only the article editor.
- The editor preview is rendered by the server with the article page's own
  partial (`articles/_article_body`); never add a client-side Markdown
  renderer, or the preview and the published page can drift. Requests from
  JavaScript send the global CSRF token (`X-CSRF-Token`), not a form's
  per-form token. The test env disables CSRF, so editor system specs turn it
  back on.
- All styles live in `app/assets/stylesheets/application.css`: no framework.
  Colours are custom properties with a light and a dark set; use the tokens,
  never literal colours, so dark mode keeps working. Code highlighting colours
  commonmarker's scope classes from the same tokens.
- A strict Content-Security-Policy is on (`config/initializers/content_security_policy.rb`):
  no inline `<script>`, `<style>` or `style=""`, and no third-party hosts. Turbo
  and the importmap get a per-request nonce; anything new needs one too.
- Never hard-code the domain: absolute URLs come from the request (`root_url`,
  `article_url`), as in the sitemap and the feed.
- AI (the writing assistant) goes through `Ai::Client` only; each feature is
  an `Ai::Tasks::*` class with a JSON schema, a prompt and a `fake_result`.
  Tests run with `Ai::Client.fake!` and a real client raises in the test env,
  so CI never calls Anthropic or spends money. AI output is shown, never
  applied: the author clicks Apply / Use / Start a draft. Requests run as
  `AiRequestJob` on Solid Queue (in Puma, own SQLite DB) and record their cost;
  `Ai::Budget` enforces `AI_MONTHLY_BUDGET_USD`. Running a real AI request
  spends the user's money: ask first.
- No secrets in the repo: production reads `SECRET_KEY_BASE` from the env.
- Deploys run Kamal through the `deploy` compose service
  (`docker compose --profile deploy run --rm deploy bin/kamal …`). Secrets and
  per-install values live in the gitignored `.env.deploy`; never commit it.
  Creating or changing AWS resources needs the user's explicit go-ahead.
