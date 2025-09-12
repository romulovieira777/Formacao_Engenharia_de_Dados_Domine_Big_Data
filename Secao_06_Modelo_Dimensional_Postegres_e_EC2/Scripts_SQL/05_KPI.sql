--CRIAMOS UMA TABELA PARA KPI
SELECT 
     dimensional.dimensaotempo.mes           AS Mes
   , SUM( dimensional.fatovendas.valortotal) AS Realizado
INTO
    dimensional.KPI
FROM
    ( dimensional.fatovendas
   INNER JOIN dimensional.dimensaotempo
       ON (dimensional.dimensaotempo.chavetempo = dimensional.fatovendas.chavetempo))
GROUP BY dimensional.dimensaotempo.mes
ORDER BY dimensional.dimensaotempo.mes;


--ADICIONA UMA COLUNA META
ALTER TABLE
    dimensional.KPI
ADD COLUMN
    Meta numeric;


--ADICIONAMOS METAS POR MES
UPDATE dimensional.KPI SET Meta = 220000 WHERE Mes =1;
UPDATE dimensional.KPI SET Meta = 220000 WHERE Mes =2;
UPDATE dimensional.KPI SET Meta = 230000 WHERE Mes =3;
UPDATE dimensional.KPI SET Meta = 235000 WHERE Mes =4;
UPDATE dimensional.KPI SET Meta = 240000 WHERE Mes =5;
UPDATE dimensional.KPI SET Meta = 250000 WHERE Mes =6;
UPDATE dimensional.KPI SET Meta = 255000 WHERE Mes =7;
UPDATE dimensional.KPI SET Meta = 260000 WHERE Mes =8;
UPDATE dimensional.KPI SET Meta = 262500 WHERE Mes =9;
UPDATE dimensional.KPI SET Meta = 265000 WHERE Mes =10;
UPDATE dimensional.KPI SET Meta = 267000 WHERE Mes =11;
UPDATE dimensional.KPI SET Meta = 270000 WHERE Mes =12;

