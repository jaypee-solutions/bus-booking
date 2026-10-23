# AGENTS.md

Instructions for any coding agent working on this repository.

Tool-specific files (`CLAUDE.md`, `.github/copilot-instructions.md`, `.cursor/rules/agents.mdc`,
`.windsurfrules`, `.clinerules`, `.junie/guidelines.md`) are stubs that point here. This file is
the only source of truth — never duplicate its content into them.

## Project

`bus_booking` — Bus Booking is a Python package.

```text
src/bus_booking/     application code
tests/                     pytest suite, mirroring the src layout
scripts/                   development and maintenance utilities
.okf/                      knowledge bundle (see below)
```



## Commands

Always use `uv`. Never invoke bare `python`, `pytest`, `ruff` or `pyright`, never
`.venv/bin/python`, and never `pip`, `poetry` or `pdm`.

```bash
uv sync                              # install and sync dependencies
uv run pytest --cov                  # run tests with the coverage gate
uv run ruff format                   # format
uv run ruff check --fix              # lint and auto-fix
uv run pyright                       # type check
./scripts/run-all-checks.sh          # all of the above, in order
```

Run the relevant checks before declaring a task complete, and explicitly report any check you
could not run.

## Code conventions

- **Quotes**: single (`'string'`), enforced by the ruff formatter.
- **Line length**: 120 characters.
- **Python**: 3.14+. Use modern syntax — built-in generics, `X | None`, `match` where it
  reads better than a chain of `elif`.
- **Type annotations**: complete, on every function signature. The package ships `py.typed`, so
  its annotations are part of its public contract.
- **Imports**: `from collections.abc import Callable`, not `typing.Callable`. Ruff's isort rules
  put one blank line between import groups.
- **No commented-out code** — ruff's `ERA` rules reject it. Delete it; git remembers.
- **Logging**: use `logging.getLogger(__name__)` with lazy `%s` formatting, never f-strings in log
  calls (ruff `G` rules).
- **Private access**: `SLF001` forbids reaching into other objects' privates in `src/`; it is
  allowed in `tests/`.

## Testing

100% branch coverage is a hard gate (`fail_under = 100`). Use `# pragma: no cover` sparingly and
only for genuinely unreachable code.

### Style

- **Write tests as functions, not classes.** This is Python, not JUnit. Use
  `def test__something():`, not `class TestSomething:`. Test classes are justified only by
  substantial shared fixture setup.
- **Naming**: `test__<subject>__<method>[__<intention>]`, with the subject in snake_case. Add the
  intention suffix only when several tests cover the same method:
  - `test__changeset__compute` — the only test for that method
  - `test__changeset__compute__excludes_nonexistent_groups` — one of several scenarios
- **No Arrange/Act/Assert comments.** Structure and naming should carry that. Comments explaining
  non-obvious behaviour, simulation or verification are still welcome.
- **Assert on return values directly**: `assert func() is False`, not `result = func()` followed by
  `assert result is False`. Keep an intermediate only when the value is reused or the expression is
  genuinely hard to read.
- **Compare whole objects**: `assert result == SomeClass(arg1='value', arg2=42)` rather than
  asserting attribute by attribute.
- **Do not assert length and then assert exact equality.** `assert items == [1, 2, 3]` already
  proves the length. Keep a length assertion only when it stands alone or precedes partial checks.
- **Do not test framework behaviour.** Constructing a dataclass or Pydantic model, setting its
  fields, and inheritance all work by definition. Test custom methods, validators and business
  logic only.

### Parametrization

Prefer `@pytest.mark.parametrize` over near-duplicate test bodies. Use parameter names that say
what varies (`('user_by_mail', 'should_raise_error')`, not `('input', 'expected')`), and put the
comment explaining a case on its own line *before* the tuple:

```python
@pytest.mark.parametrize(
    ('raw_amount', 'expected'),
    [
        # a plain decimal string parses unchanged
        ('12.34', Decimal('12.34')),
        # German formatting uses a comma as the decimal separator
        ('12,34', Decimal('12.34')),
    ],
)
def test__parse_amount(raw_amount: str, expected: Decimal) -> None:
    assert parse_amount(raw_amount) == expected
```

### Mocking

- **Import**: `from unittest import mock`. Never `import mock` or `from mock import ...`.
- **Patch by object**: `@mock.patch.object(module, 'attribute')`, not
  `@mock.patch('full.module.path.attribute')`. It is refactor-safe, IDE-navigable, and makes the
  "patch where the object is looked up" rule explicit.
- **Name mocks after what they replace**: patching `get_group_prefix` gives a parameter called
  `mock_get_group_prefix`; patching `EntraIdFacade` gives `mock_entra_id_facade`.
- **Do not mock what you do not own.** Never mock a third-party dataclass or model — instantiate
  the real thing (`ApiGroup(name='ops')`, not `mock.Mock(spec=ApiGroup)`), so the test breaks
  honestly when the library's interface changes. The same applies to your own domain types. Mock
  the *services* that supply the data, not the data.
- **Use `mock.sentinel.NAME` for values that are only passed through** and never inspected —
  in preference to both literals and `mock.Mock()`. Use sentinels inline, never assigned to a
  variable first:
  - Do: `process(mock.sentinel.CONFIG)`, then assert against `mock.sentinel.CONFIG`
  - Don't: `config = mock.sentinel.CONFIG` then `process(config)`
- **Use `mock.Mock()`** when you actually need to assert calls, configure return values or side
  effects, or read attributes back.

## Knowledge bundle

`.okf/` is an [Open Knowledge Format](https://github.com/open-knowledge-format) bundle: markdown
files with YAML frontmatter, readable by both humans and agents.

- **Read `.okf/index.md` first** on any non-trivial task, then follow only the links relevant to
  what you are doing. Treat a broken link as knowledge not yet written, not as an error.
- **Write back what you learn.** A decision made during implementation, a gotcha that cost you an
  hour, a procedure worth repeating — capture it as a concept under `.okf/decisions/` or
  `.okf/playbooks/`, refresh the directory's `index.md`, and append a dated entry to `.okf/log.md`
  (newest first).
- Every concept file needs a non-empty `type` in its frontmatter. `index.md` and `log.md` are
  reserved names and carry no frontmatter.

Do not duplicate detailed documentation into this file — link to it from here or from the bundle.

## Commits

Conventional commits are enforced on both commit messages and PR titles. Allowed types: `feat`,
`fix`, `docs`, `test`, `ci`, `refactor`, `perf`, `chore`, `revert`.

## Documentation

Markdown lines wrap at 100 characters. Break at sentence or clause boundaries, never inside inline
code or a link. Code blocks and tables are exempt.

## Working style

For anything beyond a one-line fix:

1. Read the relevant `.okf/` concepts and the existing implementation and tests.
2. State your assumptions and any unresolved decisions — do not guess at a product choice.
3. Propose a narrow plan.
4. Implement the smallest coherent vertical slice.
5. Add or update tests.
6. Run the quality checks.
7. Update `.okf/` and any affected documentation.
8. Summarise what changed, what you verified, and what remains.

## Template updates

This project was generated from
[jaypee-solutions/python-template](https://github.com/jaypee-solutions/python-template) and tracks
it via `.copier-answers.yml`. Pull template improvements with:

```bash
uvx copier update --trust
```

Resolve any `.rej` conflict files it leaves behind; a pre-commit hook fails while they exist.
