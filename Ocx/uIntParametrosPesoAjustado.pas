// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 04/12/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Pesos ajustados do produtor e associação
// ********************************************************************
// *  Últimas Alterações
// *   Carlos    04/12/2002    Criação
// *
// ********************************************************************
unit uIntParametrosPesoAjustado;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao,
     uIntMensagens, uferramentas;
type
  TIntParametrosPesoAjustado = class(TIntClasseBDNavegacaoBasica)
  private
    FIntParametrosPesoAjustado  : TIntParametrosPesoAjustado;
    FCodPessoa                  : Integer;
    FNomPessoa                  : String;
    FNumCNPJCPFFormatado        : String;
    FNumIdadePadrao1            : Integer;
    FNumIdadePadrao2            : Integer;
    FNumIdadePadrao3            : Integer;
    FNumIdadePadrao4            : Integer;
    FNumIdadePadrao5            : Integer;
    FNumLimiteAjusteIdade       : Integer;
    FNumLimiteEquivaleIdade     : Integer;
    FQtdIdadeMinimaPesagem      : Integer;

  public
    function DefinirIdadesPadraoProdutor(NumIdadePadrao1,
      NumIdadePadrao2, NumIdadePadrao3, NumIdadePadrao4, NumIdadePadrao5,
      NumLimiteAjusteIdade, NUmLimiteEquivaleIdade, QtdIdadeMinimaPesagem: Integer): Integer;
    function DefinirIdadesPadraoAssociacao(CodAssociacao, NumIdadePadrao1,
      NumIdadePadrao2, NumIdadePadrao3, NumIdadePadrao4, NumIdadePadrao5,
      NumLimiteAjusteIdade, NUmLimiteEquivaleIdade: Integer): Integer;
    function BuscarDaAssociacao(CodPessoaAssociacao: Integer): Integer;
    function BuscarDoProdutor: Integer;

    property CodPessoa:              Integer read FCodPessoa            write FCodPessoa;
    property NomPessoa:              String  read FNomPessoa            write FNomPessoa;
    property NumCNPJCPFFormatado:    String  read FNumCNPJCPFFormatado  write FNumCNPJCPFFormatado;
    property NumIdadePadrao1:        Integer read FNumIdadePadrao1      write FNumIdadePadrao1;
    property NumIdadePadrao2:        Integer read FNumIdadePadrao2      write FNumIdadePadrao2;
    property NumIdadePadrao3:        Integer read FNumIdadePadrao3      write FNumIdadePadrao3;
    property NumIdadePadrao4:        Integer read FNumIdadePadrao4      write FNumIdadePadrao4;
    property NumIdadePadrao5:        Integer read FNumIdadePadrao5      write FNumIdadePadrao5;
    property NumLimiteAjusteIdade:   Integer read FNumLimiteAjusteIdade write FNumLimiteAjusteIdade;
    property NumLimiteEquivaleIdade: Integer read FNumLimiteEquivaleIdade write FNumLimiteEquivaleIdade;
    property QtdIdadeMinimaPesagem:  Integer read FQtdIdadeMinimaPesagem  write FQtdIdadeMinimaPesagem;
    property IntParametrosPesoAjustado : TIntParametrosPesoAjustado read FIntParametrosPesoAjustado write FIntParametrosPesoAjustado;

  end;

implementation

function TIntParametrosPesoAjustado.DefinirIdadesPadraoProdutor(NumIdadePadrao1,
  NumIdadePadrao2, NumIdadePadrao3, NumIdadePadrao4, NumIdadePadrao5,
  NumLimiteAjusteIdade, NUmLimiteEquivaleIdade, QtdIdadeMinimaPesagem: Integer): Integer;
const
  Metodo: Integer = 372;
