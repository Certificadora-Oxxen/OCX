// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Versão             : 1
// *  Data               : 28/08/2004
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Pedido de Identificadores - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *
// ********************************************************************

unit uIntPedidosIdentificadores;

{$DEFINE MSSQL}

interface

uses Classes, DBTables, SysUtils, DB, uIntClassesBasicas, uLibZip, ZipUtils,
     uIntPedidoIdentificadores, uConexao, uIntMensagens, uFerramentas;

const
  Quebra: String = #$A;

type
  TPedidoIdentificador = class(TObject)
    private
       FConexao:                  TConexao;
       FMensagens:                TIntMensagens;
       FIntPedidoIdentificadores: TIntPedidoIdentificadores;
       FichaPedido:               TRelatorioPadrao;
       FIndNovaPagina:            Boolean;
       FArquivoZIP_PDF:           ZipFile;
       FArquivoZIP:               ZipFile;
       FNomeArquivoPdfZIP:        String;
       FNomeArquivoZIP:           String;
       FNomeArquivo:              String;
       FNomeArquivoPDF:           String;
       function InicializarFichaPedidoIdentificadores(): Integer;
       function GerarFichaPedidoIdentificadores(): Integer;

       function InicializarArquivoRemessaTipo2(): Integer;
       function GerarArquivoRemessaTipo2(): Integer;
       function FinalizarArquivoRemessaTipo2(): Integer;

       function InicializarArquivoRemessaTipo3(): Integer;
       function GerarArquivoRemessaTipo3(): Integer;
       function FinalizarArquivoRemessaTipo3(): Integer;
    public
       constructor Create(ConexaoBD: TConexao; Mensagem: TIntMensagens);
       destructor Destroy; Override;

       function InicializarArquivoRemessa(): Integer;
       function GravarPedidoArquivo(): Integer;
       function FinalizarArquivoRemessa(): Integer;
       function CancelarArquivoRemessa(): Integer;

       function InicializarArquivoFicha(): Integer;
       function GravarPedidoFicha(): Integer;
       function FinalizarArquivoFicha(): Integer;
       function CancelarArquivoFicha(): Integer;

       property PedidoIdentificadores: TIntPedidoIdentificadores read FIntPedidoIdentificadores write FIntPedidoIdentificadores;
       property Conexao:               TConexao      read FConexao;
       property Mensagens:             TIntMensagens read FMensagens;
  end;

  function ObtemNomeArquivo(Arquivo, Extensao: String): String;
  function QuebraTexto(Texto: String; Tamanho: Integer): String;
  function EncontrouQuebra(Linha: String; var LinhaRetorno: String): Boolean;

const
   ArquivoPDF: Integer = 1;

implementation

uses ComServ, uPrintPDF, Math, uIntEndereco, StrUtils;


{ PedidoIdentificador }

function TPedidoIdentificador.CancelarArquivoFicha: Integer;
const
   NomeMetodo: String = 'CancelarArquivoFicha';
var
   NomArquivo: String;
begin
   Result := FichaPedido.FinalizarRelatorio();
   if Result < 0 then Exit;

   if FecharZip(FArquivoZIP_PDF, nil) < 0 then begin
     Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(PedidoIdentificadores.NomArquivoRemessaPedido), 'Conclusão']);
     Result := -1140;
     Exit;
   end;

   Try
      if FileExists(FNomeArquivoPDF) then
        if not DeleteFile(FNomeArquivoPDF) then begin
          NomArquivo := FNomeArquivoPDF;
          Raise Exception.Create('Não foi possível excluir o arquivo!');
        end;
      if FileExists(FNomeArquivoPdfZIP) then begin
        if not DeleteFile(FNomeArquivoPdfZIP) then begin
          NomArquivo := FNomeArquivoPdfZIP;
          Raise Exception.Create('Não foi possível excluir o arquivo!');
        end;
      end;
   Except on E:Exception do begin
      Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['excluir', FNomeArquivoZIP, E.Message]);
      Result := -1898;
      Exit;
     end;
   end;
end;

function TPedidoIdentificador.CancelarArquivoRemessa: Integer;
const
   NomeMetodo: String = 'CancelarArquivoRemessa';
begin
  if not PedidoIdentificadores.CodTipoArquivoRemessa in [2, 3] then begin
    Mensagens.Adicionar(1897, Self.ClassName, NomeMetodo, [IntToStr(PedidoIdentificadores.CodTipoArquivoRemessa)]);
    Result := -1897;
    Exit;
  end;

   if FecharZip(FArquivoZIP, nil) < 0 then begin
     Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(PedidoIdentificadores.NomArquivoRemessaPedido), 'Conclusão']);
     Result := -1140;
     Exit;
   end;
   Result := 1;

  Try
    if FileExists(FNomeArquivoZIP) then begin
      if not DeleteFile(FNomeArquivoZIP) then begin
        Raise Exception.Create('Não foi possível excluir o arquivo!');
      end;
    end;
   Except on E:Exception do begin
      Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['excluir', FNomeArquivoZIP, E.Message]);
      Result := -1898;
      Exit;
    end;
   End;
end;

constructor TPedidoIdentificador.Create(ConexaoBD: TConexao; Mensagem: TIntMensagens);
begin
   inherited Create;
   FConexao := ConexaoBD;
   FMensagens := Mensagem;
   PedidoIdentificadores := TIntPedidoIdentificadores.Create;
   PedidoIdentificadores.EnderecoPropriedadeRural := TIntEndereco.Create;
   PedidoIdentificadores.EnderecoEntregaIdent     := TIntEndereco.Create;
   PedidoIdentificadores.EnderecoCobrancaIdent    := TIntEndereco.Create;
end;

destructor TPedidoIdentificador.Destroy;
begin
   PedidoIdentificadores.EnderecoPropriedadeRural.Free;
   PedidoIdentificadores.EnderecoEntregaIdent.Free;
   PedidoIdentificadores.EnderecoCobrancaIdent.Free;
   PedidoIdentificadores.Free;
   inherited;
end;

function TPedidoIdentificador.FinalizarArquivoFicha: Integer;
const
  NomeMetodo: String = 'FinalizarArquivoFicha';
begin
  Result := 0;
  Try
    Try
       Result := FichaPedido.FinalizarRelatorio();
       if Result < 0 then Exit;

       if AdicionarArquivoNoZipSemHierarquiaPastas(FArquivoZIP_PDF, FNomeArquivoPDF) < 0 then begin
         Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(PedidoIdentificadores.NomArquivoRemessaPedido), 'criação']);
         Result := -1140;
         Exit;
       end;

       if FecharZip(FArquivoZIP_PDF, nil) < 0 then begin
         Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(PedidoIdentificadores.NomArquivoRemessaPedido), 'conclusão']);
         Result := -1140;
         Exit;
       end;
      Try
        With TFileStream.Create(PedidoIdentificadores.TxtCaminhoArquivo + PedidoIdentificadores.NomArquivoFichaPedido, fmOpenRead or fmShareExclusive) Do Begin
          Try
            Result := Size;
          Finally
            Free;
          End;
        End;
      Except
        Result := 0;
      End;
    Finally
       if FileExists(FNomeArquivoPDF) then begin
          if not DeleteFile(FNomeArquivoPDF) then begin
            Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['excluir', FNomeArquivoPDF, 'Não foi possível exluir o arquivo']);
            Result := -1898;
          end;
       end;
       FichaPedido.Free;
    end;
  Except
    if CancelarArquivoRemessa < 0 then Exit;
  end;
end;

function TPedidoIdentificador.FinalizarArquivoRemessa: Integer;
const
   NomeMetodo: String = 'FinalizarArquivoRemessa';
begin
  case PedidoIdentificadores.CodTipoArquivoRemessa of
    2:
     begin
        Result := FinalizarArquivoRemessaTipo2();
     end;
    3:
     begin
        Result := FinalizarArquivoRemessaTipo3();
     end;
    else begin
       Mensagens.Adicionar(1897, Self.ClassName, NomeMetodo, [IntToStr(PedidoIdentificadores.CodTipoArquivoRemessa)]);
       Result := CancelarArquivoRemessa();
       if Result < 0 then Exit;
       Result := -1897;
       Exit;
    end;
  end;

  if Result < 0 then begin
    CancelarArquivoRemessa;
    Exit;
  end;

  Try
    With TFileStream.Create(PedidoIdentificadores.TxtCaminhoArquivo + PedidoIdentificadores.NomArquivoRemessaPedido, fmOpenRead or fmShareExclusive) Do Begin
      Try
        Result := Size;
      Finally
        Free;
      End;
    End;
  Except
    Result := 0;
  End;
