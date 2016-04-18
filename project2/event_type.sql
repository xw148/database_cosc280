create table Event_Type (
	event_id INTEGER,
	event_type VARCHAR(20),
FOREIGN KEY (event_id) REFERENCES Event(event_id) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (event_id,event_type));

# since event type is primary key, delete null vlaue first
delete from joinevent where event_type2 is NULL;

# insert attributes into Event_Type tbale
insert into Event_Type (event_id, event_type) select event_id, event_type2 from joinevent;