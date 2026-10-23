# Serialize booking conflict checks in SQLite

The intended design stores bookings in SQLite on a persistent volume in WAL mode and checks
half-open interval overlap inside a `BEGIN IMMEDIATE` write transaction. A single serialized writer
makes the check-and-save atomic while keeping deployment simple; a separate database service is
rejected for this single-bus workload. Backups and restores must use SQLite-safe procedures.