end;

function TPedidoIdentificador.FinalizarArquivoRemessaTipo2: Integer;
const
  NomeMetodo: String = 'FinalizarArquivoRemessaTipo2';
var
  sLinha: String;
begin
  Try
    Try
      sLinha := '</edi>';
      if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
        Result := -1140;
        Exit;
      end;

      if FecharArquivoNoZip(FArquivoZIP) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'fechamento']);
        Result := -1140;
        Exit;
      end;
      Result := 1;
    Except on E:Exception do
     begin
       Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['finalizar', PedidoIdentificadores.NomArquivoRemessaPedido, E.Message]);
       Result := -1898;
       Exit;
     end;
    End;
  Finally
    if FecharZip(FArquivoZIP, nil) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(PedidoIdentificadores.NomArquivoRemessaPedido), 'Conclusão']);
      Result := -1140;
    end;
  End;
end;

function TPedidoIdentificador.FinalizarArquivoRemessaTipo3: Integer;
const
   NomeMetodo: String = 'FinalizarArquivoRemessaTipo3';
begin
   Try
     if FecharZip(FArquivoZIP, nil) < 0 then begin
       Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(PedidoIdentificadores.NomArquivoRemessaPedido), 'Conclusão']);
       Result := -1140;
       Exit;
     end;
     Result := 1;
   Except on E:Exception do begin
      Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['finalizar', PedidoIdentificadores.NomArquivoRemessaPedido, E.Message]);
      Result := -1898;
      Exit;
    end;
   End;
end;

//Arquivo XML Fockink
function TPedidoIdentificador.GerarArquivoRemessaTipo2: Integer;
const
  NomeMetodo: String = 'GerarArquivoRemessaTipo2';
var
  CodSISBOV,
  sLinha: String;

  NumDVSisBov,
  CodAnimal: Integer;
begin
  Result := 0;
  Try
    //Cliente (endereco, endereco_cobranca, contato_entega?, contato_cobranca?, pedidos)
    sLinha := '<cliente'              +
              ' id_cliente='           + '""' +
              ' nome='                 + '"' + PedidoIdentificadores.NomProdutor + '"' +
              ' razao_social='         + '""' +
              ' tipo_pessoa='          + '"' + PedidoIdentificadores.CodNaturezaPessoa + '"';
    if UpperCase(PedidoIdentificadores.CodNaturezaPessoa) = 'F' then
      sLinha := sLinha + ' cpf='       + '"' + PedidoIdentificadores.NumCNPJCPFProdutor + '"'
    else if UpperCase(PedidoIdentificadores.CodNaturezaPessoa) = 'J' then
      sLinha := sLinha + ' cnpj='      + '"' + PedidoIdentificadores.NumCNPJCPFProdutor + '"';
    sLinha := sLinha +
              ' ie='                   + '"' + PedidoIdentificadores.SglEstadoFazenda + ' ' + PedidoIdentificadores.NumPropriedadeRuralFazenda + '"' +
              ' ddd='                  + '""' +
              ' fone='                 + '"' + PedidoIdentificadores.NumTelefoneProdutor + '"' +
              ' ramal='                + '""' + //Opcional!
              ' fax='                  + '"' + PedidoIdentificadores.NumFaxProdutor + '"' +
              ' email='                + '"' + PedidoIdentificadores.TxtEMailProdutor + '"' +
              '>';
    //Endereco da Propriedade Rural
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    sLinha := '<endereco'              +
              ' logradouro='           + '"' + PedidoIdentificadores.EnderecoPropriedadeRural.NomLogradouro + '"' +
              ' bairro='               + '"' + PedidoIdentificadores.EnderecoPropriedadeRural.NomBairro + '"' +
              ' municipio='            + '"' + PedidoIdentificadores.EnderecoPropriedadeRural.NomMunicipio + '"' +
              ' uf='                   + '"' + PedidoIdentificadores.EnderecoPropriedadeRural.SglEstado + '"' +
              ' cep='                  + '"' + PedidoIdentificadores.EnderecoPropriedadeRural.NumCEP + '"' +
              '/>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    //Endereco (contato) de Cobrança dos Identificadores
    sLinha := '<contato_cobranca'     +
              ' nome='                 + '"' + PedidoIdentificadores.EnderecoCobrancaIdent.NomPessoaContato + '"' +
              ' ddd='                  + '""' +
              ' fone='                 + '"' + PedidoIdentificadores.EnderecoCobrancaIdent.NumTelefone + '"' +
              ' ramal='                + '""' +
              ' email='                + '"' + PedidoIdentificadores.EnderecoCobrancaIdent.TxtEmail + '"' +
              ' />';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    //Endereco de Cobrança dos Indentificadores
    sLinha := '<endereco_cobranca'    +
              ' logradouro='           + '"' + PedidoIdentificadores.EnderecoCobrancaIdent.NomLogradouro + '"' +
              ' bairro='               + '"' + PedidoIdentificadores.EnderecoCobrancaIdent.NomBairro + '"' +
              ' municipio='            + '"' + PedidoIdentificadores.EnderecoCobrancaIdent.NomMunicipio + '"' +
              ' uf='                   + '"' + PedidoIdentificadores.EnderecoCobrancaIdent.SglEstado + '"' +
              ' cep='                  + '"' + PedidoIdentificadores.EnderecoCobrancaIdent.NumCEP + '"' +
              ' />';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    //Endereco (contato) de Entrega dos Identificadores
    sLinha := '<contato_entrega'     +
              ' nome='                 + '"' + PedidoIdentificadores.EnderecoEntregaIdent.NomPessoaContato + '"' +
              ' ddd='                  + '""' +
              ' fone='                 + '"' + PedidoIdentificadores.EnderecoEntregaIdent.NumTelefone + '"' +
              ' ramal='                + '""' +
              ' email='                + '"' + PedidoIdentificadores.EnderecoEntregaIdent.TxtEmail + '"' +
              ' />';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    // Pedidos (Obs?, Fazenda, endereco_entrega, itens)
    sLinha := '<pedidos>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    sLinha := '<pedido'               +
              ' id_pedido='               + '"' + IntToStr(PedidoIdentificadores.NumPedidoFabricante) + '"' +
              ' data='                    + '"' + DateToStr(PedidoIdentificadores.DtaPedido) + '"' +
              ' condicao_pagamento='      + '"' + PedidoIdentificadores.CodFormaPagamentoFabricante + '"' +
              ' ind_animais_registrados=' + '"' + PedidoIdentificadores.IndAnimaisRegistrados + '"' +
              '/>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    if Length(Trim(PedidoIdentificadores.TxtObservacaoPedido)) > 0 then begin
      sLinha := '<obs obs='                + '"' + PedidoIdentificadores.TxtObservacaoPedido + '">' +
                '</obs>';
      if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
        Result := -1140;
        Exit;
      end;
    end;
    //Fazenda
    sLinha := '<fazenda'               +
              ' nome='                 + '"' + PedidoIdentificadores.NomFazenda + '"';
    if Length(Trim(PedidoIdentificadores.NumImovelReceitaFederal)) = 8 then
      sLinha := sLinha + ' nirf='      + '"' + PedidoIdentificadores.NumImovelReceitaFederal + '"'
    else if Length(Trim(PedidoIdentificadores.NumImovelReceitaFederal)) = 13 then
      sLinha := sLinha + ' incra='     + '"' + PedidoIdentificadores.NumImovelReceitaFederal + '"'
    else
      sLinha := sLinha + '""';
      sLinha := sLinha + '/>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    sLinha := '<endereco_entrega'     +
              ' logradouro=' + '"' + PedidoIdentificadores.EnderecoEntregaIdent.NomLogradouro + '"' +
              ' bairro='     + '"' + PedidoIdentificadores.EnderecoEntregaIdent.NomBairro     + '"' +
              ' municipio='  + '"' + PedidoIdentificadores.EnderecoEntregaIdent.NomMunicipio  + '"' +
              ' uf='         + '"' + PedidoIdentificadores.EnderecoEntregaIdent.SglEstado     + '"' +
              ' cep='        + '"' + PedidoIdentificadores.EnderecoEntregaIdent.NumCEP        + '"' +
              '/>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    sLinha := '<itens>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    //Item (Produto Acessório)
    if Length(Trim(PedidoIdentificadores.CodProdutoFabricante1)) > 0 then begin
      sLinha := '<item'               +
                ' codigo='             + '"' + PedidoIdentificadores.CodProdutoFabricante1 + '"' +
                ' codigo_fornecedor='  + '""' +
                ' quantidade='         + '"' + IntToStr(PedidoIdentificadores.QtdProdutoAcessorio1) + '"' +
                '/>';
      if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
        Result := -1140;
        Exit;
      end;
    end;
    if Length(Trim(PedidoIdentificadores.CodProdutoFabricante2)) > 0 then begin
      sLinha := '<item'               +
                ' codigo='             + '"' + PedidoIdentificadores.CodProdutoFabricante2 + '"' +
                ' codigo_fornecedor='  + '""' +
                ' quantidade='         + '"' + IntToStr(PedidoIdentificadores.QtdProdutoAcessorio2) + '"' +
                '/>';
      if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
        Result := -1140;
        Exit;
      end;
    end;
    if Length(Trim(PedidoIdentificadores.CodProdutoFabricante3)) > 0 then begin
      sLinha := '<item'               +
                ' codigo='             + '"' + PedidoIdentificadores.CodProdutoFabricante3 + '"' +
                ' codigo_fornecedor='  + '""' +
                ' quantidade='         + '"' + IntToStr(PedidoIdentificadores.QtdProdutoAcessorio3) + '"' +
                '/>';
      if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
        Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
        Result := -1140;
        Exit;
      end;
    end;
    //Itens modelo de identificador
    if Length(Trim(PedidoIdentificadores.CodModeloFabricante1)) > 0 then begin
      for CodAnimal := PedidoIdentificadores.CodAnimalSISBOVInicio to PedidoIdentificadores.CodAnimalSISBOVFim do begin
        sLinha := '<item'                +
                  ' codigo='              + '"' + PedidoIdentificadores.CodModeloFabricante1 +'"' +
                  ' codigo_fornecedor='   + '""' +
                  ' quantidade='          + '"1"' +
                  '>';
        if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
          Result := -1140;
          Exit;
        end;

        NumDVSisBov := BuscarDVSisBov( PedidoIdentificadores.CodPaisSISBOV,
                                       PedidoIdentificadores.CodEstadoSISBOV,
                                       PedidoIdentificadores.CodMicroRegiaoSISBOV,
                                       CodAnimal
                                      );
        CodSISBOV := StrZero(PedidoIdentificadores.CodPaisSISBOV, 3) +
                     StrZero(PedidoIdentificadores.CodEstadoSISBOV, 2);
        if PedidoIdentificadores.CodMicroRegiaoSISBOV <> -1 then
          CodSISBOV := CodSISBOV + StrZero(PedidoIdentificadores.CodMicroRegiaoSISBOV, 2);
        CodSISBOV := CodSISBOV +
                     StrZero(CodAnimal, 9) +
                     StrZero(NumDVSisBov, 1);
        sLinha := '<aux'              +
                  ' nome='              + '"Número SISBOV"' +
                  ' valor='             + '"' + CodSISBOV + '"' +
                  '/>' +
                  '</item>';
        if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
          Result := -1140;
          Exit;
        end;
      end;
    end;

    if Length(Trim(PedidoIdentificadores.CodModeloFabricante2)) > 0 then begin
      for CodAnimal := PedidoIdentificadores.CodAnimalSISBOVInicio to PedidoIdentificadores.CodAnimalSISBOVFim do begin
        sLinha := '<item'                +
                  ' codigo='              + '"' + PedidoIdentificadores.CodModeloFabricante2 + '"' +
                  ' codigo_fornecedor='   + '""' +
                  ' quantidade='          + '"1"' +
                  '>';
        if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
          Result := -1140;
          Exit;
        end;
        NumDVSisBov := BuscarDVSisBov( PedidoIdentificadores.CodPaisSISBOV,
                                       PedidoIdentificadores.CodEstadoSISBOV,
                                       PedidoIdentificadores.CodMicroRegiaoSISBOV,
                                       CodAnimal
                                      );
        CodSISBOV := StrZero(PedidoIdentificadores.CodPaisSISBOV, 3) +
                     StrZero(PedidoIdentificadores.CodEstadoSISBOV, 2);
        if PedidoIdentificadores.CodMicroRegiaoSISBOV > 0 then
          CodSISBOV := CodSISBOV + StrZero(PedidoIdentificadores.CodMicroRegiaoSISBOV, 2);
        CodSISBOV := CodSISBOV +
                     StrZero(CodAnimal, 9) +
                     StrZero(NumDVSisBov, 1);
        sLinha := '<aux'               +
                  ' nome='              + '"Número SISBOV"' +
                  ' valor='             + '"' + CodSISBOV + '"' +
                  '/>' +
                  '</item>';
        if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
          Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
          Result := -1140;
          Exit;
        end;
      end;
    end;
    sLinha := '</itens>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    sLinha := '</pedidos>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    sLinha := '</cliente>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
  Except on E:Exception do begin
     Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['inicializar', PedidoIdentificadores.NomArquivoFichaPedido, E.Message]);
     Result := -1898;
     Exit;
   end;
  End;
