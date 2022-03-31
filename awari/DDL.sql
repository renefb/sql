SELECT COUNT(order_id) FROM olist.orders WHERE order_id IS NULL;

SELECT order_id, LEN(order_id) AS chars
FROM olist.orders
WHERE LEN(order_id) <> 32;

ALTER TABLE olist.order_reviews ALTER COLUMN order_id CHAR(32) NOT NULL;

ALTER TABLE olist.orders ADD CONSTRAINT FK_olist_orders_customer_id FOREIGN KEY (customer_id) REFERENCES olist.customers(customer_id);

CREATE INDEX IDX_olist_order_payments_payment_type ON olist.order_payments (payment_type);


DELETE FROM olist.order_reviews WHERE order_id IN
(
SELECT customer_id FROM olist.orders
EXCEPT 
SELECT customer_id FROM olist.customers
)
