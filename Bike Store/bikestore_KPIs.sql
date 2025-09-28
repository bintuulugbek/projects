--•	vw_StoreSalesSummary: Revenue, #Orders, AOV per store
create view vw_StoreSalesSummary as
with cte as (
select order_id, cast(round(quantity * list_price * (1-discount), 2) as decimal(10, 3)) as Revenue from Order_items
),
store_names as (
select distinct store_id, store_name from Stores 
)
select store_names.store_name, cast(round(avg(Revenue), 3) as decimal(10, 3)) as AOV_per_store from cte 
join Orders o on o.order_id = cte.order_id 
join store_names on o.store_id = store_names.store_id
group by store_names.store_name

--•	vw_TopSellingProducts: Rank products by total sales
create view vw_TopSellingProducts as 
with cte as (
select product_id, 
	   sum(cast(round(quantity * list_price * (1-discount), 2) as decimal(10, 3))) as total_revenue, 
	   row_number() over(order by sum(cast(round(quantity * list_price * (1-discount), 2) as decimal(10, 3)))) ranking from Order_items
group by product_id
) select top 100 percent ranking, product_name, total_revenue from cte join Products p on p.product_id = cte.product_id
order by ranking

select * from 
--•	vw_InventoryStatus: Items running low on stock
create view vw_InventoryStatus as 
select product_name as unavailable_products from Stocks 
join Products on Products.product_id = Stocks.product_id
where quantity = 0

--•	vw_StaffPerformance: Orders and revenue handled per staff
create view vw_StaffPerformance as
with cte as (
select order_id, cast(round(quantity * list_price * (1-discount), 2) as decimal(10, 3)) as Revenue from Order_items
),
cte2 as (
select staff_id, first_name + ' ' + last_name staff_name from Staffs
)
select staff_name, count(o.order_id) corder_count, sum(Revenue) total_revenue from cte 
join Orders o on o.order_id = cte.order_id
join cte2 on cte2.staff_id = o.staff_id 
group by staff_name

--•	vw_RegionalTrends: Revenue by city or region
create view vw_RegionalTrends as
with cte as (
select order_id, cast(round(quantity * list_price * (1-discount), 2) as decimal(10, 3)) as Revenue from Order_items
),
cte2 as (
select store_id, city from Stores
)
select city, sum(Revenue) total_revenue from cte 
join Orders o on o.order_id = cte.order_id
join cte2 on cte2.store_id = o.store_id
group by city

--•	vw_SalesByCategory: Sales volume and margin by product category
create view vw_SalesByCategory as
with cte as (
select product_id, quantity, discount, list_price, cast(round(quantity * list_price * (1-discount), 2) as decimal(10, 3)) as Revenue from Order_items
) 
select category_name, count(cte.quantity) volume,  sum(cte.quantity * p.list_price - Revenue) margin from cte 
join Products p on p.product_id = cte.product_id
join Categories c on c.category_id = p.category_id
group by category_name
 
--•	sp_CalculateStoreKPI: Input store ID, return full KPI breakdown
create procedure sp_CalculateStoreKPI as
with cte as (
select product_id, quantity, discount, list_price, cast(round(quantity * list_price * (1-discount), 2) as decimal(10, 3)) Revenue from Order_items
) 
select sum(cte.quantity) Items_sold,  sum(Revenue) Total_revenue, sum(cte.quantity * p.list_price - Revenue) Margin, avg(discount) Avg_discount from cte 
join Products p on p.product_id = cte.product_id

exec sp_CalculateStoreKPI

--•	sp_GenerateRestockList: Output low-stock items per store
create procedure sp_GenerateRestockList as
with cte as (
select store_id, product_id from Stocks where quantity = 0
)
select cte.store_id, string_agg(product_name, ', ') products, store_name from cte
join stores on cte.store_id = stores.store_id
join Products p on p.product_id = cte.product_id
group by cte.store_id, store_name

exec sp_GenerateRestockList

--•	sp_CompareSalesYearOverYear: Compare sales between two years
create procedure sp_CompareSalesYearOverYear as 
with cte as (
select product_id, quantity, order_id, discount, list_price, cast(round(quantity * list_price * (1-discount), 2) as decimal(10, 3)) Revenue from Order_items
) 
select left(order_date, 4) order_year, sum(cte.quantity) Items_sold,  sum(Revenue) Total_revenue, sum(cte.quantity * p.list_price - Revenue) Margin, avg(discount) Avg_discount from cte 
join Products p on p.product_id = cte.product_id
join Orders o on o.order_id = cte.order_id
group by left(order_date, 4)

exec sp_CompareSalesYearOverYear

--Total Revenue	Company-wide performance
create procedure sp_GetTotalRevenueKPI as 
begin
select sum(quantity * list_price * (1 - discount)) TotalRevenue from dbo.Order_items;
end;

exec sp_GetTotalRevenueKPI




