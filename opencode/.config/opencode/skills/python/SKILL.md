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
      module2/
          __init__.py
          ....py
      main.py
  ```

  - For packages, follow the standard src layout.
- Modules should be self-contained where possible, not relying on other modules unless avoiding significant duplication.
- Modules should have a well-defined interface, making the code in `main.py` easy to read.
- `main.py` performs orchestration, runtime management, and IO — it should not contain module logic.
- No `util` or `helper` files/modules — name them appropriately and place them within a relevant module.

## Code style

- Optimise for simplicity, readability, and composition.
- Function and method scope should be singular where possible.
- Adopt common design patterns where appropriate (dependency injection, facades, builder, adapter, etc.).
- Functions, classes, and modules should be appropriately generic without over-engineering.
- Prefer enums and Python objects over global variables and literal strings.
- Use generics when a type parameter spans 2–3+ concrete types.
- Do not mix data objects and compute objects.
- Do not use `*args` or `**kwargs` in place of named keyword arguments.
- Use full names for Python objects (no abbreviations) and PEP 8 naming conventions.

## Docstrings and comments

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
- Comments should be used sparingly (only when code is not self-documenting) and kept brief.

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
- Use custom exceptions where meaningful; only use standard exceptions when truly appropriate.
- Catch specific exceptions only.

## Common packages

- `httpx` for HTTP requests.
- `loguru` for logging.
- `fastapi` for API frameworks.
