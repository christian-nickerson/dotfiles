---
name: python
description: Use when writing, reviewing, or planning Python code. Covers project structure (src layout), style conventions, tooling (uv, ruff, ty, pytest), preferred packages (pydantic, fastapi, httpx, loguru, dynaconf, sqlmodel, alembic), testing strategy, logging, error handling, and module design patterns.
license: MIT
compatibility: opencode
---

## Usage

Review this skill before planning or writing any Python code.
If the style conventions in the current project conflict with this guide, ask clarifying questions.
Combine with other skills, like `api`, when planning or building those type of applications.

## Development tooling

- `uv` for dependency management and managing the Python installation.
- `ruff` for both linting and formatting.
- `ty` for type checking (all code should be typed).
- Pre-commit hooks for local linting with appropriate steps for each tool.
- `pytest` for testing.

## Project structure and module design

- Use an src layout.
  - For runtime applications (target is not a package):

    ```
    src/
        module1/
            __init__.py
            ....py
            submodule1/
                __init__.py
                ....py
        module2/
            __init__.py
            ....py
        main.py
    ```

  - For packages, follow the standard src layout.
  - We allow for submodules only when it improves organisation and reduces module sprawl and spaghetification.

- Modules should be self-contained and not rely on cross imports unless absolutely necessary.
- Modules should have a clear and significant enough scope, such that we have fewer larger modules, opposed to many smaller modules, but without making a module's scope too large such that it holds too many important roles.
  - As an example, if a service requires a database and object storage IO client, these should be consolidated into a single `storage/` module and not separate `database/` and `bucket/` modules. However, extending this to a redis client for managing caching exclusively would be considered a different concept and require its own module.
- Modules should have a well-defined interface, making the code in `main.py` easy to read.
- `main.py` or other runtime files should manage orchestration, module wiring, and runtime concerns, and not contain application logic.
- No `util` or `helper` files/modules — name them appropriately and place them within a relevant module.

## Code style

- Start simple. Escalate to complexity only when requirements demand it.
- Optimise for simplicity, readability, and composition.
- Function and method scope should be singular where possible.
- Do not splinter logic into many micro-files or micro-functions. Keep cohesive logic together.
- Do not create artificial parameter bundles (single-use dataclasses or dicts to pass arguments). Pass explicit parameters directly.
- Do not create redundant protocol mirrors. Use `typing.Protocol` only when multiple concrete implementations exist or for external boundary testing.
- Remove pure pass-through wrappers that only delegate calls without adding behavior or transformation.
- Adopt common design patterns where appropriate (dependency injection, facades, builder, adapter, etc.).
- Functions, classes, and modules should be appropriately generic without over-engineering.
- Prefer enums and Python objects over global variables and literal strings.
- Use generics when a type parameter spans 2–3+ concrete types.
- Do not mix data objects and compute objects.
- Do not use `*args` or `**kwargs` in place of named keyword arguments.
- Use full names for Python objects (no abbreviations) and PEP 8 naming conventions.

## Runtime services vs packages

- **Runtime services** (applications):
  - Minimise private methods (`_method`). Rely on top-level module composition and linear flow.
  - Use strict, opinionated arguments. Avoid optional arguments (`arg: T | None = None`) and default fallbacks.
  - Eliminate defensive runtime argument validation in internal functions. Rely on boundary schema validation (Pydantic) and type annotations.
- **Packages** (libraries / shared dependencies):
  - Encapsulate internal implementation details.
  - Expose a minimal public API surface with boundary validation.

## Docstrings and comments

- Do not use module docstrings.
- Use the Sphinx docstring format (no types in docstring — types live in annotations):

  ```python
  def some_function(arg_one: str, arg_two: int) -> tuple[str, int]:
      """Short description of what some_function does.

      :param arg_one: Short description for arg one.
      :param arg_two: Short description for arg two.
      :return: Description one, description two.
      """
      return arg_one, arg_two
  ```

- All functions, methods, and classes must have docstrings, updated when code changes.
- Code comments should be kept to a minimum.

## Configuration

- Use `dynaconf` for config management.
- Use validators to validate relevant settings at runtime (not so strict that they cause edge-case failures).
- Use `settings.toml` for local and default values only (default values should also appear in validators).
- Prefer environment variables for deployment configuration.

## Data and dataclass objects

- Use `pydantic` for data and dataclass objects to enable runtime validation.
- Prefer data objects over raw dicts, unless leveraging hash-map index speed is important.

## Databases and ORMs

- Prefer an ORM like `sqlmodel` when working with databases.
- Separate the database engine and runtime functionality from models into different modules (database models often live in a domain-oriented models module alongside API models).
- Use generic methods in the database engine module to run queries; separate query statement creation from execution.
- Use `alembic` for database migrations.

## Async

- Only introduce an async runtime when there is a clear reason (known performance requirements or avoiding significant future tech debt).
- Do not build async for the sake of async.

## Testing strategy

- Write tests that cover critical functionality; do not aim for unit tests on every function.
- Target public functions, methods, or API routes/handlers to maximise coverage per test.
- Test expected behaviours, exceptions, and occasionally edge cases.
- Use fixtures to define test cases; tests iterate over expected inputs and outputs.
- When patching a bug, introduce a new test covering that case to prevent regression.
- Minimise mocking — prefer realistic substitutes (e.g. `moto` for AWS) over artificially inflating coverage with mocks.

## Logging and exceptions

- Use structured logging when appropriate (e.g. deploying to k8s and deriving metrics from logs); otherwise use standard logging.
- Log at the highest reasonable level of the stack, ideally near the orchestration layer — not scattered throughout.
- In modules, prefer raising exceptions over handling them internally; let exceptions propagate up the stack to be logged.
- Do not write defensive boilerplate for unproven edge cases.
- Avoid fallback ladders (chained speculative recovery logic).
- Avoid nested `try...except` blocks.
- Do not create custom exception wrappers around library or standard errors. Let native exceptions propagate to top-level handlers or middleware.
- Catch specific exceptions only.

## Common packages

- `httpx` for HTTP requests.
- `loguru` for logging.
- `fastapi` for API frameworks.
