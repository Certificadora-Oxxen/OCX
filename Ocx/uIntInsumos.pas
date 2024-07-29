// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 16/09/2002
// *  Documentação       :
// *  Código Classe      :  63
// *  Descrição Resumida : Cadastro de Insumo
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    16/10/2002    Criação
// *
// ********************************************************************
unit uIntInsumos;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uIntInsumo,uFerramentas;

type
  { TIntInsumos }
  TIntInsumos = class(TIntClasseBDNavegacaoBasica)
  private
    FIntInsumo : TIntInsumo;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(DesInsumo: String;CodTipoInsumo,CodSubTipoInsumo,CodFabricanteInsumo :Integer;CodOrdenacao : String) : Integer;
    function Inserir(DesInsumo: String;CodTipoInsumo,CodSubTipoInsumo,CodFabricanteInsumo : Integer;txtObservacao : String): Integer;
    function Alterar(CodInsumo : Integer;DesInsumo,TxtObservacao : String): Integer;
    function Excluir(CodInsumo: Integer): Integer;
    function Buscar(CodInsumo: Integer): Integer;

    property IntInsumo : TIntInsumo read FIntInsumo write FIntInsumo;
  end;

implementation

{ TIntInsumos }
constructor TIntInsumos.Create;
begin
  inherited;
  FIntInsumo := TIntInsumo.Create;
end;

destructor TIntInsumos.Destroy;
begin
  FIntInsumo.Free;
  inherited;
end;

