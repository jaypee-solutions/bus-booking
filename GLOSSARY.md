# Bus Booking

A shared booking context for reserving the TSV Blaichach Sportbus and communicating its
availability.

## People and reservations

**Booking**:
A reservation of a time interval for the Sportbus, associated with one Nutzergruppe and optionally
a booker and driver.
_Avoid_: Trip (when referring to the reservation record)

**Booker**:
The person who owns and manages a booking through their authenticated booker identity; the booker
may reserve the Sportbus for someone else to drive.
_Avoid_: Driver, registrar

**Driver**:
The person named to drive the Sportbus for a booking; the driver is distinct from the booking
owner and need not be an enabled booker.
_Avoid_: Booker

## Organization and vehicle

**Booking group**:
A curated group representing a TSV section or an approved outside organization, assigned to each
new booking; the German UI term is **Nutzergruppe**. School, municipality and youth house are
Nutzergruppen, not TSV departments.
_Avoid_: Department, Abteilung

**Sportbus**:
The TSV Blaichach club bus managed by the first release of Bus Booking.
_Avoid_: Kreisjugendring bus (informational fallback only)
