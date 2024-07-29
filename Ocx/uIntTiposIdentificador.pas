// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 15/08/2002
// *  Documentação       : Atributos Animais - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Tipos de Identificador
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    15/08/2002    Adicionar o Metodo PesquisarRelacionamento
// *   Carlos    28/08/2002    Adicionar os Métodos DefinirDoProdutor e Buscar do Produtor
// *
// *
// ********************************************************************
unit uIntTiposIdentificador;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uIntMensagens, uconexao,
     UIntIdentificadorDoProdutor;

type
  { TIntTiposIdentificador }
  TIntTiposIdentificador = class(TIntClasseBDNavegacaoBasica)
  private
    FIntIdentificadorDoProdutor : TIntIdentificadorDoProdutor;
    function VerificaIdentificadores(
             CodTipoIdentificador1, CodPosicaoIdentificador1,
             CodTipoIdentificador2, CodPosicaoIdentificador2,
             CodTipoIdentificador3, CodPosicaoIdentificador3,
             CodTipoIdentificador4, CodPosicaoIdentificador4: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Pesquisar(CodOrdenacao: String) : Integer;
    function DefinirDoProdutor(CodTipoIdentificador1,
             CodPosicaoIdentificador1, CodTipoIdentificador2,
             CodPosicaoIdentificador2, CodTipoIdentificador3,
             CodPosicaoIdentificador3, CodTipoIdentificador4,
             CodPosicaoIdentificador4: Integer): Integer;

    function BuscarDoProdutor(NumSequenciadentificador: Integer): Integer;
    property IntIdentificadorDoProdutor : TIntIdentificadorDoProdutor read FIntIdentificadorDoProdutor write FIntIdentificadorDoProdutor;
end;
implementation

{ TIntTiposIdentificador}

constructor TIntTiposIdentificador.Create;
begin
  inherited;
  FIntIdentificadorDoProdutor := TIntIdentificadorDoProdutor.Create;
end;

destructor TIntTiposIdentificador.Destroy;
begin
  FIntIdentificadorDoProdutor.Free;
  inherited;
end;

function TIntTiposIdentificador.VerificaIdentificadores(
  CodTipoIdentificador1, CodPosicaoIdentificador1,
  CodTipoIdentificador2, CodPosicaoIdentificador2,
  CodTipoIdentificador3, CodPosicaoIdentificador3,
  CodTipoIdentificador4, CodPosicaoIdentificador4: Integer): Integer;
var
  QtdTransponder, QtdBrinco : Integer;
  Q : THerdomQuery;
begin
  Result := 0;

  QtdTransponder := 0;
  QtdBrinco := 0;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Consiste dados do Identificador1
      If CodTipoIdentificador1 > 0 Then Begin
        // Verifica se identificador é válido (R29)
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select ind_transponder, ind_brinco from tab_tipo_identificador ');
        Q.SQL.Add(' where cod_tipo_identificador = :cod_tipo_identificador ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_tipo_identificador').AsInteger := CodTipoIdentificador1;

        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(628, Self.ClassName, 'DefinirDoProdutor', []);
          Result := -628;
          Exit;
        End;
        If Q.FieldByName('ind_transponder').AsString = 'S' Then Begin
          Inc(QtdTransponder);
        End;
        If Q.FieldByName('ind_brinco').AsString = 'S' Then Begin
          Inc(QtdBrinco);
        End;
        Q.Close;

        // Verifica se a posição informada é válida (R46, R47)
        If CodPosicaoIdentificador1 > 0 then Begin
          Q.SQL.Clear;
    {$IFDEF MSSQL}
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('  from tab_posicao_identificador tpi, ');
        Q.SQL.Add('       tab_grupo_posicao_ident tgpi, ');
        Q.SQL.Add('       tab_tipo_identificador tti ');
        Q.SQL.Add(' where tpi.cod_posicao_identificador = :cod_posicao_identificador ');
        Q.SQL.Add('   and tgpi.cod_posicao_identificador = tpi.cod_posicao_identificador ');
        Q.SQL.Add('   and tgpi.cod_grupo_identificador = tti.cod_grupo_identificador ');
        Q.SQL.Add('   and tti.cod_tipo_identificador = :cod_tipo_identificador ');
        Q.SQL.Add('   and tpi.dta_fim_validade is null ');
    {$ENDIF}
          Q.ParamByName('cod_tipo_identificador').AsInteger := CodTipoIdentificador1;
          Q.ParamByName('cod_posicao_identificador').AsInteger := CodPosicaoIdentificador1;

          Q.Open;
          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(630, Self.ClassName, 'DefinirDoProdutor', []);
            Result := -630;
            Exit;
          End;
          Q.Close;
        End Else Begin
//          Mensagens.Adicionar(629, Self.ClassName, 'DefinirDoProdutor', []);
//          Result := -629;
//          Exit;
        End;
      End Else Begin
        If CodPosicaoIdentificador1 > 0 Then Begin
          Mensagens.Adicionar(627, Self.ClassName, 'DefinirDoProdutor', []);
          Result := -627;
          Exit;
        End;
      End;

      // Consiste dados do Identificador2
      If CodTipoIdentificador2 > 0 Then Begin
        // Verifica se identificador é válido (R29)
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select ind_transponder, ind_brinco from tab_tipo_identificador ');
        Q.SQL.Add(' where cod_tipo_identificador = :cod_tipo_identificador ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_tipo_identificador').AsInteger := CodTipoIdentificador2;

        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(628, Self.ClassName, 'DefinirDoProdutor', []);
          Result := -628;
          Exit;
        End;
        If Q.FieldByName('ind_transponder').AsString = 'S' Then Begin
          Inc(QtdTransponder);
        End;
        If Q.FieldByName('ind_brinco').AsString = 'S' Then Begin
          Inc(QtdBrinco);
        End;
        Q.Close;

        // Verifica se a posição informada é válida (R46, R47)
        If CodPosicaoIdentificador2 > 0 then Begin
          Q.SQL.Clear;
    {$IFDEF MSSQL}
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('  from tab_posicao_identificador tpi, ');
        Q.SQL.Add('       tab_grupo_posicao_ident tgpi, ');
        Q.SQL.Add('       tab_tipo_identificador tti ');
        Q.SQL.Add(' where tpi.cod_posicao_identificador = :cod_posicao_identificador ');
        Q.SQL.Add('   and tgpi.cod_posicao_identificador = tpi.cod_posicao_identificador ');
        Q.SQL.Add('   and tgpi.cod_grupo_identificador = tti.cod_grupo_identificador ');
        Q.SQL.Add('   and tti.cod_tipo_identificador = :cod_tipo_identificador ');
        Q.SQL.Add('   and tpi.dta_fim_validade is null ');
    {$ENDIF}
          Q.ParamByName('cod_tipo_identificador').AsInteger := CodTipoIdentificador2;
          Q.ParamByName('cod_posicao_identificador').AsInteger := CodPosicaoIdentificador2;

          Q.Open;
          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(630, Self.ClassName, 'DefinirDoProdutor', []);
            Result := -630;
            Exit;
          End;
          Q.Close;
        End Else Begin
//          Mensagens.Adicionar(629, Self.ClassName, 'DefinirDoProdutor', []);
//          Result := -629;
//          Exit;
        End;
      End Else Begin
        If CodPosicaoIdentificador2 > 0 Then Begin
          Mensagens.Adicionar(627, Self.ClassName, 'DefinirDoProdutor', []);
          Result := -627;
          Exit;
        End;
      End;

      // Consiste dados do Identificador3
      If CodTipoIdentificador3 > 0 Then Begin
        // Verifica se identificador é válido (R29)
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select ind_transponder, ind_brinco from tab_tipo_identificador ');
        Q.SQL.Add(' where cod_tipo_identificador = :cod_tipo_identificador ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_tipo_identificador').AsInteger := CodTipoIdentificador3;

        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(628, Self.ClassName, 'DefinirDoProdutor', []);
          Result := -628;
          Exit;
        End;
        If Q.FieldByName('ind_transponder').AsString = 'S' Then Begin
          Inc(QtdTransponder);
        End;
        If Q.FieldByName('ind_brinco').AsString = 'S' Then Begin
          Inc(QtdBrinco);
        End;
        Q.Close;

        // Verifica se a posição informada é válida (R46, R47)
        If CodPosicaoIdentificador3 > 0 then Begin
          Q.SQL.Clear;
    {$IFDEF MSSQL}
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('  from tab_posicao_identificador tpi, ');
        Q.SQL.Add('       tab_grupo_posicao_ident tgpi, ');
        Q.SQL.Add('       tab_tipo_identificador tti ');
        Q.SQL.Add(' where tpi.cod_posicao_identificador = :cod_posicao_identificador ');
        Q.SQL.Add('   and tgpi.cod_posicao_identificador = tpi.cod_posicao_identificador ');
        Q.SQL.Add('   and tgpi.cod_grupo_identificador = tti.cod_grupo_identificador ');
        Q.SQL.Add('   and tti.cod_tipo_identificador = :cod_tipo_identificador ');
        Q.SQL.Add('   and tpi.dta_fim_validade is null ');
    {$ENDIF}
          Q.ParamByName('cod_tipo_identificador').AsInteger := CodTipoIdentificador3;
          Q.ParamByName('cod_posicao_identificador').AsInteger := CodPosicaoIdentificador3;

          Q.Open;
          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(630, Self.ClassName, 'DefinirDoProdutor', []);
            Result := -630;
            Exit;
          End;
          Q.Close;
        End Else Begin
//          Mensagens.Adicionar(629, Self.ClassName, 'DefinirDoProdutor', []);
//          Result := -629;
//          Exit;
        End;
      End Else Begin
        If CodPosicaoIdentificador3 > 0 Then Begin
          Mensagens.Adicionar(627, Self.ClassName, 'DefinirDoProdutor', []);
          Result := -627;
          Exit;
        End;
      End;

      // Consiste dados do Identificador4
      If CodTipoIdentificador4 > 0 Then Begin
        // Verifica se identificador é válido (R29)
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select ind_transponder, ind_brinco from tab_tipo_identificador ');
        Q.SQL.Add(' where cod_tipo_identificador = :cod_tipo_identificador ');
        Q.SQL.Add('   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_tipo_identificador').AsInteger := CodTipoIdentificador4;

        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(628, Self.ClassName, 'DefinirDoProdutor', []);
          Result := -628;
          Exit;
        End;
        If Q.FieldByName('ind_transponder').AsString = 'S' Then Begin
          Inc(QtdTransponder);
        End;
        If Q.FieldByName('ind_brinco').AsString = 'S' Then Begin
          Inc(QtdBrinco);
        End;
        Q.Close;

        // Verifica se a posição informada é válida (R46, R47)
        If CodPosicaoIdentificador4 > 0 then Begin
          Q.SQL.Clear;
    {$IFDEF MSSQL}
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('  from tab_posicao_identificador tpi, ');
        Q.SQL.Add('       tab_grupo_posicao_ident tgpi, ');
        Q.SQL.Add('       tab_tipo_identificador tti ');
        Q.SQL.Add(' where tpi.cod_posicao_identificador = :cod_posicao_identificador ');
        Q.SQL.Add('   and tgpi.cod_posicao_identificador = tpi.cod_posicao_identificador ');
        Q.SQL.Add('   and tgpi.cod_grupo_identificador = tti.cod_grupo_identificador ');
        Q.SQL.Add('   and tti.cod_tipo_identificador = :cod_tipo_identificador ');
        Q.SQL.Add('   and tpi.dta_fim_validade is null ');
    {$ENDIF}
          Q.ParamByName('cod_tipo_identificador').AsInteger := CodTipoIdentificador4;
          Q.ParamByName('cod_posicao_identificador').AsInteger := CodPosicaoIdentificador4;

          Q.Open;
          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(630, Self.ClassName, 'DefinirDoProdutor', []);
            Result := -630;
            Exit;
          End;
          Q.Close;
        End Else Begin
//          Mensagens.Adicionar(629, Self.ClassName, 'DefinirDoProdutor', []);
//          Result := -629;
//          Exit;
        End;
      End Else Begin
        If CodPosicaoIdentificador4 > 0 Then Begin
          Mensagens.Adicionar(627, Self.ClassName, 'DefinirDoProdutor', []);
          Result := -627;
          Exit;
        End;
      End;

      // Verifica transponder (R48, R49)
      If QtdTransponder >1 Then Begin
          Mensagens.Adicionar(633, Self.ClassName, 'DefinirDoProdutor', []);
          Result := -633;
          Exit;
      End;

      // Verifica brincos (R48)
      If QtdBrinco > 2 Then Begin
        Mensagens.Adicionar(634, Self.ClassName, 'DefinirDoProdutor', []);
        Result := -634;
        Exit;
      End;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(496, Self.ClassName, 'DefinirDoProdutor', [E.Message, 'identificadores e transponder']);
        Result := -496;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposIdentificador.Pesquisar(CodOrdenacao: String) : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(112) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_tipo_identificador as CodTipoIdentificador ');
  Query.SQL.Add('     , sgl_tipo_identificador as SglTipoIdentificador ');
  Query.SQL.Add('     , des_tipo_identificador as DesTipoIdentificador ');
  Query.SQL.Add('     , ind_transponder as IndTransponder ');
  Query.SQL.Add('     , ind_brinco  as IndBrinco ');
  Query.SQL.Add('     , cod_grupo_identificador as CodGrupoIdentificador ');
  Query.SQL.Add('  from tab_tipo_identificador ');
  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by cod_tipo_identificador ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by sgl_tipo_identificador ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by des_tipo_identificador ');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(340, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -340;
      Exit;
    End;
  End;
end;

function TIntTiposIdentificador.DefinirDoProdutor(CodTipoIdentificador1,
             CodPosicaoIdentificador1, CodTipoIdentificador2,
             CodPosicaoIdentificador2, CodTipoIdentificador3,
             CodPosicaoIdentificador3, CodTipoIdentificador4,
             CodPosicaoIdentificador4: Integer): Integer;
var
  Q : THerdomQuery;
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('DefinirDoProdutor');
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(238) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'DefinirDoProdutor', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
 Try
  Try
  // Verifica Identificadores e Posicoes (R29, R46, R47, R48, R49)
  Result := VerificaIdentificadores(CodTipoIdentificador1, CodPosicaoIdentificador1,
    CodTipoIdentificador2, CodPosicaoIdentificador2, CodTipoIdentificador3, CodPosicaoIdentificador3,
    CodTipoIdentificador4, CodPosicaoIdentificador4);
  If Result < 0 Then Begin
    Exit;
  End;
      //---------------
      // Abre transação
      //---------------
     BeginTran;

      //---------------------------
      // Tenta Atualizar o Registro
      //---------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_produtor ');
      Q.SQL.Add(' set ');

      if (CodTipoIdentificador1 < 0)
          then Q.SQL.Add(' cod_tipo_identificador_1 = null')
          else Q.SQL.Add(' cod_tipo_identificador_1 = :CodTipoIdentificador1');

      if (CodPosicaoIdentificador1 < 0)
          then Q.SQL.Add(' ,cod_posicao_identificador_1 = null')
          else Q.SQL.Add(' ,cod_posicao_identificador_1 = :CodPosicaoIdentificador1');

      if (CodTipoIdentificador2 < 0)
          then Q.SQL.Add(' ,cod_tipo_identificador_2 = null')
          else Q.SQL.Add(' ,cod_tipo_identificador_2 = :CodTipoIdentificador2');

      if (CodPosicaoIdentificador2 < 0)
          then Q.SQL.Add(' ,cod_posicao_identificador_2 = null')
          else Q.SQL.Add(' ,cod_posicao_identificador_2 = :CodPosicaoIdentificador2');

      if (CodTipoIdentificador3 < 0)
          then Q.SQL.Add(' ,cod_tipo_identificador_3 = null')
          else Q.SQL.Add(' ,cod_tipo_identificador_3 = :CodTipoIdentificador3');

      if (CodPosicaoIdentificador3 < 0)
          then Q.SQL.Add(' ,cod_posicao_identificador_3 = null')
          else Q.SQL.Add(' ,cod_posicao_identificador_3 = :CodPosicaoIdentificador3');

      if (CodTipoIdentificador4 < 0)
          then Q.SQL.Add(' ,cod_tipo_identificador_4 = null')
          else Q.SQL.Add(' ,cod_tipo_identificador_4 = :CodTipoIdentificador4');

      Q.SQL.Add(' ,cod_posicao_identificador_4 = null');

      Q.SQL.Add(' where cod_pessoa_produtor = :CodPessoaProdutor');
{$ENDIF}
      if (CodTipoIdentificador1 > 0)
          then Q.ParamByName('CodTipoIdentificador1').AsInteger := CodTipoIdentificador1;
      if (CodPosicaoIdentificador1 > 0)
          then Q.ParamByName('CodPosicaoIdentificador1').AsInteger := CodPosicaoIdentificador1;

      if (CodTipoIdentificador2 > 0)
          then Q.ParamByName('CodTipoIdentificador2').AsInteger := CodTipoIdentificador2;
      if (CodPosicaoIdentificador2 > 0)
          then Q.ParamByName('CodPosicaoIdentificador2').AsInteger := CodPosicaoIdentificador2;

      if (CodTipoIdentificador3 > 0)
          then Q.ParamByName('CodTipoIdentificador3').AsInteger := CodTipoIdentificador3;
      if (CodPosicaoIdentificador3 > 0)
          then Q.ParamByName('CodPosicaoIdentificador3').AsInteger := CodPosicaoIdentificador3;

      if (CodTipoIdentificador4 > 0)
          then Q.ParamByName('CodTipoIdentificador4').AsInteger := CodTipoIdentificador4;

      Q.ParamByName('CodPessoaProdutor').AsInteger := Conexao.CodProdutorTrabalho;
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
        Mensagens.Adicionar(696, Self.ClassName, 'DefinirDoProdutor', [E.Message]);
        Result := -696;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposIdentificador.BuscarDoProdutor(NumSequenciadentificador: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(239) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'BuscarDoProdutor', []);
    Result := -188;
    Exit;
  End;

  If not(NumSequenciadentificador in [1,2,3,4]) then begin
    Mensagens.Adicionar(697, Self.ClassName, 'BuscarDoProdutor', []);
    Result := -697;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
 Q.SQL.Add(' select tpi.cod_posicao_identificador as CodPosicaoIdentificador ' +
           ',tpi.sgl_posicao_identificador as SglPosicaoIdentificador ' +
           ',tpi.des_posicao_identificador as DesPosicaoIdentificador ' +
           ',tgi.cod_grupo_identificador as CodGrupoIdentificador ' +
           'from tab_posicao_identificador as tpi, ' +
           'tab_grupo_identificador as tgi, ' +
           'tab_grupo_posicao_ident as tgpi, ' +
           'tab_produtor as tp ' +
           'where tp.cod_pessoa_produtor = :CodPessoaProdutor ' +
           'and tgpi.cod_posicao_identificador = tpi.cod_posicao_identificador ' +
           'and tgpi.cod_grupo_identificador = tgi.cod_grupo_identificador ');

 if NumSequenciadentificador = 1 then
     Q.SQL.Add('and tp.cod_posicao_identificador_1 = tpi.cod_posicao_identificador ');

 if NumSequenciadentificador = 2 then
     Q.SQL.Add('and tp.cod_posicao_identificador_2 = tpi.cod_posicao_identificador ');

 if NumSequenciadentificador = 3 then
     Q.SQL.Add('and tp.cod_posicao_identificador_3 = tpi.cod_posicao_identificador ');

 if NumSequenciadentificador = 4 then
     Q.SQL.Add('and tp.cod_posicao_identificador_4 = tpi.cod_posicao_identificador ');


{$ENDIF}
      Q.ParamByName('CodPessoaProdutor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
         FIntIdentificadorDoProdutor.CodPosicaoIdentificador  := 0;
         FIntIdentificadorDoProdutor.SglPosicaoIdentificador  := '';
         FIntIdentificadorDoProdutor.DesPosicaoIdentificador  := '';
         FIntIdentificadorDoProdutor.CodGrupoIdentificador    := '';
      End;

      // Obtem informações do registro
         FIntIdentificadorDoProdutor.CodPosicaoIdentificador  := Q.FieldByName('CodPosicaoIdentificador').AsInteger;
         FIntIdentificadorDoProdutor.SglPosicaoIdentificador  := Q.FieldByName('SglPosicaoIdentificador').AsString;
         FIntIdentificadorDoProdutor.DesPosicaoIdentificador  := Q.FieldByName('DesPosicaoIdentificador').AsString;
         FIntIdentificadorDoProdutor.CodGrupoIdentificador    := Q.FieldByName('CodGrupoIdentificador').AsString;


      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
 Q.SQL.Add(' select tti.cod_tipo_identificador as CodTipoIdentificador ' +
           ',tti.sgl_tipo_identificador as SglTipoIdentificador ' +
           ',tti.des_tipo_identificador as DesTipoIdentificador ' +
           'from tab_tipo_identificador as tti, ' +
           'tab_produtor as tp ' +
           'where tp.cod_pessoa_produtor = :CodPessoaProdutor ');

 if NumSequenciadentificador = 1 then
     Q.SQL.Add('and tp.cod_tipo_identificador_1 = tti.cod_tipo_identificador ');

 if NumSequenciadentificador = 2 then
     Q.SQL.Add('and tp.cod_tipo_identificador_2 = tti.cod_tipo_identificador ');

 if NumSequenciadentificador = 3 then
     Q.SQL.Add('and tp.cod_tipo_identificador_3 = tti.cod_tipo_identificador ');

 if NumSequenciadentificador = 4 then
     Q.SQL.Add('and tp.cod_tipo_identificador_4 = tti.cod_tipo_identificador ');


{$ENDIF}
      Q.ParamByName('CodPessoaProdutor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
         FIntIdentificadorDoProdutor.CodTipoIdentificador  := 0;
         FIntIdentificadorDoProdutor.SglTipoIdentificador  := '';
         FIntIdentificadorDoProdutor.DesTipoIdentificador  := '';
      End;

      // Obtem informações do registro
         FIntIdentificadorDoProdutor.CodTipoIdentificador  := Q.FieldByName('CodTipoIdentificador').AsInteger;
         FIntIdentificadorDoProdutor.SglTipoIdentificador  := Q.FieldByName('SglTipoIdentificador').AsString;
         FIntIdentificadorDoProdutor.DesTipoIdentificador  := Q.FieldByName('DesTipoIdentificador').AsString;


      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(698, Self.ClassName, 'Buscar', [E.Message]);
        Result := -698;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

end.

