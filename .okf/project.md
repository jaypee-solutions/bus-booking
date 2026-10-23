---
type: Project
title: Bus Booking
description: Standalone web application for reserving the TSV Blaichach Sportbus.
resource: https://github.com/jaypee-solutions/bus_booking
tags: [python]
timestamp: 2026-10-23T00:00:00Z
---

# Overview

Bus Booking replaces the bus reservation module of the in-house CMS of TSV Blaichach with a
standalone German-language web application. Administrators use named Authentik accounts; bookers
authenticate with one-time email links. The reviewed requirements are in [the PRD](../docs/PRD.md);
the behaviour of the old module is analysed in [legacy bus module](legacy-bus-module.md).

# Status

The PRD is reviewed; launch prerequisites remain outstanding. The code is still the generated
template; nothing is implemented.

# Sources of truth (not duplicated here)

- `AGENTS.md` — agent operating rules for this repository; read this first
- `README.md` — what the project is and how to run it

# Citations

[1] [Bus Booking repository](https://github.com/jaypee-solutions/bus_booking)
