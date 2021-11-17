-- https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions

-- DESAFIOS 3
-- Crie uma tabela analítica de todos os itens que foram vendidos, somente mostrando pedidos interestaduais. 
-- Queremos saber quantos dias os fornecedores demoram para postar o produto, se o produto chegou ou não 
-- dentro do prazo
SELECT 
    o.order_id,
    c.customer_state, s.seller_state,
    o.order_purchase_timestamp,
    o.order_approved_at, o.order_delivered_carrier_date,
    DATETIME_DIFF(IFNULL(o.order_delivered_carrier_date, CURRENT_TIMESTAMP()), o.order_approved_at, DAY) AS days_to_post,
    o.order_estimated_delivery_date, o.order_delivered_customer_date,    
    IF (    
        (IFNULL(o.order_delivered_customer_date, CURRENT_TIMESTAMP()) > o.order_estimated_delivery_date),
        true,
        false
    ) AS delivery_delayed
FROM `neural-clarity-329600.OlistDataset.olist_orders_dataset` AS o
INNER JOIN `neural-clarity-329600.OlistDataset.olist_order_items_dataset` AS oi ON (o.order_id = oi.order_id)
INNER JOIN `neural-clarity-329600.OlistDataset.olist_products_dataset` AS p ON (oi.product_id = p.product_id)
INNER JOIN `neural-clarity-329600.OlistDataset.olist_sellers_dataset` AS s ON (oi.seller_id = s.seller_id)
INNER JOIN `neural-clarity-329600.OlistDataset.olist_customers_dataset` AS c ON (o.customer_id = c.customer_id)
WHERE c.customer_state <> s.seller_state
ORDER BY o.order_purchase_timestamp ASC



-- Crie uma query SQL que me retorne todos os pagamentos do cliente, com suas datas de aprovação, valor da compra 
-- e o valor total que o cliente já gastou em todas as suas compras, me mostrando somente os clientes onde o valor 
-- da compra é diferente do valor total já gasto. Queremos saber sobre as categorias válidas, suas soma total dos 
-- valores de vendas, um ranqueamento de maior valor para menor valor junto com o somatório acumulado dos valores 
-- pela mesma regra do ranqueamento.




-- DESAFIOS 4
-- Crie uma view (SELLER_STATS) para mostrar por fornecedor, a quantidade de itens enviados, o tempo médio de postagem após a aprovação da compra, a quantidade total de pedidos de cada Fornecedor, note que trabalharemos na mesma query com 2 granularidades diferentes.
-- Queremos dar um cupom de 10% do valor da última compra do cliente. Porém os clientes elegíveis a este cupom devem ter feito uma compra anterior a última (A partir da data de aprovação do pedido) que tenha sido maior ou igual o valor da última compra e também queremos saber os valores dos cupons para cada um dos clientes elegíveis.
