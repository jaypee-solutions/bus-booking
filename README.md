# Bus Booking

Bus Booking is a Python package.

## Development

This project uses [uv](https://docs.astral.sh/uv/) for environments and dependencies. Run every
command through it — never a bare `python`, `pytest` or `ruff`.

```bash
uv sync                      # install dependencies and create .venv
uv run pytest --cov          # tests, behind a 100% branch coverage gate
uv run ruff format           # format
uv run ruff check --fix      # lint
uv run pyright               # type check
./scripts/run-all-checks.sh  # all of the above, in order
```

Git hooks are installed at generation time; `pre-commit run --all-files --hook-stage manual` runs
them on demand.

## Releasing

Pushing a tag triggers `.github/workflows/release.yaml`, which creates a GitHub release with
generated notes and publishes to PyPI with `uv build` / `uv publish`.

Publishing uses [PyPI Trusted Publishing](https://docs.pypi.org/trusted-publishers/), so no API
token is stored in this repository. Before the first release, configure it once:

1. On PyPI, add a trusted publisher for the project: owner `jaypee-solutions`, repository
   `bus_booking`, workflow `release.yaml`, environment `pypi`.
2. In this repository's settings, create an environment named `pypi`.

Until that is done the `publish` job will fail while the GitHub release still succeeds.

## Agent instructions

Conventions for coding agents live in [AGENTS.md](AGENTS.md). Every tool-specific file
(`CLAUDE.md`, `.github/copilot-instructions.md`, `.cursor/rules/`, `.windsurfrules`,
`.clinerules`, `.junie/guidelines.md`) is a stub pointing at it.

`.okf/` holds an [Open Knowledge Format](https://github.com/open-knowledge-format) knowledge
bundle — durable project knowledge in markdown that both humans and agents read. Start at
`.okf/index.md`.

## Template updates

Generated from
[jaypee-solutions/python-template](https://github.com/jaypee-solutions/python-template) and tracked
via `.copier-answers.yml`. Pull later template improvements with:

```bash
uvx copier update --trust
```
