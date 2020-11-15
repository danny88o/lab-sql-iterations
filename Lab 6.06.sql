-- Lab 6.06 
use sakila;

-- Write a query to find what is the total business done by each store.
	select c.store_id, sum(p.amount) Business
	from customer c
	join payment p on p.customer_id = c.customer_id
	group by c.store_id;

-- Convert the previous query into a stored procedure.
drop procedure if exists total_sales;
delimiter //
create procedure total_sales()
begin
  	select c.store_id, sum(p.amount) Business
	from customer c
	join payment p on p.customer_id = c.customer_id
	group by c.store_id;
end;
//
delimiter ;

call total_sales();


-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
drop procedure if exists total_sales;
delimiter //
create procedure total_sales(in store int)
begin
  	select c.store_id, sum(p.amount) Business
	from customer c
	join payment p on p.customer_id = c.customer_id
	where store_id = store
	group by c.store_id
;
end;
//
delimiter ;

call total_sales(2);

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.
drop procedure if exists total_sales;
delimiter //
create procedure total_sales(in store int, out sums float)
begin
declare total_Sales_value float default 0.0;

  	select sum(p.amount) into total_Sales_value	
	from customer c
	join payment p on p.customer_id = c.customer_id
	where store_id = store
	group by c.store_id;
    
select total_Sales_value into sums;
end;
//
delimiter ;

call total_sales(2, @x);

select round(@x,1) as Total_sales;

-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

drop procedure if exists total_sales;
delimiter //
create procedure total_sales(in store int, sums float, out flag_col varchar(10))
begin
declare total_Sales_value float default 0.0;
declare flag varchar(20) default "";

  	select sum(p.amount) into total_Sales_value	
	from customer c
	join payment p on p.customer_id = c.customer_id
	where store_id = store
	group by c.store_id
;
if total_Sales_value > 30000 then
	set flag = 'Green Flag';
else
	set flag = 'Red Flag';
end if;
select flag into flag_col;
select total_Sales_value into sums;

end;
//
delimiter ;

call total_sales(2, @x, @y);

select round(@x,1) as Total_sales, @y;