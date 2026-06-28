# Kiosk Quest

Kiosk Quest is a Ruby on Rails API-only take-home exercise for a kiosk order service.

## API Documentation

This repository uses a lightweight OpenAPI document and a tiny static docs page as the source of truth for API docs.

- OpenAPI spec: [`public/openapi.yml`](./public/openapi.yml)
- Docs page: [`/docs/`](./public/docs/index.html)

Use those docs whenever the request or response shape changes, and keep them in sync with the endpoint implementation.

## Version Management

This repo uses [`.tool-versions`](./.tool-versions) as the source of truth for language versions.

Current pinned versions:

- Ruby `3.4.9`

You can install the pinned languages with either `mise` or `asdf`:

- `mise install`
- `asdf install`

Both tools understand `.tool-versions`, so they can install and switch languages like Ruby or Node automatically when you are in this repo.

If you use `mise`, make sure your shell is activated so the shims are on your path:

```bash
eval "$(mise activate zsh)"
```

## Running the App

`bin/setup` installs dependencies, prepares the database (creating it, loading the schema, and seeding it on first run), and starts the server:

```bash
bin/setup
```

If you just want to set up the app without starting the server, pass `--skip-server`:

```bash
bin/setup --skip-server
```

This app is configured as API-only, so it uses `ActionController::API` and skips browser-focused Rails features by default.

## Running Tests

```bash
bundle exec rspec
```

This repository uses RSpec for testing.

## Notes

- `mise.toml` mirrors the Ruby pin for `mise` users.
- `.tool-versions` keeps the version manager setup compatible with `asdf`.