var
  Q: THerdomQuery;
  CodRegistroLog: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('DefinirIdadesPadraoProdutor');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'DefinirIdadesPadraoProdutor', []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'DefinirIdadesPadraoProdutor', []);
    Result := -307;
    Exit;
  End;

  // Verifica se as idades padrões são válidas
  If (NumIdadePadrao1 > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1164, Self.ClassName, 'DefinirIdadesPadraoProdutor', [Inttostr(NumIdadePadrao1)]);
    Result := -1164;
    Exit;
  end;
  If (NumIdadePadrao2 > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1164, Self.ClassName, 'DefinirIdadesPadraoProdutor', [Inttostr(NumIdadePadrao2)]);
    Result := -1164;
    Exit;
  end;
  If (NumIdadePadrao3 > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1164, Self.ClassName, 'DefinirIdadesPadraoProdutor', [Inttostr(NumIdadePadrao3)]);
    Result := -1164;
    Exit;
  end;
  If (NumIdadePadrao4 > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1164, Self.ClassName, 'DefinirIdadesPadraoProdutor', [Inttostr(NumIdadePadrao4)]);
    Result := -1164;
    Exit;
  end;
  If (NumIdadePadrao5 > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1164, Self.ClassName, 'DefinirIdadesPadraoProdutor', [Inttostr(NumIdadePadrao5)]);
    Result := -1164;
    Exit;
  end;
  // Verifica se o limite ajuste idade e o limite equivale idade são válidos
  If (NumLimiteAjusteIdade <= 0) or (NumLimiteAjusteIdade > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1165, Self.ClassName, 'DefinirIdadesPadraoProdutor', [Inttostr(NumLimiteAjusteIdade)]);
    Result := -1165;
    Exit;
  end;
  If (NumLimiteEquivaleIdade <= 0) or (NumLimiteEquivaleIdade > strtoint(ValorParametro(27))) then begin
    Mensagens.Adicionar(1166, Self.ClassName, 'DefinirIdadesPadraoProdutor', [Inttostr(NumLimiteEquivaleIdade)]);
    Result := -1166;
    Exit;
  end;
  If (QtdIdadeMinimaPesagem < 1) or (QtdIdadeMinimaPesagem < NumLimiteEquivaleIdade) then begin
    Mensagens.Adicionar(1380, Self.ClassName, 'DefinirIdadesPadraoProdutor', [Inttostr(NumLimiteEquivaleIdade)]);
    Result := -1380;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Buscando dados para serem consistidos
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select');
      Q.SQL.Add('  tpr.cod_registro_log as CodRegistroLog');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa tpe');
      Q.SQL.Add('  , tab_produtor tpr');
      Q.SQL.Add('where');
      Q.SQL.Add('  tpe.cod_pessoa = :cod_pessoa_produtor ');
      Q.SQL.Add('  and tpe.dta_fim_validade is null');
      Q.SQL.Add('  and tpr.cod_pessoa_produtor =* tpe.cod_pessoa');
      Q.SQL.Add('  and tpr.dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'DefinirIdadesPadraoProdutor', []);
        Result := -212;
        Exit;
      end;

      CodRegistroLog := Q.FieldByName('CodRegistroLog').AsInteger;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 2, Metodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // atualiza as idades padrao
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_produtor set');
      if NumIdadePadrao1 > 0
         then Q.SQL.Add('  num_idade_padrao_1 = :num_idade_padrao_1, ')
         else Q.SQL.Add('  num_idade_padrao_1 = null, ');
      if NumIdadePadrao2 > 0
         then Q.SQL.Add('  num_idade_padrao_2 = :num_idade_padrao_2, ')
         else Q.SQL.Add('  num_idade_padrao_2 = null, ');
      if NumIdadePadrao3 > 0
         then Q.SQL.Add('  num_idade_padrao_3 = :num_idade_padrao_3, ')
         else Q.SQL.Add('  num_idade_padrao_3 = null, ');
      if NumIdadePadrao4 > 0
         then Q.SQL.Add('  num_idade_padrao_4 = :num_idade_padrao_4, ')
         else Q.SQL.Add('  num_idade_padrao_4 = null, ');
      if NumIdadePadrao5 > 0
         then Q.SQL.Add('  num_idade_padrao_5 = :num_idade_padrao_5, ')
         else Q.SQL.Add('  num_idade_padrao_5 = null, ');
      Q.SQL.Add('  num_limite_ajuste_idade = :num_limite_ajuste_idade, ');
      Q.SQL.Add('  num_limite_equivale_idade = :num_limite_equivale_idade, ');
      Q.SQL.Add('  qtd_idade_minima_pesagem = :qtd_idade_minima_pesagem ');
      Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      if NumIdadePadrao1 > 0 then
         Q.ParamByName('num_idade_padrao_1').AsInteger := NumIdadePadrao1;
      if NumIdadePadrao2 > 0 then
         Q.ParamByName('num_idade_padrao_2').AsInteger := NumIdadePadrao2;
      if NumIdadePadrao3 > 0 then
         Q.ParamByName('num_idade_padrao_3').AsInteger := NumIdadePadrao3;
      if NumIdadePadrao4 > 0 then
         Q.ParamByName('num_idade_padrao_4').AsInteger := NumIdadePadrao4;
      if NumIdadePadrao5 > 0 then
         Q.ParamByName('num_idade_padrao_5').AsInteger := NumIdadePadrao5;
      Q.ParamByName('num_limite_ajuste_idade').AsInteger := NumLimiteAjusteIdade;
      Q.ParamByName('num_limite_equivale_idade').AsInteger := NumLimiteEquivaleIdade;
      Q.ParamByName('qtd_idade_minima_pesagem').AsInteger := QtdIdadeMinimaPesagem;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade, 6-Revalidação
      Result := GravarLogOperacao('tab_produtor', CodRegistroLog, 3, Metodo);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1167, Self.ClassName, 'DefinirIdadesPadraoProdutor', [E.Message]);
        Result := -1167;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntParametrosPesoAjustado.DefinirIdadesPadraoAssociacao(CodAssociacao, NumIdadePadrao1,
  NumIdadePadrao2, NumIdadePadrao3, NumIdadePadrao4, NumIdadePadrao5,
  NumLimiteAjusteIdade, NUmLimiteEquivaleIdade: Integer): Integer;
