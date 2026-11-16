--U0 samm 4 ridu tabelis sales
select count(*)
from sales;

-- tulemus 15234

--U0 samm 7	kliente, tooteid
SELECT
    (SELECT COUNT(*) FROM customers) AS kliente,
    (SELECT COUNT(*) FROM products) AS tooteid;

-- tulemus 3150 ja 362

--U1 samm 2 ridu, arveid, koopiaid

select 
    (select count(*) from sales) as ridu,
    (select count(distinct invoice_id) from sales) as arveid,
    ((select count(*) from sales) - (select count(distinct invoice_id) from sales)) as koopiaid;

--tulemus 15234, 10118, 5116

--U1 samm 6 koopiaid ROW_NUMBER-iga

SELECT *
FROM (
    SELECT
        invoice_id,
        ROW_NUMBER() OVER (
            PARTITION BY invoice_id
        ) AS rea_number
    FROM sales
) AS nummerdatud
WHERE rea_number > 1;

--tulemus 5116

--U2 samm 1 kliente, e-post puudub

select 
  count(*) as kliente,
  (count(*) - count(email)) as puuduvaid_emailid
from customers;

--tulemus 3150 ja 380

--U2 samm 6	külalisridu (customer_id on tühi)

select (count(*) - count (customer_id)) as külaliskliente
from sales;

--tulemus 1487

--U3 samm 3	linnu pärast ühtlustamist	

select count(distinct lower(trim(city)))
from customers;

--tulemus 12

--U3 samm 8	vigaseid kuupäevi
--ei saanud ülesandest aru, kust vigaseid kuupäevi otsima pidi ja ühestki tabelist neid ei leidnud


























