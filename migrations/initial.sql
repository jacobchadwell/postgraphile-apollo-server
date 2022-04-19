drop table if exists edge_purchases_customers;
drop table if exists edge_coffee_types_purchases;

-- CoffeeTypes node
drop table if exists coffee_types;
create table coffee_types
(
	coffee_type_id integer generated always as identity primary key,
	coffee_name text not null,
	description text not null
);

-- Purchases node
drop table if exists purchases;
create table purchases
(
	purchase_id integer generated always as identity primary key,
	purchase_date date not null,
	purchase_time time not null
);

-- Customers node
drop table if exists customers;
create table customers
(
	customer_id integer generated always as identity primary key,
	customer_name text not null
);

-- CoffeeTypes -> Purchases edge
create table edge_coffee_types_purchases
(
	edge_coffee_types_purchases_id integer generated always as identity primary key,
	coffee_type_id integer references coffee_types (coffee_type_id) on update cascade,
	purchase_id integer references purchases (purchase_id) on update cascade
);

comment on table edge_coffee_types_purchases is E'@omit all,many';
comment on constraint edge_coffee_types_purchases_coffee_type_id_fkey on edge_coffee_types_purchases is E'@manyToManyFieldName coffeeTypes';
comment on constraint edge_coffee_types_purchases_purchase_id_fkey on edge_coffee_types_purchases is E'@manyToManyFieldName purchases';

-- Purchases -> Customers edge
create table edge_purchases_customers
(
	edge_purchases_customers_id integer generated always as identity primary key,
	customer_id integer references customers (customer_id) on update cascade,
	purchase_id integer references purchases (purchase_id) on update cascade
);

comment on table edge_purchases_customers is E'@omit all,many';
comment on constraint edge_purchases_customers_customer_id_fkey on edge_purchases_customers is E'@manyToManyFieldName customers';
comment on constraint edge_purchases_customers_purchase_id_fkey on edge_purchases_customers is E'@manyToManyFieldName purchases';


-- Insert node data
insert into coffee_types (coffee_name, description) values ('Drip', 'A hot cup of coffee');
insert into coffee_types (coffee_name, description) values ('Single Espresso', 'A tiny coffee!');
insert into coffee_types (coffee_name, description) values ('Double Espresso', 'Tiny coffee x2');
insert into coffee_types (coffee_name, description) values ('Americano', 'Espresso + water');
insert into coffee_types (coffee_name, description) values ('Cappuccino', 'Espresso and steamed milk');
insert into coffee_types (coffee_name, description) values ('Pour Over', 'Handmade. The tastiest.');