end;

function TPedidoIdentificador.GerarArquivoRemessaTipo3: Integer;
const
   NomeMetodo: String = 'GerarArquivoRemessaTipo3';
   sQuebraLinha: String = #13+#10;
var
  NomeArquivo,
  sLinha,
  sFormatoLinha: String;

  function Truncar(Valor: String; Tamanho: Integer): String;
   begin
     if Tamanho <= 3 then
       Result := LeftStr(Valor, Tamanho)
     else if Length(Valor) <= Tamanho then
       Result := Valor
     else
       Result := LeftStr(Valor, Tamanho-3) + '...';
   end;

  function FormataLinha(NomeDoCampo, ValorDoCampo: String): String;
   begin
     sFormatoLinha := 'C' +
                      PadR(PedidoIdentificadores.CodCertificadoraFabricante, ' ' , 6) +
                      ' ' +
                      PadR(IntToStr(PedidoIdentificadores.NumOrdemServico), ' ', 15) +
                      ' ' +
                      PadR(NomeDoCampo, ' ', 15) +
                      ' ' +
                      PadR(ValorDoCampo, ' ', 300) +
                      PadR(' ', ' ', 60);
     Result := sFormatoLinha;
   end;
begin
  Try
    NomeArquivo := 'PV' + PadR(PedidoIdentificadores.CodCertificadoraFabricante, '0', 6) +
                   IntToStr(PedidoIdentificadores.NumOrdemServico) + '.TXT';

    If AbrirArquivoNoZip(FArquivoZIP, ExtractFileName(NomeArquivo)) < 0 Then Begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(NomeArquivo), 'criação']);
      Result := -1140;
      Exit;
    End;
    //Início do Arquivo AllFlex
    if GravarLinhaNoZip(FArquivoZIP, FormataLinha('AA_BOF', 'INICIO')) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(NomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    sLinha :=            FormataLinha('AA_VERSAO',       '1.00') + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.NomProdutor)) > 0 then
      sLinha := sLinha + FormataLinha('A1_NOME',         Truncar(RemoveAcentoString(PedidoIdentificadores.NomProdutor, 'S'), 40))  + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.NomReduzidoProdutor)) > 0 then
      sLinha := sLinha + FormataLinha('A1_NOME_REDUZ',   RemoveAcentoString(PedidoIdentificadores.NomReduzidoProdutor, 'S')) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.NomFazenda)) > 0 then
      sLinha := sLinha + FormataLinha('A1_NOME_FAZENDA', Truncar(RemoveAcentoString(PedidoIdentificadores.NomFazenda, 'S'), 40)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.CodNaturezaPessoa)) > 0 then
      sLinha := sLinha + FormataLinha('A1_TIPO_PESSOA',  RemoveAcentoString(PedidoIdentificadores.CodNaturezaPessoa, 'S')) + sQuebraLinha;
    //Linha FIXA!
    sLinha   := sLinha + FormataLinha('A1_TIPO_CLI',     'L') + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoPropriedadeRural.NomLogradouro)) > 0 then
      sLinha := sLinha + FormataLinha('A1_ENDERECO',     Truncar(RemoveAcentoString(PedidoIdentificadores.EnderecoPropriedadeRural.NomLogradouro, 'S'), 60)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoPropriedadeRural.NomMunicipio)) > 0 then
      sLinha := sLinha + FormataLinha('A1_MUNICIPIO',    Truncar(RemoveAcentoString(PedidoIdentificadores.EnderecoPropriedadeRural.NomMunicipio, 'S'), 40)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoPropriedadeRural.NomBairro)) > 0 then
      sLinha := sLinha + FormataLinha('A1_BAIRRO',       Truncar(RemoveAcentoString(PedidoIdentificadores.EnderecoPropriedadeRural.NomBairro, 'S'), 30)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoPropriedadeRural.SglEstado)) > 0 then
      sLinha := sLinha + FormataLinha('A1_UF',           RemoveAcentoString(PedidoIdentificadores.EnderecoPropriedadeRural.SglEstado, 'S')) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoPropriedadeRural.NumCEP)) > 0 then
      sLinha := sLinha + FormataLinha('A1_CEP',          PedidoIdentificadores.EnderecoPropriedadeRural.NumCEP) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.NumTelefoneProdutor)) > 0 then
      sLinha := sLinha + FormataLinha('A1_FONE',          PedidoIdentificadores.NumTelefoneProdutor) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.NumCNPJCPFProdutor)) > 0 then
      sLinha := sLinha + FormataLinha('A1_CNPJ',          PedidoIdentificadores.NumCNPJCPFProdutor) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.SglEstadoFazenda)) > 0 and Length(Trim(PedidoIdentificadores.NumPropriedadeRuralFazenda)) then
      sLinha := sLinha + FormataLinha('A1_INSCR_EST',     PedidoIdentificadores.NumPropriedadeRuralFazenda) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.NumImovelReceitaFederal)) > 0 then
      sLinha := sLinha + FormataLinha('A1_NIRF',          PedidoIdentificadores.NumImovelReceitaFederal) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.TxtEMailProdutor)) > 0 then
      sLinha := sLinha + FormataLinha('A1_EMAIL',         Truncar(RemoveAcentoString(PedidoIdentificadores.TxtEMailProdutor, 'S'), 50)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NomLogradouro)) > 0 then
      sLinha := sLinha + FormataLinha('A1_END_COBRANCA',  Truncar(RemoveAcentoString(PedidoIdentificadores.EnderecoCobrancaIdent.NomLogradouro, 'S'), 37)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NomMunicipio)) > 0 then
      sLinha := sLinha + FormataLinha('A1_MUN_COBRANCA',  Truncar(RemoveAcentoString(PedidoIdentificadores.EnderecoCobrancaIdent.NomMunicipio, 'S'), 40)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NomBairro)) > 0 then
      sLinha := sLinha + FormataLinha('A1_BAIRRO_COBR',   Truncar(RemoveAcentoString(PedidoIdentificadores.EnderecoCobrancaIdent.NomBairro, 'S'), 30)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoPropriedadeRural.SglEstado)) > 0 then
      sLinha := sLinha + FormataLinha('A1_UF_COBRANCA',   RemoveAcentoString(PedidoIdentificadores.EnderecoCobrancaIdent.SglEstado, 'S')) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NumCEP)) > 0 then
      sLinha := sLinha + FormataLinha('A1_CEP_COBRANCA',  PedidoIdentificadores.EnderecoCobrancaIdent.NumCEP) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NomLogradouro)) > 0 then
      sLinha := sLinha + FormataLinha('A1_END_ENTREGA',   Truncar(RemoveAcentoString(PedidoIdentificadores.EnderecoEntregaIdent.NomLogradouro, 'S'), 40)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NomMunicipio)) > 0 then
      sLinha := sLinha + FormataLinha('A1_MUN_ENTREGA',   Truncar(RemoveAcentoString(PedidoIdentificadores.EnderecoEntregaIdent.NomMunicipio, 'S'), 40)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NomBairro)) > 0 then
      sLinha := sLinha + FormataLinha('A1_BAIR_ENTREGA',  Truncar(RemoveAcentoString(PedidoIdentificadores.EnderecoEntregaIdent.NomBairro, 'S'), 30)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.SglEstado)) > 0 then
      sLinha := sLinha + FormataLinha('A1_UF_ENTREGA',    RemoveAcentoString(PedidoIdentificadores.EnderecoEntregaIdent.SglEstado, 'S')) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NomLogradouro)) > 0 then
      sLinha := sLinha + FormataLinha('A1_CEP_ENTREGA',   PedidoIdentificadores.EnderecoEntregaIdent.NumCEP) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NomPessoaContato)) > 0 then
      sLinha := sLinha + FormataLinha('A1_PESS_CONTATO',  RemoveAcentoString(PedidoIdentificadores.EnderecoCobrancaIdent.NomPessoaContato, 'S')) + sQuebraLinha;
    sLinha :=   sLinha + FormataLinha('P0_TIPO_PV',        'N') + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.IndAnimaisRegistrados)) > 0 then
      sLinha := sLinha + FormataLinha('P0_ANIMAIS_REG',   RemoveAcentoString(PedidoIdentificadores.IndAnimaisRegistrados, 'S')) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.CodFormaPagamentoFabricante)) > 0 then
      sLinha := sLinha + FormataLinha('P0_COND_PAGTO',    RemoveAcentoString(PedidoIdentificadores.CodFormaPagamentoFabricante, 'S')) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.TxtObservacaoPedido)) > 0 then begin
      sLinha := sLinha + FormataLinha('P0_OBSERVACAO',    RemoveAcentoString(RedimensionaString(PedidoIdentificadores.TxtObservacaoPedido, 255), 'S')) + sQuebraLinha;
    end;
    if PedidoIdentificadores.CodMicroRegiaoSISBOV <> -1 then
      sLinha := sLinha + FormataLinha('P1_SISBOV_INI',     StrZero(PedidoIdentificadores.CodPaisSISBOV, 3) +
                                                           StrZero(PedidoIdentificadores.CodEstadoSISBOV, 2) +
                                                           StrZero(PedidoIdentificadores.CodMicroRegiaoSISBOV, 2) +
                                                           StrZero(PedidoIdentificadores.CodAnimalSISBOVInicio, 9) +
                                                           StrZero(PedidoIdentificadores.NumDVSISBOVInicio, 1)
                                     ) + sQuebraLinha
    else
      sLinha := sLinha + FormataLinha('P1_SISBOV_INI',     StrZero(PedidoIdentificadores.CodPaisSISBOV, 3) +
                                                           StrZero(PedidoIdentificadores.CodEstadoSISBOV, 2) +
                                                           StrZero(PedidoIdentificadores.CodAnimalSISBOVInicio, 9) +
                                                           StrZero(PedidoIdentificadores.NumDVSISBOVInicio, 1)
                                     ) + sQuebraLinha;
    if PedidoIdentificadores.CodMicroRegiaoSISBOV <> -1 then
      sLinha := sLinha + FormataLinha('P1_SISBOV_FIM',     StrZero(PedidoIdentificadores.CodPaisSISBOV, 3) +
                                                           StrZero(PedidoIdentificadores.CodEstadoSISBOV, 2) +
                                                           StrZero(PedidoIdentificadores.CodMicroRegiaoSISBOV, 2) +
                                                           StrZero(PedidoIdentificadores.CodAnimalSISBOVFim, 9) +
                                                           StrZero(PedidoIdentificadores.NumDVSISBOVFim, 1)
                                     ) + sQuebraLinha
    else
      sLinha := sLinha + FormataLinha('P1_SISBOV_FIM',     StrZero(PedidoIdentificadores.CodPaisSISBOV, 3) +
                                                           StrZero(PedidoIdentificadores.CodEstadoSISBOV, 2) +
                                                           StrZero(PedidoIdentificadores.CodAnimalSISBOVFim, 9) +
                                                           StrZero(PedidoIdentificadores.NumDVSISBOVFim, 1)
                                     ) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.CodModeloFabricante1)) > 0 then
      sLinha := sLinha + FormataLinha('P1_PROD_SISBOV',    RemoveAcentoString(PedidoIdentificadores.CodModeloFabricante1, 'S')) + sQuebraLinha;
    if PedidoIdentificadores.QtdAnimais > -1 then
      sLinha := sLinha + FormataLinha('P1_QTD_SISBOV',     IntToStr(PedidoIdentificadores.QtdAnimais)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.CodProdutoFabricante1)) > 0 then
      sLinha := sLinha + FormataLinha('P2_PRODUTO',        RemoveAcentoString(PedidoIdentificadores.CodProdutoFabricante1, 'S')) + sQuebraLinha;
    if PedidoIdentificadores.QtdProdutoAcessorio1 > 0 then
      sLinha := sLinha + FormataLinha('P2_QTD_VENDA',      IntToStr(PedidoIdentificadores.QtdProdutoAcessorio1)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.CodProdutoFabricante2)) > 0 then
      sLinha := sLinha + FormataLinha('P3_PRODUTO',        RemoveAcentoString(PedidoIdentificadores.CodProdutoFabricante2, 'S')) + sQuebraLinha;
    if PedidoIdentificadores.QtdProdutoAcessorio2 > 0 then
      sLinha := sLinha + FormataLinha('P3_QTD_VENDA',      IntToStr(PedidoIdentificadores.QtdProdutoAcessorio2)) + sQuebraLinha;
    if Length(Trim(PedidoIdentificadores.CodProdutoFabricante3)) > 0 then
      sLinha := sLinha + FormataLinha('P4_PRODUTO',        RemoveAcentoString(PedidoIdentificadores.CodProdutoFabricante3, 'S')) + sQuebraLinha;
    if PedidoIdentificadores.QtdProdutoAcessorio3 > 0 then
      sLinha := sLinha + FormataLinha('P4_QTD_VENDA',      IntToStr(PedidoIdentificadores.QtdProdutoAcessorio3)) + sQuebraLinha;

    sLinha   := sLinha + FormataLinha('AA_EOF',            'FIM');
    //Grava Arquivo no ZIP!
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(NomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    if FecharArquivoNoZip(FArquivoZIP) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(NomeArquivo), 'fechamento']);
      Result := -1140;
      Exit;
    end;
    Result := 0;
  Except on E:Exception do begin
     Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['processar', PedidoIdentificadores.NomArquivoFichaPedido, E.Message]);
     Result := -1898;
     Exit;
   end;
  End;
