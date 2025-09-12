--CARREGAR OS DADOS DE CLIENTES (1ª CARGA)
WITH S AS (
     SELECT * FROM Relacional.Clientes ORDER BY idcliente
),
UPD AS (
     UPDATE Dimensional.DimensaoCliente T
     SET    DataFimValidade = CURRENT_DATE
     FROM   S
     WHERE  (T.IDCliente = S.IDCliente AND T.DataFimValidade IS NULL) 
    		AND (T.CLIENTE <> S.CLIENTE OR T.ESTADO <> S.ESTADO OR T.SEXO <> S.SEXO OR T.STATUS <> S.STATUS)
     RETURNING T.IDCLIENTE
)
INSERT INTO Dimensional.DimensaoCliente(IDCliente, Cliente, Estado, Sexo, Status, DataInicioValidade, DataFimValidade)
SELECT IDCliente, Cliente, Estado, Sexo, Status, CURRENT_DATE, NULL FROM S
WHERE S.IDCliente IN (SELECT IDCliente FROM UPD) OR
	  S.IDCliente NOT IN (SELECT IDCliente FROM Dimensional.DimensaoCliente);


SELECT
    *
FROM
    dimensional.dimensaocliente;


--CARREGAR OS DADOS DE PRODUTOS (1ª CARGA)
WITH S AS (
     SELECT * FROM Relacional.Produtos
),
UPD AS (
     UPDATE Dimensional.DimensaoProduto T
     SET    DataFimValidade = CURRENT_DATE
     FROM   S
     WHERE  (T.IDProduto = S.IDProduto AND T.DataFimValidade IS NULL) 
    		AND (T.Produto <> S.Produto)
     RETURNING T.IDProduto
)
INSERT INTO Dimensional.DimensaoProduto(IDProduto, Produto, DataInicioValidade, DataFimValidade)
SELECT IDProduto, Produto, CURRENT_DATE, NULL FROM S
WHERE S.IDProduto IN (SELECT IDProduto FROM UPD) OR
	  S.IDProduto NOT IN (SELECT IDProduto FROM Dimensional.DimensaoProduto);
	  
--VERIFICAMOS A CARGA
SELECT
    *
FROM
    Dimensional.dimensaoProduto;


--CARREGAR OS DADOS DE VENDEDORES (1ª CARGA)
WITH S AS (
     SELECT * FROM Relacional.Vendedores
),
UPD AS (
     UPDATE Dimensional.DimensaoVendedor T
     SET    DataFimValidade = CURRENT_DATE
     FROM   S
     WHERE  (T.IDVendedor = S.IDVendedor AND T.DataFimValidade IS NULL) 
    		AND (T.Nome <> S.Nome)
     RETURNING T.IDVendedor
)
INSERT INTO Dimensional.DimensaoVendedor(IDVendedor, Nome, DataInicioValidade, DataFimValidade)
SELECT IDVendedor, Nome, CURRENT_DATE, NULL FROM S
WHERE S.IDVendedor IN (SELECT IDVendedor FROM UPD) OR
	  S.IDVendedor NOT IN (SELECT IDVendedor FROM Dimensional.DimensaoVendedor);


--VERIFICAMOS A CARGA
SELECT 
    * 
FROM 
    dimensional.dimensaovendedor;


--CARREGA SOMENTE O MÊS DE JANEIRO NA FATO VENDAS
INSERT INTO dimensional.fatovendas(chavevendedor, chavecliente, chaveproduto, chavetempo, quantidade, valorunitario, valortotal, desconto)
SELECT
	Vdd.ChaveVendedor
  , C.ChaveCliente
  , P.ChaveProduto
  , T.ChaveTempo
  , IV.Quantidade
  , IV.ValorUnitario
  , IV.ValorTotal
  , IV.Desconto
FROM Relacional.Vendas V
INNER JOIN Dimensional.DimensaoVendedor Vdd
	ON V.IDVendedor = Vdd.IDVendedor AND Vdd.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Vendedor para a carga da fato no momento*/
INNER JOIN Relacional.ItensVenda IV
	ON V.IDVenda = IV.IDVenda
INNER JOIN Dimensional.DimensaoCliente C
	ON V.IDCliente = C.IDCliente AND C.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Cliente para a carga da fato no momento*/
INNER JOIN Dimensional.DimensaoProduto P
	ON IV.IDProduto = P.IDProduto AND P.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Produto para a carga da fato no momento*/
INNER JOIN Dimensional.DimensaoTempo T
	ON V.Data = T.Data
Where DATE_PART('MONTH', V.DATA) = 01;


--VERIFICAMOS A FATO
SELECT
    *
FROM
    dimensional.fatovendas;


-- Verificamos o status dos clientes 1 até 5 -RELACIONAL
SELECT
    status
FROM
    relacional.clientes
WHERE
    IDCLIENTE BETWEEN 1 AND 5;


-- FAZ UMA ALTERAÇÃO DE PLANO DOS CLIENTES DE ID 1 A 5 - RELACIONAL
UPDATE
    RELACIONAL.CLIENTES
SET
    STATUS = 'Gold'