insert into purchases (purchase_date, purchase_time) values ('02/25/2022','6:43 PM');
insert into purchases (purchase_date, purchase_time) values ('03/01/2022','6:19 PM');
insert into purchases (purchase_date, purchase_time) values ('02/09/2022','6:28 PM');
insert into purchases (purchase_date, purchase_time) values ('01/30/2022','9:11 AM');
insert into purchases (purchase_date, purchase_time) values ('01/10/2022','2:05 PM');
insert into purchases (purchase_date, purchase_time) values ('01/29/2022','12:22 PM');
insert into purchases (purchase_date, purchase_time) values ('03/23/2022','6:15 AM');
insert into purchases (purchase_date, purchase_time) values ('02/18/2022','7:51 AM');
insert into purchases (purchase_date, purchase_time) values ('03/09/2022','8:20 AM');
insert into purchases (purchase_date, purchase_time) values ('01/13/2022','9:13 AM');
insert into purchases (purchase_date, purchase_time) values ('03/23/2022','7:21 AM');
insert into purchases (purchase_date, purchase_time) values ('01/30/2022','9:14 AM');
insert into purchases (purchase_date, purchase_time) values ('02/23/2022','9:20 AM');
insert into purchases (purchase_date, purchase_time) values ('03/29/2022','12:37 PM');
insert into purchases (purchase_date, purchase_time) values ('03/24/2022','3:09 PM');
insert into purchases (purchase_date, purchase_time) values ('01/30/2022','4:55 PM');
insert into purchases (purchase_date, purchase_time) values ('01/22/2022','3:01 PM');
insert into purchases (purchase_date, purchase_time) values ('03/15/2022','11:12 AM');
insert into purchases (purchase_date, purchase_time) values ('02/05/2022','1:59 PM');
insert into purchases (purchase_date, purchase_time) values ('03/06/2022','12:26 PM');
insert into purchases (purchase_date, purchase_time) values ('03/17/2022','8:11 AM');
insert into purchases (purchase_date, purchase_time) values ('01/28/2022','5:25 PM');
insert into purchases (purchase_date, purchase_time) values ('02/04/2022','9:19 AM');
insert into purchases (purchase_date, purchase_time) values ('04/14/2022','5:12 PM');
insert into purchases (purchase_date, purchase_time) values ('01/12/2022','9:50 AM');
insert into purchases (purchase_date, purchase_time) values ('03/03/2022','12:50 PM');
insert into purchases (purchase_date, purchase_time) values ('01/22/2022','12:32 PM');
insert into purchases (purchase_date, purchase_time) values ('02/27/2022','2:42 PM');
insert into purchases (purchase_date, purchase_time) values ('03/02/2022','8:55 AM');
insert into purchases (purchase_date, purchase_time) values ('02/06/2022','3:37 PM');

insert into customers (customer_name) values ('Dog');
insert into customers (customer_name) values ('Cat');
insert into customers (customer_name) values ('Frog');
insert into customers (customer_name) values ('Beaver');
insert into customers (customer_name) values ('Penguin');

-- Insert edge data for coffee_types_purchases
insert into edge_coffee_types_purchases (coffee_type_id, purchase_id)
select c.coffee_type_id, p.purchase_id
from coffee_types c, purchases p
where c.coffee_name = 'Americano' and p.purchase_date between '01-01-2022' and '01-31-2022';

insert into edge_coffee_types_purchases (coffee_type_id, purchase_id)
select c.coffee_type_id, p.purchase_id
from coffee_types c, purchases p
where c.coffee_name = 'Cappuccino' and p.purchase_date between '02-01-2022' and '02-28-2022';

insert into edge_coffee_types_purchases (coffee_type_id, purchase_id)
select c.coffee_type_id, p.purchase_id
from coffee_types c, purchases p
where c.coffee_name = 'Drip' and p.purchase_date between '03-01-2022' and '03-31-2022';

insert into edge_coffee_types_purchases (coffee_type_id, purchase_id)
select c.coffee_type_id, p.purchase_id
from coffee_types c, purchases p
where c.coffee_name = 'Single Espresso' and p.purchase_date between '04-01-2022' and '04-30-2022';

-- Insert edge data for purchases_customers
insert into edge_purchases_customers (customer_id, purchase_id)
select c.customer_id, p.purchase_id
from purchases p, customers c
where c.customer_id = 1 and p.purchase_id between 1 and 6;

insert into edge_purchases_customers (customer_id, purchase_id)
select c.customer_id, p.purchase_id
from purchases p, customers c
where c.customer_id = 2 and p.purchase_id between 7 and 12;

insert into edge_purchases_customers (customer_id, purchase_id)
select c.customer_id, p.purchase_id
from purchases p, customers c
where c.customer_id = 3 and p.purchase_id between 13 and 18;

insert into edge_purchases_customers (customer_id, purchase_id)
select c.customer_id, p.purchase_id
from purchases p, customers c
where c.customer_id = 4 and p.purchase_id between 19 and 24;

insert into edge_purchases_customers (customer_id, purchase_id)
select c.customer_id, p.purchase_id
from purchases p, customers c
where c.customer_id = 5 and p.purchase_id between 25 and 30;