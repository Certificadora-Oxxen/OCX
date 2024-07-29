// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       :
// *  Descrição Resumida : Cadastro de Tipos de Insumo
// ************************************************************************
// *  Últimas Alterações
// *
// *
// ********************************************************************
unit uIntTiposInsumo;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uIntTipoInsumo;

type
  { TIntGrausSangue }
  TIntTiposInsumo = class(TIntClasseBDNavegacaoBasica)
  private
    FIntTipoInsumo : TIntTipoInsumo;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Buscar(CodTipoInsumo: Integer): Integer;
    function Inserir(SglTipoInsumo, DesTipoInsumo, IndSubTipoObrigatorio,
      IndAdmitePartidaLote: String; NumOrdem: Integer): Integer;
    function Alterar(CodTipoInsumo: Integer; SglTipoInsumo,
      DesTipoInsumo: String; QtdIntervaloMinimoAplicacao,
      NumOrdem: Integer): Integer;
    function Excluir(CodTipoInsumo: Integer): Integer;
    function Pesquisar(CodSubEventoSanitario: Integer;
      CodOrdenacao,IndSubEventoSanitario: String): Integer;
    function AdicionarUnidadeMedida(CodTipoInsumo,
      CodUnidadeMedida: Integer): Integer;
    function RetirarUnidadeMedida(CodTipoInsumo,
      CodUnidadeMedida: Integer): Integer;
    function PesquisarUnidadesMedida(CodTipoInsumo: Integer;
      CodOrdenacao: String): Integer;

    property IntTipoInsumo : TIntTipoInsumo read FIntTipoInsumo write FIntTipoInsumo;
  end;

implementation

constructor TIntTiposInsumo.Create;
begin
  inherited;
  FIntTipoInsumo := TIntTipoInsumo.Create;
end;

destructor TIntTiposInsumo.Destroy;
begin
  FIntTipoInsumo.Free;
  inherited;
end;

function TIntTiposInsumo.Pesquisar(CodSubEventoSanitario: Integer;
      CodOrdenacao, IndSubEventoSanitario: String): Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  if IndSubEventoSanitario <> 'S' then
        CodSubEventoSanitario := -1;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(260) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;

{$IFDEF MSSQL}
    Query.SQL.Add('select cod_tipo_insumo as CodTipoInsumo, ');
    Query.SQL.Add('       sgl_tipo_insumo as SglTipoInsumo, ');
    Query.SQL.Add('       des_tipo_insumo as DesTipoInsumo, ');
    Query.SQL.Add('       ind_sub_tipo_obrigatorio as IndSubtipoObrigatorio, ');
    Query.SQL.Add('       ind_admite_partida_lote as IndAdmitePartidaLote, ');
    Query.SQL.Add('       num_ordem as NumOrdem ');
    Query.SQL.Add('  from tab_tipo_insumo ');
    Query.SQL.Add(' where dta_fim_validade is null ');
    if UpperCase(IndSubEventoSanitario) = 'S' then
       Query.SQL.Add(' and cod_tipo_sub_evento_sanitario is not null ');
    if UpperCase(IndSubEventoSanitario) = 'N' then
       Query.SQL.Add(' and cod_tipo_sub_evento_sanitario is null ');
    if CodSubEventoSanitario <> -1 then
       Query.SQL.Add(' and cod_sub_evento_sanitario =:cod_sub_evento_sanitario ');

  If UpperCase(CodOrdenacao) = 'O' Then Begin
    Query.SQL.Add(' order by num_ordem ');
  End;
  If UpperCase(CodOrdenacao) = 'S' Then Begin
    Query.SQL.Add(' order by sgl_tipo_insumo ');
  End;
  If UpperCase(CodOrdenacao) = 'D' Then Begin
    Query.SQL.Add(' order by des_tipo_insumo ');
  End;

