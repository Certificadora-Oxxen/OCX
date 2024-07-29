// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 19/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Raças Animal - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    19/07/2002    Criação
// *   Hitalo    29/07/2002    Adicionar métodos Inserir, Excluir, Alterar
// *                           e Buscar.
// *   Hítalo    10/08/2002   Adiconar propriedade CodRacaSisBov.
// *   Hítalo    19/08/2002   Adiconar métodos AdicionarAptidao, RetirarAptidao,PossuiAptidao
// *   Hítalo    19/08/2002   Alterar os métodos Inserir(CodEspecie),Buscar(CodEspecie,DesEspecie,Sglespecie)
// *   Carlos    26/08/2002   Adicionar o método PesquisarDoProdutor(CodOrdenacao)
// *   Carlos    28/08/2002   Adicionar os métodos AdicionarAoProdutor(CodRaca) e RetirarDoProdutor(CodRaca)
// *   Hítalo    04/09/2002   Adiconar Parâmetro(IndDefaultProdutor) nos métodos Inserir, Alterar
// *   Hítalo    20/11/2002   Adiconar método GerarRelatorio
// *   Hítalo    10/12/2002   Adiconar propriedade QtdPesoPadraoNascimento
// *
// ********************************************************************

unit uIntRacas;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uIntRaca,uFerramentas;

type
  { TIntRacas }
  TIntRacas = class(TIntClasseBDNavegacaoBasica)
  private
    FIntRaca : TIntRaca;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodEspecie,CodAptidao : Integer;CodOrdenacao: String) : Integer;
    function Inserir(SglRaca, DesRaca,IndRacaPura,CodRacaSisbov: String;CodEspecie : Integer;IndDefaultProdutor: String;QtdPesoPadraoNascimento : Extended;
                     QtdMinDiasGestacao, QtdMaxDiasGestacao: Integer; CodRacaAbcz: String): Integer;
    function Alterar(CodRaca: Integer; SglRaca, DesRaca,
                     IndRacaPura,CodRacaSisBov,IndDefaultProdutor: String;QtdPesoPadraoNascimento : Extended;
                     QtdMinDiasGestacao, QtdMaxDiasGestacao: Integer; CodRacaAbcz: String): Integer;
    function Excluir(CodRaca: Integer): Integer;
    function Buscar(CodRaca: Integer): Integer;
    function AdicionarAptidao(CodRaca,CodAptidao: Integer): Integer;
    function RetirarAptidao(CodRaca,CodAptidao: Integer): Integer;
    function PossuiAptidao(CodRaca,CodAptidao: Integer): Integer;
    function PesquisarDoProdutor(IndRacaProdutor:string; CodEspecie: Integer; CodOrdenacao: String) : Integer;
    function AdicionarAoProdutor(CodRaca: Integer): Integer;
    function RetirarDoProdutor(CodRaca: Integer): Integer;
    function PesquisarRelatorio(CodEspecie : Integer;CodOrdenacao : String): Integer;
    function GerarRelatorio(CodEspecie : Integer;CodOrdenacao : String; Tipo,QtdQuebraRelatorio: Integer): String;
    function PesquisarAgrupamentos(CodRaca,CodTipoAgrupRacas: Integer): Integer;

    property IntRaca : TIntRaca read FIntRaca write FIntRaca;
  end;

implementation

{ TIntRacas }
constructor TIntRacas.Create;
begin
  inherited;
  FIntRaca := TIntRaca.Create;
end;

destructor TIntRacas.Destroy;
begin
  FIntRaca.Free;
  inherited;
end;

