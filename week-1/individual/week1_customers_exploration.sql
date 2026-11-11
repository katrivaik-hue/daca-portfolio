-- Kontrollisin, mitu unikaalset klienti on UrbanStyle'i andmebaasis.

SELECT COUNT(DISTINCT customer_id) AS unikaalseid_kliente
FROM customers;

-- Tulemus: 3150 unikaalset klienti.

- Uurisin, millistest linnadest kliendid tulevad.
-- Esialgne DISTINCT päring näitas, et sama linn esines erinevas kirjapildis.
-- Kuna pidin oma tähelepanekuid analüüsima, küsisin AI-lt, kuidas vormingut
-- enne unikaalsete väärtuste leidmist ühtlustada.
-- Selle põhjal kasutasin LOWER() ja TRIM() funktsioone:
-- LOWER ühtlustab suur- ja väiketähed ning TRIM eemaldab liigsed tühikud.

SELECT COUNT(DISTINCT LOWER(TRIM(city))) AS unikaalseid_linnu
FROM customers;

-- Tulemus: pärast vormingu ühtlustamist oli 12 unikaalset linna.

-- Kontrollisin, kui paljudel klientidel on e-mail olemas,
-- kui palju on unikaalseid e-maile ja kas andmetes esineb duplikaate.

select 
  count(*) AS kliente_kokku,
  count(*) - count(email) as puuduvad_emailid,
  count(email) as emaile_olemas,
  count(distinct email) as unikaalseid_emaile,
  count(email) - count(distinct email) as duplikaadid
from customers;

-- Tulemus:
-- kliente kokku 3150
-- e-mail olemas 2770 kliendil
-- e-mail puudub 380 kliendil
-- unikaalseid e-maile 2640
-- duplikaatide vahe 130

- Kontrollisin, kas klientide andmetes esineb puuduvaid eesnimesid.

SELECT COUNT(*) - COUNT(first_name) AS puuduvad_eesnimed
FROM customers;

-- Tulemus: puuduvaid eesnimesid ei olnud, tulemus 0.

-- Kontrollisin kõige varasemat ja kõige hilisemat kliendi registreerimiskuupäeva.

SELECT
    MIN(registration_date) AS vanim,
    MAX(registration_date) AS uusim
FROM customers;

-- Tulemus:
-- kõige varasem registreerimine oli 2020-01-02
-- kõige hilisem registreerimine oli 2025-02-27.
