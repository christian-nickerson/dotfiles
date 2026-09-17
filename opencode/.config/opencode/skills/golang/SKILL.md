---
name: golang
description: Use when writing, reviewing, or planning Go code. Covers project structure (cmd/internal/public), tooling (golangci-lint, viper, fiber), handler patterns, dependency injection via closures, testing, and the main()->run() pattern.
license: MIT
compatibility: opencode
---

## Usage

Review this skill before planning or writing any Go code.
If the current project already has established patterns, follow those and raise conflicts.
Combine with other skills, like `api`, when planning or building those type of applications.

## Development tooling

- `golangci-lint` for linting (configure via `.golangci.yml`).
- `air` for live-reload during development.
- `go test ./...` for testing.
- Pre-commit hooks for local linting.

## Project structure

- Use the `cmd/` `internal/` `public/` layout:

```
cmd/
    server/
        main.go
    migrate/
        main.go
internal/
    configs/
    storage/
    handlers/
    middleware/
    models/
    routes/
public/
    (exported packages, if any)
```

- `cmd/` contains application entry points — one sub-directory per binary.
- `internal/` contains all private application code, organised by domain/concern.
- `public/` contains any packages intended for external consumption.

## The main() -> run() pattern

- `func main()` is ultra-simple: it calls `run()` and handles the error.
- `run()` takes OS fundamentals as arguments and returns an error:

```go
func run(ctx context.Context, args []string, getenv func(string) string) error {
    ctx, cancel := signal.NotifyContext(ctx, os.Interrupt)
    defer cancel()
    // setup, start server, wait for shutdown
    return nil
}

func main() {
    ctx := context.Background()
    if err := run(ctx, os.Args, os.Getenv); err != nil {
        fmt.Fprintf(os.Stderr, "%s\n", err)
        os.Exit(1)
    }
}
```

- This makes the program fully testable — tests call `run()` with controlled inputs.

## Handler design

- Handlers are **maker functions** that return `http.Handler` (or the framework equivalent).
- Dependencies are passed as arguments to the maker function — never accessed via globals.
- The closure gives each handler its own initialisation space:

```go
func handleGetUser(logger *Logger, userStore UserStore) fiber.Handler {
    return func(c fiber.Ctx) error {
        // use logger and userStore here
    }
}
```

- Use `sync.Once` inside the closure to defer expensive setup until first call.

## Route registration

- All routes live in a single `routes.go` or `routes/` package.
- Routes are flat and declarative — the full API surface is visible in one place.
- Middleware is applied alongside route definitions.

## Configuration

- Use `viper` for config management (TOML/YAML + environment variable overlay).
- Struct-based config with explicit fields — no untyped map access.
- Environment variables use a consistent prefix (e.g. `APP_`).

## HTTP framework

- Use `fiber` (not the standard library `net/http` router) for HTTP services.
- Follow fiber's middleware and group patterns for route organisation.

## Code style

- Start simple. Escalate to complexity only when requirements demand it.
- Optimise for readability and simplicity.
- Do not splinter logic into many small files or micro-functions. Keep related domain logic cohesive.
- Do not create artificial parameter structs to bundle arguments. Pass explicit parameters unless they represent a domain entity.
- Do not mirror every struct with an interface. Define lean interfaces (1–2 methods) at the consumer site only when multiple implementations exist or for external test boundaries.
- Remove pure pass-through wrappers that only forward calls without adding behavior or transformation.
- Prefer returning errors over panicking.
- Use `context.Context` throughout and respect cancellation.
- Use generics where they reduce duplication across 2+ concrete types.
- Full names for identifiers — no abbreviations beyond well-known Go conventions (`ctx`, `err`, `req`, `resp`).
- Keep code comments to a minimum.

## Runtime services vs packages

- **Runtime services** (`cmd/`, `internal/`):
  - Minimise unexported helper methods on structs. Rely on package composition and clear linear execution.
  - Use strict, opinionated function signatures. Avoid optional parameters, variadic options, and defensive `nil` checks for internal calls. Let boundary decoders handle validation.
- **Packages** (`public/`):
  - Encapsulate internal implementation details.
  - Expose a minimal, stable exported API surface.

## Error handling

- Return errors up the stack; handle (log/respond) at the top level.
- Wrap errors with `fmt.Errorf("context: %w", err)` for traceability.
- Do not write defensive boilerplate for unproven edge cases.
- Avoid fallback ladders (chained speculative recovery logic).
- Do not create custom error types or struct wrappers that merely wrap upstream errors. Propagate errors directly to top-level handlers.
- Never ignore errors silently.

## Testing

- Prefer end-to-end tests that call `run()` with a test context and hit real endpoints.
- Use `t.Parallel()` where possible — the `run()` pattern enables this.
- Wait for readiness via a `/healthz` endpoint before sending test requests.
- Cancel the context via `t.Cleanup` to trigger graceful shutdown after each test.
- Use interfaces + test doubles (not mocks) for external dependencies.
- Test the HTTP contract (status codes, response bodies), not internal implementation.

## Graceful shutdown

- Use `signal.NotifyContext` to cancel on interrupt.
- Pass the context through all layers; check `ctx.Err()` in long-running work.
- Use `sync.WaitGroup` to wait for in-flight work to complete before exiting.

## Common packages

- `fiber` for HTTP framework.
- `viper` for configuration.
- `logrus` or `slog` for structured logging.
- `gorm` / `sqlc` for database access.
- `atlas` for database migrations.
- `testify` for test assertions (if needed beyond `testing`).
