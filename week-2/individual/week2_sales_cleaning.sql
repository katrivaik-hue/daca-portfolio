--TOOMASE PUHASTAMISRAPORT, päringud

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



-- WEEK 2, Roll A: Müügiandmete puhastamine

-- SAMM 1: Testkoopia loomine

DROP TABLE IF EXISTS sales_test; --see kustutab tabeli, kui see on olemas

CREATE TABLE sales_test AS
SELECT * 
FROM sales;  -- see loob tabeli. Kui eelmist ja seda koos käivitada, siis kustutatakse testtabel ja luuakse uus, alganamdetega sales tabelist

--kontrollin sales ridade arvu, tulemus 15234

select count(*)
from sales;

--kontrollin sales_test ridade arvu, tulemus 15234

select count(*)
from sales_test;

-- kontrollisin duplikaate kasutades group by funktsiooni

SELECT invoice_id, COUNT(*)
FROM sales_test
GROUP BY invoice_id;

--lisasin hvaing funktsiooni, et tulemus näitaks vaid neid invoice_id-sid, kus on rohkem kui 1 rida

SELECT invoice_id, COUNT(*)
FROM sales_test
GROUP BY invoice_id
HAVING COUNT(*) > 1;

--järjestasin alates suurimast korduste arvust

SELECT invoice_id, COUNT(*)
FROM sales_test
GROUP BY invoice_id
HAVING COUNT(*) > 1
order by count(*) desc;

--kontrollisin, mida see 6 rida sisaldav invoice_id-d sisaldab

SELECT *
FROM sales_test
WHERE invoice_id = 'INV-202308-00283';

-- tulmus - nägin, et kõik 6 rida polnud identsed. ühel juhul oli customer id NULL ja teisel juhul erines unit price.Tegelikkuses tuleks duplikaatide tuvastamisel kontrollida ka teiste väljade kombinatsioone, kuid õppimise eesmärgil lähtun ülesandes invoice_id duplikaatide kontrollist.

--kontrollin, mitmel customer_id-l on väärtus NULL -- tulemus 1487, see ei tähenda automaatselt viga, sest osa müüke võib olla tehtud tuvastamata kliendile

SELECT COUNT(*)
FROM sales_test
WHERE customer_id IS NULL;

--kontrollisin ka teiste väljade NULL väärtusi - tulemus 0, ehk kõik teised andmed olid olemas
--esimene päring koos FILTER funktsiooniga 

SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_null,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id_null,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS quantity_null,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS unit_price_null,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS sale_date_null
FROM sales_test;

-- saab ka ükshaaval kontrolllida

SELECT COUNT(*)
FROM sales_test
WHERE product_id IS NULL;

-- kontrollin, kas quantity ja unit_price sisaldab 0 või negatiivseid väärtusi -- Tulemus - ei sisalda

SELECT *
FROM sales_test
WHERE unit_price <= 0;

-- kontrollin sales andmete kõige varasemat ja hilisemat kuupäeva, sain tulemuseks 01.01.2023 kuni 28.06.2026

SELECT
    MIN(sale_date) AS earliest_sale_date,
    MAX(sale_date) AS latest_sale_date
FROM sales_test;

-- kontrollin, mitu müügikuupäeva on pärast andmete tegelikku lõppu 28.02.2025. Sain tulemuseks 50.

SELECT COUNT(*) AS vigased_kuupaevad
FROM sales_test
WHERE sale_date > DATE '2025-02-28';

--tegin veel eraldi kontrolli kuupäevadele, mis on hilisemad tänasest kuupäevast või varasemad kui 01.01.2020. tulemuseks sain 0.

SELECT COUNT(*) AS vigased_kuupaevad
FROM sales_test
WHERE sale_date > CURRENT_DATE
   OR sale_date < DATE '2020-01-01';

--tegin veel eraldi kontrolli kuupäevadele, mis on hilisemad tänasest kuupäevast või varasemad kui 01.01.2020. tulemuseks sain 0.

SELECT COUNT(*) AS vigased_kuupaevad
FROM sales_test
WHERE sale_date > CURRENT_DATE
   OR sale_date < DATE '2020-01-01';

--kontrollin, mis kustutamisele läheks, tulemuseks 5116 rida

SELECT *
FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id
);

-- eemaldan korduvad invoice_id read, jättes iga invoice_id kohta alles väikseima id-ga rea

DELETE FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id
);

--kontrollisin allejäänud ridade arvu, tulemus 10118

SELECT COUNT(*)
FROM sales_test;

-- seejärel liikusin sales tabeli puhastamise juurde
-- kontrollin enne päris sales tabeli puhastamist, mitu rida läheks eemaldamisele

SELECT COUNT(*)
FROM sales
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales
    GROUP BY invoice_id
);

-- eemaldan sales tabelist korduvad invoice_id read, jättes iga invoice_id kohta alles väikseima id-ga rea

DELETE FROM sales
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales
    GROUP BY invoice_id
);

-- kontrollin sales tabeli ridade arvu pärast puhastamist - sain oodatava tulemuse 10118

SELECT COUNT(*)
FROM sales;
