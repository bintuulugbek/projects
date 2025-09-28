# 🚲 BikeStores Database — SQL & Analytics Project  

This project models a **BikeStores retail database** in **SQL Server** and explores it with **SQL queries**.  
It demonstrates **data modeling, SQL analytics** of sales, customers, products, and inventory.  


## 🏗 Database Schema
The BikeStores schema connects sales, products, and operations:  
- **Customers → Orders → Order_Items → Products**  
- **Products → Categories & Brands**  
- **Orders → Stores & Staffs**  
- **Stores → Stocks → Products**  

This design supports both **transactional reporting** and **business analytics**.  

## 📸 Dashboard Preview
![BikeStores Dashboard](images/model.png)

## 🛠️ SQL Views & Stored Procedures

To simplify analytics and reporting, I created several **SQL Views** and **Stored Procedures** in SQL Server.

### 📊 Views
- **vw_StoreSalesSummary** → Revenue, Orders, and AOV (Average Order Value) per store  
- **vw_TopSellingProducts** → Ranks products by total sales revenue  
- **vw_InventoryStatus** → Shows products that are out of stock  
- **vw_StaffPerformance** → Orders and revenue handled per staff member  
- **vw_RegionalTrends** → Revenue summarized by city/region  
- **vw_SalesByCategory** → Sales volume and margin by product category  

### ⚡ Stored Procedures
- **sp_CalculateStoreKPI** → Input: Store ID → Output: full KPI breakdown (items sold, revenue, margin, discount)  
- **sp_GenerateRestockList** → Returns low-stock items grouped by store  
- **sp_CompareSalesYearOverYear** → Compares sales performance (revenue, items, margin) across years  
- **sp_GetTotalRevenueKPI** → Calculates company-wide revenue KPI  

## 🔮 Conclusion
The BikeStores project demonstrates end-to-end skills in **SQL database design, advanced querying, and business analytics**.  
By combining raw data (CSV files), **optimized views & stored procedures**, the project delivers clear insights into sales, inventory, staff performance, and regional trends.  
This case study highlights my ability to turn complex datasets into **actionable business intelligence**.