{$ENDIF}
  if CodSubEventoSanitario <> -1 then
     Query.ParamByName('cod_sub_evento_sanitario').asinteger:=CodSubEventoSanitario;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(796, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -796;
      Exit;
    End;
  End;
end;

function TIntTiposInsumo.Inserir(SglTipoInsumo, DesTipoInsumo, IndSubTipoObrigatorio,
      IndAdmitePartidaLote: String; NumOrdem: Integer): Integer;
var
  Q : THerdomQuery;
  CodTipoInsumo:integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(261) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;
  //------------
  // Trata sigla
  //------------
  Result := VerificaString(SglTipoInsumo, 'Sigla do Tipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglTipoInsumo, 2, 'Sigla do Tipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  //----------------
  // Trata descrição
  //----------------
  Result := VerificaString(DesTipoInsumo, 'Descrição do Tipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesTipoInsumo, 30, 'Descrição do Tipo Insumo');
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
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where  sgl_tipo_insumo = :sgl_tipo_insumo');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_tipo_insumo').AsString := SglTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(797, Self.ClassName, 'Inserir', [SglTipoInsumo]);
        Result := -797;
        Exit;
      End;
      Q.Close;

      //-----------------------------------
      // Verifica duplicidade da Descrição
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where  des_tipo_insumo = :des_tipo_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_tipo_insumo').AsString := DesTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(798, Self.ClassName, 'Inserir', [DesTipoInsumo]);
        Result := -798;
        Exit;
      End;
      Q.Close;

      //------------------------------------
      // Verifica se NumOrdem foi informado
      //------------------------------------
      if NumOrdem < 0 then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select IsNull(max(num_ordem),0) + 1 as numordem ');
        Q.SQL.Add(' from tab_tipo_insumo ');
        Q.SQL.Add(' where dta_fim_validade is null ');
{$ENDIF}
        Q.Open;
        NumOrdem := Q.Fieldbyname('numordem').asinteger;
      end;
      //---------------------------------
      // Verifica duplicidade do NumOrdem
      //---------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where  num_ordem = :num_ordem');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('num_ordem').AsInteger  := NumOrdem;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(802, Self.ClassName, 'Inserir', [inttostr(numordem)]);
        Result := -802;
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
      Q.SQL.Add('select isnull(max(cod_tipo_insumo), 0) + 1 as cod_tipo_insumo ');
      Q.SQL.Add('  from tab_tipo_insumo');
{$ENDIF}
      Q.Open;
      CodTipoInsumo := Q.FieldByName('cod_tipo_insumo').AsInteger;
      //-------------------------
      // Tenta Inserir Registro
      //-------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_tipo_insumo ');
      Q.SQL.Add(' (cod_tipo_insumo, ');
      Q.SQL.Add('  sgl_tipo_insumo, ');
      Q.SQL.Add('  des_tipo_insumo, ');
      Q.SQL.Add('  ind_sub_tipo_obrigatorio, ');
      Q.SQL.Add('  ind_admite_partida_lote, ');
      Q.SQL.Add('  ind_restrito_sistema, ');
      Q.SQL.Add('  cod_tipo_sub_evento_sanitario, ');
      Q.SQL.Add('  qtd_intervalo_minimo_aplicacao, ');
      Q.SQL.Add('  num_ordem, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_tipo_insumo, ');
      Q.SQL.Add('  :sgl_tipo_insumo, ');
      Q.SQL.Add('  :des_tipo_insumo, ');
      Q.SQL.Add('  :ind_sub_tipo_obrigatorio, ');
      Q.SQL.Add('  :ind_admite_partida_lote, ');
      Q.SQL.Add('  ''N'', ');
      Q.SQL.Add('  null, ');
      Q.SQL.Add('  null, ');
      Q.SQL.Add('  :num_ordem, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger            := CodTipoInsumo;
      Q.ParamByName('sgl_tipo_insumo').AsString             := SglTipoInsumo;
      Q.ParamByName('des_tipo_insumo').AsString             := DesTipoInsumo;
      Q.ParamByName('ind_sub_tipo_obrigatorio').AsString    := IndSubTipoObrigatorio;
      Q.ParamByName('ind_admite_partida_lote').AsString     := IndAdmitePartidaLote;
      Q.ParamByName('num_ordem').AsInteger                  := NumOrdem;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodTipoInsumo;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(799, Self.ClassName, 'Inserir', [E.Message]);
        Result := -799;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposInsumo.Alterar(CodTipoInsumo: Integer; SglTipoInsumo,
      DesTipoInsumo: String; QtdIntervaloMinimoAplicacao,
      NumOrdem: Integer): Integer;
var
  Q : THerdomQuery;
  Tipo: String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(262) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //------------------------------------------------------------------
      // Verifica a existência do Codigo Tipo Insumo e o tipo de alteração
      //------------------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ind_restrito_sistema from tab_tipo_insumo ');
      Q.SQL.Add(' where  cod_tipo_insumo = :cod_tipo_insumo');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(800, Self.ClassName, 'Alterar', [IntToStr(CodTipoInsumo)]);
        Result := -800;
        Exit;
      End
      Else
        if Q.FieldByName('ind_restrito_sistema').asstring = 'S' then tipo := '1'
                                                                else tipo := '0';
      Q.Close;

if tipo = '0' then begin //Altera os campos sigla, descricao e numordem
  //------------
  // Trata sigla
  //------------
  Result := VerificaString(SglTipoInsumo, 'Sigla do Tipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglTipoInsumo, 2, 'Sigla do Tipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  //----------------
  // Trata descrição
  //----------------
  Result := VerificaString(DesTipoInsumo, 'Descrição do Tipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesTipoInsumo, 30, 'Descrição do Tipo Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

      //-------------------------------
      // Verifica duplicidade de sigla
      //-------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where  sgl_tipo_insumo = :sgl_tipo_insumo');
      Q.SQL.Add('   and  cod_tipo_insumo != :cod_tipo_insumo');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_tipo_insumo').AsString  := SglTipoInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(797, Self.ClassName, 'Alterar', [SglTipoInsumo]);
        Result := -797;
        Exit;
      End;
      Q.Close;

      //-----------------------------------
      // Verifica duplicidade da Descrição
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where  des_tipo_insumo = :des_tipo_insumo');
      Q.SQL.Add('   and  cod_tipo_insumo != :cod_tipo_insumo');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_tipo_insumo').AsString  := DesTipoInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(798, Self.ClassName, 'Alterar', [DesTipoInsumo]);
        Result := -798;
        Exit;
      End;
      Q.Close;

      //------------------------------------
      // Verifica se NumOrdem foi informado
      //------------------------------------
      if NumOrdem < 0 then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select IsNull(max(num_ordem),0) + 1 as numordem ');
        Q.SQL.Add(' from tab_tipo_insumo ');
        Q.SQL.Add(' where dta_fim_validade is null ');
{$ENDIF}
        Q.Open;
        NumOrdem := Q.Fieldbyname('numordem').asinteger;
      end;

      //---------------------------------
      // Verifica duplicidade do NumOrdem
      //---------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where  num_ordem = :num_ordem');
      Q.SQL.Add('   and  cod_tipo_insumo != :cod_tipo_insumo');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('num_ordem').AsInteger  := NumOrdem;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(802, Self.ClassName, 'Alterar', [inttostr(numordem)]);
        Result := -802;
        Exit;
      End;
      Q.Close;

end
else begin //altera somente  qtd_intervalo_minimo_aplicacao
      //------------------------------------------------------------
      // Verifica se qtd_intervalo_minimo_aplicacao é maior que zero
      //------------------------------------------------------------
      if QtdIntervaloMinimoAplicacao < 0 then begin
        Mensagens.Adicionar(801, Self.ClassName, 'Alterar', [Inttostr(QtdIntervaloMinimoAplicacao)]);
        Result := -801;
        Exit;
      End;
end;
      //----------------
      // Abre transação
      //----------------
      BeginTran;

      //-----------------
      // Alterar Registro
      //-----------------
      Q.SQL.Clear;
if tipo = '0' then begin
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_tipo_insumo ');
      Q.SQL.Add('   set sgl_tipo_insumo = :sgl_tipo_insumo');
      Q.SQL.Add('     , des_tipo_insumo = :des_tipo_insumo');
      Q.SQL.Add('     , num_ordem = :num_ordem');
      Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.ParamByName('sgl_tipo_insumo').AsString  := SglTipoInsumo;
      Q.ParamByName('des_tipo_insumo').AsString  := DesTipoInsumo;
      Q.ParamByName('num_ordem').AsInteger       := NumOrdem;
      Q.ExecSQL;
end else begin
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_tipo_insumo ');
      Q.SQL.Add('   set qtd_intervalo_minimo_aplicacao = :qtd_intervalo_minimo_aplicacao');
      Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.ParamByName('qtd_intervalo_minimo_aplicacao').AsInteger  := QtdIntervaloMinimoAplicacao;
      Q.ExecSQL;
end;
      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(803, Self.ClassName, 'Alterar', [E.Message]);
        Result := -803;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposInsumo.Excluir(CodTipoInsumo : Integer): Integer;
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
  If Not Conexao.PodeExecutarMetodo(263) Then Begin
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
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where  cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(800, Self.ClassName, 'Excluir', [IntToStr(CodTipoInsumo)]);
        Result := -800;
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
        Q.SQL.Add('update tab_tipo_insumo ');
        Q.SQL.Add('   set dta_fim_validade = getdate() ');
        Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
  {$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(804, Self.ClassName, 'Excluir', [E.Message]);
        Result := -804;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposInsumo.Buscar(CodTipoInsumo : Integer): Integer;
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
  If Not Conexao.PodeExecutarMetodo(264) Then Begin
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
      Q.SQL.Add('     , ti.ind_sub_tipo_obrigatorio ');
      Q.SQL.Add('     , ti.ind_admite_partida_lote ');
      Q.SQL.Add('     , ti.Ind_restrito_sistema ');
      Q.SQL.Add('     , ts.cod_tipo_sub_evento_sanitario ');
      Q.SQL.Add('     , ts.sgl_tipo_sub_evento_sanitario ');
      Q.SQL.Add('     , ts.des_tipo_sub_evento_sanitario ');
      Q.SQL.Add('     , ti.qtd_intervalo_minimo_aplicacao ');
      Q.SQL.Add('     , ti.num_ordem ');
      Q.SQL.Add('  from tab_tipo_insumo as ti ');
      Q.SQL.Add('  , tab_tipo_sub_evento_sanitario as ts ');
      Q.SQL.Add(' where ti.cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add('   and ti.cod_tipo_sub_evento_sanitario *= ts.cod_tipo_sub_evento_sanitario ');
      Q.SQL.Add('   and ti.dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      //---------------------------------------
      // Verifica se existe registro para busca
      //---------------------------------------
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(800, Self.ClassName, 'Buscar', []);
        Result := -800;
        Exit;
      End;
      //-------------------------------
      // Obtem informações do registro
      //-------------------------------
      IntTipoInsumo.CodTipoInsumo               := Q.FieldByName('cod_tipo_insumo').AsInteger;
      IntTipoInsumo.SglTipoInsumo               := Q.FieldByName('sgl_tipo_insumo').AsString;
      IntTipoInsumo.DesTipoInsumo               := Q.FieldByName('des_tipo_insumo').AsString;
      IntTipoInsumo.IndSubTipoObrigatorio       := Q.FieldByName('ind_sub_tipo_obrigatorio').AsString;
      IntTipoInsumo.IndAdmitePartidaLote        := Q.FieldByName('ind_admite_partida_lote').AsString;
      IntTipoInsumo.IndRestritoSistema          := Q.FieldByName('ind_restrito_sistema').AsString;
      IntTipoInsumo.CodSubEventoSanitario       := Q.FieldByName('cod_tipo_sub_evento_sanitario').AsInteger;
      IntTipoInsumo.SglSubEventoSanitario       := Q.FieldByName('sgl_tipo_sub_evento_sanitario').AsString;
      IntTipoInsumo.DesSubEventoSanitario       := Q.FieldByName('des_tipo_sub_evento_sanitario').AsString;
      IntTipoInsumo.QtdIntervaloMinimoAplicacao := Q.FieldByName('qtd_intervalo_minimo_aplicacao').AsInteger;
      IntTipoInsumo.NumOrdem                    := Q.FieldByName('num_ordem').AsInteger;

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

function TIntTiposInsumo.AdicionarUnidadeMedida(CodTipoInsumo,
      CodUnidadeMedida: Integer): Integer;
var
  Q : THerdomQuery;
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('AdicionarUnidadeMedida');
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(265) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'AdicionarGrauSangue', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //---------------------------------------
      // Verifica existencia do tipo Insumo
      //---------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(800, Self.ClassName, 'AdicionarUnidadeMedida', []);
        Result := -800;
        Exit;
      End;
      Q.Close;

      //---------------------------------------
      // Verifica existencia de Unidade Medida
      //---------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_unidade_medida ');
      Q.SQL.Add(' where cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(806, Self.ClassName, 'AdicionarUnidadeMedida', []);
        Result := -806;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo_unidade_medida ');
      Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add('   and cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
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
      Q.SQL.Add('insert into tab_tipo_insumo_unidade_medida ');
      Q.SQL.Add(' ( cod_tipo_insumo  ');
      Q.SQL.Add(' , cod_unidade_medida ');
      Q.SQL.Add(' )');
      Q.SQL.Add('values ');
      Q.SQL.Add(' ( :cod_tipo_insumo  ');
      Q.SQL.Add(' , :cod_unidade_medida ');
      Q.SQL.Add(' )');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger  := CodTipoInsumo;
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
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
        Mensagens.Adicionar(807, Self.ClassName, 'AdicionarUnidadeMedida', [E.Message]);
        Result := -807;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposInsumo.RetirarUnidadeMedida(CodTipoInsumo,
      CodUnidadeMedida: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('RetirarUnidadeMedida');
    Exit;
  End;
  // -----------------------------------------
  // Verifica se usuário pode executar método
  // -----------------------------------------
  If Not Conexao.PodeExecutarMetodo(266) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'RetirarGrauSangue', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //---------------------------------------
      // Verifica existencia do tipo Insumo
      //---------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo ');
      Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(800, Self.ClassName, 'AdicionarUnidadeMedida', []);
        Result := -800;
        Exit;
      End;
      Q.Close;

      //---------------------------------------
      // Verifica existencia de Unidade Medida
      //---------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_unidade_medida ');
      Q.SQL.Add(' where cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(806, Self.ClassName, 'AdicionarUnidadeMedida', []);
        Result := -806;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica existencia do Registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_insumo_unidade_medida ');
      Q.SQL.Add(' where cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add('   and cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
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
      Q.SQL.Add('delete from tab_tipo_insumo_unidade_medida  ');
      Q.SQL.Add(' where cod_tipo_insumo= :cod_tipo_insumo ');
      Q.SQL.Add('   and cod_unidade_medida = :cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger  := CodTipoInsumo;
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.ExecSQL;
      //-------------------
      // Confirma transação
      //-------------------
      Commit;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(808, Self.ClassName, 'RetirarUnidadeMedida', [E.Message]);
        Result := -808;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntTiposInsumo.PesquisarUnidadesMedida(CodTipoInsumo: Integer;
      CodOrdenacao: String): Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(267) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarUnidadeMedida', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tui.cod_tipo_insumo as CodTipoInsumo ' );
  Query.SQL.Add('     , tu.cod_unidade_medida as CodUnidadeMedida ');
  Query.SQL.Add('     , tu.sgl_unidade_medida as SglUnidadeMedida ');
  Query.SQL.Add('     , tu.des_unidade_medida as DesUnidadeMedida ');
  Query.SQL.Add('     , case tui.cod_tipo_insumo ');
  Query.SQL.Add('     when :cod_tipo_insumo then ''S'' ');
  Query.SQL.Add('     else ''N'' ');
  Query.SQL.Add('     end as IndAssociacaoTipoInsumo ');
  Query.SQL.Add('  from tab_tipo_insumo_unidade_medida tui ');
  Query.SQL.Add('     , tab_unidade_medida tu ');
  Query.SQL.Add(' where tu.cod_unidade_medida *= tui.cod_unidade_medida ');
  Query.SQL.Add('   and tui.cod_tipo_insumo = :cod_tipo_insumo ');
  if UpperCase(CodOrdenacao)= 'C' then begin
    Query.SQL.Add(' order by tu.cod_unidade_medida ');
  end
  else If UpperCase(CodOrdenacao)= 'S' then begin
    Query.SQL.Add(' order by tu.sgl_unidade_medida ');
  end
  else If UpperCase(CodOrdenacao)= 'D' then begin
    Query.SQL.Add(' order by tu.des_unidade_medida ');
  end;
{$ENDIF}
  Try
    Query.ParamByName('cod_tipo_insumo').asinteger:=CodTipoInsumo;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(809, Self.ClassName, 'PesquisarUnidadeMedida', [E.Message]);
      Result := -809;
      Exit;
    End;
  End;
end;

end.

