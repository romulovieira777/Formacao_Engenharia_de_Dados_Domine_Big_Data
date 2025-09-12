CREATE SCHEMA Dimensional;

CREATE SEQUENCE Dimensional.ChaveVendedor;

CREATE TABLE Dimensional.DimensaoVendedor (
    ChaveVendedor INT DEFAULT NEXTVAL('Dimensional.ChaveVendedor'::regclass) PRIMARY KEY
  , IDVendedor INT
  , Nome VARCHAR(50)
  , DataInicioValidade DATE NOT NULL
  , DataFimValidade DATE
);

CREATE SEQUENCE Dimensional.ChaveCliente;

CREATE TABLE Dimensional.DimensaoCliente (
    ChaveCliente INT DEFAULT NEXTVAL('Dimensional.ChaveCliente'::regclass) PRIMARY KEY
  , IDCliente INT
  , Cliente VARCHAR(50)
  , Estado VARCHAR(2)
  , Sexo CHAR(1)
  , Status VARCHAR(50)
  , DataInicioValidade DATE NOT NULL
  , DataFimValidade DATE
);

CREATE SEQUENCE Dimensional.ChaveProduto;

CREATE TABLE Dimensional.DimensaoProduto (
    ChaveProduto INT DEFAULT NEXTVAL('Dimensional.ChaveProduto'::regclass) PRIMARY KEY
  , IDProduto INT
  , Produto VARCHAR(100)
  , DataInicioValidade DATE NOT NULL
  , DataFimValidade DATE
);

CREATE SEQUENCE Dimensional.ChaveTempo;

CREATE TABLE Dimensional.DimensaoTempo (
    ChaveTempo INT DEFAULT NEXTVAL('Dimensional.ChaveTempo'::regclass) PRIMARY KEY
  , Data DATE
  , Dia INT
  , Mes INT
  , Ano INT
  , DiaSemana INT
  , Trimestre INT
);

CREATE SEQUENCE Dimensional.ChaveVendas;

CREATE TABLE Dimensional.FatoVendas (
    ChaveVendas INT DEFAULT NEXTVAL('Dimensional.ChaveVendas'::regclass) PRIMARY KEY
  , ChaveVendedor INT REFERENCES Dimensional.DimensaoVendedor (ChaveVendedor)
  , ChaveCliente INT REFERENCES Dimensional.DimensaoCliente (ChaveCliente)
  , ChaveProduto INT REFERENCES Dimensional.DimensaoProduto (ChaveProduto)
  , ChaveTempo INT REFERENCES Dimensional.DimensaoTempo (ChaveTempo)
  , Quantidade INT
  , ValorUnitario NUMERIC(10,2)
  , ValorTotal NUMERIC(10,2)
  , Desconto NUMERIC(10,2)
);
