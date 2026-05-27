---
name: terraform
description: Use when writing, reviewing, or planning Terraform infrastructure code. Covers project structure (env/modules layout), module design, variable conventions, state management, provider configuration, and IaC best practices.
license: MIT
compatibility: opencode
---

## Usage

Review this skill before writing or modifying any Terraform code.
If the current project already has established patterns, follow those and raise conflicts.

## Project structure

- Use a top-level `infra/` (or `terraform/`) directory containing `env/` and `modules/`:

```
infra/
    env/
        dev/
            backend.tf
            provider.tf
            main.tf
            variables.tf
            outputs.tf
        prod/
        test/
    modules/
        networking/
            main.tf
            variables.tf
            outputs.tf
            provider.tf
        cluster/
        database/
```

- One directory per environment under `env/` — each is a root module.
- Reusable child modules live under `modules/`, referenced by relative path from env root modules.
- No workspaces for environment separation — use directory-per-environment.

## Module design

- Every module has at minimum: `main.tf`, `variables.tf`, `outputs.tf`.
- Add `provider.tf` with `required_version` and `required_providers` in each module.
- Modules should be self-contained and reusable across environments.
- Keep modules focused — one logical concern per module (e.g. networking, cluster, database).
- Use relative source paths for internal modules: `source = "../../modules/networking"`.

## Variable conventions

- All variables must have `type` and `description`.
- Use `snake_case` for all naming (enforced by tflint `terraform_naming_convention`).
- All outputs must have `description`.
- Provide sensible defaults in variable definitions where appropriate.
- Use a `.tfvars` file for environment-specific values (not committed for sensitive values).
- Prefer environment variables for secrets in CI/CD.

## State management

- Use remote state backends (e.g. GCS, S3) — one state file per environment.
- Enable state locking.
- Use `data.terraform_remote_state` when one environment needs to reference another's outputs.
- Never store state locally in production.

## Provider configuration

- Declare providers in each env's `provider.tf`.
- Apply default labels/tags to all resources (e.g. `environment`, `managed_by`, `project`).
- Pin provider versions with pessimistic constraint (e.g. `~> 6.0`).
- Pin Terraform version with minimum constraint (e.g. `>= 1.5`).

## Resource conventions

- Enable deletion protection by default for stateful resources; override in dev only.
- Use explicit `depends_on` when implicit dependency ordering is insufficient (e.g. API enablement).
- Name resources descriptively — the resource name should convey its purpose without reading the config.

## Code quality

- Use `terraform fmt` for formatting.
- Use `terraform validate` for syntax checking.
- Use `tflint` with appropriate rules (naming conventions, variable/output descriptions, pinned module sources).
- Use `terraform-docs` to auto-generate module documentation.
- Run these checks via pre-commit hooks.

## Security

- No secrets in `.tf` files or committed `.tfvars`.
- Use IAM and workload identity federation for CI/CD authentication — no long-lived service account keys.
- Follow least-privilege for IAM bindings.
- Separate sensitive outputs with `sensitive = true`.
