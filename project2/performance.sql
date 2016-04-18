create table Performance (
	event_id INTEGER NOT NULL,
	performance_id SERIAL NOT NULL,
	performance_date VARCHAR(225),
	performance_time VARCHAR(225),
	venue_id INTEGER,
	nbr_seats INTEGER,
	event_status VARCHAR(225),
	purchase_limit INTEGER,
	posting_date DATE DEFAULT CURRENT_DATE,
	sale_start_date DATE DEFAULT CURRENT_DATE,
	minimum_ticket_price DECIMAL(5,2),
	maximum_ticket_price DECIMAL(5,2),
FOREIGN KEY (event_id) REFERENCES Event(event_id) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (venue_id) REFERENCES Venue(venue_id) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (event_id,performance_id));

# insert attributes into Performance table
insert into Performance (event_id, performance_date, performance_time, event_status, purchase_limit, minimum_ticket_price, maximum_ticket_price )
	select event_id, event_date,event_time,event_status, total_ticket,min_price, max_price from joinevent;
