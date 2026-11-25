--Grupitöö osa.

-- Vaata, millised müügikanalid on olemas    

SELECT DISTINCT channel FROM sales ORDER BY channel;

--on 2 kanalit - online ja pood.

-- Milline kanal toob enim müüke?    

SELECT        
s.channel AS müügikanal,        
COUNT(DISTINCT s.customer_id) AS kliente,        
COUNT(s.sale_id) AS oste,        
SUM(s.total_price) AS kogumüük    
FROM sales s    
GROUP BY s.channel    
ORDER BY kogumüük DESC;    

--pood, oste 6656 kogumüügiga 1902430,3 vs online 3462 ja 1006747,68

-- Millistest linnadest kliendid milliseid kanaleid kasutavad?    

SELECT        
s.channel AS müügikanal,        
c.city AS linn,        
COUNT(DISTINCT c.customer_id) AS kliente,        
SUM(s.total_price) AS kogumüük    
FROM sales s    
INNER JOIN customers c ON s.customer_id = c.customer_id    
GROUP BY s.channel, c.city    
ORDER BY müügikanal, kogumüük DESC;    

--online top 3 linn/kliente/müük tallinn 667 ja 335719,11, Tartu 345 ja 179175,44 ja Pärnu 188 ja 135423,94
--pood top 3 Tallinn 910 ja 670533,77, Tartu 461 ja 344111,2 ja pärnu 258 ja 238581,92

-- 3 tabeli JOIN: millised tooted müüvad millises kanalis?    

SELECT        
s.channel AS müügikanal,        
p.category AS tootekategooria,        
COUNT(DISTINCT c.customer_id) AS kliente,        
COUNT(s.sale_id) AS oste,        
SUM(s.total_price) AS kogumüük,        
ROUND(AVG(s.total_price), 2) AS keskmine_ost    
FROM sales s    INNER JOIN customers c ON s.customer_id = c.customer_id    
INNER JOIN products p ON s.product_id = p.product_id    
GROUP BY s.channel, p.category    
ORDER BY müügikanal, kogumüük DESC;

--Poes on müük suurem kui online-kanalis kõigis viies kategoorias.
--Näiteks:
--jalanõud: pood 440 060,24 vs online 248 820,61
--meeste riided: pood 447 173,58 vs online 233 375,66
--naiste riided: pood 408 066,19 vs online 215 503,09
--Ka klientide ja ostude arv on poes kõigis kategooriates suurem.

--Kanalite TOP-kategooria ei ole sama.
--Online-kanalis on suurima kogumüügiga jalanõud: 248 820,61
--Poes on suurima kogumüügiga meeste riided: 447 173,58

--Jalanõudel on mõlemas kanalis kõige suurem keskmine ost.
--online: 393,70
--pood: 371,67

--Lasteriided on mõlemas kanalis nõrgim kategooria müügisumma järgi.
--online: 94 330,66
--pood: 180 441,5
--Ka keskmine ost on lasteriietel mõlemas kanalis kõige väiksem

--Leia kõige efektiivsem kanal (müük per klient):
  
SELECT        
s.channel AS müügikanal,        
COUNT(DISTINCT s.customer_id) AS kliente,        
SUM(s.total_price) AS kogumüük,        
ROUND(SUM(s.total_price) / COUNT(DISTINCT s.customer_id), 2) AS müük_per_klient    
FROM sales s    
GROUP BY s.channel    
ORDER BY müük_per_klient DESC;    

--efektiivseim kanal müük per kleint on pood.

select count(*) from customers;

--Lisa kaupluste võrdlus: leia iga kaupluse müügikanalite jaotus

SELECT       
s.store_location AS kauplus,       
s.channel AS müügikanal,       
COUNT(s.sale_id) AS oste,       
SUM(s.total_price) AS kogumüük,       
ROUND(SUM(s.total_price) / COUNT(s.sale_id), 2) AS keskmine_ost   
FROM sales s   
GROUP BY s.store_location, s.channel   
ORDER BY kauplus, kogumüük DESC;

--poest on 2278 ostu ja onlineist 1706 ostu ehk 2/3 vs 1/3 poe kasuks
