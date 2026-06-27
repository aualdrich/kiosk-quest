# Agent Notes

- This repository uses `mise` for tool versions. Run Ruby/Bundler/RSpec commands via `mise exec -- ...`.
- This repository uses `rspec` for testing.
- Prefer service objects to drive application logic. Name them with noun phrases instead of active verbs, such as `OrderPlacement` rather than `PlaceOrder`.
- Keep controllers thin by avoiding direct business logic; delegate that work to service objects.
- Keep the API documentation up to date whenever endpoint behavior changes. Update `public/openapi.yml` and the `/docs` page alongside any request/response changes.
