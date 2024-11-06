create database sales;
use sales;
-- Q1 แสดงชื่อของลูกคา (name) ที่ชําระเงินสูงสุด
SELECT 
    customer_name AS name
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
WHERE
    order_id = (SELECT 
            order_id
        FROM
            payments
        ORDER BY amount DESC
        LIMIT 1);
-- Q2 แสดงชื่อสินคา (product_name) ที่มีการซื้อมากกวา 1 ครั้ง
SELECT 
    product_name
FROM
    products
WHERE
    product_id IN (SELECT 
            product_id
        FROM
            order_details
        GROUP BY product_id
        HAVING COUNT(*) > 1);
-- Q3 แสดงชื่อของลูกคา (customer_name) ที่เคยซื้อสินคาที่มีชื่อวา “Sugar - Brown”
SELECT 
    customer_name
FROM
    customers
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            orders
        WHERE
            order_id IN (SELECT 
                    order_id
                FROM
                    order_details
                WHERE
                    product_id IN (SELECT 
                            product_id
                        FROM
                            products
                        WHERE
                            product_name = 'Sugar - Brown')))
;
-- Q4 แสดงชื่อสินคา (product_name) ที่เคยถูกซื้อดวยลูกคาที่มีรหัสประจําตัวคือ “71-4595008”
SELECT 
    product_name
FROM
    products
WHERE
    product_id IN (SELECT 
            product_id
        FROM
            order_details
        WHERE
            order_id IN (SELECT 
                    order_id
                FROM
                    orders
                WHERE
                    customer_id = '71-4595008'));

-- Q5 แสดงชื่อลูกคา (customer_name) ที่สั่งซื้อสินคาอยางนอยหนึ่งรายการโดยสินคาชิ้นนั้นตองมีราคาตอหนวย “unit_price” มากกวา $50
SELECT 
    customer_name
FROM
    customers
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            orders
        WHERE
            order_id IN (SELECT 
                    order_id
                FROM
                    order_details
                WHERE
                    product_id IN (SELECT 
                            product_id
                        FROM
                            products
                        WHERE
                            unit_price > 50))); 
                
-- Q6 แสดงชื่อลูกคา (name) พรอมกับจํานวนคําสั่งซื้อทั้งหมด (total_orders) และจํานวนเงินที่ชําระทั้งหมด(total_payment) ของลูกคาแตละคน
SELECT 
    c.customer_name AS name,
    (SELECT 
            COUNT(*)
        FROM
            orders
        WHERE
            orders.customer_id = c.customer_id) AS total_orders,
    (SELECT 
            SUM(amount)
        FROM
            payments
        WHERE
            order_id IN (SELECT 
                    order_id
                FROM
                    orders
                WHERE
                    orders.customer_id = c.customer_id)) AS total_payment
FROM
    customers c; 
-- Q7 แสดงขอมูลชื่อลูกคา (Name) รหัสคําสั่งซื้อ (ID) และวิธีการชําระเงิน (Method) สําหรับคําสั่งซื้อที่มียอดการชําระเงินรวมเกิน $100
SELECT 
    c.customer_name AS Name,
    o.order_id AS ID,
    p.payment_method AS Method
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    payments p ON o.order_id = p.order_id
WHERE
    amount > 100;

-- Q8 แสดงชื่อลูกคา (Name) รหัสคําสั่งซื้อ (ID) และจํานวนเงินรวมสําหรับคําสั่งซื้อ (total_payment) ที่เกิดขึ้นตั้งแตวันที่ 1 มกราคม 2023
SELECT 
    c.customer_name AS Name,
    o.order_id AS ID,
    amount AS total_payment
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    payments p ON o.order_id = p.order_id
WHERE
    o.order_date >= '2023-01-01';
 