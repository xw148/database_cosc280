create table Venue (
	venue_id SERIAL PRIMARY KEY,
	venue_name VARCHAR(225),
	venue_street_address VARCHAR(225),
	venue_city VARCHAR(20),
	venue_state VARCHAR(20),
	venue_zip INTEGER,
	venue_type VARCHAR(20));

# insert attributes into Venue table
insert into Venue (venue_name) select venue_name from joinevent;

