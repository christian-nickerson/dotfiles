---
name: docker
description: Use when writing, reviewing, or planning Dockerfiles and container builds. Covers multi-stage builds, distroless images, security best practices, Python/Go-specific patterns, layer caching, and minimal runtime images.
license: MIT
compatibility: opencode
---

## Usage

Review this skill before writing or modifying any Dockerfile or container configuration.
If the current project already has a Dockerfile, follow its established patterns and raise conflicts.

## General principles

- Use multi-stage builds: separate builder stage(s) from a minimal runtime stage.
- Run as non-root in the final image (use `USER nonroot` or numeric UID).
- Use distroless base images for production — minimal attack surface, no shell, no package manager.
- Pin base image versions (digest or specific tag) for reproducibility.
- Order layers for maximum cache efficiency: dependencies before source code.
- Use `.dockerignore` to exclude unnecessary files from the build context.
- One process per container.

## Distroless images

- For Go: use `gcr.io/distroless/static-debian12:nonroot` (fully static binary, no libc needed).
- For Python: use a C-flavoured distroless (`gcr.io/distroless/cc-debian12:nonroot`) as the runtime base.
- Never install packages in distroless — all runtime dependencies must come from the builder stage via `COPY --from`.

## Go builds

```dockerfile
FROM golang:1.23 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/server ./cmd/server

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=builder /app/server /server
ENTRYPOINT ["/server"]
```

- Always build with `CGO_ENABLED=0` for a fully static binary.
- Use `-ldflags="-s -w"` to strip debug info and reduce binary size.
- Inject version info via `-ldflags` at build time if needed.

## Python builds

The pattern: build a uv-managed Python environment in a builder stage, then copy the entire runtime into a C distroless image (which provides the C libraries Python needs).

```dockerfile
FROM ghcr.io/astral-sh/uv:python3.12-bookworm AS builder
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project
COPY src/ ./src/
RUN uv sync --frozen --no-dev

FROM gcr.io/distroless/cc-debian12:nonroot
COPY --from=builder /usr/local/lib/python3.12 /usr/local/lib/python3.12
COPY --from=builder /usr/local/bin/python3.12 /usr/local/bin/python3.12
COPY --from=builder /app /app
WORKDIR /app
ENTRYPOINT ["/usr/local/bin/python3.12", "-m", "src.main"]
```

- Use C distroless (`cc-debian12`) because Python needs libc and other C libraries.
- Copy the Python interpreter and its lib directory from the builder — this is simpler than resolving individual shared libraries.
- Install dependencies before copying source code for better layer caching.
- Use `uv sync --frozen` to ensure lockfile-pinned dependencies.

## Layer caching

- Copy dependency manifests (`go.mod`, `pyproject.toml`, `uv.lock`) first, install, then copy source.
- Separate `RUN` instructions that change rarely from those that change often.
- Combine related `RUN` commands with `&&` to reduce layer count where caching is not a concern.

## Security

- No secrets in the image (use build-time secrets with `--mount=type=secret` if needed during build).
- Scan images with a vulnerability scanner (e.g. `trivy`, `grype`) in CI.
- Use `COPY` over `ADD` unless extracting archives.
- Set `ENTRYPOINT` with exec form (`["binary"]`) not shell form.
- Consider read-only root filesystem at runtime (`--read-only`).

## Health checks

- Include a `HEALTHCHECK` instruction or rely on orchestrator-level probes (k8s liveness/readiness).
- Point health checks at a dedicated `/healthz` endpoint.

## Labels and metadata

- Add standard OCI labels for traceability:

```dockerfile
LABEL org.opencontainers.image.source="https://github.com/org/repo"
LABEL org.opencontainers.image.revision="${GIT_SHA}"
```