end;

function TPedidoIdentificador.GerarFichaPedidoIdentificadores(): Integer;
const
  NomeMetodo: String = 'GerarFichaPedidoIdentificadores';
var
  sFicha: String;
  sLinhaObservacao,
  sObservacao: String;
begin
  Try
     if FIndNovaPagina then FichaPedido.NovaPagina(Trim(PedidoIdentificadores.NomCertificadora));
     FichaPedido.InicializarQuadro('N');
     FichaPedido.FonteNegrito;
     sFicha :=  'Produtor:          ' + PedidoIdentificadores.NomProdutor;
     FichaPedido.ImprimirTexto(01, sFicha);
     FichaPedido.FonteNormal;
     If (Length(Trim(PedidoIdentificadores.NumCNPJCPFProdutor)) = 14) then
        sFicha := 'CNPJ:              ' + PedidoIdentificadores.NumCNPJCPFProdutorFormatado
     else If (Length(Trim(PedidoIdentificadores.NumCNPJCPFProdutor)) = 11) then
        sFicha := 'CPF:               ' + PedidoIdentificadores.NumCNPJCPFProdutorFormatado;
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha :=    'Telefone:          ' + PedidoIdentificadores.NumTelefoneProdutor;
     if (Length(Trim(PedidoIdentificadores.NumFaxProdutor)) <> 0) then
        sFicha := PadR(sFicha, ' ', 57) + 'FAX:    ' + PedidoIdentificadores.NumFaxProdutor;
     FichaPedido.ImprimirTexto(01, sFicha);
     if (Length(Trim(PedidoIdentificadores.TxtEMailProdutor)) <> 0) then begin
       sFicha := 'E-mail:            ' + PedidoIdentificadores.TxtEMailProdutor;
       FichaPedido.ImprimirTexto(01, sFicha);
     end;
     FichaPedido.NovaLinha;
     FichaPedido.FonteNegrito;
     sFicha := 'Fazenda:           ' + PedidoIdentificadores.NomFazenda;
     FichaPedido.ImprimirTexto(01, sFicha);
     FichaPedido.FonteNormal;

     if Length(Trim(PedidoIdentificadores.NumImovelReceitaFederal)) = 8 then
        sFicha :=   'NIRF:              ' + PedidoIdentificadores.NumImovelReceitaFederal
     else if Length(Trim(PedidoIdentificadores.NumImovelReceitaFederal)) = 8 then
        sFicha :=   'INCRA:             ' + PedidoIdentificadores.NumImovelReceitaFederal
     else
        sFicha :=   'NIRF/INCRA:        ' + PedidoIdentificadores.NumImovelReceitaFederal;
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha :=   'Insc. estadual:    ' + PedidoIdentificadores.SglEstadoFazenda + ' ' + PedidoIdentificadores.NumPropriedadeRuralFazenda;
     FichaPedido.ImprimirTexto(01, sFicha);
     if (Length(Trim(PedidoIdentificadores.EnderecoPropriedadeRural.NomPessoaContato)) <> 0) then begin
       sFicha := 'Contato:           ' + PedidoIdentificadores.EnderecoPropriedadeRural.NomPessoaContato;
       FichaPedido.ImprimirTexto(01, sFicha);
     end;
     sFicha :=   'Telefone:          ' + PedidoIdentificadores.EnderecoPropriedadeRural.NumTelefone;
     if (Length(Trim(PedidoIdentificadores.EnderecoPropriedadeRural.NumFax)) <> 0) then
       sFicha := PadR(sFicha, ' ', 57) + 'FAX:    ' + PedidoIdentificadores.EnderecoPropriedadeRural.NumFax;
     FichaPedido.ImprimirTexto(01, sFicha);
     if (Length(Trim(PedidoIdentificadores.EnderecoPropriedadeRural.TxtEmail)) <> 0) then begin
       sFicha := 'E-mail:            ' + PedidoIdentificadores.EnderecoPropriedadeRural.TxtEmail;
       FichaPedido.ImprimirTexto(01, sFicha);
     end;
     sFicha :=   'Município:         ' + PedidoIdentificadores.EnderecoPropriedadeRural.NomMunicipio + ' - ' +PedidoIdentificadores.EnderecoPropriedadeRural.SglEstado;
     FichaPedido.ImprimirTexto(01, sFicha);
     FichaPedido.FinalizarQuadro;
     FichaPedido.NovaLinha;

     FichaPedido.InicializarQuadro('S');
     FichaPedido.FonteNegrito;
     sFicha :=    'Fabricante:        ' + UpperCase(PedidoIdentificadores.NomFabricanteIdentificador);
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha :=    'Nº pedido:         ' + IntToStr(PedidoIdentificadores.NumPedidoFabricante);
     FichaPedido.ImprimirTexto(01, sFicha);
     FichaPedido.NovaLinha;

     FichaPedido.FonteNegrito;
     sFicha :=   'Quant. animais:    ' + IntToStr(PedidoIdentificadores.QtdAnimais);
     if UpperCase(PedidoIdentificadores.IndAnimaisRegistrados) = 'S' then
       sFicha := sFicha + ' (registrados em associação de raça)';
     FichaPedido.ImprimirTexto(01, sFicha);
     FichaPedido.FonteNormal;
     if PedidoIdentificadores.CodMicroRegiaoSISBOV > 0 then begin
        sFicha := 'SISBOV inicial:    ' + StrZero(PedidoIdentificadores.CodPaisSISBOV, 3)          + ' '
                                          + StrZero(PedidoIdentificadores.CodEstadoSISBOV, 2)        + ' '
                                          + StrZero(PedidoIdentificadores.CodMicroRegiaoSISBOV, 2)   + ' '
                                          + StrZero(PedidoIdentificadores.CodAnimalSISBOVInicio, 9) + ' '
                                          + StrZero(PedidoIdentificadores.NumDVSISBOVInicio, 1);
     end else begin
        sFicha := 'SISBOV inicial:    ' + StrZero(PedidoIdentificadores.CodPaisSISBOV, 3)          + ' '
                                          + StrZero(PedidoIdentificadores.CodEstadoSISBOV, 2)        + ' '
                                          + StrZero(PedidoIdentificadores.CodAnimalSISBOVInicio, 9) + ' '
                                          + StrZero(PedidoIdentificadores.NumDVSISBOVInicio, 1);
     end;
     FichaPedido.ImprimirTexto(01, sFicha);

     if PedidoIdentificadores.CodMicroRegiaoSISBOV > 0 then begin
        sFicha := 'SISBOV final:      ' + StrZero(PedidoIdentificadores.CodPaisSISBOV, 3)        + ' '
                                          + StrZero(PedidoIdentificadores.CodEstadoSISBOV, 2)      + ' '
                                          + StrZero(PedidoIdentificadores.CodMicroRegiaoSISBOV, 2) + ' '
                                          + StrZero(PedidoIdentificadores.CodAnimalSISBOVFim, 9) + ' '
                                          + StrZero(PedidoIdentificadores.NumDVSISBOVFim, 1);
     end else begin
        sFicha := 'SISBOV final:      ' + StrZero(PedidoIdentificadores.CodPaisSISBOV, 3)        + ' '
                                          + StrZero(PedidoIdentificadores.CodEstadoSISBOV, 2)      + ' '
                                          + StrZero(PedidoIdentificadores.CodAnimalSISBOVFim, 9) + ' '
                                          + StrZero(PedidoIdentificadores.NumDVSISBOVFim, 1);
     end;

     FichaPedido.ImprimirTexto(01, sFicha);
     FichaPedido.NovaLinha;
     FichaPedido.FonteNegrito;
     sFicha :=    'Tipo ident.:       ' + PedidoIdentificadores.SglIdentificacaoDupla + ' - ' + PedidoIdentificadores.DesIdentificacaoDupla;
     FichaPedido.ImprimirTexto(01, sFicha);
     FichaPedido.FonteNormal;
     if (Length(Trim(PedidoIdentificadores.CodModeloFabricante2)) = 0) then begin
        sFicha := 'Modelo bricos:     ' + PedidoIdentificadores.DesModeloIdentificador1 + '(' + PedidoIdentificadores.CodModeloFabricante1 +')';
        FichaPedido.ImprimirTexto(01, sFicha);
     end else begin
        sFicha := 'Modelo brincos 1:  ' + PedidoIdentificadores.DesModeloIdentificador1 + '(' + PedidoIdentificadores.CodModeloFabricante1 +')';
        FichaPedido.ImprimirTexto(01, sFicha);
        sFicha := 'Modelo brincos 2:  ' + PedidoIdentificadores.DesModeloIdentificador2 + '(' + PedidoIdentificadores.CodModeloFabricante2 +')';
        FichaPedido.ImprimirTexto(01, sFicha);
     end;

     if (Length(Trim(PedidoIdentificadores.DesProdutoAcessorio2)) = 0) and (Length(Trim(PedidoIdentificadores.DesProdutoAcessorio1)) > 0) then begin
        sFicha := 'Prod. acessório:   ' + RedimensionaString(PedidoIdentificadores.DesProdutoAcessorio1, 25) + '(' + PedidoIdentificadores.CodProdutoFabricante1 + ')';
        sFicha := PadR(sFicha, ' ', 57) + 'Quant.: ' + IntToStr(PedidoIdentificadores.QtdProdutoAcessorio1);
        FichaPedido.ImprimirTexto(01, sFicha);
     end else if (Length(Trim(PedidoIdentificadores.DesProdutoAcessorio3)) = 0) and (Length(Trim(PedidoIdentificadores.DesProdutoAcessorio1)) > 0) and (Length(Trim(PedidoIdentificadores.DesProdutoAcessorio2)) > 0) then begin
        sFicha := 'Prod. acessório 1: ' + RedimensionaString(PedidoIdentificadores.DesProdutoAcessorio1, 25) + '(' + PedidoIdentificadores.CodProdutoFabricante1 + ')';
        sFicha := PadR(sFicha, ' ', 57) + 'Quant.: ' + IntToStr(PedidoIdentificadores.QtdProdutoAcessorio1);
        FichaPedido.ImprimirTexto(01, sFicha);
        sFicha := 'Prod. acessório 2: ' + RedimensionaString(PedidoIdentificadores.DesProdutoAcessorio2, 25) + '(' + PedidoIdentificadores.CodProdutoFabricante1 + ')';
        sFicha := PadR(sFicha, ' ', 57) + 'Quant.: ' + IntToStr(PedidoIdentificadores.QtdProdutoAcessorio2);
        FichaPedido.ImprimirTexto(01, sFicha);
     end else if (Length(Trim(PedidoIdentificadores.DesProdutoAcessorio1)) > 0) and (Length(Trim(PedidoIdentificadores.DesProdutoAcessorio2)) > 0) and (Length(Trim(PedidoIdentificadores.DesProdutoAcessorio3)) > 0) then begin
        sFicha := 'Prod. acessório 1: ' + RedimensionaString(PedidoIdentificadores.DesProdutoAcessorio1, 25) + '(' + PedidoIdentificadores.CodProdutoFabricante1 + ')';
        sFicha := PadR(sFicha, ' ', 57) + 'Quant.: ' + IntToStr(PedidoIdentificadores.QtdProdutoAcessorio1);
        FichaPedido.ImprimirTexto(01, sFicha);
        sFicha := 'Prod. acessório 2: ' + RedimensionaString(PedidoIdentificadores.DesProdutoAcessorio2, 25) + '(' + PedidoIdentificadores.CodProdutoFabricante1 + ')';
        sFicha := PadR(sFicha, ' ', 57) + 'Quant.: ' + IntToStr(PedidoIdentificadores.QtdProdutoAcessorio2);
        FichaPedido.ImprimirTexto(01, sFicha);
        sFicha := 'Prod. acessório 3: ' + RedimensionaString(PedidoIdentificadores.DesProdutoAcessorio3, 25) + '(' + PedidoIdentificadores.CodProdutoFabricante1 + ')';
        sFicha := PadR(sFicha, ' ', 57) + 'Quant.: ' + IntToStr(PedidoIdentificadores.QtdProdutoAcessorio3);
        FichaPedido.ImprimirTexto(01, sFicha);
     end;
     sFicha := 'Forma pagamento:   ' + PedidoIdentificadores.DesFormaPagamentoIdent;
     FichaPedido.ImprimirTexto(01, sFicha);
     FichaPedido.FinalizarQuadro;
     FichaPedido.NovaLinha;

     FichaPedido.InicializarQuadro('S');
     FichaPedido.FonteNegrito;
     FichaPedido.ImprimirTexto(01, 'Endereço de Entrega');
     FichaPedido.FonteNormal;

     if Length(Trim(PedidoIdentificadores.EnderecoEntregaIdent.NomPessoaContato)) <> 0 then begin
       sFicha := 'Contato:           ' + PadR(RedimensionaString(PedidoIdentificadores.EnderecoEntregaIdent.NomPessoaContato, 44), ' ', 45);
       FichaPedido.ImprimirTexto(01, sFicha);
     end;
     sFicha :=   'Telefone:          ' + PedidoIdentificadores.EnderecoEntregaIdent.NumTelefone;
     if Length(Trim(PedidoIdentificadores.EnderecoEntregaIdent.NumFax)) <> 0 then
       sFicha := PadR(sFicha, ' ', 57) + 'FAX:    ' + RightStr(PedidoIdentificadores.EnderecoEntregaIdent.NumFax, 15);
     FichaPedido.ImprimirTexto(01, sFicha);
     if Length(Trim(PedidoIdentificadores.EnderecoEntregaIdent.TxtEmail)) <> 0 then begin
       sFicha := 'E-mail:            ' + RedimensionaString(PedidoIdentificadores.EnderecoEntregaIdent.TxtEmail, 59);
       FichaPedido.ImprimirTexto(01, sFicha);
     end;
     sFicha :=   'Logradouro:        ' + RedimensionaString(PedidoIdentificadores.EnderecoEntregaIdent.NomLogradouro, 59);
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha :=   'Bairro:            ' + RedimensionaString(PedidoIdentificadores.EnderecoEntregaIdent.NomBairro, 37);
     if Length(Trim(PedidoIdentificadores.EnderecoEntregaIdent.NumCEP)) <> 0 then
       sFicha := PadR(sFicha, ' ', 57) + 'CEP:    ' + PedidoIdentificadores.EnderecoEntregaIdent.NumCEP;
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha :=   'Município:         ' + PedidoIdentificadores.EnderecoEntregaIdent.NomMunicipio + ' - ' + PedidoIdentificadores.EnderecoEntregaIdent.SglEstado;
     FichaPedido.ImprimirTexto(01, sFicha);
     FichaPedido.NovaLinha;
     FichaPedido.FonteNegrito;
     FichaPedido.ImprimirTexto(01, 'Endereço de Cobrança');
     FichaPedido.FonteNormal;
     if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NomPessoaContato)) <> 0 then begin
       sFicha := 'Contato:           ' + PadR(RedimensionaString(PedidoIdentificadores.EnderecoCobrancaIdent.NomPessoaContato, 44), ' ', 45);
       FichaPedido.ImprimirTexto(01, sFicha);
     end;
     sFicha := 'Telefone:          ' + PedidoIdentificadores.EnderecoCobrancaIdent.NumTelefone;
     if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NumFax)) <> 0 then
       sFicha := PadR(sFicha, ' ', 57) + 'FAX:    ' + RightStr(PedidoIdentificadores.EnderecoCobrancaIdent.NumFax, 15);
     FichaPedido.ImprimirTexto(01, sFicha);
     if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.TxtEmail)) <> 0 then begin
       sFicha := 'E-mail:            ' + RedimensionaString(PedidoIdentificadores.EnderecoCobrancaIdent.TxtEmail, 59);
       FichaPedido.ImprimirTexto(01, sFicha);
     end;
     sFicha := 'Logradouro:        ' + RedimensionaString(PedidoIdentificadores.EnderecoCobrancaIdent.NomLogradouro, 59);
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha := 'Bairro:            ' + RedimensionaString(PedidoIdentificadores.EnderecoCobrancaIdent.NomBairro, 37);
     if Length(Trim(PedidoIdentificadores.EnderecoCobrancaIdent.NumCEP)) <> 0 then
       sFicha := PadR(sFicha, ' ', 57) + 'CEP:    ' + PedidoIdentificadores.EnderecoCobrancaIdent.NumCEP;
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha := 'Município:         ' + PedidoIdentificadores.EnderecoCobrancaIdent.NomMunicipio + ' - ' + PedidoIdentificadores.EnderecoCobrancaIdent.SglEstado;
     FichaPedido.ImprimirTexto(01, sFicha);
     FichaPedido.FinalizarQuadro;
     FichaPedido.NovaLinha;
     FichaPedido.InicializarQuadro('S');
     sFicha := 'Nº O.S.:           ' + IntToStr(PedidoIdentificadores.NumOrdemServico);
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha := 'Nº remessa:        ' + IntToStr(PedidoIdentificadores.NumRemessaFabricante);
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha := 'Nome arquivo:      ' + PedidoIdentificadores.NomArquivoFichaPedido;
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha := 'Data pedido:       ' + DateToStr(PedidoIdentificadores.DtaPedido);
     FichaPedido.ImprimirTexto(01, sFicha);
     sFicha := 'Responsável:       ' + PedidoIdentificadores.NomTratamentoUsuarioPedido;
     FichaPedido.ImprimirTexto(01, sFicha);
     if Length(Trim(PedidoIdentificadores.TxtObservacaoPedido)) > 0 then begin
       sFicha := 'Observação:        ';
       sObservacao := QuebraTexto(PedidoIdentificadores.TxtObservacaoPedido, 60);
       while EncontrouQuebra(sObservacao, sLinhaObservacao) do
        begin
           sFicha := sFicha + (Trim(sLinhaObservacao));
           FichaPedido.ImprimirTexto(01, sFicha);
           // if Length(Trim(sFicha)) < 60 then sObservacao := '';
           sFicha := Padr('', ' ', 19);

           // Remove da string a perte impressa
           sObservacao := Copy(sObservacao, Length(sLinhaObservacao) + 2, Length(sObservacao));
           sLinhaObservacao := '';
           // sObservacao := AnsiReplaceStr(sObservacao, (Trim(sLinhaObservacao) + '#13'), '');
        end;
     end;
     FichaPedido.FinalizarQuadro;
     FIndNovaPagina := True;
     Result := 1;
   Except on E:Exception do begin
     Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['criar', PedidoIdentificadores.NomArquivoFichaPedido, E.Message]);
     Result := -1898;
     Exit;
    end;
   End;
