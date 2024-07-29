// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       :
// *  Descrição Resumida : Cadastro de SubTipos de Insumo
// ************************************************************************
// *  Últimas Alterações
// *
// *
// ********************************************************************
unit uIntSubTiposInsumo;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uIntSubTipoInsumo;

type
  TIntSubTiposInsumo = class(TIntClasseBDNavegacaoBasica)
  private
    FIntSubTipoInsumo : TIntSubTipoInsumo;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Buscar(CodSubTipoInsumo: Integer): integer;
    function Pesquisar(CodTipoInsumo: Integer;
      CodOrdenacao: String): Integer;
    function Inserir(CodTipoInsumo: Integer; SglSubTipoInsumo,
      DesSubTipoInsumo: String; QtdeIntervaloMinimoAplicacao: Integer;
      IndSexoAnimalAplicacao: String;
      NumOrdem: Integer): Integer;
    function Excluir(CodSubTipoInsumo: Integer): Integer;
    function Alterar(CodSubTipoInsumo: Integer; SglSubTipoInsumo,
      DesSubTipoString: String; QtdIntervaloMinimoAplicacao: Integer;
      IndSexoAnimalAplicacao: String;
      NumOrdem: Integer): Integer;

    property IntSubTipoInsumo : TIntSubTipoInsumo read FIntSubTipoInsumo write FIntSubTipoInsumo;
  end;

implementation

{ TIntGrausSangue}
constructor TIntSubTiposInsumo.Create;
begin
  inherited;
  FIntSubTipoInsumo := TIntSubTipoInsumo.Create;
end;

destructor TIntSubTiposInsumo.Destroy;
begin
  FIntSubTipoInsumo.Free;
  inherited;
end;

