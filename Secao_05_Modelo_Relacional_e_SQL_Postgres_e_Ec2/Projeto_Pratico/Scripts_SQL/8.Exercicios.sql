/*
Crie as seguintes consulta:
    - Compras de um cliente específico
    - Campos: Nome do cliente, produto, quantidade, valor total, data da venda
    - Filtros: Código do cliente
*/
SELECT
    clientes.cliente
  , produtos.produto
  , itensvenda.quantidade
  , itensvenda.valortotal
  , vendas.data
FROM
    relacional.vendas AS vendas
INNER JOIN
    relacional.clientes AS clientes
ON
    (vendas.idcliente = clientes.idcliente)
INNER JOIN
    relacional.itensvenda AS itensvenda
ON
    (vendas.idvenda = itensvenda.idvenda)
INNER JOIN
    relacional.produtos AS produtos
ON
    (itensvenda.idproduto = produtos.idproduto)
WHERE
    clientes.idcliente = 1;


/*
Lista dos 5 melhores/piores vendedores (2 consultas)
    - Campos: Nome do vendedor, total de vendas
    - Agrupado por vendedor
    - Ordenado por total de vendas
*/
SELECT
    vendedores.nome
  , COUNT(vendas.idvenda) AS totalvendas
FROM
    relacional.vendas AS vendas
INNER JOIN
    relacional.vendedores AS vendedores
ON
    (vendas.idvendedor = vendedores.idvendedor)
GROUP BY
    vendedores.nome
ORDER BY
    totalvendas DESC
LIMIT 5;


SELECT
    vendedores.nome
  , COUNT(vendas.idvenda) AS totalvendas
FROM
    relacional.vendas AS vendas
INNER JOIN
    relacional.vendedores AS vendedores
ON
    (vendas.idvendedor = vendedores.idvendedor)
GROUP BY
    vendedores.nome
ORDER BY
    totalvendas ASC
LIMIT 5;


/*
Total de vendas em período
    - Produto, total de vendas
    - Agrupado por produto
    - Filtro de mês e ano
*/
SELECT
    produtos.produto
  , COUNT(itensvenda.idvenda) AS totalvendas
FROM
    relacional.vendas AS vendas
INNER JOIN
    relacional.itensvenda AS itensvenda
ON
    (vendas.idvenda = itensvenda.idvenda)
INNER JOIN
    relacional.produtos AS produtos
ON
    (itensvenda.idproduto = produtos.idproduto)
WHERE
    EXTRACT(MONTH FROM vendas.data) = 1
AND
    EXTRACT(YEAR FROM vendas.data) = 2023
GROUP BY
    produtos.produto;


/*
Produtos com maiores valores
    - Produto, vendedor, total de descontos
    - Agrupado por produto
*/
SELECT
    produtos.produto
  , vendedores.nome
  , SUM(itensvenda.desconto) AS totaldescontos
FROM
    relacional.vendas AS vendas
INNER JOIN
    relacional.itensvenda AS itensvenda
ON
    (vendas.idvenda = itensvenda.idvenda)
INNER JOIN
    relacional.produtos AS produtos
ON
    (itensvenda.idproduto = produtos.idproduto)
INNER JOIN
    relacional.vendedores AS vendedores
ON
    (vendas.idvendedor = vendedores.idvendedor)
GROUP BY
    produtos.produto
  , vendedores.nome
ORDER BY
    totaldescontos DESC;