function TIntInsumos.Pesquisar(DesInsumo: String;CodTipoInsumo,CodSubTipoInsumo,CodFabricanteInsumo :Integer;CodOrdenacao : String) : Integer;
var
  sOrd : String;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(288) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  If (CodTipoInsumo = -1) and (CodSubTipoInsumo <> -1)  Then Begin
    Mensagens.Adicionar(866, Self.ClassName, 'Pesquisar', []);
    Result := -866;
    Exit;
  End;


  if UpperCase(CodOrdenacao) =  'D' then
    sOrd := ' order by ti.des_insumo '
  else if UpperCase(CodOrdenacao) =  'T' then
    sOrd := ' order by tti.des_tipo_insumo,tsti.des_sub_tipo_insumo,ti.des_insumo '
  else if UpperCase(CodOrdenacao) =  'F' then
    sOrd := ' order by tf.Nom_reduzido_Fabricante,ti.des_insumo ';

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select ti.cod_insumo as CodInsumo ' +
            ' , ti.des_insumo as DesInsumo' +
            ' , tti.cod_tipo_insumo as CodTipoInsumo' +
            ' , tti.sgl_tipo_insumo as SglTipoInsumo' +
            ' , tti.Des_tipo_insumo as DesTipoInsumo' +
            ' , tsti.Cod_sub_tipo_insumo as CodSubTipoInsumo' +
            ' , tsti.Sgl_sub_tipo_insumo as SglSubTipoInsumo' +
            ' , tsti.Des_sub_tipo_insumo as DesSubTipoInsumo' +
            ' , tf.Cod_Fabricante_insumo as CodFabricanteInsumo' +
            ' , tf.Nom_reduzido_Fabricante as NomReduzidoFabricanteInsumo' +
            ' , tf.nom_fabricante_insumo as NomFabricanteInsumo' +
            ' , tf.num_registro_fabricante as NumRegistroFabricante' +
       ' from tab_insumo ti' +
        '   , tab_tipo_insumo tti' +
        '   , tab_sub_tipo_insumo tsti' +
        '   , tab_fabricante_insumo tf' +
       ' where tti.cod_tipo_insumo  = ti.cod_tipo_insumo' +
        '  and tsti.cod_tipo_insumo  =* ti.cod_tipo_insumo' +
        '  and tsti.cod_sub_tipo_insumo =* ti.cod_sub_tipo_insumo' +
        '  and tf.cod_fabricante_insumo = ti.cod_fabricante_insumo' +
        '  and ((ti.cod_tipo_insumo = :cod_tipo_insumo) or (:cod_tipo_insumo = -1))' +
        '  and ((ti.cod_sub_tipo_insumo = :cod_sub_tipo_insumo) or (:cod_sub_tipo_insumo = -1))' +
        '  and ((ti.cod_fabricante_insumo = :cod_fabricante_insumo) or (:cod_fabricante_insumo = -1))' +
        '  and ti.des_insumo like :des_insumo ' +
        '  and ti.dta_fim_validade is null ' +
          sOrd );
{$ENDIF}
  Query.ParamByName('cod_tipo_insumo').asInteger := CodTipoInsumo;
  Query.ParamByName('cod_sub_tipo_insumo').asInteger := CodSubTipoInsumo;
  Query.ParamByName('cod_fabricante_insumo').asInteger := CodFabricanteInsumo;
  Query.ParamByName('des_insumo').asString := '%' + trim(DesInsumo) + '%';
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(862, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -862;
      Exit;
    End;
  End;
end;

function TIntInsumos.Inserir(DesInsumo: String;CodTipoInsumo,CodSubTipoInsumo,CodFabricanteInsumo: Integer;txtObservacao : String): Integer;
var
  Q : THerdomQuery;
  CodInsumo : Integer;
  sIndAdimeteSubTipo : String;
begin

  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(290) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  //-----------------
  //Valida Descrição
  //-----------------
  Result := VerificaString(DesInsumo,'Descrição do Insumo');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesInsumo,20,'Descrição do Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  //---------------------
  //Valida txtObservacao
  //---------------------
  if trim(txtObservacao) <> '' then begin
    Result := TrataString(txtObservacao,255,'Observação do Insumo');
    If Result < 0 Then Begin
      Exit;
    End;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------------------
      // Verifica duplicidade da Descrição
      //-----------------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_insumo ' +
         ' where des_insumo = :des_insumo' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_insumo').AsString := DesInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(863, Self.ClassName, 'Inserir', [DesInsumo]);
        Result := -863;
        Exit;
      End;
      Q.Close;

      //-------------------------------
      // Verifica Codigo do Tipo Insumo
      //-------------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select ind_sub_tipo_obrigatorio from tab_tipo_insumo ' +
         ' where cod_tipo_insumo = :cod_tipo_insumo ' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(800, Self.ClassName, 'Inserir', [IntToStr(CodTipoInsumo)]);
        Result := -800;
        Exit;
      End;
      sIndAdimeteSubTipo := Q.fieldByName('ind_sub_tipo_obrigatorio').asString;
      Q.Close;

      //------------------------------------
      // Verifica Codigo do Sub Tipo Insumo
      //------------------------------------
      if sIndAdimeteSubTipo = 'S' then begin
{$IFDEF MSSQL}
        Q.SQL.Clear;
        Q.SQL.Add('select 1 from tab_sub_tipo_insumo ' +
         ' where cod_sub_tipo_insumo = :cod_sub_tipo_insumo ' +
         '   and cod_tipo_insumo = :cod_tipo_insumo ' +
         '   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
        Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(811, Self.ClassName, 'Inserir', [IntToStr(CodSubTipoInsumo)]);
          Result := -811;
          Exit;
        End;
        Q.Close;
     end
     else begin
       if CodSubTipoInsumo <> -1 then begin
          Mensagens.Adicionar(826, Self.ClassName, 'Inserir', []);
          Result := -826;
          Exit;
       end;
     end;

      //------------------------------
      // Verifica Codigo do Fabricante
      //------------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_fabricante_insumo ' +
         ' where cod_fabricante_insumo = :cod_fabricante_insumo ' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(815, Self.ClassName, 'Inserir', [IntToStr(CodFabricanteInsumo)]);
        Result := -815;
        Exit;
      End;
      Q.Close;

      //----------------------------------------------------------------
      // Verifica Codigo do Fabricante está relacionado com Tipo Insumo
      //----------------------------------------------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_fabricante_tipo_insumo ' +
         ' where cod_fabricante_insumo = :cod_fabricante_insumo ' +
         '   and cod_tipo_insumo = :cod_tipo_insumo ');
{$ENDIF}
      Q.ParamByName('cod_fabricante_insumo').AsInteger := CodFabricanteInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(875, Self.ClassName, 'Inserir', [IntToStr(CodTipoInsumo)]);
        Result := -875;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      //---------------------
      // Pega próximo código
      //---------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_insumo), 0) + 1 as cod_insumo from tab_insumo');
{$ENDIF}
      Q.Open;

      CodInsumo := Q.FieldByName('cod_insumo').AsInteger;

      //-----------------------
      // Tenta Inserir Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_insumo ' +
      ' ( cod_insumo ' +
      ' , des_insumo ' +
      ' , cod_tipo_insumo ' +
      ' , cod_sub_tipo_insumo ' +
      ' , cod_fabricante_insumo ' +
      ' , txt_observacao ' +
      ' , dta_fim_validade ) ' +
      'values ' +
      ' ( :cod_insumo ' +
      ' , :des_insumo ' +
      ' , :cod_tipo_insumo ' +
      ' , :cod_sub_tipo_insumo ' +
      ' , :cod_fabricante_insumo ' +
      ' , :txt_observacao ' +
      ' ,  null ) ');
{$ENDIF}
      Q.ParamByName('cod_insumo').AsInteger   := CodInsumo;
      Q.ParamByName('des_insumo').AsString   := DesInsumo;
      Q.ParamByName('cod_tipo_insumo').AsInteger   := CodTipoInsumo;

      Q.ParamByName('cod_sub_tipo_insumo').DataType := ftInteger;
      AtribuiValorParametro(Q.ParamByName('cod_sub_tipo_insumo'),CodSubTipoInsumo);

      Q.ParamByName('cod_fabricante_insumo').AsInteger   := CodFabricanteInsumo;

      Q.ParamByName('txt_observacao').DataType   := ftString;
      AtribuiValorParametro(Q.ParamByName('txt_observacao'),TxtObservacao);

      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodFabricanteInsumo;;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(864, Self.ClassName, 'Inserir', [E.Message]);
        Result := -864;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInsumos.Alterar(CodInsumo : Integer;DesInsumo,TxtObservacao : String): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(291) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  //-----------------
  //Valida Descrição
  //-----------------
  Result := VerificaString(DesInsumo,'Descrição do Insumo');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesInsumo,20,'Descrição do Insumo');
  If Result < 0 Then Begin
    Exit;
  End;

  //---------------------
  //Valida txtObservacao
  //---------------------
  if trim(txtObservacao) <> '' then begin
    Result := TrataString(txtObservacao,255,'Observação do Insumo');
    If Result < 0 Then Begin
      Exit;
    End;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //--------------------------
      // Verifica Codigo Existente
      //--------------------------
      Q.Close;
  {$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_insumo ' +
         ' where cod_insumo = :cod_insumo ' +
         '   and dta_fim_validade is null ');
  {$ENDIF}
      Q.ParamByName('cod_insumo').AsInteger := CodInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(867, Self.ClassName, 'Alterar', [IntToStr(CodInsumo)]);
        Result := -867;
        Exit;
      End;
      Q.Close;

      //-----------------------------------
      // Verifica duplicidade da Descrição
      //-----------------------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_insumo ' +
         ' where des_insumo  = :des_insumo' +
         '   and cod_insumo != :cod_insumo' +
         '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_insumo').AsString := DesInsumo;
      Q.ParamByName('cod_insumo').AsInteger := CodInsumo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(863, Self.ClassName, 'Alterar', [DesInsumo]);
        Result := -863;
        Exit;
      End;
      Q.Close;


      //---------------
      // Abre transação
      //---------------
      BeginTran;
      //-----------------------
      // Tenta Alterar Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_insumo ' +
      '   set des_insumo = :des_insumo ' +
      '     , txt_observacao = :txt_observacao ' +
      ' where cod_insumo = :cod_insumo ');
{$ENDIF}
      //----------------------------------------
      // Atribui o Tipo de dado para o parâmetro
      //----------------------------------------
      Q.ParamByName('cod_insumo').DataType     := ftInteger;
      AtribuiValorParametro(Q.ParamByName('cod_insumo'),CodInsumo);

      Q.ParamByName('des_insumo').DataType     := ftString;
      AtribuiValorParametro(Q.ParamByName('des_insumo'),DesInsumo);

      Q.ParamByName('txt_observacao').DataType     := ftString;
      AtribuiValorParametro(Q.ParamByName('txt_observacao'),TxtObservacao);

      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(865, Self.ClassName, 'Alterar', [E.Message]);
        Result := -865;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInsumos.Excluir(CodInsumo: Integer): Integer;
