---
type: Decision
title: Reservation storage
description: Intended SQLite write serialization and backup design.
tags: [sqlite, storage, booking]
timestamp: 2026-10-23T00:00:00Z
---

# Reservation storage

The intended design uses SQLite in WAL mode on a persistent volume, with overlap checks and saves
serialized in `BEGIN IMMEDIATE` transactions. SQLite-safe backups and tested restore are required;
this describes a design, not deployed infrastructure. See `docs/PRD.md` and
`docs/adr/0003-sqlite-overlap-control.md`.
