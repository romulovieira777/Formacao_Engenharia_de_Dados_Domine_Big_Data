--CONSULTA PADRÃO
SELECT
    *
FROM
    relacional.clientes;


--ATRIBUTOS ESPECIFICIOS E CLAUSULA WHERE
SELECT
    clientes
  , sexo
  , status
FROM
    relacional.clientes
WHERE
    status = 'Silver';


--USO DE "OR"
SELECT
    clientes
  , sexo
  , status
FROM
    relacional.clientes
WHERE
    status = 'Silver'
OR
    status = 'Platinum';


--USO DE "IN"
SELECT
    clientes
  , sexo
  , status
FROM
    relacional.clientes
WHERE
    status IN('Silver','Platinum');


--USO DE NOT
SELECT
    clientes
  , sexo
  , status
FROM
    relacional.clientes
WHERE
    status NOT IN('Silver','Platinum');


--USO DE LIKE
SELECT
    clientes
  , sexo
  , status
FROM
    relacional.clientes
WHERE
    cliente LIKE '%Alb%';


-- TRAZENDO UMA TUPLA
SELECT
    clientes
  , sexo
  , status
FROM
    relacional.clientes
LIMIT 1;


-- TRAZENDO SEM TUPLA
SELECT
    cliente
  , sexo
  , status
FROM
    relacional.clientes
LIMIT 1;


-- VERIFICANDO A TABELA VENDAS
SELECT
    *
FROM
    relacional.vendas
LIMIT 1;


-- OPERADORES DE COMPARAÇÃO
SELECT
    *
FROM
    relacional.vendas
WHERE
    total > 6000;


-- USANDO O AND
SELECT
    *
FROM
    relacional.vendas
WHERE
    total > 6000
AND
    total < 8000;


-- BETWEEN
SELECT
    *
FROM
    relacional.vendas
WHERE
    total BETWEEN 6000 AND 8000;


--AGREGAÇÃO
SELECT
    COUNT(*)
FROM
    relacional.vendas;


--AGREGAÇÃO COM WHERE
SELECT
    COUNT(*)
FROM
    relacional.vendas
WHERE
    total >= 6000;


-- USANDO O LIMIT
SELECT
    *
FROM
    relacional.vendas
LIMIT 1;


--AGRUPANDO contando quantas vendas o vendedor teve
SELECT
    idvendedor
  , COUNT(idvendedor)
FROM
    relacional.vendas
GROUP BY
    idvendedor;


--TOTAL DE VENDAS POR VENDEDOR
SELECT
    idvendedor
  , SUM(total)
FROM
    relacional.vendas
GROUP BY
    idvendedor;


--TOTAL DE VENDAS POR VENDEDOR
SELECT
    idvendedor
  , SUM(total)
FROM
    relacional.vendas
WHERE
    idvendedor = 1
GROUP BY
    idvendedor;


-- DISTINCT
SELECT
    DISTINCT status
FROM
    relacional.clientes;


-- VERIFICANDO A TABELA CLIENTES
SELECT
    *
FROM
    relacional.clientes
LIMIT 1;


--INSERT
INSERT INTO relacional.clientes(idcliente, cliente, estado, sexo, status)
VALUES (251, 'Fernando Amaral', 'RS', 'M', 'Silver');


--SELECT
SELECT
    *
FROM
    relacional.clientes
WHERE
    idcliente = 251;


--UPDATE
UPDATE
        relacional.clientes
SET
    estado='MS', status='Platinum'
WHERE
    idcliente = 251;


--SELECT
SELECT
    *
FROM
    relacional.clientes
WHERE
    idcliente = 251;


--DELETE
DELETE FROM
           relacional.clientes
WHERE
    idcliente = 251;


--SELECT
SELECT
    *
FROM
    relacional.clientes
WHERE
    idcliente = 251;


--CONTROLE DE TRANSAÇÕES    
--INICIA TRANSAÇÃO
BEGIN;
INSERT INTO relacional.clientes(
	idcliente, cliente, estado, sexo, status)
	VALUES (251, 'Fernando Amaral', 'RS', 'M', 'Silver');


--VERIFICAMOS QUE O REGISTRO ENCONTRA-SE NO BD
SELECT
    *
FROM
    relacional.clientes
WHERE
    idcliente = 251;

-- Rollback
ROLLBACK;


--COMMIT
COMMIT;


--VERIFICAMOS QUE O REGISTRO NÃO SE ENCONTRA MAIS NO BD
SELECT
    *
FROM
    relacional.clientes
WHERE
    idcliente = 251;


--INNER JOINS
--TEMOS 10 VENDEDORES
SELECT
    COUNT(*)
FROM
    relacional.vendedores;


--TEMOS 400 VENDAS
SELECT
    COUNT(*)
FROM
    relacional.vendas ;


--INNER JOIN DEVE RETORNAR 400, POIS TODA VENDA TEM UM VENDEDOR
SELECT
    COUNT(*)
FROM
    relacional.vendas AS vendas
INNER JOIN
    relacional.vendedores AS vendedores
ON
    (vendas.idvendedor = vendedores.idvendedor );


--LEFT JOIN DEVE RETORNAR 400, POIS TODA VENDA TEM VENDEDOR
SELECT
    COUNT(*)
FROM
    relacional.vendas AS vendas
LEFT JOIN
    relacional.vendedores AS vendedores
ON
    (vendas.idvendedor = vendedores.idvendedor );


--RIGHT JOIN DEVE RETORNAR 400
SELECT
    COUNT(*)
FROM
    relacional.vendas AS vendas
RIGHT JOIN
    relacional.vendedores AS vendedores
ON
    (vendas.idvendedor = vendedores.idvendedor );

--INSERE NOVOS VENDEDORES
INSERT INTO Relacional.vendedores(nome) VALUES ('Fernando Amaral');


--RIGHT JOIN DEVE RETORNAR 401 POIS TEMOS 1 VENDEDORES SEM VENDAS
SELECT
    COUNT(*)
FROM
    relacional.vendas AS vendas
RIGHT JOIN
    relacional.vendedores AS vendedores
ON
    (vendas.idvendedor = vendedores.idvendedor );


SELECT
    nome
  , data
  , total
FROM
    relacional.vendas as vendas
INNER JOIN
    relacional.vendedores AS vendedores
ON
    (vendas.idvendedor = vendedores.idvendedor );


SELECT
    nome AS vendedor
  , cliente
  , data
  , total
FROM
    relacional.vendas AS vendas
INNER JOIN
    relacional.vendedores AS vendedores
ON
    (vendas.idvendedor = vendedores.idvendedor )
INNER JOIN
    relacional.clientes AS clientes
ON
    (vendas.idcliente = clientes.idcliente );


SELECT
    vendedores.nome
  , SUM(total)
FROM relacional.vendas AS vendas
INNER JOIN
    relacional.vendedores AS vendedores
ON
    (vendas.idvendedor = vendedores.idvendedor )
GROUP BY
    vendedores.nome;
