# Separate scheduled retention from privacy erasure

Booking-linked personal details and matching audit identifiers are scrubbed three years after the
scheduled trip end, while non-personal occupancy statistics remain. A data-subject erasure request
is a distinct earlier pathway that cancels future bookings and removes identity and personal
free-text from retained bookings; ordinary account deletion cannot silently erase booking history.
Backups rotate for at most 30 days and restored data must reconcile erasures before serving users.
