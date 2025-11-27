INSERT INTO venue_types (venueType_id, name, description, minCapacity, maxCapacity, area)
VALUES
  (UUID_TO_BIN('12121212-1212-1212-1212-121212121212'), 'Conference Hall', 'Large conference hall suitable for corporate events and conferences.', 50, 500, 450.0),
  (UUID_TO_BIN('13131313-1313-1313-1313-131313131313'), 'Banquet Hall',    'Elegant banquet hall for weddings, parties and large gatherings.', 80, 600, 520.5),
  (UUID_TO_BIN('14141414-1414-1414-1414-141414141414'), 'Meeting Room',    'Small to medium meeting rooms for workshops and business meetings.', 4, 40, 45.0),
  (UUID_TO_BIN('15151515-1515-1515-1515-151515151515'), 'Studio',          'Flexible studio spaces for classes, photography, or rehearsals.', 5, 60, 80.0),
  (UUID_TO_BIN('16161616-1616-1616-1616-161616161616'), 'Outdoor Venue',   'Open-air spaces suitable for parties, markets or rooftop events.', 20, 400, 600.0);
