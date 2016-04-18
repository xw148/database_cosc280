CREATE TABLE Customer_Preference (
	username VARCHAR(225) NOT NULL,
	preference_nbr SERIAL PRIMARY KEY,
	preference_type VARCHAR(225),
	preference VARCHAR(225),
FOREIGN KEY (username) REFERENCES Customer(username) ON DELETE RESTRICT ON UPDATE CASCADE);

# insert asstribute username into Customer_Preference table
insert into Customer_Preference (username) select username from Customer;