end;

function TPedidoIdentificador.GravarPedidoArquivo: Integer;
const
   NomeMetodo: String = 'GravarPedidoArquivo';
begin
  case PedidoIdentificadores.CodTipoArquivoRemessa of
    2:
     begin
       Result := GerarArquivoRemessaTipo2();
     end;
    3:
     begin
       Result := GerarArquivoRemessaTipo3();
     end;
    else begin
      Mensagens.Adicionar(1897, Self.ClassName, NomeMetodo, [IntToStr(PedidoIdentificadores.CodTipoArquivoRemessa)]);
      Result := -1897;
      Exit;
    end;
  end;
  if Result < 0 then begin
    CancelarArquivoRemessa;
    Exit;
  end;
end;

function TPedidoIdentificador.GravarPedidoFicha: Integer;
begin
  Result := GerarFichaPedidoIdentificadores();
  if Result < 0 then begin
    CancelarArquivoFicha;
    Exit;
  end;
end;

function TPedidoIdentificador.InicializarArquivoFicha: Integer;
begin
  Result := InicializarFichaPedidoIdentificadores;
  FIndNovaPagina := False;
end;

function TPedidoIdentificador.InicializarArquivoRemessa(): Integer;
const
   NomeMetodo: String = 'InicializarArquivoRemessa';
