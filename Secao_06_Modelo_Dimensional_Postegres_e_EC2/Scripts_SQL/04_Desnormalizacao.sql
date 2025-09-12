SELECT
    dimensional.dimensaocliente.cliente
  , dimensional.dimensaocliente.estado
  , dimensional.dimensaocliente.sexo
  , dimensional.dimensaocliente.status
  , dimensional.fatovendas.quantidade
  , dimensional.fatovendas.valorunitario
  , dimensional.fatovendas.valortotal
  , dimensional.fatovendas.desconto
  , dimensional.dimensaoproduto.produto
  , dimensional.dimensaotempo.data
  , dimensional.dimensaotempo.dia
  , dimensional.dimensaotempo.mes
  , dimensional.dimensaotempo.ano
  , dimensional.dimensaotempo.trimestre
  , dimensional.dimensaovendedor.nome
INTO
    dimensional.des_vendas
FROM
    ((((dimensional.dimensaocliente
INNER JOIN dimensional.fatovendas
     ON (dimensional.fatovendas.chavecliente = dimensional.dimensaocliente.chavecliente))
INNER JOIN dimensional.dimensaoproduto
     ON (dimensional.dimensaoproduto.chaveproduto = dimensional.fatovendas.chaveproduto))
INNER JOIN dimensional.dimensaotempo
     ON (dimensional.dimensaotempo.chavetempo = dimensional.fatovendas.chavetempo))
INNER JOIN dimensional.dimensaovendedor
     ON (dimensional.dimensaovendedor.chavevendedor = dimensional.fatovendas.chavevendedor));


SELECT
    *
FROM
    dimensional.des_vendas;
