-- Q1 แสดงชื่อของลูกคา (name) ที่ชําระเงินสูงสุด
select customer_name as name from customers c join orders o on c.customer_id = o.customer_id 
where order_id = (select order_id from payments order by amount desc limit 1);
-- Q2 แสดงชื่อสินคา (product_name) ที่มีการซื้อมากกวา 1 ครั้ง
select product_name from products p
join order_details od on p.product_id = od.product_id
join orders o on od.order_id = o.order_id
join customers c on o.customer_id = c.customer_id
where c.order_count > 1 group by p.product_name;
-- Q3 แสดงชื่อของลูกคา (customer_name) ที่เคยซื้อสินคาที่มีชื่อวา “Sugar - Brown”
select customer_name from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on p.product_id = od.product_id 
where od.product_id = (select product_id from products where product_name = 'Sugar - Brown');
-- Q4 แสดงชื่อสินคา (product_name) ที่เคยถูกซื้อดวยลูกคาที่มีรหัสประจําตัวคือ “71-4595008”
select product_name from products p
join order_details od on od.product_id = p.product_id
join orders o on o.order_id = od.order_id
join customers c on c.customer_id = o.customer_id
where c.customer_id = '71-4595008';
-- Q5 แสดงชื่อลูกคา (customer_name) ที่สั่งซื้อสินคาอยางนอยหนึ่งรายการโดยสินคาชิ้นนั้นตองมีราคาตอหนวย “unit_price” มากกวา $50
select customer_name 
from customers 
where order_count >=1 
and customer_id in(select customer_id 
					from orders 
					where order_id in (select order_id
                    from order_details where product_id in(select product_id 
															from products 
                                                            where unit_price > 50)
									  )
				  );
-- Q6 แสดงชื่อลูกคา (name) พรอมกับจํานวนคําสั่งซื้อทั้งหมด (total_orders) และจํานวนเงินที่ชําระทั้งหมด(total_payment) ของลูกคาแตละคน
select customer_name as name, sum(order_count) as total_orders, sum(amount) as total_payment from customers c
join orders o on c.customer_id = o.customer_id 
join payments p on o.order_id = p.order_id group by customer_name;

-- Q7 แสดงขอมูลชื่อลูกคา (Name) รหัสคําสั่งซื้อ (ID) และวิธีการชําระเงิน (Method) สําหรับคําสั่งซื้อที่มียอดการชําระเงินรวมเกิน $100
select customer_name as Name, o.order_id as ID, p.payment_method as Method from customers c 
join orders o on c.customer_id = o.customer_id 
join payments p on o.order_id = p.order_id
where amount > 100;
-- Q8 แสดงชื่อลูกคา (Name) รหัสคําสั่งซื้อ (ID) และจํานวนเงินรวมสําหรับคําสั่งซื้อ (total_payment) ที่เกิดขึ้นตั้งแตวันที่ 1 มกราคม 2023
select customer_name as Name ,(o.order_id) as ID ,amount as total_payment from customers c 
join orders o on c.customer_id = o.customer_id 
join payments p on p.order_id = o.order_id
where order_date >= '2023-01-01' ;