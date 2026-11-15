# Contributing Guide

Thank you for contributing to this project.

## Development setup

Install Node.js 20 or later, then run `npm ci`.

## Commit message convention

Every commit must use Conventional Commits:

- `feat(scope): description` for new functionality
- `fix(scope): description` for bug fixes
- `docs(scope): description` for documentation
- `test(scope): description` for test changes
- `chore(scope): description` for maintenance

Use a short, descriptive, imperative message.

## Quality gates

Run `npm run lint` and `npm test` before submitting changes.

## Releases

Releases use semantic versioning. Run `npm run release` after committing
changes. The release tool updates package.json, CHANGELOG.md and Git tags.

## Pull requests

Describe the change, explain its purpose, and include test evidence.

## Release version rules

- Breaking changes increase the major version.
- Features increase the minor version.
- Fixes increase the patch version.
