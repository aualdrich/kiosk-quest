# Agent Notes

## Versioning
- We use either asdf or mise for tool versions.

## Testing
- This repository uses `rspec` for testing.
- It is vital that you maintain a passing test suite at all times and that you write tests for all functionality.

## Best Practices
- Prefer service objects to drive application logic. Name them with noun phrases instead of active verbs, such as `OrderPlacement` rather than `PlaceOrder`.
- Service objects typically have a `Result` object and a `call` method. Look at some examples before making one.
- Keep controllers thin by avoiding direct business logic; delegate that work to service objects.
- Keep the API documentation up to date whenever endpoint behavior changes. Update `public/openapi.yml` and the `/docs` page alongside any request/response changes.