WHERE
    IDCLIENTE BETWEEN 1 AND 5;


--RECARREGAR A DIMENSAO CLIENTE. SÓ FARÁ TRATAMENTO DE HISTÓRICO NOS REGISTROS ALTERADOS (CLIENTES DE ID 1 A 5);
WITH S AS (
     SELECT * FROM Relacional.Clientes
),
UPD AS (
     UPDATE Dimensional.DimensaoCliente T
     SET    DataFimValidade = CURRENT_DATE
     FROM   S
     WHERE  (T.IDCliente = S.IDCliente AND T.DataFimValidade IS NULL) 
    		AND (T.CLIENTE <> S.CLIENTE OR T.ESTADO <> S.ESTADO OR T.SEXO <> S.SEXO OR T.STATUS <> S.STATUS)
     RETURNING T.IDCLIENTE
)
INSERT INTO Dimensional.DimensaoCliente(IDCliente, Cliente, Estado, Sexo, Status, DataInicioValidade, DataFimValidade)
SELECT IDCliente, Cliente, Estado, Sexo, Status, CURRENT_DATE, NULL FROM S
WHERE S.IDCliente IN (SELECT IDCliente FROM UPD) OR
	  S.IDCliente NOT IN (SELECT IDCliente FROM Dimensional.DimensaoCliente);


--CONSULTA OS CLIENTES ALTERADOS PARA VERIFICAR O HISTÓRICO DE CADA CLIENTE. CAMPOS DE DATA FORAM ATUALIZADOS
SELECT
    *
FROM
    DIMENSIONAL.DIMENSAOCLIENTE
WHERE
    IDCLIENTE BETWEEN 1 AND 5;


--VERIFICA QUE OS CLIENTES DA CARGA DA FATO REFERENTE À JANEIRO ESTÃO APONTANDO PARA AS SKs ANTIGAS DOS CLIENTES DE 1,2,3 e 5
--POIS A CARGA DA FATO FOI FEITA ANTES 
SELECT
    f.chavecliente
  , c.cliente
FROM
    dimensional.fatovendas f
INNER JOIN
        dimensional.dimensaocliente c
ON
    f.chavecliente = c.chavecliente
WHERE
    c.idcliente BETWEEN 1 AND 5;


--CARREGA SOMENTE O MÊS DE FEVEREIRO NA FATO VENDAS
INSERT INTO dimensional.fatovendas(chavevendedor, chavecliente, chaveproduto, chavetempo, quantidade, valorunitario, valortotal, desconto)
SELECT
	Vdd.ChaveVendedor
  , C.ChaveCliente
  , P.ChaveProduto
  , T.ChaveTempo
  , IV.Quantidade
  , IV.ValorUnitario
  , IV.ValorTotal
  , IV.Desconto
FROM Relacional.Vendas V
INNER JOIN Dimensional.DimensaoVendedor Vdd
	ON V.IDVendedor = Vdd.IDVendedor AND Vdd.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Vendedor para a carga da fato no momento*/
INNER JOIN Relacional.ItensVenda IV
	ON V.IDVenda = IV.IDVenda
INNER JOIN Dimensional.DimensaoCliente C
	ON V.IDCliente = C.IDCliente AND C.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Cliente para a carga da fato no momento*/
INNER JOIN Dimensional.DimensaoProduto P
	ON IV.IDProduto = P.IDProduto AND P.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Produto para a carga da fato no momento*/
INNER JOIN Dimensional.DimensaoTempo T
	ON V.Data = T.Data
WHERE DATE_PART('MONTH', V.DATA) = 02;


--VERIFICA QUE OS CLIENTES DA CARGA DA FATO REFERENTE À JANEIRO ESTÃO APONTANDO PARA AS SKs ANTIGAS DOS CLIENTES DE 1 A 5. EM FEVEREIRO SOMENTE O CLIENTE 5 REALIZOU COMPRAS.
--OS REGISTROS DA FATO JÁ APONTAM PARA A ÚLTIMA SK DO CLIENTE
SELECT
    f.valortotal
  , t.data
  , f.chavecliente
  , c.idcliente
  , c.cliente
FROM
    dimensional.fatovendas f
INNER JOIN
    dimensional.dimensaocliente c
ON
    f.chavecliente = c.chavecliente
INNER JOIN
    dimensional.dimensaotempo t
ON
    f.chavetempo = t.chavetempo
WHERE 
    c.idcliente BETWEEN 1 AND 5;


 --CARREGA SOMENTE O MÊS DE MARÇO NA FATO VENDAS
INSERT INTO dimensional.fatovendas(chavevendedor, chavecliente, chaveproduto, chavetempo, quantidade, valorunitario, valortotal, desconto)
SELECT
	Vdd.ChaveVendedor
  , C.ChaveCliente
  , P.ChaveProduto
  , T.ChaveTempo
  , IV.Quantidade
  , IV.ValorUnitario
  , IV.ValorTotal
  , IV.Desconto
FROM Relacional.Vendas V
INNER JOIN Dimensional.DimensaoVendedor Vdd
	ON V.IDVendedor = Vdd.IDVendedor AND Vdd.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Vendedor para a carga da fato no momento*/
