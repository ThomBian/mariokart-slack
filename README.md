# Mario Kart Slack

A small league app for tracking **Mario Kart** sessions with your team: record games from Slack, maintain **Elo-style ratings**, optional **votes and bets**, a playful **in-game currency** shop, and a **web dashboard** for rankings, match history, and player stats.

Built for a Slack workspace where everyone uses a shared slash command; the UI adds charts, profiles, and a nicer view of the data than threads alone.

## What it does

- **Slack slash command** (`/mariokart`, configured in your Slack app) — start flows to log new games, rematches, show the leaderboard, and personal stats.
- **Web app** — React SPA (Apollo Client → GraphQL) served by Sinatra: games list, ranking, “money” shop, per-player pages with history and achievements.
- **Sign-in** — Slack OpenID Connect so workspace members can link to a `Player` profile (matched by real name).

## Tech stack

| Layer | Choice |
|--------|--------|
| API & HTML shell | [Sinatra](https://sinatrarb.com/) |
| Data | [ActiveRecord](https://guides.rubyonrails.org/active_record_basics.html) + **PostgreSQL** |
| API for the SPA | **GraphQL** (`POST /data`) |
| Frontend | **React 17**, [Apollo Client](https://www.apollographql.com/docs/react/), [styled-components](https://styled-components.com/), [Nivo](https://nivo.rocks/) charts |
| Build | **Webpack 5** |
| Slack | [slack-ruby-client](https://github.com/slack-ruby/slack-ruby-client) |

Ruby **2.6.8** is specified in the `Gemfile`. The repo includes a **Heroku** `Procfile` (`rackup` + `release: rake db:migrate`).

## Prerequisites

- Ruby 2.6.8 (e.g. [rbenv](https://github.com/rbenv/rbenv) / [rvm](https://rvm.io/))
- [Bundler](https://bundler.io/)
- [Node.js](https://nodejs.org/) + [Yarn](https://yarnpkg.com/)
- PostgreSQL and a `DATABASE_URL` (or whatever your `sinatra-activerecord` setup expects—commonly `DATABASE_URL` for Postgres)

## Local setup

1. **Install dependencies**

   ```bash
   bundle install
   yarn install
   ```

2. **Configure environment**  
   Create a `.env` in the project root (loaded automatically in development/test via `dotenv`). See [Environment variables](#environment-variables) below.

3. **Database**

   ```bash
   rake db:create db:migrate
   # or load schema if you prefer:
   # rake db:schema:load
   ```

4. **Build the frontend**  
   In development, keep webpack watching so `public/js/index.js` stays up to date:

   ```bash
   yarn dev
   ```

5. **Run the app**

   ```bash
   bundle exec rackup config.ru -p 9292
   ```

   Open [http://localhost:9292](http://localhost:9292). GraphQL from the browser goes to `POST /data` on the same origin.

## Slack app configuration (overview)

Your Slack app must be wired to this service:

- **Slash command** — points at your deployed URL (same endpoint as `GET /`; the app uses `POST /` for slash commands with verification).
- **Interactivity & shortcuts** — if you use modals/actions, point the **Request URL** to `/actions` (see `app.rb`).
- **OpenID / OAuth** — for web login: redirect URI must match `LOGIN_REDIRECT_URL`; use the Slack client ID and secret you put in env.

The incoming slash command payload is validated with `SLACK_TOKEN` (verification token from the Slack app’s **Basic Information**).

## Environment variables

| Variable | Purpose |
|----------|---------|
| `DATABASE_URL` | PostgreSQL connection string (typical for Heroku/local Postgres). |
| `SESSION_SECRET` | Secret for Sinatra sessions (set a long random string in production). |
| `SLACK_TOKEN` | Slack app **Verification Token** — must match incoming slash command requests. |
| `BOT_ACCESS_TOKEN` | Bot user OAuth token for posting messages, opening conversations, etc. |
| `CHANNEL_ID` | Default Slack channel for posts that don’t specify another channel. |
| `SLACK_CLIENT_ID` | For OpenID login flow. |
| `SLACK_CLIENT_SECRET` | For OpenID token exchange. |
| `LOGIN_REDIRECT_URL` | Registered redirect URI for Slack OAuth/OpenID (must match `/connect` route usage). |
| `UNDER_DEV` | If set to `true`, slash commands reply with a “under development” message instead of running commands. |

## Useful Rake tasks

| Task | Description |
|------|-------------|
| `rake run` | Start the Sinatra app (same idea as `rackup`). |
| `rake console` | Pry console with DML scripts loaded. |
| `rake display_rank_in_channel` | Post current Elo ranking to the configured channel (see task in `Rakefile`). |
| `rake update_players` | Sync player metadata from Slack (`Task::UpdatePlayersFromSlack`). |
| `rake new_season` | Season rollover logic. |
| `rake set_inactive_players` | Mark players inactive when appropriate. |
| `rake delete_game[game_id]` | Remove a game by id. |

## Tests

```bash
RACK_ENV=test rake db:test:prepare   # if needed
bundle exec rspec
```

## License

MIT (see `package.json`).

---

*Not affiliated with Nintendo. “Mario Kart” is a trademark of Nintendo.*