function TIntSubTiposInsumo.Buscar(CodSubTipoInsumo: Integer): integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(276) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------
      // Buscar Registro
      //-----------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select ti.cod_tipo_insumo ');
      Q.SQL.Add('     , ti.sgl_tipo_insumo ');
      Q.SQL.Add('     , ti.des_tipo_insumo ');
      Q.SQL.Add('     , ts.cod_sub_tipo_insumo ');
      Q.SQL.Add('     , ts.sgl_sub_tipo_insumo ');
      Q.SQL.Add('     , ts.des_sub_tipo_insumo ');
      Q.SQL.Add('     , ts.qtd_intervalo_minimo_aplicacao ');
      Q.SQL.Add('     , ts.ind_sexo_animal_aplicacao ');
      Q.SQL.Add('     , ts.num_ordem ');
      Q.SQL.Add('  from tab_tipo_insumo as ti ');
      Q.SQL.Add('  , tab_sub_tipo_insumo as ts ');
      Q.SQL.Add(' where ts.cod_sub_tipo_insumo = :cod_sub_tipo_insumo ');
      Q.SQL.Add('   and ti.cod_tipo_insumo = ts.cod_tipo_insumo ');
      Q.SQL.Add('   and ts.dta_fim_validade is null');
      Q.SQL.Add('   and ti.dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
      Q.Open;
      //---------------------------------------
      // Verifica se existe registro para busca
      //---------------------------------------
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(811, Self.ClassName, 'Buscar', []);
        Result := -811;
        Exit;
      End;
      //-------------------------------
      // Obtem informações do registro
      //-------------------------------
      IntSubTipoInsumo.CodTipoInsumo               := Q.FieldByName('cod_tipo_insumo').AsInteger;
      IntSubTipoInsumo.SglTipoInsumo               := Q.FieldByName('sgl_tipo_insumo').AsString;
      IntSubTipoInsumo.DesTipoInsumo               := Q.FieldByName('des_tipo_insumo').AsString;
      IntSubTipoInsumo.CodSubTipoInsumo            := Q.FieldByName('cod_sub_tipo_insumo').AsInteger;
      IntSubTipoInsumo.SglSubTipoInsumo            := Q.FieldByName('sgl_sub_tipo_insumo').AsString;
      IntSubTipoInsumo.DesSubTipoInsumo            := Q.FieldByName('des_sub_tipo_insumo').AsString;
      IntSubTipoInsumo.QtdIntervaloMinimoAplicacao := Q.FieldByName('qtd_intervalo_minimo_aplicacao').AsInteger;
      IntSubTipoInsumo.IndSexoAnimalAplicacao      := Q.FieldByName('ind_sexo_animal_aplicacao').AsString;
      IntSubTipoInsumo.NumOrdem                    := Q.FieldByName('num_ordem').AsInteger;

      Q.close;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(805, Self.ClassName, 'Buscar', [E.Message]);
        Result := -805;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntSubTiposInsumo.Pesquisar(CodTipoInsumo: Integer;
      CodOrdenacao: String): Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(277) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;

{$IFDEF MSSQL}
    Query.SQL.Add('select ts.cod_sub_tipo_insumo as CodSubTipoInsumo, ');
    Query.SQL.Add('       ts.sgl_sub_tipo_insumo as SglSubTipoInsumo, ');
    Query.SQL.Add('       ts.des_sub_tipo_insumo as DesSubTipoInsumo, ');
    Query.SQL.Add('       ti.cod_tipo_insumo as CodTipoInsumo, ');
    Query.SQL.Add('       ti.sgl_tipo_insumo as SglTipoInsumo, ');
    Query.SQL.Add('       ti.des_tipo_insumo as DesTipoInsumo, ');
    Query.SQL.Add('       ts.qtd_intervalo_minimo_aplicacao as QtdIntervaloMinimoAplicacao, ');
    Query.SQL.Add('       ts.num_ordem as NumOrdem ');
    Query.SQL.Add('  from tab_tipo_insumo as ti,');
    Query.SQL.Add('       tab_sub_tipo_insumo as ts ');
    Query.SQL.Add(' where ts.dta_fim_validade is null ');
    Query.SQL.Add(' and   ti.dta_fim_validade is null ');
    Query.SQL.Add(' and   ti.cod_tipo_insumo = ts.cod_tipo_insumo ');
    Query.SQL.Add(' and   ti.cod_tipo_insumo = :cod_tipo_insumo ');

  If UpperCase(CodOrdenacao) = 'O' Then Begin
    Query.SQL.Add(' order by ts.num_ordem ');
  End;
  If UpperCase(CodOrdenacao) = 'S' Then Begin
    Query.SQL.Add(' order by ts.sgl_sub_tipo_insumo ');
  End;
  If UpperCase(CodOrdenacao) = 'D' Then Begin
    Query.SQL.Add(' order by ts.des_sub_tipo_insumo ');
  End;

{$ENDIF}
  Query.ParamByName('cod_tipo_insumo').asinteger:=CodTipoInsumo;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(818, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -818;
      Exit;
    End;
  End;
end;

function TIntSubTiposInsumo.Inserir(CodTipoInsumo: Integer; SglSubTipoInsumo,
     DesSubTipoInsumo: String; QtdeIntervaloMinimoAplicacao: Integer;
     IndSexoAnimalAplicacao: String;
     NumOrdem: Integer): Integer;
var
  Q : THerdomQuery;
  CodSubTipoInsumo:integer;
  IndSistema:string;
  QtdMinimo:integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(278) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;
  //------------
  // Trata sigla
  //------------
  Result := VerificaString(SglSubTipoInsumo, 'Sigla do SubTipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglSubTipoInsumo, 5, 'Sigla do SubTipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  //----------------
  // Trata descrição
  //----------------
  Result := VerificaString(DesSubTipoInsumo, 'Descrição do SubTipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesSubTipoInsumo, 60, 'Descrição do SubTipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------------------
      // Verifica duplicidade de sigla
      //-------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_sub_tipo_insumo as ts,');
      Q.SQL.Add(' tab_tipo_insumo as ti ');
      Q.SQL.Add(' where  ts.sgl_sub_tipo_insumo = :sgl_sub_tipo_insumo');
      Q.SQL.Add(' and ts.cod_tipo_insumo = ti.cod_tipo_insumo ');
      Q.SQL.Add(' and ts.cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add(' and ts.dta_fim_validade is null ');
      Q.SQL.Add(' and ti.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_sub_tipo_insumo').AsString := SglSubTipoInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(820, Self.ClassName, 'Inserir', [SglSubTipoInsumo]);
        Result := -820;
        Exit;
      End;
      Q.Close;

      //-----------------------------------
      // Verifica duplicidade da Descrição
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_sub_tipo_insumo as ts,');
      Q.SQL.Add(' tab_tipo_insumo as ti ');
      Q.SQL.Add(' where  ts.des_sub_tipo_insumo = :des_sub_tipo_insumo');
      Q.SQL.Add(' and ts.cod_tipo_insumo = ti.cod_tipo_insumo ');
      Q.SQL.Add(' and ts.cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add(' and ts.dta_fim_validade is null ');
      Q.SQL.Add(' and ti.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_sub_tipo_insumo').AsString := DesSubTipoInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(822, Self.ClassName, 'Inserir', [DesSubTipoInsumo]);
        Result := -822;
        Exit;
      End;
      Q.Close;

      //-----------------------------------
      // Verifica se pode ser inserido
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ind_sub_tipo_obrigatorio,ind_restrito_sistema,qtd_intervalo_minimo_aplicacao from tab_tipo_insumo ');
      Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add(' and   dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(824, Self.ClassName, 'Inserir', [Inttostr(CodTipoInsumo)]);
        Result := -824;
        Exit;
      End
      Else begin
       if Q.fieldbyname('ind_sub_tipo_obrigatorio').asstring <> 'S' then Begin
          Mensagens.Adicionar(826, Self.ClassName, 'Inserir', [Inttostr(CodTipoInsumo)]);
          Result := -826;
          Exit;
       end
       else begin
          IndSistema := Q.fieldbyname('ind_restrito_sistema').asstring;
          QtdMinimo := Q.fieldbyname('qtd_intervalo_minimo_aplicacao').asinteger;
       end;
      end;
      Q.Close;

      //--------------------------------------------------------------------
      // Verifica Qtd_intervalo_minimo_aplicacao e ind_sexo_animal_aplicacao
      //--------------------------------------------------------------------
      if IndSistema = 'S' then begin
         if not ((IndSexoAnimalAplicacao = 'F') or (IndSexoAnimalAplicacao = 'M') or (IndSexoAnimalAplicacao = 'A')) then begin
            Mensagens.Adicionar(828, Self.ClassName, 'Inserir', [IndSexoAnimalAplicacao]);
            Result := -828;
            Exit;
         end;
         if QtdMinimo > QtdeIntervaloMinimoAplicacao then begin
            Mensagens.Adicionar(829, Self.ClassName, 'Inserir', [inttostr(QtdeIntervaloMinimoAplicacao)]);
            Result := -829;
            Exit;
         end;
      end;

      //------------------------------------
      // Verifica se NumOrdem foi informado
      //------------------------------------
      if NumOrdem < 0 then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(ts.num_ordem),0) + 1 as numordem from tab_sub_tipo_insumo as ts,');
        Q.SQL.Add(' tab_tipo_insumo as ti ');
        Q.SQL.Add(' where ts.cod_tipo_insumo = :cod_tipo_insumo ');
        Q.SQL.Add(' and ts.cod_tipo_insumo = ti.cod_tipo_insumo ');
        Q.SQL.Add(' and ts.dta_fim_validade is null ');
        Q.SQL.Add(' and ti.dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_tipo_insumo').AsInteger  := CodTipoInsumo;
        Q.Open;
        NumOrdem := Q.Fieldbyname('numordem').asinteger;
      end;

      //---------------------------------
      // Verifica duplicidade do NumOrdem
      //---------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_sub_tipo_insumo as ts,');
      Q.SQL.Add(' tab_tipo_insumo as ti ');
      Q.SQL.Add(' where  ts.num_ordem = :num_ordem');
      Q.SQL.Add(' and ts.cod_tipo_insumo = ti.cod_tipo_insumo ');
      Q.SQL.Add(' and ts.cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add(' and ts.dta_fim_validade is null ');
      Q.SQL.Add(' and ti.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('num_ordem').AsInteger  := NumOrdem;
      Q.ParamByName('cod_tipo_insumo').AsInteger  := CodTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(823, Self.ClassName, 'Inserir', [inttostr(numordem)]);
        Result := -823;
        Exit;
      End;
      Q.Close;

      //---------------
      // Abre transação
      //---------------
      BeginTran;

      //--------------------
      // Pega próximo código
      //---------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_sub_tipo_insumo), 0) + 1 as cod_sub_tipo_insumo ');
      Q.SQL.Add('  from tab_sub_tipo_insumo');
{$ENDIF}
      Q.Open;
      CodSubTipoInsumo := Q.FieldByName('cod_sub_tipo_insumo').AsInteger;
      //-------------------------
      // Tenta Inserir Registro
      //-------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_sub_tipo_insumo ');
      Q.SQL.Add(' (cod_sub_tipo_insumo, ');
      Q.SQL.Add('  sgl_sub_tipo_insumo, ');
      Q.SQL.Add('  des_sub_tipo_insumo, ');
      Q.SQL.Add('  cod_tipo_insumo, ');
      Q.SQL.Add('  qtd_intervalo_minimo_aplicacao, ');
      Q.SQL.Add('  ind_sexo_animal_aplicacao, ');
      Q.SQL.Add('  num_ordem, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_sub_tipo_insumo, ');
      Q.SQL.Add('  :sgl_sub_tipo_insumo, ');
      Q.SQL.Add('  :des_sub_tipo_insumo, ');
      Q.SQL.Add('  :cod_tipo_insumo, ');
      if IndSistema = 'S' then begin
        Q.SQL.Add('  :qtd_intervalo_minimo_aplicacao, ');
        Q.SQL.Add('  :ind_sexo_animal_aplicacao, ');
      end else begin
        Q.SQL.Add('  null, ');
        Q.SQL.Add('  null, ');
      end;
      Q.SQL.Add('  :num_ordem, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_sub_tipo_insumo').AsInteger            := CodSubTipoInsumo;
      Q.ParamByName('sgl_sub_tipo_insumo').AsString             := SglSubTipoInsumo;
      Q.ParamByName('des_sub_tipo_insumo').AsString             := DesSubTipoInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger                := CodTipoInsumo;
      if IndSistema = 'S' then begin
        Q.ParamByName('qtd_intervalo_minimo_aplicacao').AsInteger       := QtdeIntervaloMinimoAplicacao;
        Q.ParamByName('ind_sexo_animal_aplicacao').AsString             := IndSexoAnimalAplicacao;
      end;
      Q.ParamByName('num_ordem').AsInteger                      := NumOrdem;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodSubTipoInsumo;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(830, Self.ClassName, 'Inserir', [E.Message]);
        Result := -830;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntSubTiposInsumo.Excluir(CodSubTipoInsumo: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(279) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //-----------------------------------
      // Verifica a existência do registro
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_sub_tipo_insumo ');
      Q.SQL.Add(' where  cod_sub_tipo_insumo = :cod_sub_tipo_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(831, Self.ClassName, 'Excluir', [IntToStr(CodSubTipoInsumo)]);
        Result := -831;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;


      //------------------------------------
      // Exclui o Registro - DtaFimValidade
      //------------------------------------
      Q.Close;
      Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_sub_tipo_insumo ');
        Q.SQL.Add('   set dta_fim_validade = getdate() ');
        Q.SQL.Add(' where cod_sub_tipo_insumo = :cod_sub_tipo_insumo ');
  {$ENDIF}
      Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(832, Self.ClassName, 'Excluir', [E.Message]);
        Result := -832;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntSubTiposInsumo.Alterar(CodSubTipoInsumo: Integer; SglSubTipoInsumo,
      DesSubTipoString: String; QtdIntervaloMinimoAplicacao: Integer;
      IndSexoAnimalAplicacao: String;
      NumOrdem: Integer): Integer;
var
  Q : THerdomQuery;
  IndSistema:string;
  QtdMinimo:integer;
  CodTipoInsumo:Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(280) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  //------------
  // Trata sigla
  //------------
  Result := VerificaString(SglSubTipoInsumo, 'Sigla do SubTipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglSubTipoInsumo, 5, 'Sigla do SubTipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  //----------------
  // Trata descrição
  //----------------
  Result := VerificaString(DesSubTipoString, 'Descrição do SubTipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesSubTipoString, 60, 'Descrição do SubTipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //---------------------------------
      // Verifica o código do Tipo Insumo
      //---------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_tipo_insumo from tab_sub_tipo_insumo ');
      Q.SQL.Add(' where  cod_sub_tipo_insumo = :cod_sub_tipo_insumo');
{$ENDIF}
      Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
      Q.Open;
      CodTipoInsumo:=Q.fieldbyname('cod_tipo_insumo').AsInteger;
      
      //-------------------------------
      // Verifica duplicidade de sigla
      //-------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_sub_tipo_insumo as ts,');
      Q.SQL.Add(' tab_tipo_insumo as ti ');
      Q.SQL.Add(' where  ts.sgl_sub_tipo_insumo = :sgl_sub_tipo_insumo');
      Q.SQL.Add(' and ts.cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add(' and ts.cod_sub_tipo_insumo != :cod_sub_tipo_insumo ');
      Q.SQL.Add(' and ts.cod_tipo_insumo = ti.cod_tipo_insumo ');
      Q.SQL.Add(' and ts.dta_fim_validade is null ');
      Q.SQL.Add(' and ti.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_sub_tipo_insumo').AsString := SglSubTipoInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(820, Self.ClassName, 'Alterar', [SglSubTipoInsumo]);
        Result := -820;
        Exit;
      End;
      Q.Close;

      //-----------------------------------
      // Verifica duplicidade da Descrição
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_sub_tipo_insumo as ts,');
      Q.SQL.Add(' tab_tipo_insumo as ti ');
      Q.SQL.Add(' where  ts.des_sub_tipo_insumo = :des_sub_tipo_insumo');
      Q.SQL.Add(' and ts.cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add(' and ts.cod_sub_tipo_insumo != :cod_sub_tipo_insumo ');
      Q.SQL.Add(' and ts.cod_tipo_insumo = ti.cod_tipo_insumo ');
      Q.SQL.Add(' and ts.dta_fim_validade is null ');
      Q.SQL.Add(' and ti.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_sub_tipo_insumo').AsString := DesSubTipoString;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(822, Self.ClassName, 'Alterar', [DesSubTipoString]);
        Result := -822;
        Exit;
      End;
      Q.Close;

      //-----------------------------------
      // Verifica se pode ser alterado
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ti.ind_sub_tipo_obrigatorio,ti.ind_restrito_sistema,ti.qtd_intervalo_minimo_aplicacao from tab_tipo_insumo as ti, tab_sub_tipo_insumo as ts');
      Q.SQL.Add(' where ti.cod_tipo_insumo = ts.cod_tipo_insumo ');
      Q.SQL.Add(' and   ts.cod_sub_tipo_insumo = :cod_sub_tipo_insumo ');
      Q.SQL.Add(' and   ti.dta_fim_validade is null ');
      Q.SQL.Add(' and   ts.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(834, Self.ClassName, 'Alterar', [Inttostr(CodSubTipoInsumo)]);
        Result := -834;
        Exit;
      End
      Else begin
        IndSistema := Q.fieldbyname('ind_restrito_sistema').asstring;
        QtdMinimo := Q.fieldbyname('qtd_intervalo_minimo_aplicacao').asinteger;
      end;
      Q.Close;

      //--------------------------------------------------------------------
      // Verifica Qtd_intervalo_minimo_aplicacao e ind_sexo_animal_aplicacao
      //--------------------------------------------------------------------
      if IndSistema = 'S' then begin
         if not ((IndSexoAnimalAplicacao = 'F') or (IndSexoAnimalAplicacao = 'M') or (IndSexoAnimalAplicacao = 'A')) then begin
            Mensagens.Adicionar(828, Self.ClassName, 'Alterar', [IndSexoAnimalAplicacao]);
            Result := -828;
            Exit;
         end;
         if QtdMinimo > QtdIntervaloMinimoAplicacao then begin
            Mensagens.Adicionar(829, Self.ClassName, 'Alterar', [IndSexoAnimalAplicacao]);
            Result := -829;
            Exit;
         end;
      end;

      //------------------------------------
      // Verifica se NumOrdem foi informado
      //------------------------------------
      if NumOrdem < 0 then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select max(ts.num_ordem) + 1 as numordem from tab_sub_tipo_insumo as ts,');
        Q.SQL.Add(' tab_tipo_insumo as ti ');
        Q.SQL.Add(' where ts.cod_tipo_insumo = :cod_tipo_insumo ');
        Q.SQL.Add(' and ts.cod_tipo_insumo = ti.cod_tipo_insumo ');
        Q.SQL.Add(' and ts.dta_fim_validade is null ');
        Q.SQL.Add(' and ti.dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_tipo_insumo').AsInteger  := CodTipoInsumo;
        Q.Open;
        NumOrdem := Q.Fieldbyname('numordem').asinteger;
      end;
      //---------------------------------
      // Verifica duplicidade do NumOrdem
      //---------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_sub_tipo_insumo as ts,');
      Q.SQL.Add(' tab_tipo_insumo as ti ');
      Q.SQL.Add(' where  ts.num_ordem = :num_ordem');
      Q.SQL.Add(' and ts.cod_sub_tipo_insumo != :cod_sub_tipo_insumo ');
      Q.SQL.Add(' and ts.cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add(' and ts.cod_tipo_insumo = ti.cod_tipo_insumo ');
      Q.SQL.Add(' and ts.dta_fim_validade is null ');
      Q.SQL.Add(' and ti.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('num_ordem').AsInteger  := NumOrdem;
      Q.ParamByName('cod_sub_tipo_insumo').AsInteger  := CodSubTipoInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger  := CodTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(823, Self.ClassName, 'Inserir', [inttostr(numordem)]);
        Result := -823;
        Exit;
      End;
      Q.Close;

      //----------------
      // Abre transação
      //----------------
      BeginTran;

      //-----------------
      // Alterar Registro
      //-----------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_sub_tipo_insumo ');
      Q.SQL.Add('   set sgl_sub_tipo_insumo = :sgl_sub_tipo_insumo');
      Q.SQL.Add('     , des_sub_tipo_insumo = :des_sub_tipo_insumo');
      if IndSistema = 'S' then begin
        Q.SQL.Add('     , qtd_intervalo_minimo_aplicacao = :qtd_intervalo_minimo_aplicacao ');
        Q.SQL.Add('     , ind_sexo_animal_aplicacao = :ind_sexo_animal_aplicacao');
      end;
      Q.SQL.Add('     , num_ordem = :num_ordem');
      Q.SQL.Add(' where cod_sub_tipo_insumo = :cod_sub_tipo_insumo ');
{$ENDIF}
      Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
      Q.ParamByName('sgl_sub_tipo_insumo').AsString  := SglSubTipoInsumo;
      Q.ParamByName('des_sub_tipo_insumo').AsString  := DesSubTipoString;
      if IndSistema = 'S' then begin
        Q.ParamByName('qtd_intervalo_minimo_aplicacao').AsInteger       := QtdIntervaloMinimoAplicacao;
        Q.ParamByName('ind_sexo_animal_aplicacao').AsString             := IndSexoAnimalAplicacao;
      end;
      Q.ParamByName('num_ordem').AsInteger              := NumOrdem;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(833, Self.ClassName, 'Alterar', [E.Message]);
        Result := -833;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.
