#  Inventory and Warehouse Management System

##  Introduction

The Inventory and Warehouse Management System is a MySQL-based backend project designed to efficiently manage products, suppliers, warehouses, and stock levels. It helps organizations track inventory across multiple locations and ensures smooth stock operations.

---

##  Abstract

This project implements a relational database system to handle inventory operations such as stock tracking, supplier management, and warehouse distribution. It includes advanced SQL features like triggers and stored procedures to automate tasks such as low-stock alerts and stock transfers. The system improves accuracy, reduces manual errors, and enhances decision-making.

---

##  Tools Used

* MySQL (Database)
* SQL (DDL, DML, Joins, Triggers, Stored Procedures)

---

##  Steps Involved in Building the Project

1. **Database Design**

   * Created tables: Suppliers, Products, Warehouses, Stock, Notifications
   * Established relationships using foreign keys

2. **Data Insertion**

   * Inserted realistic sample data for suppliers, products, and warehouses

3. **Query Implementation**

   * Developed queries to:

     * Check stock levels
     * Identify low-stock items
     * Generate inventory reports

4. **Trigger Creation**

   * Implemented a trigger to automatically generate alerts when stock falls below reorder level

5. **Stored Procedure**

   * Created a procedure to transfer stock between warehouses with validation

6. **Testing**

   * Verified functionality using SELECT queries and procedure calls

---

##  Key Features

*  Real-time inventory tracking
*  Low-stock alert system
*  Multi-warehouse management
*  Stock transfer automation
*  Inventory reporting

---

## Sample Queries

* View stock levels
* Detect low inventory
* Calculate total stock per product

---

##  Conclusion

This project demonstrates how SQL can be used to build a powerful inventory management backend system. By integrating triggers and stored procedures, the system automates critical operations and ensures efficient stock handling. It is scalable and can be extended with a frontend for real-world applications.

---

##  Future Enhancements

* Add frontend (HTML, PHP, or React)
* Implement user authentication system
* Add dashboard with analytics
* Integrate barcode or RFID tracking

---


