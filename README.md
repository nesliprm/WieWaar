# WieWaar Kempen

A view-only dashboard that shows where everyone at Kempen Automatisering is right
now: at the office, working from home, in a meeting, at a client, at a private
appointment or away. It also shows who is on Ticketdienst today.
The board is meant for a large office TV and also works on a laptop or phone.

Nobody enters anything in the app. The data will come from Google
Calendar. That sync is not built yet, so for now the board runs on seed and demo data.

## Stack

- Ruby 4.0.7, Rails 8.1
- PostgreSQL
- Hotwire (Turbo + Stimulus), importmap
- Bootstrap 5.3 via dartsass-rails, Kempen colours in `app/assets/stylesheets/application.scss`
- Solid Queue / Solid Cache / Solid Cable
- Deploy with Kamal (not set up yet)

## Getting started

Requirements: Ruby 4.0.7 and a running PostgreSQL (locally e.g. Homebrew `postgresql@17`).

```bash
bin/setup        # installs gems, prepares the database and starts the server
```

Or step by step:

```bash
bundle install
bin/rails db:prepare   # creates wie_waar_development and runs the migrations
bin/rails db:seed      # the team (11 colleagues) and a day of sample events
bin/dev                # Rails server + Sass watcher, see Procfile.dev
```

Open http://localhost:3000. The board is the root page.

## Demo scenarios

`bin/rails demo:day` fills today's board with demo data. Times are relative to
the current hour, so "tot …" and "terug om …" always make sense. The task first
clears today's events and Ticketdienst rows, so you can switch freely between
scenarios. It only works in development.

| Command | Scenario | What it shows |
|---|---|---|
| `bin/rails demo:day` | **normaal** | A mixed day: 2 at home, 2 in a meeting, 1 at a client, 1 on holiday, 1 sick, the rest at the office |
| `SCENARIO=thuisdag bin/rails demo:day` | **thuisdag** | 8 people working from home (a long "Werkt thuis" card). Both people on Ticketdienst are at home, so the "Niemand beschikbaar" warning appears |
| `SCENARIO=vergaderdag bin/rails demo:day` | **vergaderdag** | 7 people in one meeting (long "In overleg" and "Op kantoor" cards), 2 at a client, 1 private appointment, 1 sick |

The scenarios live in `lib/tasks/demo.rake`. Each one has a list of
`"Name" => [status, from, to]` entries (hours relative to now; `nil, nil` means
all day) and the names on Ticketdienst. Everyone not listed shows as "Op kantoor".

## How the board works

- **Statuses** (`CalEvent`): kantoor, thuis, bij_klant, prive, overleg, afwezig,
  vakantie, ziek. For privacy, ziek shows as plain "Afwezig"; vakantie shows
  "Vakantie".
- **Zones**: `Employee.statuses_for(events)` turns someone's current events into
  the zones they appear in. Afwezig, ziek, vakantie, prive and bij_klant each put
  someone in a single zone. Everyone else is at the office or at home, plus
  "In overleg" when they're in a meeting, so people in a meeting show in two zones.
- **Ticketdienst**: two people per day. The warning shows when nobody on duty is
  available at the office.
- **Refresh**: the board reloads itself every 60 seconds (Stimulus
  `refresh_controller.js`, Turbo morph).
- **Avatars**: transparent PNGs in `app/assets/images/avatars/`, named after the
  first name in lowercase without hyphens (`Willem-Jan` → `willemjan.png`). Without an image the board shows
  the person's initials (`employees.initials`). The circle behind the avatar takes
  the zone colour.
- Only who, when and status are stored, never event titles.

## Tests

```bash
bin/rails test
```

CI (GitHub Actions, `.github/workflows/ci.yml`) runs Brakeman, bundler-audit,
importmap audit, RuboCop and the tests.

## Still to do

- Tests for `Employee.statuses_for`
- Google Calendar sync (service account with domain-wide delegation, push
  notifications + sync tokens, rules plus AI to tell client visits from private
  appointments)
- Working hours (09:00–17:00) for the default "Op kantoor" status
- Week view
- TV/kiosk mode
- Deploy with Kamal
