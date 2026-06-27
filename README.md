# Kiosk Quest

Kiosk Quest is a Ruby on Rails API-only take-home exercise for a kiosk order service.

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

Install dependencies, then start the app:

```bash
bundle install
bin/rails server
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
