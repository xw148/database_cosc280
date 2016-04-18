CREATE TABLE Customer (
	username VARCHAR(225) NOT NULL, 
	customer_email VARCHAR(40) NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(40) NOT NULL,
	password VARCHAR(40) NOT NULL,
	street_address VARCHAR(255),
	city VARCHAR(40),
	state CHAR(2),
	zip_code VARCHAR(10),
	country VARCHAR(10),
PRIMARY KEY (username));

# copy user.dat
CREATE TABLE userdata(
	customer_email VARCHAR(40) NOT NULL,
	password VARCHAR(40) NOT NULL,
	email VARCHAR(40) NOT NULL,
	first_name VARCHAR(20),
	last_name VARCHAR(40),
	middle_initial VARCHAR(5));

scp -r /Users/xiuliwang/Desktop/project2Data/user.dat xw148@cs-class.uis.georgetown.edu:/home/xw148/project2
\copy userdata from /home/xw148/project2/user.dat with delimiter '|'

alter table userdata drop column email;   # drop duplicated email address here

# copy zip.dat
CREATE TABLE zipdata(
	zip1 VARCHAR(10),
	state CHAR(2),
	country VARCHAR(10) default 'USA');

scp -r /Users/xiuliwang/Desktop/project2Data/zip.dat xw148@cs-class.uis.georgetown.edu:/home/xw148/project2
\copy zipdata from /home/xw148/project2/zip.dat with delimiter '|'

# copy address.dat
CREATE table addressdata(
	email VARCHAR(40) not null,
	street VARCHAR(225),
	city VARCHAR(40),
	zip2 VARCHAR(10));

scp -r /Users/xiuliwang/Desktop/project2Data/address.dat xw148@cs-class.uis.georgetown.edu:/home/xw148/project2
\copy addressdata from /home/xw148/project2/address.dat with delimiter '|'

# make a new joinzip table by joining two tables: zipdata & addressdata
CREATE TABLE joinzip as (
	select * from zipdata full join addressdata on zip1=zip2);
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! need check !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
alter table joinzip drop column zip1;   

# make a new joinemail table by joining two tables: userdata & joinzip
CREATE TABLE joinemail as(
	select * from userdata full join joinzip on customer_email=email);

# Delete rows that email does not contains @
delete from joinemail where customer_email NOT like '%@%';

# make all email standerdized to lowercase
update joinemail set customer_email = LOWER(customer_email);

# since no two people would have same email, delete duplicate email
delete from joinemail where ctid NOT IN (select max(ctid) from joinemail group by customer_email);

# check if any remaining duplicate in email attribute
select customer_email, count(*) from joinemail group by customer_email having count(*)>1;

# update first_name as only capitalize the first char
update joinemail set first_name = INITCAP(first_name);
update joinemail set last_name = INITCAP(last_name);

# delete null value in password
delete from joinemail where password is NULL;

#capitalize street name
update joinemail set street = INITCAP(street);

# capitalize city name
update joinemail set city = INITCAP(city);

# create a column of random number
alter table joinemail add column random_number int;
update joinemail set random_number = cast(random()*999+1 as int);

# create new variable name username in joinemail
alter table joinemail add column username VARCHAR(225);

# update username as first lastname
update joinemail set username = first_name|| last_name || random_number;

# delete null value in username, customer_email
delete from joinemail where username is NULL;

# insert attributes in joinemail table into Customer table
insert into Customer (username,customer_email,first_name,last_name,password,street_address,
	city,state,zip_code,country)
	select username,customer_email,first_name,last_name,password,street,city,state,zip2,country from joinemail;




