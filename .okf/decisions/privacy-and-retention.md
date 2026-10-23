---
type: Decision
title: Privacy and retention
description: Retention, erasure and backup reconciliation for booking data.
tags: [privacy, retention, erasure]
timestamp: 2026-10-23T00:00:00Z
---

# Privacy and retention

Booking-linked personal data and matching audit identifiers are scrubbed three years after
scheduled trip end; a distinct erasure path cancels future bookings and scrubs retained personal
details sooner. Backups rotate for at most 30 days, and erasures are reconciled before restored data
is served. See `docs/PRD.md` and `docs/adr/0004-retention-and-erasure.md`.
