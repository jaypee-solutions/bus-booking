---
type: Decision
title: Launch and migration
description: Sportbus-only launch scope and explicit migration cutover gates.
tags: [launch, migration, scope]
timestamp: 2026-10-23T00:00:00Z
---

# Launch and migration

Release 1 manages the TSV Sportbus only. Migration requires reviewed identity and Nutzergruppe
mappings; unmatched bookings remain admin-managed and occupy their intervals, while unknown group
mappings and imported overlaps block cutover until explicitly resolved. The standalone launch URL
is announced directly by email. See `docs/PRD.md`.
