---
type: Decision
title: Booking intervals
description: Half-open reservation intervals and local end-of-day semantics.
tags: [booking, intervals, time]
timestamp: 2026-10-23T00:00:00Z
---

# Booking intervals

Bookings occupy half-open intervals: exact end-to-start adjacency is allowed. An all-day, open-end,
or explicit 23:59 end reaches exclusive local midnight on the next day; ambiguous or nonexistent
explicit local times are rejected. See `docs/PRD.md`.
