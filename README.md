# Juicer App

A Ruby on Rails application featuring an interactive **Zumex Versatile Basic** commercial citrus juicer simulator and a product catalog. Built from the [juicer-demo](juicer-demo) domain model and visual spec.

## Features

- **Simulator** Power on/off, load oranges, juice in batches, empty jug, safety shutdown (motor seizure), reset. Session-backed state so your juicer persists across requests.
- **Product catalog** Browse the Zumex Versatile Basic product (spec, dimensions, price, features). Seeded from the juicer-demo spec.
- **Stack** Rails 8, Tailwind CSS, Stimulus, Turbo, SQLite. Session stored in cache to avoid cookie overflow with large feeder state.

## Prerequisites

- **Ruby** 3.x (3.4 recommended)
- **Bundler** (`gem install bundler`)

No Node/npm required; Tailwind is provided by the `tailwindcss-rails` gem.

## Setup

**Mac / Linux:**

```bash
bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed                    # optional
bin/rails tailwindcss:build           # required before first run
```

**Windows (PowerShell or CMD):** use the `.cmd` wrappers:

```cmd
bundle install
.\bin\rails.cmd db:create
.\bin\rails.cmd db:migrate
.\bin\rails.cmd db:seed
.\bin\rails.cmd tailwindcss:build
```

## Running the app

**Mac / Linux:** Rails server + Tailwind watch in one command:

```bash
bin/dev
```
### If permissions issue run this on root of application: chmod +x bin/dev

**Windows:** opens Rails in this window and Tailwind watch in a new window:

```cmd
.\bin\dev.cmd
```

Then open [http://localhost:3000](http://localhost:3000).

**Or run manually in two terminals (any OS):**

```bash
# Terminal 1
bin/rails server          # Mac/Linux
.\bin\rails.cmd server    # Windows

# Terminal 2
bin/rails tailwindcss:watch
.\bin\rails.cmd tailwindcss:watch   # Windows
```

## Tests

**Mac / Linux:** `bin/rails test`
**Windows:** `.\bin\rails.cmd test`

## Project structure

| Area | Description |
|------|-------------|
| `lib/zumex/` | Domain model: `VersatileBasic`, `Feeder`, `PeelBucket`, `Fruit`, `Dimensions`. Used by the simulator and restorable from session. |
| `app/controllers/simulator_controller.rb` | Simulator actions (power, load, juice, empty jug, reset, safety). |
| `app/controllers/products_controller.rb` | Catalog: index and show. |
| `app/views/simulator/` | Simulator UI (Tailwind). |
| `app/views/products/` | Catalog list and product detail. |
| `config/routes.rb` | Root ? simulator; `/catalog` for products. |

## Configuration

- **Session** ? Stored in the cache (`config.session_store :cache_store`) so large simulator state doesn't overflow the cookie.
- **Database** SQLite (development/test). Production can use the same or another adapter per `config/database.yml`.

## Deployment

For production, run migrations and precompile assets (`bin/rails assets:precompile`; Tailwind is built as part of that). Deploy the app to any host that supports Rails (e.g. a VPS, PaaS, or your own server).

## License

MIT. Product information ? Juicers.co.uk / Zumex.
