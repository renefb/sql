/*
 * Todos os scripts foram testados no SQLite online (https://sqliteonline.com/)
 */
-------------------------------------------------------------------------------


/*
 * 1. Crie uma query em SQL que retorne os valores distintos de cidade. Utilize a tabela “olist_customers_dataset” e 
 * a função aliases para retornar o dado.
 */
SELECT 
	DISTINCT customer_city AS cidade 
FROM olist_customers_dataset;

--------------------------------------------------------------------------------

/*
 * 02. Crie uma query em SQL que retorne os valores distintos de cidade e estado, para os estados de são paulo, minas 
 * gerais e rio de janeiro. Utilize a tabela “olist_customers_dataset” e a função aliases para retornar o dado.
 */
SELECT 
	DISTINCT customer_city as cidade, customer_state AS estado
FROM olist_customers_dataset
WHERE customer_state IN ("SP", "MG", "RJ");

--------------------------------------------------------------------------------

/*
 * 03. Crie uma ou mais queries que retornem o preço, o frete, a data limite para envio,  e o identificador do pedido 
 * para os registros que tem o preço entre 50 e 250, e que tem ao mesmo tempo a data de de envio limite maior do que 
 * 08 de Fevereiro de 2018. Utilize a função aliases para retornar o dado. Utilize a tabela “olist_order_items_dataset” 
 * e a função aliases para retornar o dado.
 */
SELECT
	order_id as "identificador do pedido"
	, price as "preco"
    , freight_value as "frete"
    , shipping_limit_date as "data limite para envio"
FROM olist_order_items_dataset
WHERE 
	price between 50 and 250
    AND DATE(shipping_limit_date) > DATE("2018-02-08")
ORDER BY shipping_limit_date ASC;

--------------------------------------------------------------------------------

/*
 * 04. Crie uma ou mais queries que retornem o preço, o frete, a data limite para envio,  e o identificador do pedido 
 * para os registros que tem o preço do frete inferior a 149 ou que tem um preço entre 250 e 500. Utilize a função 
 * aliases para retornar o dado. Utilize a tabela “olist_order_items_dataset” e a função aliases para retornar o dado.  
 */
SELECT
	order_id as "identificador do pedido"
	, price as "preco"
    , freight_value as "frete"
    , shipping_limit_date as "data limite para envio"
FROM olist_order_items_dataset
WHERE 
	freight_value < 149
    OR price BETWEEN 250 AND 500;

--------------------------------------------------------------------------------

/*
 * 05. Crie uma query em SQL que retorne todos os tipos de pagamento. Utilize a tabela “olist_order_payments_dataset” 
 * e a função aliases para retornar o dado.  
 */
SELECT DISTINCT payment_type AS "tipo de pagamento" FROM olist_order_payments_dataset;

--------------------------------------------------------------------------------

/*
 * 06. Crie uma query em SQL que retorne o tipo de pagamento, e o valor do pagamento para as compras que foram 
 * parceladas de 12 a 24 vezes e que tiveram um valor superior a 245,99 . Utilize a tabela “olist_order_payments_dataset” 
 * e a função aliases para retornar o dado.
 */
SELECT 
	order_id as "identificador do pedido"
	, payment_type AS "tipo de pagamento"
    , payment_value as "valor de pagamento"
    , payment_installments AS "parcelas"  -- adicionei para facilitar a conferência, mas poderia ter sido omitido
FROM olist_order_payments_dataset 
WHERE 
	payment_installments between 12 and 24
    AND payment_value > 245.99
ORDER BY payment_installments DESC;

--------------------------------------------------------------------------------

/*
 * 07. Crie uma query em SQL que retorne todas as pontuações de avaliação. Utilize a tabela “olist_order_reviews_dataset” 
 * e a função aliases para retornar o dado.
 */
SELECT 
	order_id as "identificador do pedido"
    , review_score as "pontuação de avaliação" 
from olist_order_reviews_dataset;
-- aqui talvez fizesse mais sentido uma consulta que contasse a quantidade de avaliações por nota, como:
-- SELECT review_score AS "pontuação de avaliação", COUNT() AS quantidade FROM olist_order_reviews_dataset GROUP BY review_score;

--------------------------------------------------------------------------------

/*
 * 08. Crie uma query em SQL que retorne todos os status de pedidos. Utilize a tabela “olist_orders_dataset” e a 
 * função aliases para retornar o dado.
 */
SELECT 
	order_id as "identificador do pedido"
    , order_status as "status do pedido" 
FROM olist_orders_dataset;

--------------------------------------------------------------------------------

