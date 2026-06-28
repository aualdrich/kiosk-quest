# Kiosk Quest

Kiosk Quest is a Ruby on Rails app designed to simulate a restauraunt order API endpoint.

## Getting Started

### Setting up Ruby

This repo uses [`.tool-versions`](./.tool-versions) as the source of truth for language versions.

Current pinned versions:

- Ruby `3.4.9`

You can install the pinned languages with either [`mise`](https://mise.jdx.dev/) or [`asdf`](https://asdf-vm.com/):

- `mise install`
- `asdf install`

Both tools understand `.tool-versions`, so they can install and switch languages like Ruby or Node automatically when you are in this repo.

If you use `mise`, make sure your shell is activated so the shims are on your path:

```bash
eval "$(mise activate zsh)"
```

### Installing Dependencies & Database

To install dependencies, prepare the database (creating it, loading the schema, and seeding it on first run), 
and start the server, run:

`bin/setup`

### Running the Server

`bin/dev`

## Running Tests

This is an app that could be used by potentially tens of thousands of kiosks.
It is vital that all functionality is covered by tests (unit and request specs).

We use Rspec for testing.

To run tests:

```bash
bundle exec rspec
```

## API Documentation

To view the API docs, boot up the app then visit [/docs](http://localhost:3000/docs).

- OpenAPI spec: [`public/openapi.yml`](./public/openapi.yml)
- Docs page: [`/docs/`](./public/docs/index.html)

Use those docs whenever the request or response shape changes, and keep them in sync with the endpoint implementation.