const
  Metodo: Integer = 373;
var
  Q: THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('DefinirIdadesPadraoAssociacao');
    Exit;
  End;

 // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'DefinirIdadesPadraoAssociacao', []);
    Result := -188;
    Exit;
  End;

  // Verifica se as idades padrões são válidas
  If (NumIdadePadrao1 <= 0) or (NumIdadePadrao1 > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1164, Self.ClassName, 'DefinirIdadesPadraoAssociacao', [Inttostr(NumIdadePadrao1)]);
    Result := -1164;
    Exit;
  end;
  If (NumIdadePadrao2 <= 0) or (NumIdadePadrao2 > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1164, Self.ClassName, 'DefinirIdadesPadraoAssociacao', [Inttostr(NumIdadePadrao2)]);
    Result := -1164;
    Exit;
  end;
  If (NumIdadePadrao3 <= 0) or (NumIdadePadrao3 > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1164, Self.ClassName, 'DefinirIdadesPadraoAssociacao', [Inttostr(NumIdadePadrao3)]);
    Result := -1164;
    Exit;
  end;
  If (NumIdadePadrao4 <= 0) or (NumIdadePadrao4 > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1164, Self.ClassName, 'DefinirIdadesPadraoAssociacao', [Inttostr(NumIdadePadrao4)]);
    Result := -1164;
    Exit;
  end;
  If (NumIdadePadrao5 <= 0) or (NumIdadePadrao5 > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1164, Self.ClassName, 'DefinirIdadesPadraoAssociacao', [Inttostr(NumIdadePadrao5)]);
    Result := -1164;
    Exit;
  end;
  // Verifica se o limite ajuste idade e o limite equivale idade são válidos
  If (NumLimiteAjusteIdade <= 0) or (NumLimiteAjusteIdade > strtoint(ValorParametro(34))) then begin
    Mensagens.Adicionar(1165, Self.ClassName, 'DefinirIdadesPadraoAssociacao', [Inttostr(NumLimiteAjusteIdade)]);
    Result := -1165;
    Exit;
  end;
  If (NumLimiteEquivaleIdade <= 0) or (NumLimiteEquivaleIdade > strtoint(ValorParametro(27))) then begin
    Mensagens.Adicionar(1166, Self.ClassName, 'DefinirIdadesPadraoAssociacao', [Inttostr(NumLimiteEquivaleIdade)]);
    Result := -1166;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica se a aglomeração existe
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1');
      Q.SQL.Add('from');
      Q.SQL.Add('  tab_pessoa tpe');
      Q.SQL.Add('  , tab_associacao ta');
      Q.SQL.Add('where');
      Q.SQL.Add('  tpe.cod_pessoa = :cod_pessoa');
      Q.SQL.Add('  and tpe.dta_fim_validade is null');
      Q.SQL.Add('  and ta.cod_pessoa_associacao = tpe.cod_pessoa');
      Q.SQL.Add('  and ta.dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodAssociacao;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'DefinirIdadesPadraoAssociacao', []);
        Result := -212;
        Exit;
      end;

      // Abre transação
      BeginTran;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_associacao set');
      Q.SQL.Add('  num_idade_padrao_1 = :num_idade_padrao_1, ');
      Q.SQL.Add('  num_idade_padrao_2 = :num_idade_padrao_2, ');
      Q.SQL.Add('  num_idade_padrao_3 = :num_idade_padrao_3, ');
      Q.SQL.Add('  num_idade_padrao_4 = :num_idade_padrao_4, ');
      Q.SQL.Add('  num_idade_padrao_5 = :num_idade_padrao_5, ');
      Q.SQL.Add('  num_limite_ajuste_idade = :num_limite_ajuste_idade, ');
      Q.SQL.Add('  num_limite_equivale_idade = :num_limite_equivale_idade ');
      Q.SQL.Add('where cod_pessoa_associacao = :cod_pessoa_associacao ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_associacao').AsInteger := CodAssociacao;
      Q.ParamByName('num_idade_padrao_1').AsInteger := NumIdadePadrao1;
      Q.ParamByName('num_idade_padrao_2').AsInteger := NumIdadePadrao2;
      Q.ParamByName('num_idade_padrao_3').AsInteger := NumIdadePadrao3;
      Q.ParamByName('num_idade_padrao_4').AsInteger := NumIdadePadrao4;
      Q.ParamByName('num_idade_padrao_5').AsInteger := NumIdadePadrao5;
      Q.ParamByName('num_limite_ajuste_idade').AsInteger := NumLimiteAjusteIdade;
      Q.ParamByName('num_limite_equivale_idade').AsInteger := NumLimiteEquivaleIdade;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1168, Self.ClassName, 'DefinirIdadesPadraoAssociacao', [E.Message]);
        Result := -1168;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntParametrosPesoAjustado.BuscarDaAssociacao(CodPessoaAssociacao: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('BuscarDaAssociacao');
    Exit;
  End;

 // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(375) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'BuscarDaAssociacao', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //------------------------
      // Obtem dados do produtor
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tp.cod_pessoa, ' +
      '       tp.nom_pessoa, ' +
      '       case tp.cod_natureza_pessoa ' +
      '         when ''F'' then convert(varchar(18), ' +
      '                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ' +
      '                             substring(tp.num_cnpj_cpf, 10, 2)) ' +
      '         when ''J'' then convert(varchar(18), ' +
      '                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
      '                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
      '                             substring(tp.num_cnpj_cpf, 13, 2)) ' +
      '       end as num_cnpj_cpf_formatado, ' +
      '       ta.num_idade_padrao_1, ' +
      '       ta.num_idade_padrao_2, ' +
      '       ta.num_idade_padrao_3, ' +
      '       ta.num_idade_padrao_4, ' +
      '       ta.num_idade_padrao_5, ' +
      '       ta.num_limite_ajuste_idade, ' +
      '       ta.num_limite_equivale_idade ' +
      '  from tab_pessoa tp, ' +
      '       tab_associacao ta ' +
      ' where  ' +
      '       ta.cod_pessoa_associacao = tp.cod_pessoa ' +
      '   and tp.dta_fim_validade is null ' +
      '   and ta.dta_fim_validade is null ' +
      '   and tp.cod_pessoa = :cod_pessoa ');
{$ENDIF}

      Q.ParamByName('cod_pessoa').AsInteger := CodPessoaAssociacao;

      Q.Open;

      // Verifica existência de dados da pessoa (Associacao)
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(212, Self.ClassName, 'BuscarDaAssociacao', []);
        Result := -180;
        Exit;
      End;

      // Atribui dados
      FCodPessoa                := Q.FieldByName('cod_pessoa').AsInteger;
      FNomPessoa                := Q.FieldByName('nom_pessoa').AsString;
      FNumCNPJCPFFormatado      := Q.FieldByName('num_cnpj_cpf_formatado').AsString;
      FNumIdadePadrao1          := Q.FieldByName('num_idade_padrao_1').AsInteger;
      FNumIdadePadrao2          := Q.FieldByName('num_idade_padrao_2').AsInteger;
      FNumIdadePadrao3          := Q.FieldByName('num_idade_padrao_3').AsInteger;
      FNumIdadePadrao4          := Q.FieldByName('num_idade_padrao_4').AsInteger;
      FNumIdadePadrao5          := Q.FieldByName('num_idade_padrao_5').AsInteger;
      FNumLimiteAjusteIdade     := Q.FieldByName('num_limite_ajuste_idade').AsInteger;
      FNumLimiteEquivaleIdade   := Q.FieldByName('num_limite_equivale_idade').AsInteger;

      Q.Close;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1189, Self.ClassName, 'BuscarDaAssociacao', [E.Message]);
        Result := -1189;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntParametrosPesoAjustado.BuscarDoProdutor: Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('BuscarDoProdutor');
    Exit;
  End;

 // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(374) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'BuscarDoProdutor', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //------------------------
      // Obtem dados do produtor
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tp.cod_pessoa, ' +
      '       tp.nom_pessoa, ' +
      '       case tp.cod_natureza_pessoa ' +
      '         when ''F'' then convert(varchar(18), ' +
      '                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ' +
      '                             substring(tp.num_cnpj_cpf, 10, 2)) ' +
      '         when ''J'' then convert(varchar(18), ' +
      '                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
      '                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
      '                             substring(tp.num_cnpj_cpf, 13, 2)) ' +
      '       end as num_cnpj_cpf_formatado, ' +
      '       tpr.num_idade_padrao_1, ' +
      '       tpr.num_idade_padrao_2, ' +
      '       tpr.num_idade_padrao_3, ' +
      '       tpr.num_idade_padrao_4, ' +
      '       tpr.num_idade_padrao_5, ' +
      '       tpr.num_limite_ajuste_idade, ' +
      '       tpr.num_limite_equivale_idade, ' +
      '       tpr.qtd_idade_minima_pesagem ' +
      '  from tab_pessoa tp, ' +
      '       tab_produtor tpr ' +
      ' where  ' +
      '       tpr.cod_pessoa_produtor = tp.cod_pessoa ' +
      '   and tp.dta_fim_validade is null ' +
      '   and tpr.dta_fim_validade is null ' +
      '   and tp.cod_pessoa = :cod_pessoa ');
{$ENDIF}

      Q.ParamByName('cod_pessoa').AsInteger := Conexao.CodProdutorTrabalho;

      Q.Open;

      // Verifica existência de dados da pessoa (produtor)
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(212, Self.ClassName, 'BuscarDoProdutor', []);
        Result := -180;
        Exit;
      End;

      // Atribui dados
      FCodPessoa                := Q.FieldByName('cod_pessoa').AsInteger;
      FNomPessoa                := Q.FieldByName('nom_pessoa').AsString;
      FNumCNPJCPFFormatado      := Q.FieldByName('num_cnpj_cpf_formatado').AsString;
      FNumIdadePadrao1          := Q.FieldByName('num_idade_padrao_1').AsInteger;
      FNumIdadePadrao2          := Q.FieldByName('num_idade_padrao_2').AsInteger;
      FNumIdadePadrao3          := Q.FieldByName('num_idade_padrao_3').AsInteger;
      FNumIdadePadrao4          := Q.FieldByName('num_idade_padrao_4').AsInteger;
      FNumIdadePadrao5          := Q.FieldByName('num_idade_padrao_5').AsInteger;
      FNumLimiteAjusteIdade     := Q.FieldByName('num_limite_ajuste_idade').AsInteger;
      FNumLimiteEquivaleIdade   := Q.FieldByName('num_limite_equivale_idade').AsInteger;
      FQtdIdadeMinimaPesagem    := Q.FieldByName('qtd_idade_minima_pesagem').AsInteger;

      Q.Close;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1187, Self.ClassName, 'BuscarDoProdutor', [E.Message]);
        Result := -1187;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

end.
