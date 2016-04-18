create table Event (
	event_id INTEGER NOT NULL,
	event_name VARCHAR(225),
	event_desc VARCHAR(225),
	event_rating VARCHAR(225),
	nbr_raters DECIMAL(5,2) CHECK(nbr_raters>0),
PRIMARY KEY (event_id));

#copy event-detials.dat
create table eventdetail (
	event_name VARCHAR(225),
	event_desc VARCHAR(225),
	event_rating1 VARCHAR(225),
	event_desc2 VARCHAR(225),
	venue_name VARCHAR(225),
	city_state VARCHAR(225),
	event_date VARCHAR(225),
	event_time VARCHAR(225),
	event_type VARCHAR(225),
	event_status VARCHAR(225),
	total_ticket VARCHAR(225),
	min_price VARCHAR(40),
	max_price VARCHAR(40));

scp -r /Users/xiuliwang/Desktop/project2Data/event-details.dat xw148@cs-class.uis.georgetown.edu:/home/xw148/project2
\copy eventdetail from /home/xw148/project2/event-details.dat with delimiter '|'

# capitalize event_name
update eventdetail set event_name = INITCAP(event_name);

#delete duplicate event which has same name,event_date,event_time (no row deleted here)
delete from eventdetail where exists (select event_name,event_date,event_time,count(*) 
	from eventdetail group by event_name,event_date,event_time having count(*)>1);

# combine event_desc and event_description together
alter table eventdetail add column event_description VARCHAR(225);
update eventdetail set event_description = event_desc || event_desc2;
alter table eventdetail drop column event_desc;
alter table eventdetail drop column event_desc2;

# change event_rating to decimal format
alter table eventdetail add column event_rating VARCHAR(5);
update eventdetail set event_rating = substring(event_rating1,1,3);
### update eventdetail set event_rating = cast(event_rating as DECIMAL(2,1));

# add new column nbr_raters
alter table eventdetail add column nbr_raters VARCHAR(20);
UPDATE eventdetail set nbr_raters = 
substring(event_rating1,position('(' in event_rating1),position(')'in event_rating1));
update eventdetail set nbr_raters = TRIM(nbr_raters,'()');
###  update eventdetail set nbr_raters = cast(nbr_raters as int);

# uppercaser all the letter in event_type
update eventdetail set event_type = UPPER(event_type);


# create a column of random number as event event_id
alter table eventdetail add column event_id int;
update eventdetail set event_id = cast(random()*999999+1 as int);

insert into Event (event_id,event_name,event_desc,event_rating) select
	event_id,event_name,event_description,event_rating from eventdetail;