begin
  case PedidoIdentificadores.CodTipoArquivoRemessa of
    2:
     begin
        Result := InicializarArquivoRemessaTipo2();
        if Result < 0 then Exit;
     end;
    3:
     begin
        Result := InicializarArquivoRemessaTipo3();
        if Result < 0 then Exit;
     end;
    else begin
      Mensagens.Adicionar(1897, Self.ClassName, NomeMetodo, [IntToStr(PedidoIdentificadores.CodTipoArquivoRemessa)]);
      Result := -1897;
      Exit;
    end;
  end;
end;

function TPedidoIdentificador.InicializarArquivoRemessaTipo2: Integer;
const
   NomeMetodo: String = 'InicializarArquivoRemessaTipo2';
var
   sLinha,
   NomeArquivo: String;
begin
  Try
    FNomeArquivoZIP := PedidoIdentificadores.TxtCaminhoArquivo;
    if not Length(Trim(FNomeArquivoZIP)) > 0 then begin
      Mensagens.Adicionar(1904, Self.ClassName, NomeMetodo, []);
      Result := -1904;
      Exit;
    end;

    if not DirectoryExists(PedidoIdentificadores.TxtCaminhoArquivo) then begin
      if not ForceDirectories(PedidoIdentificadores.TxtCaminhoArquivo) then begin
        Mensagens.Adicionar(1906, Self.ClassName, NomeMetodo, []);
        Result := -1906;
        Exit;
      end;
    end;

    FNomeArquivoZIP := FNomeArquivoZIP + PedidoIdentificadores.NomArquivoRemessaPedido;
    if not Length(Trim(FNomeArquivoZIP)) > 0 then begin
      Mensagens.Adicionar(1904, Self.ClassName, NomeMetodo, []);
      Result := -1904;
      Exit;
    end;

    if ((UpperCase(Copy(FNomeArquivoZIP, Length(FNomeArquivoZIP) - 3, Length(FNomeArquivoZIP))) <> '.ZIP')) then begin
      Mensagens.Adicionar(1899, Self.ClassName, NomeMetodo, [FNomeArquivoZIP]);
      Result := -1899;
      Exit;
    end;

     // Gravação do arquivo
     If AbrirZip(FNomeArquivoZIP, FArquivoZip) < 0 Then Begin
       Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivoZIP), 'criação']);
       Result := -1140;
       Exit;
     End;

    NomeArquivo := ObtemNomeArquivo(FNomeArquivoZIP, '.XML');
    If AbrirArquivoNoZip(FArquivoZIP, ExtractFileName(NomeArquivo)) < 0 Then Begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(NomeArquivo), 'criação']);
      Result := -1140;
      Exit;
    End;
    sLinha := '<?xml version="1.0" encoding="iso-8859-1"?>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(NomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;
    sLinha := '<edi' +
              ' nome_fornecedor=' + '"' + PedidoIdentificadores.NomFabricanteIdentificador + '"'+
              ' cnpj_fornecedor=' + '"' + PedidoIdentificadores.NumCNPJFabricante + '"' +
              ' num_remessa='     + '"' + IntToStr(PedidoIdentificadores.NumRemessaFabricante) + '"' +
              '>';
    if GravarLinhaNoZip(FArquivoZIP, sLinha) < 0 then begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(NomeArquivo), 'gravação']);
      Result := -1140;
      Exit;
    end;     

    Result := 1;
  Except on E:Exception do begin
      Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['inicializar', PedidoIdentificadores.NomArquivoRemessaPedido, E.Message]);
      Result := -1898;
      Exit;
   end;
  End;
