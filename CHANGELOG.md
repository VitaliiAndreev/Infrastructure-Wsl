# Changelog

All notable changes to `Infrastructure.Wsl` are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

Add entries under `[Unreleased]` as changes merge; at release the
`[Unreleased]` heading is promoted to the new version + date and a fresh
`[Unreleased]` is opened above it. Changes prior to 0.1.0 live in the git
history and the tag list.

## [Unreleased]

## [0.1.0] - 2026-06-12

### Added
- Baseline changelog. This section pins the current released surface so the
  release pipeline's changelog gate and GitHub Release have notes to anchor
  on; earlier history remains in the git log and tag list.

### Notes
- Public surface: `Assert-Wsl2Ready`, `Assert-WslHasBash`,
  `Invoke-WslShell` - WSL2 readiness assertions and a shell-invocation
  wrapper over `wsl.exe`, consumed by the other infrastructure repos.

[Unreleased]: https://github.com/VitaliiAndreev/Infrastructure-Wsl/compare/0.1.0...HEAD
[0.1.0]: https://github.com/VitaliiAndreev/Infrastructure-Wsl/releases/tag/0.1.0
