-- Qual o volume de pedidos por status, agrupados pelo ano do pedido de compra?
SELECT 
    EXTRACT (year FROM order_purchase_timestamp) AS ano
    , order_status AS status
    , COUNT(*) AS volume    
FROM `neural-clarity-329600.OlistDataset.olist_orders_dataset`
GROUP BY ano, status
ORDER BY ano, status;

-- Qual o volume de pedidos por mês do ano? Faça uma limpeza para trazer os resultados 
-- pelo nome do mês por extenso e pelo valor numérico. Ex: Janeiro : 8069.
SELECT mes_nome AS mes, volume
FROM (    
    SELECT 
        EXTRACT (month FROM order_purchase_timestamp) AS mes_num,
        CASE EXTRACT (month FROM order_purchase_timestamp)
            WHEN 1 THEN 'janeiro'
            WHEN 2 THEN 'fevereiro'
            WHEN 3 THEN 'março'
            WHEN 4 THEN 'abril'
            WHEN 5 THEN 'maio'
            WHEN 6 THEN 'junho'
            WHEN 7 THEN 'julho'
            WHEN 8 THEN 'agosto'
            WHEN 9 THEN 'setembro'
            WHEN 10 THEN 'outubro'
            WHEN 11 THEN 'novembro'
            WHEN 12 THEN 'dezembro'
            ELSE 'outros'
        END AS mes_nome
        , COUNT(*) AS volume    
    FROM `neural-clarity-329600.OlistDataset.olist_orders_dataset`
    GROUP BY mes_num, mes_nome
) ORDER BY mes_num;


-- Retorne o volume de pedidos por mês e por status, em que os meses não sejam Janeiro, 
-- Julho e Outubro, ordenados pelo mês descendente.
SELECT mes_nome AS mes, status, volume
FROM (    
    SELECT 
        EXTRACT (month FROM order_purchase_timestamp) AS mes_num,
        CASE EXTRACT (month FROM order_purchase_timestamp)
            WHEN 1 THEN 'janeiro'
            WHEN 2 THEN 'fevereiro'
            WHEN 3 THEN 'março'
            WHEN 4 THEN 'abril'
            WHEN 5 THEN 'maio'
            WHEN 6 THEN 'junho'
            WHEN 7 THEN 'julho'
            WHEN 8 THEN 'agosto'
            WHEN 9 THEN 'setembro'
            WHEN 10 THEN 'outubro'
            WHEN 11 THEN 'novembro'
            WHEN 12 THEN 'dezembro'
            ELSE 'outros'
        END AS mes_nome
        , order_status AS status
        , COUNT(*) AS volume    
    FROM `neural-clarity-329600.OlistDataset.olist_orders_dataset`
    GROUP BY mes_num, mes_nome, status
    HAVING mes_num NOT IN (1, 7, 10)
) ORDER BY mes_num DESC;


-- Qual o volume de pedidos que foram entregues e que a data da entrega estava dentro do estimado? 
-- Agrupe por ano e por mês da compra;
SELECT
    EXTRACT (year from order_delivered_customer_date) AS ano,
    EXTRACT (month FROM order_delivered_customer_date) AS mes,
    COUNT(*) AS volume
FROM `neural-clarity-329600.OlistDataset.olist_orders_dataset`
WHERE 
    order_delivered_customer_date IS NOT NULL AND 
    order_delivered_customer_date <= order_estimated_delivery_date
GROUP BY ano, mes
ORDER BY ano, mes;


