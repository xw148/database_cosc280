create table Order_info(
	order_id SERIAL PRIMARY KEY,
	nbr_tickets INTEGER CHECK(nbr_tickets<=10),
	total_price DECIMAL(8,2) CHECK(total_price >= 0),
	order_date DATE DEFAULT CURRENT_DATE,
	username VARCHAR(225),
	credit_card_nbr CHAR(12),
	credit_card_expiration DATE,
FOREIGN KEY (username) REFERENCES Customer(username));

# insert attributes into Order table
insert into Order_info(username) select username from Customer;