/*
 * 09. Crie uma query em SQL que delete os registros para os pedidos que tenham o status é igual à “unavailable” e 
 * que tem uma data de aprovação igual ou anterior a 10 de Outubro de 2017. Utilize a tabela “olist_orders_dataset” 
 * e a função aliases para retornar o dado.
 */
DELETE from olist_orders_dataset
WHERE order_id IN (
  SELECT order_id 
  from olist_orders_dataset 
  where order_status = "unavailable" and DATE(order_approved_at) <= DATE ("2017-10-10")
);
-- aqui, usei queries aninhadas pra ficar mais fácil, primeiro, conferir quais eram os registros que deveriam ser excluídos e,
-- depois, se eles ainda existiam (executando apenas o select interno)

--------------------------------------------------------------------------------

/*
 * 10. [DESAFIO] Crie uma query em SQL que atualize os nomes de categorias de produto para uma versão de melhor leitura 
 * (Ex: moveis_decoracao > Movéis e Decoração), para os registros que tem a altura maior ou igual a 20 e que o tamanho 
 * do nome do produto esteja entre 10 e 200 . Para isso, voce precisa selecionar todos as categorias existentes na 
 * tabela que atendem aos critérios e depois criar seu comando para atualização de registros. Utilize a tabela 
 * “olist_products_dataset” e a função aliases para retornar o dado.
 */

-- Para não comprometer a estrutura da tabela product_category_name_translate,
-- criei uma tabela própria para mapear os nomes de categoria dos produtos:
--DROP TABLE IF EXISTS map_product_category_names;
CREATE TEMP TABLE map_product_category_names AS 
	SELECT product_category_name AS ugly_name
	FROM product_category_name_translation;

-- Aqui, faço um tratamento manual dos nomes de categorias, substituindo os underscores,
-- capitalizando as palavras e corrigindo algumas grafias que resultaram com incorreções:
ALTER TABLE map_product_category_names ADD COLUMN pretty_name TEXT(255);
UPDATE map_product_category_names SET pretty_name=UPPER(SUBSTRING(ugly_name, 1, 1)) || SUBSTRING(ugly_name, 2);
UPDATE map_product_category_names 
	SET pretty_name=REPLACE(SUBSTRING(pretty_name, 1, instr(pretty_name, "_")), "_", " / ") 
    || UPPER(SUBSTRING(pretty_name, instr(pretty_name, "_")+1, 1)) || SUBSTRING(pretty_name, instr(pretty_name, "_")+2);
UPDATE map_product_category_names 
	SET pretty_name=REPLACE(SUBSTRING(pretty_name, 1, instr(pretty_name, "_")), "_", " / ")
    || UPPER(SUBSTRING(pretty_name, instr(pretty_name, "_")+1, 1)) || SUBSTRING(pretty_name, instr(pretty_name, "_")+2);
UPDATE map_product_category_names 
	SET pretty_name=REPLACE(SUBSTRING(pretty_name, 1, instr(pretty_name, "_")), "_", " / ")
    || UPPER(SUBSTRING(pretty_name, instr(pretty_name, "_")+1, 1)) || SUBSTRING(pretty_name, instr(pretty_name, "_")+2);
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, " / E / ", " e ");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, " / De / ", " de ");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, " / 2", " 2");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Utilidades / Domesticas", "Utilidades Domesticas");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Telefonia / Fixa", "Telefonia Fixa");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Relogios presentes", "Relogios e presentes");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Area / De_servico_jantar_e_jardim", "Área de Serviço / Jantar e Jardim");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Pet / Shop", "Pet Shop");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Market / Place", "Market Place");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Livros / Técnicos", "Livros Tecnicos");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Interesse / Geral", "Interesse Geral");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Moda_praia", "Moda Praia");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Roupa / Feminina", "Roupa Feminina");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "La / Cuisine", "La Cuisine");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "/ E_cafe", "e cafe");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Blu / Ray", "Blu Ray");
UPDATE map_product_category_names SET pretty_name=REPLACE(pretty_name, "Infanto / Juvenil", "Infantojuvenil");


-- Finalmente, faço a alteração proposta no enunciado, mapeando categorias originais da
-- tabela olist_products_dataset para as categorias reescritas da tabela map_product_category_names:
UPDATE olist_products_dataset 
SET product_category_name = (SELECT pretty_name FROM map_product_category_names WHERE ugly_name=olist_products_dataset.product_category_name)
WHERE EXISTS (SELECT pretty_name FROM map_product_category_names WHERE ugly_name=olist_products_dataset.product_category_name);

-- Por fim, exibo a tabela olist_products_dataset para confirmar que as alterações foram feitas
SELECT * FROM olist_products_dataset
WHERE product_height_cm >= 20 AND product_name_lenght BETWEEN 10 and 200;

