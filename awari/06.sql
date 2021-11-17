/*
    Explore as bases realizando JOINS entre elas
    Que retorne a quantidade de items vendidos em cada categorias 
    por estado em que o cliente se encontra, mostrando somente categorias
    que tenham vendido uma quantidade de items acima de 1000 items.
 */
SELECT 
    customers.customer_state AS estado,
    products.product_category_name AS categoria,
    COUNT(*) AS quantidade_vendas
FROM `neural-clarity-329600.OlistDataset.olist_order_items_dataset` AS order_items
INNER JOIN `neural-clarity-329600.OlistDataset.olist_products_dataset` AS products ON (order_items.product_id = products.product_id)
INNER JOIN `neural-clarity-329600.OlistDataset.olist_orders_dataset` AS orders ON(order_items.order_id = orders.order_id)
INNER JOIN `neural-clarity-329600.OlistDataset.olist_customers_dataset` AS customers ON (orders.customer_id = customers.customer_id)
GROUP BY estado, categoria
HAVING quantidade_vendas > 1000
ORDER BY estado, categoria;



/*
    Mostre os 5 clientes (customer_id) que gastaram mais dinheiro em compras, 
    qual foi o valor total de todas as compras deles, quantidade de compras, e 
    valor médio gasto por compras, ordene os mesmos por ordem decrescente pela media do valor de compra.
 */
SELECT 
    customers.customer_id AS cliente,
    SUM(order_payments.payment_value) AS valor_total_compras,
    COUNT(order_payments.order_id) AS quantidade_compras,
    AVG(order_payments.payment_value) AS valor_medio_compras
FROM `neural-clarity-329600.OlistDataset.olist_customers_dataset` AS customers
INNER JOIN `neural-clarity-329600.OlistDataset.olist_orders_dataset` AS orders ON (customers.customer_id = orders.customer_id)
INNER JOIN `neural-clarity-329600.OlistDataset.olist_order_payments_dataset` AS order_payments ON (orders.order_id = order_payments.order_id)
GROUP BY cliente
ORDER BY valor_medio_compras DESC
LIMIT 5;



/*
    Mostre o valor vendido total de cada vendedor(seller_id) em cada uma das categorias 
    de produtos, somente retornando os vendedores que nesse somatório e agrupamento venderam mais de $1000, 
    desejamos ver a categoria do produto e os vendedores, para cada uma dessas categorias mostre seus valores de venda de forma decrescente.
 */
SELECT 
    products.product_category_name AS categoria,
    sellers.seller_id AS vendedor,
    ROUND(SUM(order_items.price), 2) AS valor_total
FROM `neural-clarity-329600.OlistDataset.olist_sellers_dataset` AS sellers
INNER JOIN `neural-clarity-329600.OlistDataset.olist_order_items_dataset` AS order_items ON (sellers.seller_id = order_items.seller_id)
INNER JOIN `neural-clarity-329600.OlistDataset.olist_products_dataset` AS products ON (order_items.product_id = products.product_id)
WHERE products.product_category_name IS NOT NULL
GROUP BY vendedor, categoria
HAVING valor_total > 1000
ORDER BY categoria ASC, valor_total DESC;



/*
    Crie uma consulta que retorne por estado:
    - a quantidade de compras;
    - média do valor das compras;
    - a soma do valor das compras;
    - a compra de maior valor;
    - a compra de menor valor
    Retornar os estados que tiverem a soma do valor das compras acima de 300.000
 */
SELECT 
    customers.customer_state AS estado,
    COUNT(*) AS qtde_compras,
    ROUND(AVG(payments.payment_value), 2) AS valor_medio,
    ROUND(SUM(payments.payment_value), 2) AS total,
    ROUND(MAX(payments.payment_value), 2) AS maximo,
    ROUND(MIN(payments.payment_value), 2) AS minimo
FROM `neural-clarity-329600.OlistDataset.olist_customers_dataset` AS customers
INNER JOIN `neural-clarity-329600.OlistDataset.olist_orders_dataset` AS orders ON (customers.customer_id = orders.customer_id)
INNER JOIN `neural-clarity-329600.OlistDataset.olist_order_payments_dataset` AS payments ON (orders.order_id = payments.order_id)
GROUP BY estado
HAVING total > 300000
ORDER BY estado;
