---
name: api
description: Use when designing, building, or reviewing HTTP APIs and web services. Covers handler/route separation, domain modelling, request/response patterns, middleware, validation, and structuring services for reuse across CLI, MCP, and HTTP interfaces.
license: MIT
compatibility: opencode
---

## Usage

Review this skill before designing or implementing any HTTP service or API.
This is language-agnostic architecture guidance — combine with the relevant language skill (e.g. `python`, `golang`) for implementation specifics.
If the current project already has established patterns, follow those and raise conflicts.

## Core architecture

- Separate **routes** (thin wiring), **handlers** (core logic), and **models** (domain types).
- Routes map HTTP verbs and paths to handlers — nothing else. Keep them declarative and flat.
- Handlers contain the business logic. Design them as closures or functions that receive dependencies as arguments.
- Handlers should be reusable: the same logic should be callable from HTTP, CLI, or MCP tool interfaces with minimal adaptation.
- Models define domain objects, request/response schemas, and database entities — kept in a dedicated `models/` module organised by domain.

## Handler design

- Handlers receive their dependencies explicitly (constructor/closure injection) — no global state.
- Each handler has a single responsibility.
- Encode/decode logic is centralised in shared helpers, not repeated per handler.
- Validation happens at the boundary (decode step), not deep inside business logic.
- Return structured errors that the router/middleware can translate to appropriate HTTP status codes.

## Route registration

- All routes should be visible in a single location (e.g. `routes.go`, `routes/` module, or a router factory).
- Group routes logically by domain or feature.
- Middleware is applied declaratively alongside route definitions so the full request lifecycle is visible in one place.

## Domain modelling

- Separate API models (request/response schemas) from database models.
- Co-locate related models by domain (e.g. `models/library.py` holds both API and DB models for the library domain).
- Use explicit types for request/response bodies — avoid raw dicts or untyped maps.
- Validate at the boundary; trust validated types internally.

## Middleware

- Use the adapter/wrapper pattern: middleware wraps a handler and returns a new handler.
- Order middleware deliberately (e.g. recover -> tracing -> logging -> auth -> rate-limit).
- Keep middleware small and composable.
- Top-level concerns (CORS, auth, logging, tracing) apply globally; domain-specific middleware applies per route group.

## Error handling

- Define a consistent error response shape across the API (e.g. `{"error": "message", "code": "ENUM"}`).
- Map domain errors to HTTP status codes in one place (middleware or a response helper).
- Never leak internal details (stack traces, SQL errors) in production responses.
- Use appropriate status codes: 400 for validation, 401/403 for auth, 404 for not found, 409 for conflicts, 500 for unexpected failures.

## Testing

- Prefer end-to-end tests that hit the full HTTP stack (routes + middleware + handlers + real/test DB).
- Use a test server instance per test or test suite — pass dependencies explicitly.
- Test the API contract (status codes, response shapes, headers) not internal implementation.
- Include a health/readiness endpoint for startup verification in tests and production.

## API design conventions

- Use RESTful resource naming (`/api/v1/resources/{id}`).
- Version APIs in the URL path (`/api/v1/`, `/api/v2/`).
- Use plural nouns for resource collections.
- Return appropriate status codes for each operation (201 for create, 204 for delete with no body, etc.).
- Support pagination for list endpoints.
- Use consistent query parameter conventions for filtering and sorting.