function TIntRacas.Pesquisar(CodEspecie,CodAptidao : Integer; CodOrdenacao: String) : Integer;
Const
  NomeMetodo : String = 'Pesquisar';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(85) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tr.cod_raca as CodRaca ');
  Query.SQL.Add('     , tr.sgl_raca as SglRaca ');
  Query.SQL.Add('     , tr.des_raca as DesRaca ');
  Query.SQL.Add('     , tr.Ind_raca_Pura as IndRacaPura ');
  Query.SQL.Add('     , tr.cod_raca_sisbov as CodRacaSisbov ');
  Query.SQL.Add('     , te.cod_Especie as CodEspecie ');
  Query.SQL.Add('     , te.sgl_Especie as SglEspecie ');
  Query.SQL.Add('     , tr.cod_raca_abcz as CodRacaAbcz ');
  Query.SQL.Add('  from tab_raca tr ');
  Query.SQL.Add('     , tab_especie te ');

  if CodAptidao <> - 1 then begin
    Query.SQL.Add('   , tab_raca_aptidao tra ');
  end;
  Query.SQL.Add(' where te.cod_especie =* tr.cod_especie ');
  Query.SQL.Add('   and ((tr.Cod_especie = :Cod_especie or tr.cod_especie is null) or (:cod_especie = -1))');
  if CodAptidao <> - 1 then begin
    Query.SQL.Add('   and tra.Cod_aptidao = :Cod_aptidao ');
    Query.SQL.Add('   and tra.Cod_raca = tr.cod_raca ');
  end;
  Query.SQL.Add('   and tr.dta_fim_validade is null ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by tr.cod_raca ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by tr.sgl_raca ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by tr.des_raca ');
{$ENDIF}
  Query.ParamByName('cod_especie').AsInteger         := CodEspecie;
  if CodAptidao <> - 1 then begin
    Query.ParamByName('cod_aptidao').AsInteger         := CodAptidao;
  end;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(305, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -305;
      Exit;
    End;
  End;
end;

function TIntRacas.Inserir(SglRaca, DesRaca,IndRacaPura,CodRacaSisbov: String;CodEspecie : Integer;IndDefaultProdutor: String;QtdPesoPadraoNascimento : Extended;
                           QtdMinDiasGestacao, QtdMaxDiasGestacao: Integer; CodRacaAbcz: String): Integer;
var
  Q : THerdomQuery;
  CodRaca : Integer;
Const
  NomeMetodo : String = 'Inserir';
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(122) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;
  //--------------------
  //Valida Sigla da Raca
  //---------------------
  Result := VerificaString(SglRaca,'Sigla da Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //--------------------
  //Valida Sigla da Raca
  //---------------------
  Result := TrataString(SglRaca,3, 'Sigla da Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //-------------------------
  //Valida Descrição da Raca
  //-------------------------
  Result := VerificaString(DesRaca, 'Descrição da Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //-------------------------
  //Valida Descrição da Raca
  //-------------------------
  Result := TrataString(DesRaca, 35, 'Descrição da Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //------------------------------
  //  Valida Código da Raça Sisbov
  //------------------------------
  if Trim(CodRacaSisBov) <> '' then begin
    Result := TrataString(CodRacaSisBov,2, 'Código da Raça SisBov');
    If Result < 0 Then Begin
      Exit;
    End;
  end;

  //-------------------------
  //Valida Indicador da Raca
  //-------------------------
  Result := VerificaString(IndRacaPura,'Indicador da Raça');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(IndRacaPura,1, 'Indicador da Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //---------------------------
  //Verifica QtdMinDiasGestacao
  //---------------------------
  if QtdMinDiasGestacao <= 0 then begin
     Mensagens.Adicionar(1439, Self.ClassName, NomeMetodo, []);
     Result := -1439;
     Exit;
  End;

  //---------------------------
  //Verifica QtdMaxDiasGestacao
  //---------------------------
  if QtdMaxDiasGestacao < QtdMinDiasGestacao then begin
     Mensagens.Adicionar(1440, Self.ClassName, NomeMetodo, []);
     Result := -1440;
     Exit;
  End;

  //------------------------------
  //  Valida Código da Raça Abcz
  //------------------------------
  if Trim(CodRacaAbcz) <> '' then begin
    Result := TrataString(CodRacaAbcz,3, 'Código da Raça ABCZ');
    If Result < 0 Then Begin
      Exit;
    End;
  end;

  //----------------------------------
  //Valida Indicador Default Produtor
  //----------------------------------
  Result := VerificaString(IndDefaultProdutor,'Indicador Default do Produtor');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(IndDefaultProdutor,1,'Indicador Default do Produtor');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------------------------------
      // Verifica duplicidade de sigla
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where sgl_raca = :sgl_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_raca').AsString := SglRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(378, Self.ClassName, NomeMetodo, [SglRaca]);
        Result := -378;
        Exit;
      End;
      Q.Close;
      //----------------------------------
      // Verifica duplicidade de Descrição
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where des_raca = :des_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_raca').AsString := DesRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(379, Self.ClassName, NomeMetodo, [DesRaca]);
        Result := -379;
        Exit;
      End;
      Q.Close;

      //------------------------------------------------------------
      // Verifica existência do Codigo Especie se este foi informado
      //------------------------------------------------------------
      if CodEspecie > 0 then begin
         Q.SQL.Clear;
{$IFDEF MSSQL}
         Q.SQL.Add('select 1 from tab_especie ');
         Q.SQL.Add(' where cod_especie = :cod_especie ');
         Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
         Q.ParamByName('cod_especie').AsInteger := CodEspecie;
         Q.Open;
         If Q.IsEmpty Then Begin
            Mensagens.Adicionar(542, Self.ClassName, NomeMetodo, [IntToStr(CodEspecie)]);
            Result := -542;
            Exit;
         End;
         Q.Close;
      end;

      if Trim(CodRacaSisBov) <> '' then begin
        //-------------------------------------------
        // Verifica duplicidade do Código Raca SisBov
        //-------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_raca ');
        Q.SQL.Add(' where cod_raca_sisbov = :cod_raca_sisbov ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_raca_sisbov').AsString := CodRacaSisbov;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(489, Self.ClassName, NomeMetodo, [CodRacaSisbov]);
          Result := -489;
          Exit;
        End;
        Q.Close;
      end;

      //------------------------------------
      // Verifica se o peso é valido
      //------------------------------------
      If (QtdPesoPadraoNascimento <= 0) Then Begin
          Mensagens.Adicionar(1215, Self.ClassName, NomeMetodo, []);
          Result := -1215;
          Exit;
      End;

      //------------------------------------
      // Busca a idade padrão de nascimento
      //------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select qtd_peso_minimo,qtd_peso_maximo from tab_limite_peso_animal ' +
                ' where num_idade_inicial = 0 ' +
                '   and num_idade_final  >= 0 ');

{$ENDIF}
      Q.Open;
      If not Q.IsEmpty then begin
         If (QtdPesoPadraoNascimento < Q.FieldByName('qtd_peso_minimo').asFloat) or (QtdPesoPadraoNascimento  > Q.FieldByName('qtd_peso_maximo').asFloat) Then Begin
            Mensagens.Adicionar(1208, Self.ClassName, NomeMetodo, []);
            Result := -1208;
            Exit;
         End;
      End;
      Q.Close;

      // Abre transação
      BeginTran;


      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_raca), 0) + 1 as cod_raca from tab_raca');
{$ENDIF}
      Q.Open;
      CodRaca := Q.FieldByName('cod_raca').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_raca ' +
      ' (cod_raca, ' +
      '  sgl_raca, ' +
      '  Des_raca, ' +
      '  Ind_raca_pura  , ' +
      '  cod_especie  , ' +
      '  cod_raca_sisbov, ' +
      '  ind_default_produtor, ' +
      '  dta_fim_validade, ' +
      '  qtd_min_dias_gestacao, ' +
      '  qtd_max_dias_gestacao, ' +
      '  cod_raca_abcz, ' +
      '  qtd_peso_padrao_nascimento ) ' +
      'values ' +
      ' (:cod_raca, ' +
      '  :sgl_raca, ' +
      '  :Des_raca, ' +
      '  :Ind_raca_pura, ');
      if CodEspecie > 0
         then Q.SQL.Add('  :cod_especie  , ')
         else Q.SQL.Add('  null, ');
      Q.SQL.Add('  :cod_raca_sisbov, ' +
      '  :ind_default_produtor, ' +
      '  null, ' +
      '  :qtd_min_dias_gestacao, ' +
      '  :qtd_max_dias_gestacao, ' +
      '  :cod_raca_abcz, ' +
      '  :qtd_peso_padrao_nascimento )');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger      := CodRaca;
      Q.ParamByName('sgl_raca').AsString       := SglRaca;
      Q.ParamByName('Des_raca').AsString       := DesRaca;
      Q.ParamByName('Ind_raca_pura').AsString  := IndRacaPura;
      if CodEspecie > 0 then
         Q.ParamByName('cod_especie').AsInteger   := CodEspecie;
      if trim(CodRacaSisBov)='' then begin
        Q.ParamByName('cod_raca_sisbov').DataType := ftString;
        Q.ParamByName('cod_raca_sisbov').Clear;
      end
      else begin
        Q.ParamByName('cod_raca_sisbov').asString := CodRacaSisBov;
      end;
      Q.ParamByName('ind_default_produtor').AsString := IndDefaultProdutor;
      Q.ParamByName('qtd_peso_padrao_nascimento').AsFloat := QtdPesoPadraoNascimento;
      Q.ParamByName('qtd_min_dias_gestacao').AsInteger := QtdMinDiasGestacao;
      Q.ParamByName('qtd_max_dias_gestacao').AsInteger := QtdMaxDiasGestacao;
      Q.ParamByName('cod_raca_abcz').AsString := CodRacaAbcz;

      //----------------------------------------
      // Atribui o Tipo de dado para o parâmetro
      //----------------------------------------
      Q.ParamByName('cod_raca_sisbov').DataType   := ftString;
      Q.ParamByName('cod_raca_abcz').DataType     := ftString;
      AtribuiValorParametro(Q.ParamByName('cod_raca_sisbov'),CodRacaSisBov);
      AtribuiValorParametro(Q.ParamByName('cod_raca_abcz'),CodRacaAbcz);
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodRaca;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(380, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -380;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRacas.Alterar(CodRaca: Integer; SglRaca, DesRaca,
                           IndRacaPura,CodRacaSisBov,IndDefaultProdutor: String;QtdPesoPadraoNascimento : Extended;
                           QtdMinDiasGestacao, QtdMaxDiasGestacao: Integer; CodRacaAbcz: String): Integer;
var
  Q : THerdomQuery;
const
  NomeMetodo : String = 'Alterar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(123) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  //--------------------
  //Valida Sigla da Raca
  //---------------------
  Result := VerificaString(SglRaca,'Sigla da Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //--------------------
  //Valida Sigla da Raca
  //---------------------
  Result := TrataString(SglRaca,3, 'Sigla da Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //-------------------------
  //Valida Descrição da Raca
  //-------------------------
  Result := VerificaString(DesRaca, 'Descrição da Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //-------------------------
  //Valida Descrição da Raca
  //-------------------------
  Result := TrataString(DesRaca, 30, 'Descrição da Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //------------------------------
  //  Valida Código da Raça Sisbov
  //------------------------------
  if Trim(CodRacaSisBov) <> '' then begin
    Result := TrataString(CodRacaSisBov,2, 'Código da Raça SisBov');
    If Result < 0 Then Begin
      Exit;
    End;
  end;

  //-------------------------
  //Valida Indicador da Raca
  //-------------------------
  Result := VerificaString(IndRacaPura,'Indicador da Raça');
  If Result < 0 Then Begin
    Exit;
  End;

  //---------------------------
  //Verifica QtdMinDiasGestacao
  //---------------------------
  if QtdMinDiasGestacao <= 0 then begin
     Mensagens.Adicionar(1439, Self.ClassName, NomeMetodo, []);
     Result := -1439;
     Exit;
  End;

  //---------------------------
  //Verifica QtdMaxDiasGestacao
  //---------------------------
  if QtdMaxDiasGestacao < QtdMinDiasGestacao then begin
     Mensagens.Adicionar(1440, Self.ClassName, NomeMetodo, []);
     Result := -1440;
     Exit;
  End;

  //------------------------------
  //  Valida Código da Raça Abcz
  //------------------------------
  if Trim(CodRacaAbcz) <> '' then begin
    Result := TrataString(CodRacaAbcz,3, 'Código da Raça ABCZ');
    If Result < 0 Then Begin
      Exit;
    End;
  end;

  //-------------------------
  //Valida Indicador da Raca
  //-------------------------
  Result := TrataString(IndRacaPura,1, 'Indicador da Raça');
  If Result < 0 Then Begin
    Exit;
  End;
  //----------------------------------
  //Valida Indicador Default Produtor
  //----------------------------------
  Result := VerificaString(IndDefaultProdutor,'Indicador Default do Produtor');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(IndDefaultProdutor,1,'Indicador Default do Produtor');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //-------------------------------------------
      // Verifica existência do registro
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(381, Self.ClassName, NomeMetodo, []);
        Result := -381;
        Exit;
      End;
      Q.Close;

      //-------------------------------------------
      // Verifica duplicidade de sigla
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where sgl_raca = :sgl_raca ');
      Q.SQL.Add('   and cod_raca != :cod_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_raca').AsString  := SglRaca;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(378, Self.ClassName, NomeMetodo, [SglRaca]);
        Result := -378;
        Exit;
      End;
      Q.Close;

      //-----------------------------------------------------------------
      // Verifica se a sigla considerada desconhecida está sendo alterada
      //-----------------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select sgl_raca from tab_raca ');
      Q.SQL.Add('where  cod_raca = :cod_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If (Q.fieldbyname('sgl_raca').asstring = ValorParametro(40)) and
         (Q.fieldbyname('sgl_raca').asstring <> SglRaca) Then Begin
        Mensagens.Adicionar(1319, Self.ClassName, NomeMetodo, []);
        Result := -1319;
        Exit;
      End;
      If (Q.fieldbyname('sgl_raca').asstring = ValorParametro(40)) and
         (IndRacaPura = 'S') Then Begin
        Mensagens.Adicionar(1320, Self.ClassName, NomeMetodo, []);
        Result := -1320;
        Exit;
      End;
      Q.Close;

      //----------------------------------
      // Verifica duplicidade de Descrição
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where des_raca = :des_raca ');
      Q.SQL.Add('   and cod_raca != :cod_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_raca').AsString := DesRaca;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(379, Self.ClassName, NomeMetodo, [DesRaca]);
        Result := -379;
        Exit;
      End;
      Q.Close;

      //--------------------------------------------------
      // Verifica relacionamento com a Composição Racial
      //--------------------------------------------------
      if IndRacaPura = 'N' then begin
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_composicao_racial ');
        Q.SQL.Add(' where cod_raca = :CodRaca ');
  {$ENDIF}
        Q.ParamByName('CodRaca').AsInteger := CodRaca;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(385, Self.ClassName, NomeMetodo, [CodRaca]);
          Result := -385;
          Exit;
        End;
        Q.Close;
      end;
      if Trim(CodRacaSisBov) <> '' then begin
        //-------------------------------------------
        // Verifica duplicidade do Código Raca SisBov
        //-------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_raca ');
        Q.SQL.Add(' where cod_raca_sisbov = :cod_raca_sisbov ');
        Q.SQL.Add('   and cod_raca != :cod_raca ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_raca_sisbov').AsString := CodRacaSisbov;
        Q.ParamByName('cod_raca').AsInteger := CodRaca;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(489, Self.ClassName, NomeMetodo, [CodRacaSisbov]);
          Result := -489;
          Exit;
        End;
        Q.Close;
      End;

      //------------------------------------
      // Verifica se o peso é valido
      //------------------------------------
      If (QtdPesoPadraoNascimento <= 0) Then Begin
          Mensagens.Adicionar(1215, Self.ClassName, NomeMetodo, []);
          Result := -1215;
          Exit;
      End;
      //------------------------------------
      // Busca a idade padrão de nascimento
      //------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select qtd_peso_minimo,qtd_peso_maximo from tab_limite_peso_animal ' +
                ' where num_idade_inicial = 0 ' +
                '   and num_idade_final  >= 0 ');

{$ENDIF}
      Q.Open;
      If not Q.IsEmpty then begin
         If (QtdPesoPadraoNascimento < Q.FieldByName('qtd_peso_minimo').asFloat) or (QtdPesoPadraoNascimento  > Q.FieldByName('qtd_peso_maximo').asFloat) Then Begin
            Mensagens.Adicionar(1208, Self.ClassName, NomeMetodo, []);
            Result := -1208;
            Exit;
         End;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_raca   ' +
      '   set sgl_raca = :sgl_raca ' +
      '     , des_raca = :des_raca ' +
      '     , ind_raca_pura = :ind_raca_pura ' +
      '     , cod_raca_sisbov = :cod_raca_sisbov ' +
      '     , ind_default_produtor = :ind_default_produtor ' +
      '     , qtd_peso_padrao_nascimento = :qtd_peso_padrao_nascimento ' +
      '     , qtd_min_dias_gestacao = :qtd_min_dias_gestacao ' +
      '     , qtd_max_dias_gestacao = :qtd_max_dias_gestacao ' +
      '     , cod_raca_abcz = :cod_raca_abcz ' +
      ' where cod_raca = :cod_raca ');
{$ENDIF}
      //----------------------------------------
      // Atribui o Tipo de dado para o parâmetro
      //----------------------------------------
      Q.ParamByName('sgl_raca').DataType     := ftString;
      AtribuiValorParametro(Q.ParamByName('sgl_raca'),SglRaca);

      Q.ParamByName('des_raca').DataType     := ftString;
      AtribuiValorParametro(Q.ParamByName('des_raca'),DesRaca);

      Q.ParamByName('ind_raca_pura').DataType     := ftString;
      AtribuiValorParametro(Q.ParamByName('ind_raca_pura'),IndRacaPura);

      Q.ParamByName('cod_raca').DataType     := ftInteger;
      AtribuiValorParametro(Q.ParamByName('cod_raca'),CodRaca);

      Q.ParamByName('cod_raca_sisbov').DataType     := ftString;
      AtribuiValorParametro(Q.ParamByName('cod_raca_sisbov'),CodRacaSisBov);

      Q.ParamByName('ind_default_produtor').DataType     := ftString;
      AtribuiValorParametro(Q.ParamByName('ind_default_produtor'),IndDefaultProdutor);

      Q.ParamByName('qtd_peso_padrao_nascimento').AsFloat := QtdPesoPadraoNascimento;

      Q.ParamByName('qtd_min_dias_gestacao').AsInteger := QtdMinDiasGestacao;
      Q.ParamByName('qtd_max_dias_gestacao').AsInteger := QtdMaxDiasGestacao;

      Q.ParamByName('cod_raca_abcz').DataType := ftString;
      AtribuiValorParametro(Q.ParamByName('cod_raca_abcz'),CodRacaAbcz);

      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(382, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -382;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRacas.Excluir(CodRaca: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'Excluir';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(124) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //-------------------------------------
      // Verifica existência do Registro Raça
      //-------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where cod_raca = :codRaca ');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('codRaca').AsInteger := CodRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(381, Self.ClassName, NomeMetodo, []);
        Result := -381;
        Exit;
      End;
      Q.Close;

      //------------------------------------------------
      // Verifica se a raça é a considerada desconhecida
      //------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where sgl_raca = :SglRaca ');
      Q.SQL.Add('   and cod_raca = :CodRaca ');
      Q.SQL.Add('   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('SglRaca').AsString := ValorParametro(40);
      Q.ParamByName('CodRaca').AsInteger := CodRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1321, Self.ClassName, NomeMetodo, []);
        Result := -1321;
        Exit;
      End;
      Q.Close;

      //------------------------------------------
      // Verifica relacionamento com algum animal
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal ');
      Q.SQL.Add(' where cod_raca = :codRaca ');
{$ENDIF}
      Q.ParamByName('codRaca').AsInteger := CodRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(763, Self.ClassName, NomeMetodo, []);
        Result := -763;
        Exit;
      End;
      Q.Close;

      //------------------------------------------------------
      // Verifica relacionamento com algum Composição Racial
      //------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_composicao_racial ');
      Q.SQL.Add(' where cod_raca = :codRaca ');
{$ENDIF}
      Q.ParamByName('codRaca').AsInteger := CodRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(764, Self.ClassName, NomeMetodo, []);
        Result := -764;
        Exit;
      End;
      Q.Close;

      //-------------------------------------------
      // Verifica relacionamento com algum Produtor
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_produtor_raca ');
      Q.SQL.Add(' where cod_raca = :codRaca ');
{$ENDIF}
      Q.ParamByName('codRaca').AsInteger := CodRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(765, Self.ClassName, NomeMetodo, []);
        Result := -765;
        Exit;
      End;
      Q.Close;
      
      // Abre transação
      BeginTran;

      //---------------------------------------------------
      // Verifica relacionamento com Aptidao para Exclusão
      //---------------------------------------------------

//      Q.SQL.Clear;
//{$IFDEF MSSQL}
//      Q.SQL.Add('delete from tab_raca_aptidao ');
//      Q.SQL.Add(' where cod_raca = :codRaca ');
//{$ENDIF}
//      Q.ParamByName('codRaca').AsInteger := CodRaca;
//      Q.ExecSQL;
//      Q.Close;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_raca ');
      Q.SQL.Add(' set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_raca = :CodRaca ');
{$ENDIF}
      Q.ParamByName('CodRaca').AsInteger      := CodRaca;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(383, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -383;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRacas.Buscar(CodRaca: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'Buscar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(125) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tr.cod_raca ' +
      '     , tr.sgl_raca ' +
      '     , tr.des_raca ' +
      '     , tr.ind_raca_pura ' +
      '     , tr.cod_raca_sisbov ' +
      '     , te.cod_especie ' +
      '     , te.Sgl_especie ' +
      '     , te.des_especie ' +
      '     , tr.ind_default_produtor ' +
      '     , tr.qtd_peso_padrao_nascimento  as QtdPesoPadraoNascimento ' +
      '     , tr.qtd_min_dias_gestacao  as QtdMinDiasGestacao ' +
      '     , tr.qtd_max_dias_gestacao  as QtdMaxDiasGestacao ' +
      '     , tr.cod_raca_abcz as CodRacaAbcz ' +
      '  from tab_raca tr ' +
      '     , tab_especie te ' +
      ' where tr.cod_raca = :CodRaca ' +
      '   and tr.dta_fim_validade is null ' +
      '   and te.cod_especie =* tr.cod_especie ');
{$ENDIF}
      Q.ParamByName('CodRaca').AsInteger := CodRaca;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(381, Self.ClassName, NomeMetodo, []);
        Result := -381;
        Exit;
      End;

      // Obtem informações do registro
      FIntRaca.CodRaca          := Q.FieldByName('Cod_raca').AsInteger;
      FIntRaca.SglRaca          := Q.FieldByName('sgl_raca').AsString;
      FIntRaca.DesRaca          := Q.FieldByName('Des_raca').AsString;
      FIntRaca.IndRacaPura      := Q.FieldByName('Ind_raca_pura').AsString;
      FIntRaca.CodRacaSisbov    := Q.FieldByName('cod_raca_sisbov').AsString;
      FIntRaca.CodEspecie       := Q.FieldByName('Cod_Especie').AsInteger;
      FIntRaca.SglEspecie       := Q.FieldByName('sgl_Especie').AsString;
      FIntRaca.DesEspecie       := Q.FieldByName('Des_Especie').AsString;
      FIntRaca.IndDefaultProdutor := Q.FieldByName('ind_default_produtor').AsString;
      FIntRaca.QtdPesoPadraoNascimento := Q.FieldByName('QtdPesoPadraoNascimento').AsFloat;
      FIntRaca.QtdMinDiasGestacao := Q.FieldByName('QtdMinDiasGestacao').AsInteger;
      FIntRaca.QtdMaxDiasGestacao := Q.FieldByName('QtdMaxDiasGestacao').AsInteger;
      FIntRaca.CodRacaAbcz      := Q.FieldByName('CodRacaAbcz').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(384, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -384;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRacas.AdicionarAptidao(CodRaca,CodAptidao: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'AdicionarAptidao';
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(211) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica existencia de Raça
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(381, Self.ClassName, NomeMetodo, []);
        Result := -381;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia de Aptidao
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_aptidao ');
      Q.SQL.Add(' where cod_aptidao = :cod_aptidao ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_aptidao').AsInteger := CodAptidao;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(543, Self.ClassName, NomeMetodo, []);
        Result := -543;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca_aptidao ');
      Q.SQL.Add(' where cod_aptidao = :cod_aptidao ');
      Q.SQL.Add('   and cod_raca = :cod_raca ');
{$ENDIF}
      Q.ParamByName('cod_aptidao').AsInteger := CodAptidao;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        result := 0;
        Q.Close;
        exit;
      End;
      Q.Close;
      //---------------
      // Abre transação
      //---------------
      BeginTran;


      //------------------------
      // Tenta Inserir Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_raca_aptidao ');
      Q.SQL.Add(' ( cod_raca ');
      Q.SQL.Add(' , cod_aptidao ');
      Q.SQL.Add(' )');
      Q.SQL.Add('values ');
      Q.SQL.Add(' ( :cod_raca ');
      Q.SQL.Add(' , :cod_aptidao ');
      Q.SQL.Add(' )');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger    := CodRaca;
      Q.ParamByName('cod_aptidao').AsInteger := CodAptidao;
      Q.ExecSQL;
      //-------------------
      // Cofirma transação
      //-------------------
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(544, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -544;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRacas.RetirarAptidao(CodRaca,CodAptidao: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'RetirarAptidao';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(212) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica existencia de Raça
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(381, Self.ClassName, NomeMetodo, []);
        Result := -381;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia de Aptidao
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_aptidao ');
      Q.SQL.Add(' where cod_aptidao = :cod_aptidao ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_aptidao').AsInteger := CodAptidao;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(543, Self.ClassName, NomeMetodo, []);
        Result := -543;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca_aptidao ');
      Q.SQL.Add(' where cod_aptidao = :cod_aptidao ');
      Q.SQL.Add('   and cod_raca = :cod_raca ');
{$ENDIF}
      Q.ParamByName('cod_aptidao').AsInteger := CodAptidao;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        result := 0;
        Q.Close;
        exit;
      End;
      Q.Close;
      //---------------
      // Abre transação
      //---------------
      BeginTran;


      //------------------------
      // Tenta Excluir Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_raca_aptidao ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add('   and cod_aptidao = :cod_aptidao ');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger    := CodRaca;
      Q.ParamByName('cod_aptidao').AsInteger := CodAptidao;
      Q.ExecSQL;
      //-------------------
      // Cofirma transação
      //-------------------
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(545, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -545;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRacas.PossuiAptidao(CodRaca,CodAptidao: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'PossuiAptidao';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(213) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica existencia de Raça
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(381, Self.ClassName, NomeMetodo, []);
        Result := -381;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia de Aptidao
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_aptidao ');
      Q.SQL.Add(' where cod_aptidao = :cod_aptidao ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_aptidao').AsInteger := CodAptidao;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(543, Self.ClassName, NomeMetodo, []);
        Result := -543;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca_aptidao ');
      Q.SQL.Add(' where cod_aptidao = :cod_aptidao ');
      Q.SQL.Add('   and cod_raca = :cod_raca ');
{$ENDIF}
      Q.ParamByName('cod_aptidao').AsInteger := CodAptidao;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Result := 1;
      End Else Begin
        Result := 0;
      End;
      Q.Close;
    Except
      On E: Exception do Begin
        Mensagens.Adicionar(490, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -490;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRacas.PesquisarDoProdutor(IndRacaProdutor:string; CodEspecie: Integer; CodOrdenacao: String) : Integer;
Const
  NomeMetodo : String = 'PesquisarDoProdutor';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(234) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se produtor de trabalho foi definido
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tr.cod_raca as CodRaca ');
  Query.SQL.Add('     , tr.sgl_raca as SglRaca ');
  Query.SQL.Add('     , tr.des_raca as DesRaca ');
  Query.SQL.Add('     , te.cod_especie as CodEspecie ');
  Query.SQL.Add('     , te.sgl_especie as SglEspecie ');
  Query.SQL.Add('     , te.des_especie as DesEspecie ');
  Query.SQL.Add('     , tr.cod_raca_abcz as CodRacaAbcz ');
  Query.SQL.Add('     , case tpr.cod_pessoa_produtor  ');
  Query.SQL.Add('       when null then ''N'' ');
  Query.SQL.Add('       else ''S'' ');
  Query.SQL.Add('       end as IndRacaProdutor ');
  Query.SQL.Add('from tab_raca tr ');
  Query.SQL.Add('   , tab_produtor_raca tpr ');
  Query.SQL.Add('   , tab_especie te ');
  if IndRacaProdutor = 'S'
        then Query.SQL.Add(' where tr.cod_raca = tpr.cod_raca ')
        else if IndRacaProdutor = 'N'
                then begin
                  Query.SQL.Add(' where tr.cod_raca *= tpr.cod_raca ');
                  Query.SQL.Add(' and tr.cod_raca not in (select cod_raca ');
                  Query.SQL.Add(' from tab_produtor_raca ');
                  Query.SQL.Add(' where cod_pessoa_produtor=:cod_produtor) ');
                end
                else Query.SQL.Add(' where tr.cod_raca *= tpr.cod_raca ');
  Query.SQL.Add('   and tpr.cod_pessoa_produtor =:cod_produtor');
  Query.SQL.Add('   and tr.cod_especie = te.cod_especie');
  Query.SQL.Add('   and tr.dta_fim_validade is null');
  if CodEspecie > 0 then
        Query.SQL.Add('   and tr.cod_especie = :cod_especie ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by tr.cod_raca ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by tr.sgl_raca ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by tr.des_raca ');
{$ENDIF}
  Query.ParamByName('cod_produtor').AsInteger := Conexao.CodProdutorTrabalho;
  if CodEspecie > 0 then
        Query.ParamByName('cod_especie').AsInteger := CodEspecie;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(305, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -305;
      Exit;
    End;
  End;
end;


function TIntRacas.AdicionarAoProdutor(CodRaca: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'AdicionarAoProdutor';
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(236) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica existencia de Raça
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(381, Self.ClassName, NomeMetodo, []);
        Result := -381;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Produtor
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_produtor ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(170, Self.ClassName, NomeMetodo, []);
        Result := -170;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_produtor_raca ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_raca = :cod_raca ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If not Q.IsEmpty Then Begin
        result := 0;
        Q.Close;
        exit;
      End;
      Q.Close;
      //---------------
      // Abre transação
      //---------------
      BeginTran;

      //------------------------
      // Tenta Inserir Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_produtor_raca ');
      Q.SQL.Add(' ( cod_raca ');
      Q.SQL.Add(' , cod_pessoa_produtor ');
      Q.SQL.Add(' )');
      Q.SQL.Add('values ');
      Q.SQL.Add(' ( :cod_raca ');
      Q.SQL.Add(' , :cod_pessoa_produtor ');
      Q.SQL.Add(' )');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger    := CodRaca;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ExecSQL;
      //-------------------
      // Cofirma transação
      //-------------------
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(694, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -694;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRacas.RetirarDoProdutor(CodRaca: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo : String = 'RetirarDoProdutor';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(237) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica existencia de Raça
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(381, Self.ClassName, NomeMetodo, []);
        Result := -381;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Produtor
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_produtor ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(170, Self.ClassName, NomeMetodo, []);
        Result := -170;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_produtor_raca ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_raca = :cod_raca ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
        result := 0;
        Q.Close;
        exit;
      End;
      Q.Close;
      //---------------
      // Abre transação
      //---------------
      BeginTran;

      //------------------------
      // Tenta Excluir Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_produtor_raca ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger    := CodRaca;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ExecSQL;
      //-------------------
      // Cofirma transação
      //-------------------
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(695, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -695;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRacas.PesquisarRelatorio(CodEspecie : Integer;CodOrdenacao : String): Integer;
var
  Q : THerdomQuery;
  sDesAptidao,sSglRaca,sDesRaca,sSglEspecie,sDesEspecie : String;
  iQtdMinDiasGestacao, iQtdMaxDiasGestacao: Integer;
Const
  NomeMetodo : String = 'PesquisarRelatorio';
begin
  Result      := -1;
  sDesAptidao := '';
  sSglRaca    := '';
  sDesRaca    := '';
  sSglEspecie := '';
  sDesEspecie := '';
  iQtdMinDiasGestacao := 0;
  iQtdMaxDiasGestacao := 0;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try

    Q.Close;
    Q.SQL.Clear;
  {$IFDEF MSSQL}
    // Cria temporária caso não exista
    Q.SQL.Add(
        #13#10'if object_id(''tempdb..#tmp_raca_relatorio'') is null '+
        #13#10'  create table #tmp_raca_relatorio '+
        #13#10'  ( '+
        #13#10'      SglRaca varchar(3)    null ' +
        #13#10'    , DesRaca varchar(35)   null'+
        #13#10'    , DesAptidao char(50)   null'+
        #13#10'    , QtdMinDiasGestacao integer  null'+
        #13#10'    , QtdMaxDiasGestacao integer  null'+
        #13#10'  ) ');
    Q.ExecSQL;
  {$ENDIF}

    // Limpa a tabela
    Q.SQL.Clear;
  {$IFDEF MSSQL}
    Q.SQL.Add(#13#10'truncate table #tmp_raca_relatorio ');
    Q.ExecSQL;
  {$ENDIF}

    Query.Close;
    Query.SQL.Clear;
  {$IFDEF MSSQL}
    //----------------------------------------------
    //Tráz todas as raças relacionadas com aptidoes
    //----------------------------------------------
    Query.SQL.Add('select tr.sgl_raca as SglRaca ' +
                  '     , tr.des_raca as DesRaca ' +
                  '     , ta.des_aptidao as DesAptidao ' +
                  '     , tr.qtd_min_dias_gestacao as QtdMinDiasGestacao ' +
                  '     , tr.qtd_max_dias_gestacao as QtdMaxDiasGestacao ' +
                  '  from tab_raca as tr ' +
                  '     , tab_aptidao as ta ' +
                  '     , tab_raca_aptidao as tra ' +
                  ' where tr.dta_fim_validade is null ' +
                  '   and tr.cod_especie = :CodEspecie ' +
                  '   and tra.cod_raca   = tr.cod_raca ' +
                  '   and ta.cod_aptidao = tra.cod_aptidao ' +
                  ' order by tr.sgl_raca ');
  {$ENDIF}
    Query.ParamByName('CodEspecie').AsInteger := CodEspecie;
    Query.open;

    if not Query.Eof then begin
       Q.Sql.Clear;
    {$IFDEF MSSQL}
       Q.Sql.Add(' insert into #tmp_raca_relatorio values (' +
                 '   :SglRaca ' +
                 ' , :DesRaca ' +
                 ' , :DesAptidao ' +
                 ' , :QtdMinDiasGestacao ' +
                 ' , :QtdMaxDiasGestacao)');
    {$ENDIF}
       sSglRaca := Query.FieldByName('SglRaca').asString;

       while not Query.Eof do begin
         if sSglRaca = Query.FieldByName('SglRaca').asString then begin
           sSglRaca    := Query.FieldByName('SglRaca').asString;
           sDesRaca    := Query.FieldByName('DesRaca').asString;
           sDesAptidao := sDesAptidao + Query.FieldByName('DesAptidao').asString + ', ';
           iQtdMinDiasGestacao := Query.FieldByName('QtdMinDiasGestacao').asInteger;
           iQtdMaxDiasGestacao := Query.FieldByName('QtdMaxDiasGestacao').asInteger;
         end else begin
           //--------------------------------------------
           // Tira o espaço e a virgula da ultima aptidao
           //--------------------------------------------
           sDesAptidao := Copy(sDesAptidao,1,length(sDesAptidao)- 2);

           Q.Close;
           Q.ParamByName('SglRaca').asString := sSglRaca;
           Q.ParamByName('DesRaca').asString := sDesRaca;
           Q.ParamByName('DesAptidao').asString := sDesAptidao;
           Q.ParamByName('QtdMinDiasGestacao').asInteger := iQtdMinDiasGestacao;
           Q.ParamByName('QtdMaxDiasGestacao').asInteger := iQtdMaxDiasGestacao;
           Q.ExecSQL;

           //-----------------------------
           // Atualiza os novos registros
           //-----------------------------
           sSglRaca    := Query.FieldByName('SglRaca').asString;
           sDesRaca    := Query.FieldByName('DesRaca').asString;
           sDesAptidao := Query.FieldByName('DesAptidao').asString + ', ';
           iQtdMinDiasGestacao := Query.FieldByName('QtdMinDiasGestacao').asInteger;
           iQtdMaxDiasGestacao := Query.FieldByName('QtdMaxDiasGestacao').asInteger;
         end;
         Query.next;
       end;
       //---------------------------
       // Adiciona o ultimo registro
       //---------------------------
       Q.Close;
       Q.ParamByName('SglRaca').asString := sSglRaca;
       Q.ParamByName('DesRaca').asString := sDesRaca;
       Q.ParamByName('DesAptidao').asString := sDesAptidao;
       Q.ParamByName('QtdMinDiasGestacao').asInteger := iQtdMinDiasGestacao;
       Q.ParamByName('QtdMaxDiasGestacao').asInteger := iQtdMaxDiasGestacao;
       Q.ExecSQL;
    end;
      //------------------------------------------------------------
      //Tráz todas as raças que não estão relacionadas com aptidoes
      //------------------------------------------------------------
      Q.Close;
      Q.SQL.Clear;
   {$IFDEF MSSQL}
      Q.SQL.Add(' insert into #tmp_raca_relatorio ( ' +
                    '    SglRaca ' +
                    '  , DesRaca ' +
                    '  , DesAptidao   ' +
                    '  , QtdMinDiasGestacao   ' +
                    '  , QtdMaxDiasGestacao  ) ' +
                    ' select tr.sgl_raca as SglRaca ' +
                    '      , tr.des_raca as DesRaca ' +
                    '      , convert(varchar(15),'''')  as DesAptidao ' +
                    '      , tr.qtd_min_dias_gestacao as QtdMinDiasGestacao ' +
                    '      , tr.qtd_max_dias_gestacao as QtdMaxDiasGestacao ' +
                    '   from tab_raca as tr ' +
                    '  where tr.dta_fim_validade is null ' +
                    '    and tr.cod_especie = :CodEspecie ' +
                    '    and not exists ( select 1 from tab_raca_aptidao tra where tr.cod_raca = tra.cod_raca )');
    {$ENDIF}
      Q.ParamByName('CodEspecie').AsInteger := CodEspecie;
      Q.ExecSQL;
   finally
    Q.Free;
  end;
  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
 if CodOrdenacao = 'S' then
    Query.SQL.Add(' select SglRaca , DesRaca ')
  else
    Query.SQL.Add(' select DesRaca, SglRaca ');

  Query.SQL.Add('     , DesAptidao, QtdMinDiasGestacao, QtdMaxDiasGestacao ' +
                '  from #tmp_raca_relatorio ');
  if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by SglRaca ')
  else
    Query.SQL.Add(' order by DesRaca ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(305, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -305;
      Exit;
    End;
  End;
end;

function TIntRacas.GerarRelatorio(CodEspecie : Integer;CodOrdenacao : String; Tipo,QtdQuebraRelatorio: Integer): String;
const
  CodMetodo : Integer = 355;
  NomeMetodo: String = 'GerarRelatorio';
  CodRelatorio: Integer = 8;
var
  Q : THerdomQuery;
  Rel: TRelatorioPadrao;
  Retorno : Integer;
  sQuebra: String;
begin
  Result := '';

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Exit;
  End;

  {Realiza pesquisa de raças de acordo com os critérios informados}
  Retorno := PesquisarRelatorio(CodEspecie,CodOrdenacao);
  if Retorno < 0 then Exit;

  {Verifica se a pesquisa é válida (se existe algum registro)}
  if Query.IsEmpty then begin
    Mensagens.Adicionar(1142, Self.ClassName, NomeMetodo, []);
    Exit;
  end;
  
  Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
  try
    Rel.TipoDoArquvio := Tipo;

    {Define o relatório em questão e carrega os seus dados específicos}
    Retorno := Rel.CarregarRelatorio(CodRelatorio);
    if Retorno < 0 then Exit;

    Q := THerdomQuery.Create(Conexao, nil);
    Try
      Q.close;
      Q.Sql.Clear;
    {$IFDEF MSSQL}
      Q.Sql.Add(' select sgl_especie, des_especie from tab_especie ' +
                '  where cod_especie = :cod_especie ' );

    {$ENDIF}
      Q.ParamByName('cod_especie').AsInteger := CodEspecie;
      Q.Open;;
      if not Q.Eof then
        rel.TxtSubTitulo := 'Espécie: ' + Q.FieldByName('sgl_especie').AsString + ' - ' + Q.FieldByName('des_especie').AsString;

    Finally
      Q.Free;
    end;

    {Inicializa o procedimento de geração do arquivo de relatório}
    Retorno := Rel.InicializarRelatorio;
    if Retorno < 0 then Exit;

    sQuebra := '';
    Query.First;
    while not EOF do begin
      Rel.ImprimirColunasResultSet(Query);
      Query.Next;
    end;
    Retorno := Rel.FinalizarRelatorio;
    {Se a finalização foi bem sucedida retorna o nome do arquivo gerado}
    if Retorno = 0 then begin
      Result := Rel.NomeArquivo;
    end;
  finally
    Rel.Free;
  end;
end;

function TIntRacas.PesquisarAgrupamentos(CodRaca,
  CodTipoAgrupRacas: Integer): Integer;
Const
  NomeMetodo : String = 'PesquisarAgrupamentos';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(422) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add(' select tar.cod_agrupamento_racas as CodAgrupamentoRacas, ' +
                ' tar.sgl_agrupamento_racas as SglAgrupamentoRacas, ' +
                ' tar.des_agrupamento_racas as DesAgrupamentoRacas, ' +
                ' ttr.cod_tipo_agrup_racas as CodTipoAgrupRacas, ' +
                ' ttr.sgl_tipo_agrup_racas as SglTipoAgrupRacas, ' +
                ' ttr.des_tipo_agrup_racas as DesTipoAgrupRacas, ' +
                ' tcr.qtd_fracao_raca as QtdFracaoRaca ' +
                ' from tab_composicao_agrup_racas as tcr, ' +
                ' tab_agrupamento_racas as tar, ' +
                ' tab_tipo_agrup_racas as ttr ' +
                ' where tcr.cod_raca = :cod_raca ');
  if CodTipoAgrupRacas > 0 then
  Query.SQL.Add(' and   ttr.cod_tipo_agrup_racas = :cod_tipo_agrup_racas ');
  Query.SQL.Add(' and   ttr.cod_tipo_agrup_racas = tar.cod_tipo_agrup_racas ' +
                ' and   tcr.cod_agrupamento_racas = tar.cod_agrupamento_racas ');
  Query.SQL.Add(' order by ttr.sgl_tipo_agrup_racas, tar.sgl_agrupamento_racas ');
{$ENDIF}
  Query.ParamByName('cod_raca').AsInteger := CodRaca;
  if CodTipoAgrupRacas > 0 then
     Query.ParamByName('cod_tipo_agrup_racas').AsInteger:= CodTipoAgrupRacas;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1377, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1377;
      Exit;
    End;
  End;
end;

end.