end;

function TPedidoIdentificador.InicializarArquivoRemessaTipo3: Integer;
const
   NomeMetodo: String = 'InicializarArquivoRemessaTipo3';
begin
  Try
    FNomeArquivoZIP := PedidoIdentificadores.TxtCaminhoArquivo;
    if not Length(Trim(FNomeArquivoZIP)) > 0 then begin
      Mensagens.Adicionar(1904, Self.ClassName, NomeMetodo, []);
      Result := -1904;
      Exit;
    end;

    if not DirectoryExists(PedidoIdentificadores.TxtCaminhoArquivo) then begin
      if not ForceDirectories(PedidoIdentificadores.TxtCaminhoArquivo) then begin
        Mensagens.Adicionar(1906, Self.ClassName, NomeMetodo, []);
        Result := -1906;
        Exit;
      end;
    end;

    FNomeArquivoZIP := FNomeArquivoZIP + PedidoIdentificadores.NomArquivoRemessaPedido;
    if not Length(Trim(FNomeArquivoZIP)) > 0 then begin
      Mensagens.Adicionar(1904, Self.ClassName, NomeMetodo, []);
      Result := -1904;
      Exit;
    end;

    if ((UpperCase(Copy(FNomeArquivoZIP, Length(FNomeArquivoZIP) - 3, Length(FNomeArquivoZIP))) <> '.ZIP')) then begin
      Mensagens.Adicionar(1899, Self.ClassName, NomeMetodo, [FNomeArquivoZIP]);
      Result := -1899;
      Exit;
    end;

     // Gravação do arquivo
     If AbrirZip(FNomeArquivoZIP, FArquivoZip) < 0 Then Begin
       Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivoZIP), 'criação']);
       Result := -1140;
       Exit;
     End;

    Result := 1;
  Except on E:Exception do begin
    Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['inicializar', PedidoIdentificadores.NomArquivoRemessaPedido, E.Message]);
    Result := -1898;
    Exit;
   end;
  End;
