# Week 2 – Sales Data Cleaning Report

## Eesmärk

Kontrollida sales tabeli andmekvaliteeti ja tuvastada võimalikud probleemid enne andmete kasutamist analüüsis.

Töö tegin sales_test tabelis, et säilitada algne sales tabel muutmata kujul.

## 1. Algandmete kontroll
- sales tabeli ridade arv: 15 234
- sales_test tabeli ridade arv: 15 234

Testtabelis oli sama arv ridu kui algses tabelis.

## 2. Duplikaatide kontroll

Duplikaate kontrollisin invoice_id alusel.

### Tulemus

GROUP BY ja HAVING COUNT(*) > 1 kontrolliga leidsin 5116 invoice_id väärtust, millel esines rohkem kui üks müügirida.

Kontrollisin lähemalt ühte invoice_id, millel oli 6 rida. Kõik 6 rida ei olnud identsed: ühel juhul oli customer_id NULL ja teisel juhul erines unit_price.

Tegelikkuses tuleks duplikaatide tuvastamisel kontrollida ka teiste väljade kombinatsioone, kuid õppimise eesmärgil lähtusin ülesandes invoice_id duplikaatide kontrollist.

## 3. NULL-väärtuste kontroll

Kontrollisin NULL-väärtusi müügiandmete olulisemates väljades.

### Tulemus
- customer_id: 1487 NULL-väärtust
- product_id: 0
- quantity: 0
- unit_price: 0
- sale_date: 0

customer_id NULL ei tähenda automaatselt viga, sest osa müüke võib olla tehtud tuvastamata kliendile.

NULL-väärtuste koondkontrolli FILTER funktsiooniga tegin AI abil. Ise oskan NULL-väärtusi kontrollida ükshaaval IS NULL tingimusega.

## 4. Quantity kontroll

Kontrollisin, kas quantity sisaldab väärtusi 0 või alla selle.

### Tulemus

Leitud ridu: 0.

Kõik quantity väärtused olid suuremad kui 0.

## 5. Unit price kontroll

Kontrollisin, kas unit_price sisaldab väärtusi 0 või alla selle.

### Tulemus

Leitud ridu: 0.

Kõik unit_price väärtused olid suuremad kui 0.

## 6. Kuupäevade kontroll

Kontrollisin müügiandmete kuupäevavahemikku.

### Tulemus
- varaseim sale_date: 01.01.2023
- hiliseim sale_date: 28.06.2026

Õppematerjali järgi peaks analüüsitav müügiperiood lõppema 28.02.2025.

Pärast 28.02.2025 oli andmetes 50 müügirida.

Lisaks kontrollisin, kas andmetes on tänasest hilisemaid kuupäevi või kuupäevi enne 01.01.2020. Selliseid ridu ei olnud.

## 7. Kokkuvõte

### Peamised leiud
- invoice_id põhise kontrolliga tuvastasin 5116 eemaldatavat korduvat müügirida.
- customer_id oli NULL 1487 real, kuid jaemüügi kontekstis ei tähenda see automaatselt andmeviga, sest osa oste võib olla tehtud tuvastamata kliendile.
- quantity ja unit_price väärtustes ei leidunud 0 ega negatiivseid väärtusi ning teistes kontrollitud väljades NULL-väärtusi ei olnud.
- 50 müügirida olid pärast andmestiku lubatud lõppkuupäeva 28.02.2025.

### Puhastamisel tehtud tegevused
- Eemaldasin 5116 korduvat müügirida, jättes iga invoice_id kohta alles väikseima id väärtusega rea.
- Pärast duplikaatide eemaldamist vähenes sales_test ridade arv 15 234 realt 10 118 reale.
- customer_id NULL-väärtusi ei muutnud, sest need võivad olla äriliselt korrektsed.
  
### Analüüsist välja jäetud andmed
- 50 müügirida kuupäevaga pärast 28.02.2025 jäid sales_test tabelisse alles, kuid need tuleb analüüsist kuupäevafiltriga välja jätta.
- Muude kontrollide põhjal ei tuvastanud ma andmeid, mida oleks vaja analüüsist välja jätta.