-- Encontre uma forma de retornar em uma única coluna, o mês por extenso e o ano da data 
-- de compra do pedido. Ex: Janeiro de 2018
SELECT order_id, CONCAT(mes_nome, ' de ', ano) AS mes_ano
FROM (    
    SELECT 
        order_id,
        EXTRACT (year FROM order_purchase_timestamp) AS ano,
        EXTRACT (month FROM order_purchase_timestamp) AS mes_num,
        CASE EXTRACT (month FROM order_purchase_timestamp)
            WHEN 1 THEN 'Janeiro'
            WHEN 2 THEN 'Fevereiro'
            WHEN 3 THEN 'Março'
            WHEN 4 THEN 'Abril'
            WHEN 5 THEN 'Maio'
            WHEN 6 THEN 'Junho'
            WHEN 7 THEN 'Julho'
            WHEN 8 THEN 'Agosto'
            WHEN 9 THEN 'Setembro'
            WHEN 10 THEN 'Outubro'
            WHEN 11 THEN 'Novembro'
            WHEN 12 THEN 'Dezembro'
            ELSE 'Outros'
        END AS mes_nome 
    FROM `neural-clarity-329600.OlistDataset.olist_orders_dataset`
    
);


-- [ Desafio ] Apresente em uma única query, qual o volume total de pedidos, o volume de pedidos 
-- entregues, o volume total de pedidos que foram entregues dentro do previsto e o volume de pedidos 
-- que não foram entregues no tempo previsto.
-- * Confira se os valores estão corretos e justifique.
-- * Agrupe os resultados por ano e pos mês.
-- * Ordene os resultados pelo ano ascendente, mês numérico ascendente, volume total descendente 
--   e volume dentro do prazo ascendente.
-- * Filtre os meses que tem um volume de entrega fora do prazo menor do que 100.
SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS ano,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS mes,
    COUNT(order_id) AS total_pedidos,
    COUNT(order_delivered_customer_date) AS total_pedidos_entregues,
    SUM(IF(order_delivered_customer_date <= order_estimated_delivery_date, 1, 0)) AS pedidos_entregues_no_prazo,
    SUM(IF(order_delivered_customer_date > order_estimated_delivery_date, 1, 0)) AS pedidos_entregues_fora_do_prazo,
    IF(
        (COUNT(order_delivered_customer_date) = 
            SUM(IF(order_delivered_customer_date <= order_estimated_delivery_date, 1, 0)) + SUM(IF(order_delivered_customer_date > order_estimated_delivery_date, 1, 0))
        ), true, false) AS total_entregas_confere
FROM `neural-clarity-329600.OlistDataset.olist_orders_dataset`
GROUP BY ano, mes
HAVING pedidos_entregues_fora_do_prazo < 100
ORDER BY ano ASC, mes ASC, total_pedidos DESC, pedidos_entregues_no_prazo ASC;


-- Faça uma pesquisa de funções que ainda não foram utilizadas nas aulas e pense em situações que 
-- poderiam ser utilizadas. Exemplos:

-- * Como faço para converter um texto para maiusculo ou minusculo?
SELECT LOWER('TeStE dE FuNçÕeS De TeXtO');
SELECT UPPER('TeStE dE FuNçÕeS De TeXtO');

-- * Como descubro o numero de caracteres de um texto?
SELECT LENGTH('TeStE dE FuNçÕeS De TeXtO');

-- * Como formatar um campo de data para outro modelo usando uma função? Ex: 01-01-2021, 01 de Jan, 
--   Janeiro de 2021.
SELECT FORMAT_DATE('%d-%m-%Y', DATE('2021-01-01')); -- retorna 01-01-2021
SELECT FORMAT_DATE('%b %d', DATE('2021-01-01')); -- retorna Jan 01
SELECT FORMAT_DATE('%B %Y', DATE('2021-01-01')); -- retorna January 2021

-- * Como concatenar textos  em um único campo? Ex: Retornar Cidade e Estado em um único campo texto
--   ( Cidade: Rio, Estado: RJ, Resultado “Rio, RJ”.
SELECT 
    customer_city, 
    customer_state,
    CONCAT(customer_city, ', ', customer_state) AS cidade_uf
FROM `neural-clarity-329600.OlistDataset.olist_customers_dataset`
ORDER BY customer_state, customer_city;