var
  Q : THerdomQuery;
  nDiaExclusao : Integer;
  sIndExclusao : string;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(292) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //--------------------------
      // Verifica Codigo Existente
      //--------------------------
      Q.Close;
    {$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_insumo ' +
         ' where cod_insumo = :cod_insumo ' +
         '   and dta_fim_validade is null ');
    {$ENDIF}
      Q.ParamByName('cod_insumo').AsInteger := CodInsumo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(867, Self.ClassName, 'Excluir', [IntToStr(CodInsumo)]);
        Result := -867;
        Exit;
      End;
      Q.Close;

      //-------------------------------------------------
      // Verifica relacionamento com a Entrada de Insumo
      //-------------------------------------------------
      Q.Close;
    {$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select dta_cadastramento, getdate() as DataAtual from tab_entrada_insumo ' +
         ' where cod_insumo = :cod_insumo ');
    {$ENDIF}
      Q.ParamByName('cod_insumo').AsInteger := CodInsumo;
      Q.Open;
      If Q.IsEmpty Then
        sIndExclusao := 'S'
      else begin
        //-------------------------------------------------
        // Verifica se a data de cadastramento é menor que
        // a data atual - quantidade do parametro
        //-------------------------------------------------
        nDiaExclusao := StrToInt(ValorParametro(10));
        if Q.FieldByName('dta_cadastramento').asDateTime  > Q.FieldByName('DataAtual').asDateTime - nDiaExclusao then begin
          Mensagens.Adicionar(876, Self.ClassName, 'Excluir', [IntToStr(CodInsumo)]);
          Result := -876;
          Exit;
        end else
          sIndExclusao := 'N';
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      Q.SQL.Clear;
      if sIndExclusao = 'N' then begin
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_insumo ' +
          '          set dta_fim_validade  = getDate() ' +
          ' where cod_insumo = :cod_insumo ');
{$ENDIF}
      end else begin
{$IFDEF MSSQL}
        Q.SQL.Add(' delete  tab_insumo ' +
          ' where cod_insumo = :cod_insumo ');
{$ENDIF}
      end;
      Q.ParamByName('cod_insumo').AsInteger      := CodInsumo;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(868, Self.ClassName, 'Excluir', [E.Message]);
        Result := -868;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntInsumos.Buscar(CodInsumo: Integer): Integer;
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
  If Not Conexao.PodeExecutarMetodo(289) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------
      // Tenta Buscar Registro
      //-----------------------
      Q.Close;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select ti.cod_insumo as CodInsumo ' +
      '     ,  ti.des_insumo as DesInsumo' +
      '     ,  ti.txt_observacao as TxtObservacao ' +
      '     , tti.cod_tipo_insumo as CodTipoInsumo ' +
      '     , tti.sgl_tipo_insumo as SglTipoInsumo ' +
      '     , tti.Des_tipo_insumo as DesTipoInsumo ' +
      '     , tsti.Cod_sub_tipo_insumo as CodSubTipoInsumo ' +
      '     , tsti.Sgl_sub_tipo_insumo as SglSubTipoInsumo ' +
      '     , tsti.Des_sub_tipo_insumo as DesSubTipoInsumo ' +
      '     , tf.Cod_Fabricante_insumo as CodFabricanteInsumo ' +
      '     , tf.nom_fabricante_insumo as NomFabricanteInsumo ' +
      '     , tf.Nom_reduzido_Fabricante as NomReduzidoFabricanteInsumo ' +
      '  from tab_insumo ti ' +
      '     , tab_tipo_insumo tti ' +
      '     , tab_sub_tipo_insumo tsti ' +
      '     , tab_fabricante_insumo tf ' +
      ' where tti.cod_tipo_insumo = ti.cod_tipo_insumo ' +
      '   and tsti.cod_tipo_insumo =* ti.cod_tipo_insumo ' +
      '   and tsti.cod_sub_tipo_insumo =* ti.cod_sub_tipo_insumo ' +
      '   and tf.cod_fabricante_insumo = ti.cod_fabricante_insumo ' +
      '   and ti.cod_insumo = :cod_insumo ' +
      '   and ti.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_insumo').AsInteger := CodInsumo;
      Q.Open;

      // Verifica existência do registro
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(867, Self.ClassName, 'Buscar', []);
        Result := -867;
        Exit;
      End;
      //--------------------------------
      // Obtem informações do registro
      //--------------------------------
      FIntInsumo.CodInsumo          := Q.FieldByName('CodInsumo').AsInteger;
      FIntInsumo.DesInsumo          := Q.FieldByName('DesInsumo').AsString;
      FIntInsumo.TxtObservacao      := Q.FieldByName('TxtObservacao').AsString;
      FIntInsumo.CodTipoInsumo      := Q.FieldByName('CodTipoInsumo').AsInteger;
      FIntInsumo.SglTipoInsumo      := Q.FieldByName('SglTipoInsumo').AsString;
      FIntInsumo.DesTipoInsumo      := Q.FieldByName('DesTipoInsumo').AsString;
      FIntInsumo.CodSubTipoInsumo   := Q.FieldByName('CodSubTipoInsumo').AsInteger;
      FIntInsumo.SglSubTipoInsumo   := Q.FieldByName('SglSubTipoInsumo').AsString;
      FIntInsumo.DesSubTipoInsumo   := Q.FieldByName('DesSubTipoInsumo').AsString;
      FIntInsumo.CodFabricanteInsumo          := Q.FieldByName('CodFabricanteInsumo').AsInteger;
      FIntInsumo.NomFabricanteInsumo          := Q.FieldByName('NomFabricanteInsumo').AsString;
      FIntInsumo.NomReduzidoFabricanteInsumo  := Q.FieldByName('NomReduzidoFabricanteInsumo').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(869, Self.ClassName, 'Buscar', [E.Message]);
        Result := -869;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.