INNER JOIN Relacional.ItensVenda IV
	ON V.IDVenda = IV.IDVenda
INNER JOIN Dimensional.DimensaoCliente C
	ON V.IDCliente = C.IDCliente AND C.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Cliente para a carga da fato no momento*/
INNER JOIN Dimensional.DimensaoProduto P
	ON IV.IDProduto = P.IDProduto AND P.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Produto para a carga da fato no momento*/
INNER JOIN Dimensional.DimensaoTempo T
	ON V.Data = T.Data
WHERE DATE_PART('MONTH', V.DATA) = 03;

--EM MARÇO NENHUM DOS CLIENTES QUE ESTAMOS MAPEANDO (1 A 5) FEZ COMPRAS.
SELECT
    *
FROM
    dimensional.fatovendas f
INNER JOIN
    dimensional.dimensaocliente c
ON
    f.chavecliente = c.chavecliente
INNER JOIN
    dimensional.dimensaotempo t
ON
    f.chavetempo = t.chavetempo
WHERE
    c.idcliente BETWEEN 1 AND 5 AND t.mes = 3;


--FAZ UMA ALTERAÇÃO NO PLANO DO CLIENTE 3
UPDATE
    RELACIONAL.CLIENTES
SET
    STATUS = 'Platinum'
WHERE
    IDCLIENTE = 3;


--CARREGAR OS DADOS DE CLIENTES. SÓ FARÁ TRATAMENTO DE HISTÓRICO NOS REGISTROS ALTERADOS (CLIENTE 3)
WITH S AS (
     SELECT * FROM Relacional.Clientes
),
UPD AS (
     UPDATE Dimensional.DimensaoCliente T
     SET    DataFimValidade = CURRENT_DATE
     FROM   S
     WHERE  (T.IDCliente = S.IDCliente AND T.DataFimValidade IS NULL) 
    		AND (T.CLIENTE <> S.CLIENTE OR T.ESTADO <> S.ESTADO OR T.SEXO <> S.SEXO OR T.STATUS <> S.STATUS)
     RETURNING T.IDCLIENTE
)
INSERT INTO Dimensional.DimensaoCliente(IDCliente, Cliente, Estado, Sexo, Status, DataInicioValidade, DataFimValidade)
SELECT IDCliente, Cliente, Estado, Sexo, Status, CURRENT_DATE, NULL FROM S
WHERE S.IDCliente IN (SELECT IDCliente FROM UPD) OR
	  S.IDCliente NOT IN (SELECT IDCliente FROM Dimensional.DimensaoCliente);


--CONSULTA OS CLIENTES ALTERADOS PARA VERIFICAR O HISTÓRICO DE CADA CLIENTE. CAMPOS DE DATA FORAM ATUALIZADOS
SELECT
    *
FROM
    DIMENSIONAL.DIMENSAOCLIENTE
WHERE
    IDCLIENTE BETWEEN 1 AND 5;


 --CARREGA SOMENTE OS OUTROS MESES
INSERT INTO dimensional.fatovendas(chavevendedor, chavecliente, chaveproduto, chavetempo, quantidade, valorunitario, valortotal, desconto)
SELECT
	Vdd.ChaveVendedor
  , C.ChaveCliente
  , P.ChaveProduto
  , T.ChaveTempo
  , IV.Quantidade
  , IV.ValorUnitario
  , IV.ValorTotal
  , IV.Desconto
FROM Relacional.Vendas V
INNER JOIN Dimensional.DimensaoVendedor Vdd
	ON V.IDVendedor = Vdd.IDVendedor AND Vdd.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Vendedor para a carga da fato no momento*/
INNER JOIN Relacional.ItensVenda IV
	ON V.IDVenda = IV.IDVenda
INNER JOIN Dimensional.DimensaoCliente C
	ON V.IDCliente = C.IDCliente AND C.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Cliente para a carga da fato no momento*/
INNER JOIN Dimensional.DimensaoProduto P
	ON IV.IDProduto = P.IDProduto AND P.DataFimValidade IS NULL /*DataFimValidade IS NULL representa o registro atual do Produto para a carga da fato no momento*/
INNER JOIN Dimensional.DimensaoTempo T
	ON V.Data = T.Data
WHERE DATE_PART('MONTH', V.DATA) > 03;

--VERIFICA TODAS AS COMPRAS DOS CLIENTES QUE ESTAMOS MAPEANDO (1 A 5). VERIFICAMOS QUE HAVIA COMPRAS COM A SK ANTIGA E AGORA HÁ COMPRAS FEITAS COM O ÚLTIMO STATUS (SK NOVA)
SELECT
    f.valortotal
  , t.data
  , f.chavecliente
  , c.idcliente
  , c.cliente
FROM
    dimensional.fatovendas f
INNER JOIN
    dimensional.dimensaocliente c
ON
    f.chavecliente = c.chavecliente
INNER JOIN
    dimensional.dimensaotempo t
ON
    f.chavetempo = t.chavetempo
WHERE
    c.idcliente BETWEEN 1 AND 5;