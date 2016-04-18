create table Ticket (
	event_id INTEGER,
	performance_id INTEGER,
	seat_area VARCHAR(10),
	seat_nbr CHAR(4),
	ticket_price DECIMAL(5,2) CHECK(ticket_price>=0),
	order_id INTEGER,
FOREIGN key (event_id,performance_id) REFERENCES Performance(event_id,performance_id) 
ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (order_id) REFERENCES Order_info(order_id) ON DELETE RESTRICT ON UPDATE CASCADE);

# insert attributes in Ticket table
insert into Ticket (event_id,performance_id) select event_id,performance_id from Performance;
insert into Ticket (order_id) select order_id from Order_info;

# create a column of attribute named ticket_id
alter table Ticket add column ticket_id INTEGER;
update Ticket set ticket_id = cast(random()*99999999+1 as int);

# add primary key constrain
alter table Ticket add PRIMARY KEY (ticket_id);