end;

function TPedidoIdentificador.InicializarFichaPedidoIdentificadores(): Integer;
const
  NomeMetodo: String = 'InicializarFichaPedidoIdentificadores';
begin
  if not DirectoryExists(PedidoIdentificadores.TxtCaminhoArquivo) then begin
    if not ForceDirectories(PedidoIdentificadores.TxtCaminhoArquivo) then begin
      Mensagens.Adicionar(1906, Self.ClassName, NomeMetodo, []);
      Result := -1906;
      Exit;
    end;
  end;

  Try
    FichaPedido := TRelatorioPadrao.Create(Conexao, Mensagens);
    FichaPedido.TipoDoArquvio   := ArquivoPDF;
    FichaPedido.NomeArquivo     := ObtemNomeArquivo(PedidoIdentificadores.TxtCaminhoArquivo + PedidoIdentificadores.NomArquivoFichaPedido, '');
    FichaPedido.CodOrientacao   := 1;
    FichaPedido.CodTamanhoFonte := 3;
    FichaPedido.QtdColunas      := 1;
    FichaPedido.CodTamanhoFonteTxtDados := 3;
    FichaPedido.TxtTitulo       := Trim(UpperCase('Ficha do Pedido de Brincos'));
    FichaPedido.TxtSubTitulo    := Trim(PedidoIdentificadores.NomCertificadora);
    FichaPedido.PrimeiraLinhaNegritoTxtDados := False;
    FichaPedido.FormatarTxtDados := False;
    FichaPedido.TxtDados := '';
    Result := FichaPedido.InicializarRelatorio(FichaPedido.TxtSubTitulo, PedidoIdentificadores.DtaPedido, PedidoIdentificadores.DtaPedido, PedidoIdentificadores.NomUsuarioPedido);
    if Result < 0 then Exit;
    Result := 1;

    FNomeArquivoPdfZIP := PedidoIdentificadores.TxtCaminhoArquivo;
    if not Length(Trim(FNomeArquivoPdfZIP)) > 0 then begin
      Mensagens.Adicionar(1904, Self.ClassName, NomeMetodo, []);
      Result := -1904;
      Exit;
    end;

    FNomeArquivoPdfZIP := FNomeArquivoPdfZIP + PedidoIdentificadores.NomArquivoFichaPedido;
    if not Length(Trim(FNomeArquivoPdfZIP)) > 0 then begin
      Mensagens.Adicionar(1904, Self.ClassName, NomeMetodo, []);
      Result := -1904;
      Exit;
    end;

    if ((UpperCase(Copy(FNomeArquivoPdfZIP, Length(FNomeArquivoPdfZIP) - 3, Length(FNomeArquivoPdfZIP))) <> '.ZIP')) then begin
      Mensagens.Adicionar(1899, Self.ClassName, NomeMetodo, [FNomeArquivoPdfZIP]);
      Result := -1899;
      Exit;
    end;

     // Gravação do arquivo
    If AbrirZip(FNomeArquivoPdfZIP, FArquivoZIP_PDF) < 0 Then Begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [ExtractFileName(FNomeArquivoPdfZIP), 'criação']);
      Result := -1140;
      Exit;
    End;

    FNomeArquivoPDF := ObtemNomeArquivo(FNomeArquivoPdfZIP, '.PDF');
    {FNomeArquivoPDF := NomeArquivo;
    If AbrirArquivoNoZip(FArquivoZIP_PDF, ExtractFileName(NomeArquivo)) < 0 Then Begin
      Mensagens.Adicionar(1140, Self.ClassName, NomeMetodo, [NomeArquivo, 'criação']);
      Result := -1140;
      Exit;
    End;}
  Except on E:Exception do begin
     Mensagens.Adicionar(1898, Self.ClassName, NomeMetodo, ['inicializar', PedidoIdentificadores.NomArquivoFichaPedido, E.Message]);
     Result := -1898;
     Exit;
   end;
  End;
end;

function ObtemNomeArquivo(Arquivo, Extensao: String): String;
var
  NomArquivo: String;
begin
  NomArquivo := LeftStr(Arquivo, Length(Arquivo) - 8);
  Result := NomArquivo + Extensao;
end;

function QuebraTexto(Texto: String; Tamanho: Integer): String;
var
  I: Integer;
  Retorno,
  Txt: String;
begin
  Retorno := '';

  while Length(Texto) > 0 do
  begin
    I := 1;
    Txt := '';
    // Obtem os primeiros 'Tamanho' caracteres ou até a primeira quebra
    while (Length(Txt) < Tamanho)
      and (I < Length(Texto) + 1)
      and (Texto[I] <> Quebra) do
    begin
      Txt := Txt + Texto[I];
      Inc(I);
    end;

    // Inclui a quebra na linha
    if (Texto[I] = Quebra) and (Length(Txt) < Tamanho) then
    begin
      Txt := Txt + Texto[I];
    end;

    I := Length(Txt);
    // Remove a ultima palavra se ela foi cortada
    if (Length(txt) = Tamanho) and (Length(Texto) > Tamanho)
      and (Txt[I] <> Quebra) then
    begin
      // Remove a palavra cortada
      while (I > 1) and (Length(Texto) > I + 1) and (Txt[I] <> Quebra)
        and (Txt[I] <> ' ') and (Texto[I + 1] <> ' ') do
      begin
        Dec(I);
      end;
    end;

    if I = 1 then
    begin
      // Caso a palavra seja maior que tamanho quebra a palavra
      Retorno := Retorno + Txt;
    end
    else
    begin
      // Obtem o texto até a ultima palavra inteira
      Txt := Copy(Txt, 1, I);
      Retorno := Retorno + Txt
    end;

    // Acrescenta a quebra
    if (Retorno[Length(Retorno)] <> Quebra)
      and (Length(Texto) <> Length(Txt)) then
    begin
      Retorno := Retorno + Quebra;
    end;

    // Remove do texto o segmento obtido
    Texto := Copy(Texto, Length(Txt) + 1, Length(Texto));
  end;


  Result := AnsiReplaceStr(Retorno, #$D, '');
{
  Txt := '';
  sTxt := Texto;
  while Length(sTxt) > Tamanho  do begin
    bEncontrouQuebra := False;
    if ((Trim(sTxt[Tamanho]) = '') and (not bEncontrouQuebra)) or
       ((Trim(sTxt[Tamanho]) <> '') and (Trim(sTxt[Tamanho + 1]) = '') and (not bEncontrouQuebra)) then begin
      Txt  := Txt + Copy(sTxt, 01, Tamanho) + Quebra;
      sTxt := TrimLeft(Copy(sTxt, Tamanho + 1, Length(sTxt)));
    end else begin
      for i := Tamanho downto 0 do begin
        if (Trim(sTxt[i]) = '') and (not bEncontrouQuebra) then begin
          Txt  := Txt + Copy(sTxt, 01, i) + Quebra;
          sTxt := TrimLeft(Copy(sTxt, i + 1, Length(sTxt)));
          bEncontrouQuebra := True;
        end
      end;
    end;
  end;
  Result := Txt + sTxt;
}
end;

function EncontrouQuebra(Linha: String; var LinhaRetorno: String): Boolean;
var
  i: Integer;
begin
  LinhaRetorno := '';
  Result := False;
  if Length(Linha) > 0 then begin
    for i := 1 to Length(Linha) do begin
      if Linha[i] = Quebra then begin
        Result := True;
        Break;
      end else
        LinhaRetorno := LinhaRetorno + Linha[i];
      Result := True;
    end;
  end else begin
    LinhaRetorno := '';
    Result := False;
  end;
end;

end.


