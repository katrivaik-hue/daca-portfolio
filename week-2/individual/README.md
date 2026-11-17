# Roll A ülesandes kontrollisin ja puhastasin sales tabeli müügiandmeid.

## Kontrollisin:

- duplikaatseid invoice_id väärtusi
- NULL-väärtusi
- quantity ja unit_price väärtusi
- sale_date kuupäevade korrektsust

Puhastamiseks lõin esmalt sales_test testkoopia, mille peal kontrollisin puhastusloogika tulemust.

## Peamised tulemused
- Algandmetes oli 15 234 müügirida.
- Duplikaatide puhastamisel eemaldati 5 116 üleliigset rida.
- Pärast puhastamist jäi alles 10 118 müügirida.
- customer_id väljal oli 1 487 NULL-väärtust. Neid ei käsitlenud automaatselt veana, sest osa jaemüüke võib olla tehtud tuvastamata kliendile.
- quantity ja unit_price väljadel ei leidunud 0 ega negatiivseid väärtusi.
- 50 müügirida olid hilisemad kui andmestiku lubatud lõppkuupäev 28.02.2025. Need jäid andmetesse alles, kuid tuleb analüüsist välja filtreerida.
- Pärast testimist rakendasin sama duplikaatide puhastamise ka sales tabelile. Lõplik ridade arv oli 10 118.

## Failid
- [week2_sales_cleaning.sql](week2_sales_cleaning.sql)
- [week2_sales_report.md](week2_sales_report.md)
