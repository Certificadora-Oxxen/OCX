// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 06/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Localidades
// ********************************************************************
// *  Últimas Alterações
// *   Jerry    06/08/2002    Criação
// *   Hítalo   06/08/2002    Adicionar método Inserir,Excluir,Alterar.
// *
// *
// ********************************************************************

unit uIntLocalidades;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntLocalidade, dbtables, sysutils, db,uFerramentas;

type
  { TIntLocalidades }
  TIntLocalidades = class(TIntClasseBDNavegacaoBasica)
  private
    FIntLocalidade : TIntLocalidade;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodPais, CodEstado: Integer; NomLocalidade : String;
                       CodMicroRegiao: Integer; NomMicroRegiao,NumMunicipioIBGE, IndCadastroEfetivado,CodTipoLocalidade, CodOrdenacao: String): Integer;
    function Buscar(CodLocalidade: Integer; CodTipoLocalidade: String): Integer;
    function Inserir(NomLocalidade : String;CodLocalidadePai,NumLatitude,
      NumLongitude,CodMicroRegiao : Integer;NumMunicipioIBGE,CodTipoLocalidade : String): Integer;
    function Alterar(CodLocalidade : Integer;NomLocalidade : String;NumLatitude,NumLongitude,CodMicroRegiao : integer;NumMunicipioIBGE,CodTipoLocalidade : String): Integer;
    function Excluir(CodLocalidade : Integer;CodTipoLocalidade : String): Integer;
    function EfetivarCadastro(CodLocalidade : Integer): Integer;
    function CancelarEfetivacao(CodLocalidade : Integer): Integer;

    property IntLocalidade : TIntLocalidade read FIntLocalidade write FIntLocalidade;
  end;

implementation

{ TIntLocalidades }
constructor TIntLocalidades.Create;
begin
  inherited;
  FIntLocalidade := TIntLocalidade.Create;
end;

destructor TIntLocalidades.Destroy;
begin
  FIntLocalidade.Free;
  inherited;
end;

function TIntLocalidades.Pesquisar(CodPais, CodEstado: Integer; NomLocalidade : String;
  CodMicroRegiao: Integer; NomMicroRegiao, NumMunicipioIBGE, IndCadastroEfetivado,CodTipoLocalidade, CodOrdenacao: String): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(126) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  If (Uppercase(CodTipoLocalidade) = 'D') then
     CodPais := -1;

  If (Uppercase(CodTipoLocalidade) <> 'M') and (Uppercase(CodTipoLocalidade) <> 'D') and
     (Uppercase(CodTipoLocalidade) <> 'A') Then Begin
    Mensagens.Adicionar(409, Self.ClassName, 'Pesquisar', []);
    Result := -409;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try

    if (CodEstado > 0) and (CodMicroRegiao > 0) then begin
      //----------------------------------------
      // Verifica se a Micro Região pertence ao
      // Estado do parâmetro
      //----------------------------------------
      Q.SQL.Clear;
   {$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_micro_regiao tmr, ' + 
      ' tab_estado te' +
      ' where tmr.cod_micro_regiao = :cod_micro_regiao ' + 
      '   and tmr.cod_estado  = :cod_estado ' + 
      '   and tmr.dta_fim_validade is null ' + 
      '   and te.cod_estado   = tmr.cod_estado ' +
      '   and te.dta_fim_validade is null ');
   {$ENDIF}
      Q.ParamByName('cod_micro_regiao').AsInteger := CodMicroRegiao;
      Q.ParamByName('cod_estado').AsInteger       := CodEstado;
      Q.Open;
      If Q.IsEmpty Then Begin
         Mensagens.Adicionar(477, Self.ClassName, 'Pesquisar', [IntToStr(CodMicroRegiao)]);
         Result := -477;
         Exit;
       End;
       Q.Close;
    end;
  Except
    On E: Exception do Begin
      Mensagens.Adicionar(477, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -477;
      Exit;
    End;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  If (Uppercase(CodTipoLocalidade) = 'M') or
     (Uppercase(CodTipoLocalidade) = 'A') Then Begin
    Query.SQL.Add('select tm.cod_municipio as CodLocalidade ' + 
    '     , tm.nom_municipio as NomLocalidade ' + 
    '     , ''Município'' as DesTipoLocalidade ' + 
    '     , tm.cod_municipio as CodMunicipio ' + 
    '     , tm.nom_municipio as NomMunicipio ' + 
    '     , tm.cod_estado as CodEstado ' + 
    '     , tm.num_municipio_IBGE as NumMunicipioIBGE ' + 
    '     , te.sgl_estado as SglEstado ' + 
    '     , te.cod_estado_sisBov as CodEstadoSisBov ' + 
    '     , tmr.cod_micro_regiao as CodMicroRegiao ' + 
    '     , tmr.nom_micro_regiao as NomMicroRegiao ' + 
    '     , tmr.cod_micro_regiao_sisbov as CodMicroRegiaoSisBov ' + 
    '     , case isnull(tm.dta_efetivacao_cadastro,0) ' +
    '       when 0 then ''Não'' ' +
    '       else        ''Sim'' ' +
    '       end as IndEfetivacaoCadastro ' +
    '  from tab_municipio tm ' +
    '     , tab_estado te ' +
    '     , tab_micro_regiao tmr ' +
    ' where te.cod_estado = tm.cod_estado ');
    if (CodPais) > 0 then
      Query.SQL.Add('   and te.cod_pais = :cod_pais ');
    if (CodMicroRegiao = -1) and (Trim(NomMicroRegiao) = '') then begin
      Query.SQL.Add('   and tmr.cod_estado =* tm.cod_estado ' +
        '   and tmr.cod_micro_regiao =* tm.cod_micro_regiao ');
    end else begin
      Query.SQL.Add('   and tmr.cod_estado = tm.cod_estado ' +
        '   and tmr.cod_micro_regiao = tm.cod_micro_regiao ');
    end;
    Query.SQL.Add('   and tm.dta_fim_validade is null ' +
                '   and ((tmr.cod_micro_regiao = :cod_micro_regiao) or (:cod_micro_regiao = -1)) ' +
                '   and ((te.cod_estado = :cod_estado) or (:cod_estado = -1)) ');
    if UpperCase(IndCadastroEfetivado)='S' then begin
      Query.SQL.Add(' and tm.dta_efetivacao_cadastro is not null');
    end
    else if UpperCase(IndCadastroEfetivado)='N' then begin
      Query.SQL.Add(' and tm.dta_efetivacao_cadastro is null');
    end;
    If Trim(NumMunicipioIBGE) <> '' Then Begin
      Query.SQL.Add('   and tm.num_municipio_ibge = :num_municipio_ibge ');
    End;
    If Trim(NomLocalidade) <> '' Then Begin
      Query.SQL.Add('   and tm.nom_municipio like :nom_localidade ');
    End;
    If Trim(NomMicroRegiao) <> '' Then Begin
      Query.SQL.Add('   and tmr.nom_micro_regiao like :nom_micro_regiao ');
    End;
  End;

  If Uppercase(CodTipoLocalidade) = 'A' Then Begin
    Query.SQL.Add('union ');
  End;

  If (Uppercase(CodTipoLocalidade) = 'D') or
     (Uppercase(CodTipoLocalidade) = 'A') Then Begin
    Query.SQL.Add('select td.cod_distrito as CodLocalidade ' +
    '     , td.nom_distrito as NomLocalidade ' +
    '     , ''Distrito'' as DesTipoLocalidade ' +
    '     , td.cod_municipio as CodMunicipio ' +
    '     , tm.nom_municipio as NomMunicipio ' +
    '     , tm.cod_estado as CodEstado ' +
    '     , '''' as NumMunicipioIBGE ' +
    '     , te.sgl_estado as SglEstado ' +
    '     , te.cod_estado_sisBov as CodEstadoSisBov ' +
    '     , tmr.cod_micro_regiao as CodMicroRegiao ' +
    '     , tmr.nom_micro_regiao as NomMicroRegiao ' +
    '     , case tmr.cod_micro_regiao_sisBov  when -1 then null else tmr.cod_micro_regiao_sisBov  end as CodMicroRegiaoSisBov ' +
    '     , '''' as IndEfetivacaoCadastro' +
    '  from tab_distrito td ' +
    '     , tab_municipio tm ' +
    '     , tab_estado te ' +
    '     , tab_micro_regiao tmr ' +
    ' where tm.cod_municipio = td.cod_municipio ' +
    '   and te.cod_estado = tm.cod_estado ');
    if (CodMicroRegiao = -1) and (Trim(NomMicroRegiao) = '') then begin
      Query.SQL.Add('   and tmr.cod_estado =* tm.cod_estado ' +
        '   and tmr.cod_micro_regiao =* tm.cod_micro_regiao ');
    end
    else begin
      Query.SQL.Add('   and tmr.cod_estado = tm.cod_estado ' +
        '   and tmr.cod_micro_regiao = tm.cod_micro_regiao ');
    end;
    Query.SQL.Add('   and td.dta_fim_validade is null ' +
        '   and ((te.cod_estado = :cod_estado) or (:cod_estado = -1)) ' +
        '   and ((tmr.cod_micro_regiao = :cod_micro_regiao) or (:cod_micro_regiao = -1)) ');
    If NomLocalidade <> '' Then Begin
      Query.SQL.Add('   and td.nom_distrito like :nom_localidade ');
    End;

    If NomMicroRegiao <> '' Then Begin
      Query.SQL.Add('   and tmr.cod_estado = tm.cod_estado '+
        '   and tmr.cod_micro_regiao = tm.cod_micro_regiao ' +
        '   and tmr.nom_micro_regiao like :nom_micro_regiao ');
    End;
  End;
  If Uppercase(CodOrdenacao) = 'M' Then Begin
    Query.SQL.Add(' order by 2,10  ');
  End;
  If Uppercase(CodOrdenacao) = 'B' Then Begin
    Query.SQL.Add(' order by 8,11,2 ');
  End;
{$ENDIF}

  Query.ParamByName('cod_estado').AsInteger := CodEstado;
  Query.ParamByName('cod_micro_regiao').AsInteger := CodMicroRegiao;

  if (CodPais) > 0 then
    Query.ParamByName('cod_pais').AsInteger := CodPais;

  If Trim(NomLocalidade) <> '' Then Begin
    Query.ParamByName('nom_localidade').AsString := '%' + trim(NomLocalidade) + '%';
  End;
  If Trim(NomMicroRegiao) <> '' Then Begin
    Query.ParamByName('nom_micro_regiao').AsString := '%' + trim(NomMicroRegiao) + '%';
  End;
  If ((Uppercase(CodTipoLocalidade) = 'M') or
     (Uppercase(CodTipoLocalidade) = 'A')) and (Trim(NumMunicipioIBGE) <> '') Then Begin
       Query.ParamByName('num_municipio_ibge').AsString := NumMunicipioIBGE;
  End;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(410, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -410;
      Exit;
    End;
  End;
end;

function TIntLocalidades.Inserir(NomLocalidade : String;CodLocalidadePai,NumLatitude,
      NumLongitude,CodMicroRegiao : Integer;NumMunicipioIBGE,CodTipoLocalidade : String): Integer;
var
  Q : THerdomQuery;
  CodLocalidade : Integer;
begin

  Result := -1;
  CodLocalidade := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;

  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(156) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  //----------------------------
  //Válida o Nome da Localidade
  //----------------------------
  Result := VerificaString(NomLocalidade,'Nome da Localidade');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomLocalidade,50,'Nome da Localidade');
  If Result < 0 Then Begin
    Exit;
  End;

  //----------------------------
  //Válida o Tipo de Localidade
  //----------------------------
  Result := TrataString(CodTipoLocalidade,1,'Tipo de Localidade');
  If Result < 0 Then Begin
    Exit;
  End
  else if (UpperCase(CodTipoLocalidade)<>'M') and (UpperCase(CodTipoLocalidade)<>'D') then begin
    Mensagens.Adicionar(411, Self.ClassName, 'Inserir', []);
    Result := -411;
    Exit;
  end;

  if (NumLatitude <> 0) and (NumLongitude <> 0) then begin
    //---------------------
    //  Valida a Latitude
    //--------------------
    if ValidaLatitudeLongitude(abs(NumLatitude),6,0) = false then begin
      Mensagens.Adicionar(478, Self.ClassName, 'Inserir', [IntToStr(NumLatitude)]);
      Result := -478;
      Exit;
    end;
    //---------------------
    //  Valida a Longitude
    //--------------------
    if ValidaLatitudeLongitude(abs(NumLongitude),6,0) = false then begin
      Mensagens.Adicionar(479, Self.ClassName, 'Inserir', [IntToStr(NumLongitude)]);
      Result := -479;
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      if upperCase(CodTipoLocalidade)='M' then begin
        //------------------------------------
        //            Munícipio
        //------------------------------------
        // Verifica a existência do Estado
        // CodLocalidadePai
        //--------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_estado ' +
                ' where   cod_estado  = :cod_estado ' +
                '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_estado').AsInteger      := CodLocalidadePai;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(387, Self.ClassName, 'Inserir', [IntToStr(CodLocalidadePai)]);
          Result := -387;
          Exit;
        End;
        Q.Close;

        //----------------------------------------
        // Verifica se a Micro Região pertence ao
        // Estado do parâmetro(CodLoacalidadePai)
        //----------------------------------------
        if CodMicroRegiao > 0 then begin
          Q.SQL.Clear;
       {$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_micro_regiao tmr, ' + 
          ' tab_estado te' + 
          ' where tmr.cod_micro_regiao = :cod_micro_regiao ' + 
          '   and tmr.cod_estado  = :cod_estado ' + 
          '   and tmr.dta_fim_validade is null ' + 
          '   and te.cod_estado   = tmr.cod_estado ' + 
          '   and te.dta_fim_validade is null ');
       {$ENDIF}
          Q.ParamByName('cod_micro_regiao').AsInteger := CodMicroRegiao;
          Q.ParamByName('cod_estado').AsInteger       := CodLocalidadePai;
          Q.Open;
          If Q.IsEmpty Then Begin
             Mensagens.Adicionar(477, Self.ClassName, 'Inserir', [IntToStr(CodMicroRegiao)]);
             Result := -477;
             Exit;
           End;
           Q.Close;
        end;
        //--------------------------------------------------------
        // Verifica duplicidade no Nome da Localidade - Municipio
        //--------------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_municipio ' +
                ' where nom_municipio = :nom_municipio ' +
                '   and cod_estado    = :cod_estado ' +
                '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_estado').AsInteger         := CodLocalidadePai;
        Q.ParamByName('nom_municipio').AsString       := NomLocalidade;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(481, Self.ClassName, 'Inserir', [NomLocalidade]);
          Result := -481;
          Exit;
        End;
        Q.Close;

        if Trim(NumMunicipioIBGE)<>'' then begin
          //-------------------------------------
          //Válida o Número do Município do IBGE
          //-------------------------------------
          Result := TrataString(NumMunicipioIBGE,7,'Número do Município no IBGE');
          If Result < 0 Then Begin
            Exit;
          End;

          //------------------------------------------------
          // Verifica duplicidade no Número IBGE - Municipio
          //------------------------------------------------
          Q.SQL.Clear;
    {$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_municipio ' + 
                ' where num_municipio_ibge = :num_municipio_ibge ' +
                '   and dta_fim_validade is null ');
    {$ENDIF}
          Q.ParamByName('num_municipio_ibge').AsString      := NumMunicipioIBGE;
          Q.Open;
          If not Q.IsEmpty Then Begin
            Mensagens.Adicionar(484, Self.ClassName, 'Inserir', [NumMunicipioIBGE]);
            Result := -484;
            Exit;
          End;
          Q.Close;
        end;
      end else if upperCase(CodTipoLocalidade)='D' then begin
        //--------------------------------
        //            Distrito
        //--------------------------------
        // Verifica a existência do Município
        // CodLocalidadePai
        //------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_municipio ' +
                ' where   cod_municipio  = :cod_municipio ' +
                '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_municipio').AsInteger      := CodLocalidadePai;
        Q.Open;

        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(399, Self.ClassName, 'Inserir', [IntToStr(CodLocalidadePai)]);
          Result := -399;
          Exit;
        End;
        Q.Close;

        //------------------------------------------------------
        // Verifica duplicidade no Nome da Localidade - Distrito
        //------------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_distrito ' + 
        ' where nom_distrito   = :nom_distrito ' + 
        '   and cod_municipio   = :cod_municipio ' + 
        '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_municipio').AsInteger     := CodLocalidadePai;
        Q.ParamByName('nom_distrito').AsString       := NomLocalidade;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(481, Self.ClassName, 'Inserir', [NomLocalidade]);
          Result := -481;
          Exit;
        End;
        Q.Close;

        //------------------------------
        // Micro Região nunca informado
        //------------------------------
        CodMicroRegiao := -1
      end;

      //Abre transação
      BeginTran;

      if upperCase(CodTipoLocalidade)='M' then begin
        //--------------------------------
        //            Município
        //--------------------------------------------------------------------

        //---------------------
        // Pega próximo código
        //---------------------
        Q.SQL.Clear;
   {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_municipio), 0) + 1 as cod_municipio from tab_municipio');
  {$ENDIF}
        Q.Open;
        CodLocalidade := Q.FieldByName('cod_municipio').AsInteger;
        //------------------------
        // Tenta Inserir Registro
        //------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_municipio ' +
        ' (cod_municipio, ' +
        '  nom_municipio, ' +
        '  num_latitude, ' +
        '  num_longitude, ' +
        '  cod_estado , ' +
        '  cod_micro_regiao , ' +
        '  num_municipio_ibge , ' +
        '  dta_fim_validade ,  ' +
        '  dta_efetivacao_cadastro) ' +
        'values ' +
        ' (:cod_municipio, ' +
        '  :nom_municipio, ' +
        '  :num_latitude, ' +
        '  :num_longitude, ' +
        '  :cod_estado, ' +
        '  :cod_micro_regiao, ' +
        '  :num_municipio_ibge, ' +
        '  null , ' +
        '  null ) ');
  {$ENDIF}
        Q.ParamByName('cod_municipio').AsInteger            := CodLocalidade;
        Q.ParamByName('nom_municipio').AsString             := NomLocalidade;
        Q.ParamByName('cod_estado').AsInteger               := CodLocalidadePai;
        if (NumLatitude = 0) and (NumLongitude = 0) then begin
          Q.ParamByName('num_latitude').DataType            := ftInteger;
          Q.ParamByName('num_latitude').clear;
          Q.ParamByName('num_longitude').DataType            := ftInteger;
          Q.ParamByName('num_longitude').Clear;
        end else begin
          Q.ParamByName('num_latitude').AsInteger           := NumLatitude;
          Q.ParamByName('num_longitude').AsInteger          := NumLongitude;
        end;
        if CodMicroRegiao =-1 then begin
          Q.ParamByName('cod_micro_regiao').DataType        := ftInteger;
          Q.ParamByName('cod_micro_regiao').clear;
        end else begin
          Q.ParamByName('cod_micro_regiao').AsInteger       := CodMicroRegiao;
        end;
        if trim(NumMunicipioIBGE) = '' then begin
          Q.ParamByName('num_municipio_IBGE').DataType        := ftString;
          Q.ParamByName('num_municipio_IBGE').clear;
        end else begin
          Q.ParamByName('num_municipio_IBGE').AsString       := NumMunicipioIBGE;
        end;
      end else if upperCase(CodTipoLocalidade)='D' then begin
        //--------------------------------
        //            Distrito
        //--------------------------------------------------------------------

        //---------------------
        // Pega próximo código
        //---------------------
        Q.SQL.Clear;
   {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_distrito), 0) + 1 as cod_distrito from tab_distrito');
  {$ENDIF}
        Q.Open;
        CodLocalidade := Q.FieldByName('cod_distrito').AsInteger;
        //------------------------
        // Tenta Inserir Registro
        //------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_distrito ' + 
        ' (cod_distrito, ' + 
        '  nom_distrito, ' + 
        '  cod_municipio, ' + 
        '  num_latitude, ' + 
        '  num_longitude, ' +
        '  dta_fim_validade) ' + 
        'values ' + 
        ' (:cod_distrito, ' + 
        '  :nom_distrito, ' + 
        '  :cod_municipio, ' + 
        '  :num_latitude, ' + 
        '  :num_longitude, ' + 
        '  null ) ');
  {$ENDIF}
        Q.ParamByName('cod_distrito').AsInteger            := CodLocalidade;
        Q.ParamByName('nom_distrito').AsString             := NomLocalidade;
        Q.ParamByName('cod_municipio').AsInteger           := CodLocalidadePai;
        if (NumLatitude = 0) and (NumLongitude = 0) then begin
          Q.ParamByName('num_latitude').DataType            := ftInteger;
          Q.ParamByName('num_latitude').clear;
          Q.ParamByName('num_longitude').DataType            := ftInteger;
          Q.ParamByName('num_longitude').Clear;
        end else begin
          Q.ParamByName('num_latitude').AsInteger           := NumLatitude;
          Q.ParamByName('num_longitude').AsInteger          := NumLongitude;
        end;
      end;
      Q.ExecSQL;
      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodLocalidade;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(480, Self.ClassName, 'Inserir', [E.Message]);
        Result := -480;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocalidades.Alterar(CodLocalidade : Integer;NomLocalidade : String;NumLatitude,NumLongitude,CodMicroRegiao : integer;NumMunicipioIBGE,CodTipoLocalidade : String): Integer;
var
  Q : THerdomQuery;
  CodLocalidadePai : Integer;
begin
  Result := -1;
  CodLocalidadePai := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(157) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  //----------------------------
  //Válida o Nome da Localidade
  //----------------------------
  Result := TrataString(NomLocalidade,50,'Nome da Localidade');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := VerificaString(NomLocalidade,'Nome da Localidade');
  If Result < 0 Then Begin
    Exit;
  End;

  //----------------------------
  //Válida o Tipo de Localidade
  //----------------------------
  Result := TrataString(CodTipoLocalidade,1,'Tipo de Localidade');
  If Result < 0 Then Begin
    Exit;
  End
  else if (UpperCase(CodTipoLocalidade)<>'M') and (UpperCase(CodTipoLocalidade)<>'D') then begin
    Mensagens.Adicionar(411, Self.ClassName, 'Alterar', []);
    Result := -411;
    Exit;
  end;
  if (NumLatitude <> 0) and (NumLongitude <> 0) then begin
    //---------------------
    //  Valida a Latitude
    //--------------------
     if ValidaLatitudeLongitude(abs(NumLatitude),6,0) = false then begin
      Mensagens.Adicionar(478, Self.ClassName, 'Alterar', [IntToStr(NumLatitude)]);
      Result := -478;
      Exit;
    end;
    //---------------------
    //  Valida a Longitude
    //--------------------
    if ValidaLatitudeLongitude(abs(NumLongitude),6,0) = false then begin
      Mensagens.Adicionar(479, Self.ClassName, 'Alterar', [IntToStr(NumLongitude)]);
      Result := -479;
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try


      if upperCase(CodTipoLocalidade)='M' then begin
        //--------------------------------
        //            Munícipio
        //-------------------------------------
        if Trim(NumMunicipioIBGE)<>'' then begin
           //Válida o Número do Município do IBGE
           //-------------------------------------
           Result := TrataString(NumMunicipioIBGE,7,'Número do Município no IBGE');
           If Result < 0 Then Begin
             Exit;
           End;
          //------------------------------------------------
          // Verifica duplicidade no Número IBGE - Municipio
          //------------------------------------------------
          Q.SQL.Clear;
    {$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_municipio '+
          ' where cod_municipio != :cod_municipio '+
          '   and num_municipio_ibge = :num_municipio_ibge '+
          '   and dta_fim_validade is null ');
    {$ENDIF}
          Q.ParamByName('num_municipio_ibge').AsString  := NumMunicipioIBGE;
          Q.ParamByName('cod_municipio').AsInteger      := CodLocalidade;
          Q.Open;
          If not Q.IsEmpty Then Begin
            Mensagens.Adicionar(484, Self.ClassName, 'Inserir', [NumMunicipioIBGE]);
            Result := -484;
            Exit;
          End;
          Q.Close;
        end;

        //-------------------------------------------------
        // Verifica a existência da Localidade - Municipio
        //-------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select cod_estado from tab_municipio ' +
                ' where   cod_municipio  = :cod_municipio ' +
                '   and dta_fim_validade is null ' +
                '   and dta_efetivacao_cadastro is null ');

  {$ENDIF}
        Q.ParamByName('cod_municipio').AsInteger      := CodLocalidade;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(399, Self.ClassName, 'Alterar', [IntToStr(CodLocalidade)]);
          Result := -399;
          Exit;
        End;
        CodLocalidadePai := Q.FieldByName('cod_estado').AsInteger;
        Q.Close;
        //----------------------------------------
        // Verifica se a Micro Região pertence ao
        // mesmo Estado (CodLoacalidadePai)
        //----------------------------------------
        if CodMicroRegiao > 0 then begin
          Q.SQL.Clear;
       {$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_micro_regiao tmr, ' +
          ' tab_estado te' +
          ' where tmr.cod_micro_regiao = :cod_micro_regiao ' +
          '   and tmr.cod_estado  = :cod_estado ' +
          '   and tmr.dta_fim_validade is null ' +
          '   and te.cod_estado   = tmr.cod_estado ' +
          '   and te.dta_fim_validade is null ');
       {$ENDIF}
          Q.ParamByName('cod_micro_regiao').AsInteger := CodMicroRegiao;
          Q.ParamByName('cod_estado').AsInteger       := CodLocalidadePai;
          Q.Open;
          If Q.IsEmpty Then Begin
             Mensagens.Adicionar(477, Self.ClassName, 'Inserir', [IntToStr(CodMicroRegiao)]);
             Result := -477;
             Exit;
           End;
           Q.Close;
        end;

        //--------------------------------------------------------
        // Verifica duplicidade no Nome da Localidade - Municipio
        //--------------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_municipio ' + 
        ' where cod_municipio != :cod_municipio ' + 
        '   and nom_municipio  = :nom_municipio ' + 
        '   and cod_estado     = :cod_estado ' + 
        '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_municipio').AsInteger      := CodLocalidade;
        Q.ParamByName('nom_municipio').AsString       := NomLocalidade;
        Q.ParamByName('cod_estado').AsInteger         := CodLocalidadePai;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(481, Self.ClassName, 'Alterar', [NomLocalidade]);
          Result := -481;
          Exit;
        End;
        Q.Close;
      end else if upperCase(CodTipoLocalidade)='D' then begin
        //--------------------------------
        //            Distrito
        //-------------------------------------------------
        // Verifica a existência da Localidade - Distrito
        //-------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select cod_municipio from tab_distrito ' +
                ' where   cod_distrito  = :cod_distrito ' +
                '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_distrito').AsInteger      := CodLocalidade;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(397, Self.ClassName, 'Alterar', [IntToStr(CodLocalidade)]);
          Result := -397;
          Exit;
        End;
        CodLocalidadePai := Q.FieldByName('cod_municipio').AsInteger;
        Q.Close;

        //------------------------------------------------------
        // Verifica duplicidade no Nome da Localidade - Distrito
        //------------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_distrito ' + 
        ' where cod_distrito != :cod_distrito ' + 
        '   and nom_distrito  = :nom_distrito ' + 
        '   and cod_municipio = :cod_municipio ' + 
        '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_distrito').AsInteger  := CodLocalidade;
        Q.ParamByName('nom_distrito').AsString   := NomLocalidade;
        Q.ParamByName('cod_municipio').AsInteger := CodLocalidadePai;
        Q.Open;
        If not Q.IsEmpty Then Begin
          Mensagens.Adicionar(481, Self.ClassName, 'Alterar', [NomLocalidade]);
          Result := -481;
          Exit;
        End;
        Q.Close;

        //------------------------------
        // Micro Região nunca informado
        //------------------------------
        CodMicroRegiao := -1
      end;

      //Abre transação
      BeginTran;

      if upperCase(CodTipoLocalidade)='M' then begin
        //--------------------------
        //            Município
        //--------------------------
        // Tenta Atualizar Registro
        //--------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_municipio  set ' + 
        ' nom_municipio = :nom_municipio ' + 
        ', num_latitude  = :num_latitude ' + 
        ', num_longitude = :num_longitude ' + 
        ', cod_micro_regiao = :cod_micro_regiao ' + 
        ', num_municipio_IBGE = :num_municipio_IBGE ' +
        ' where cod_municipio = :cod_municipio');
  {$ENDIF}
        //--------------------------------------------
        // Atribui o Tipo de dados para os parâmetros
        //--------------------------------------------
        Q.ParamByName('cod_municipio').DataType     := ftInteger;
        Q.ParamByName('nom_municipio').DataType     := ftString;
        Q.ParamByName('cod_micro_regiao').DataType  := ftInteger;
        Q.ParamByName('num_municipio_IBGE').DataType  := ftString;

        AtribuiValorParametro(Q.ParamByName('cod_municipio'),CodLocalidade);
        AtribuiValorParametro(Q.ParamByName('nom_municipio'),NomLocalidade);
        if (NumLatitude = 0) and (NumLongitude = 0) then begin
          Q.ParamByName('num_latitude').DataType            := ftInteger;
          Q.ParamByName('num_latitude').clear;
          Q.ParamByName('num_longitude').DataType           := ftInteger;
          Q.ParamByName('num_longitude').Clear;
        end else begin
          Q.ParamByName('num_latitude').AsInteger           := NumLatitude;
          Q.ParamByName('num_longitude').AsInteger          := NumLongitude;
        end;
        AtribuiValorParametro(Q.ParamByName('cod_micro_regiao'),CodMicroRegiao);
        AtribuiValorParametro(Q.ParamByName('num_municipio_IBGE'),NumMunicipioIBGE);
      end else if upperCase(CodTipoLocalidade)='D' then begin
        //--------------------------
        //            Distrito
        //--------------------------
        // Tenta Atualizar Registro
        //--------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_distrito  set ' + 
        ' Nom_distrito = :Nom_distrito ' + 
        ', num_latitude  = :num_latitude ' + 
        ', num_longitude = :num_longitude ' + 
        ', cod_municipio = :cod_municipio ' + 
        ' where cod_distrito = :cod_distrito');
  {$ENDIF}
        Q.ParamByName('cod_distrito').AsInteger    := CodLocalidade;
        Q.ParamByName('nom_distrito').AsString     := NomLocalidade;
        Q.ParamByName('cod_municipio').AsInteger   := CodLocalidadePai;
        if (NumLatitude = 0) and (NumLongitude = 0) then begin
          Q.ParamByName('num_latitude').DataType            := ftInteger;
          Q.ParamByName('num_latitude').clear;
          Q.ParamByName('num_longitude').DataType           := ftInteger;
          Q.ParamByName('num_longitude').Clear;
        end else begin
          Q.ParamByName('num_latitude').AsInteger           := NumLatitude;
          Q.ParamByName('num_longitude').AsInteger          := NumLongitude;
        end;
      end;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(483, Self.ClassName, 'Alterar', [E.Message]);
        Result := -483;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocalidades.Excluir(CodLocalidade : Integer;CodTipoLocalidade : String): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(158) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      if UpperCase(CodTipoLocalidade)='M' then begin
        //----------------------------------
        // Verifica a existência do Registro
        //----------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_municipio ' +
                ' where cod_municipio = :cod_municipio ' +
                '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_municipio').AsInteger := CodLocalidade;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(413, Self.ClassName, 'Inserir', [IntToStr(CodLocalidade)]);
          Result := -413;
          Exit;
        End;
        //------------------------
        // Tenta Alterar Registro
        //------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_municipio ' + 
                '   set dta_fim_validade = getdate() ' +
                ' where cod_municipio = :cod_municipio ');
  {$ENDIF}
        Q.ParamByName('cod_municipio').AsInteger := CodLocalidade;
        Q.ExecSQL;
      end else if UpperCase(CodTipoLocalidade)='D' then begin
        //----------------------------------
        // Verifica a existência do Registro
        //----------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_distrito ' +
                ' where cod_distrito = :cod_distrito ' +
                '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_distrito').AsInteger := CodLocalidade;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(413, Self.ClassName, 'Inserir', [IntToStr(CodLocalidade)]);
          Result := -413;
          Exit;
        End;
        //------------------------
        // Tenta Alterar Registro
        //------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_distrito ');
        Q.SQL.Add('   set dta_fim_validade = getdate() ');
        Q.SQL.Add(' where cod_distrito = :cod_distrito ');
  {$ENDIF}
        Q.ParamByName('cod_distrito').AsInteger := CodLocalidade;
        Q.ExecSQL;
      end;
      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(482, Self.ClassName, 'Excluir', [E.Message]);
        Result := -482;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocalidades.Buscar(CodLocalidade: Integer;
  CodTipoLocalidade: String): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(127) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  If (Uppercase(CodTipoLocalidade) <> 'M') and
     (Uppercase(CodTipoLocalidade) <> 'D') Then Begin
    Mensagens.Adicionar(411, Self.ClassName, 'Buscar', []);
    Result := -411;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //-----------------------
      // Tenta Buscar Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      If Uppercase(CodTipoLocalidade) = 'M' Then Begin
        Q.SQL.Add('select tm.cod_municipio as CodLocalidade ' + 
        '     , tm.nom_municipio as NomLocalidade ' + 
        '     , tm.cod_estado as CodEstado ' + 
        '     , te.sgl_estado as SglEstado ' + 
        '     , te.cod_estado_sisBov as CodEstadoSisBov ' + 
        '     , tm.num_latitude as NumLatitude ' + 
        '     , tm.num_longitude as NumLongitude ' + 
        '     , tm.cod_municipio as CodMunicipio ' + 
        '     , tm.nom_municipio as NomMunicipio ' + 
        '     , tm.num_municipio_ibge as NumMunicipioIBGE ' + 
        '     , tm.dta_efetivacao_cadastro as DtaEfetivacaoCadastro ' + 
        '     , tp.cod_pais as CodPais ' + 
        '     , tp.nom_pais as NomPais ' + 
        '     , tp.cod_pais_sisBov as CodPaisSisBov ' + 
        '     , ''Município'' as DesTipoLocalidade ' + 
        '     , tmr.cod_micro_regiao as CodMicroRegiao ' +
        '     , tmr.nom_micro_regiao as NomMicroRegiao ' + 
        '     , case tmr.cod_micro_regiao_sisbov when -1 then null else tmr.cod_micro_regiao_sisbov end as CodMicroRegiaoSisBov ' +
        '  from tab_municipio tm ' + 
        '     , tab_estado te ' + 
        '     , tab_pais tp ' + 
        '     , tab_micro_regiao tmr ' + 
        ' where te.cod_estado = tm.cod_estado ' + 
        '   and tp.cod_pais = te.cod_pais ' + 
        '   and tm.dta_fim_validade is null ' + 
        '   and tm.cod_municipio = :cod_localidade ' + 
        '   and tmr.cod_micro_regiao =* tm.cod_micro_regiao ');
      End Else Begin
        Q.SQL.Add('select td.cod_distrito as CodLocalidade, ' + 
        '       td.nom_distrito as NomLocalidade, ' + 
        '       tm.cod_estado as CodEstado, ' + 
        '       te.sgl_estado as SglEstado, ' + 
        '       te.cod_estado_sisBov as CodEstadoSisBov, ' + 
        '       td.num_latitude as NumLatitude, ' + 
        '       td.num_longitude as NumLongitude, ' + 
        '       tm.cod_municipio as CodMunicipio, ' + 
        '       tm.nom_municipio as NomMunicipio, ' + 
        '       tp.cod_pais as CodPais, ' + 
        '       tp.nom_pais as NomPais, ' + 
        '       tp.cod_pais_sisBov as CodPaisSisBov, ' +         
        '       ''Distrito'' as DesTipoLocalidade, ' + 
        '       tmr.cod_micro_regiao as CodMicroRegiao, ' + 
        '       tmr.nom_micro_regiao as NomMicroRegiao, ' + 
        '       case tmr.cod_micro_regiao_sisbov when -1 then null else tmr.cod_micro_regiao_sisbov end as CodMicroRegiaoSisBov ' + 
        '  from tab_distrito td, ' + 
        '       tab_municipio tm, ' + 
        '       tab_estado te, ' + 
        '       tab_pais tp, ' + 
        '       tab_micro_regiao tmr ' +
        ' where tm.cod_municipio = td.cod_municipio ' + 
        '   and te.cod_estado = tm.cod_estado ' + 
        '   and tp.cod_pais = te.cod_pais ' + 
        '   and td.dta_fim_validade is null ' + 
        '   and td.cod_distrito = :cod_localidade ' + 
        '   and tmr.cod_estado =* tm.cod_estado ' +
        '   and tmr.cod_micro_regiao =* tm.cod_micro_regiao ');

      End;
{$ENDIF}
      Q.ParamByName('cod_localidade').AsInteger := CodLocalidade;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(413, Self.ClassName, 'Buscar', []);
        Result := -413;
        Exit;
      End;
      // Obtem informações do registro
      IntLocalidade.CodLocalidade     := Q.FieldByName('CodLocalidade').AsInteger;
      IntLocalidade.NomLocalidade     := Q.FieldByName('NomLocalidade').AsString;
      IntLocalidade.CodEstado         := Q.FieldByName('CodEstado').AsInteger;
      IntLocalidade.SglEstado         := Q.FieldByName('SglEstado').AsString;
      IntLocalidade.CodEstadoSisBov   := Q.FieldByName('CodEstadoSisbov').AsInteger;
      IntLocalidade.NumLatitude       := Q.FieldByName('NumLatitude').AsInteger;
      IntLocalidade.NumLongitude      := Q.FieldByName('NumLongitude').AsInteger;
      IntLocalidade.CodMunicipio      := Q.FieldByName('CodMunicipio').AsInteger;
      IntLocalidade.NomMunicipio      := Q.FieldByName('NomMunicipio').AsString;
      IntLocalidade.DesTipoLocalidade := Q.FieldByName('DesTipoLocalidade').AsString;
      IntLocalidade.CodPais           := Q.FieldByName('CodPais').AsInteger;
      IntLocalidade.NomPais           := Q.FieldByName('NomPais').AsString;
      IntLocalidade.CodpaisSisBov     := Q.FieldByName('CodPaisSisbov').AsInteger;
      IntLocalidade.CodMicroRegiao        := Q.FieldByName('CodMicroRegiao').AsInteger;
      IntLocalidade.NomMicroRegiao        := Q.FieldByName('NomMicroRegiao').AsString;
      IntLocalidade.CodMicroRegiaoSisBov  := Q.FieldByName('CodMicroRegiaoSisbov').AsInteger;
      If Uppercase(CodTipoLocalidade) = 'M' Then Begin
        IntLocalidade.NumMunicipioIBGE      := Q.FieldByName('NumMunicipioIBGE').asString;
        IntLocalidade.DtaEfetivacaoCadastro := Q.FieldByName('DtaEfetivacaoCadastro').asDateTime;
      end;
      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(412, Self.ClassName, 'Buscar', [E.Message]);
        Result := -412;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocalidades.EfetivarCadastro(CodLocalidade : Integer): Integer;
var
  Q : THerdomQuery;
  CodMicroReigao : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('EfetivarCadastro');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(179) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'EfetivarCadastro', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
        //-------------------------------------------------
        // Verifica a existência da Localidade - Municipio
        //-------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select cod_micro_regiao from tab_municipio ' +
                ' where   cod_municipio  = :cod_municipio ' +
                '   and dta_fim_validade is null ' +
                '   and dta_efetivacao_cadastro is null ');
  {$ENDIF}
        Q.ParamByName('cod_municipio').AsInteger      := CodLocalidade;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(399, Self.ClassName, 'EfetivarCadastro', [IntToStr(CodLocalidade)]);
          Result := -399;
          Exit;
        End;
        CodMicroReigao := Q.FieldByName('cod_micro_regiao').asInteger;
        Q.Close;

        //----------------------------------------------------------------
        // Efetivar somente municipio quando possuir Micro Regiao  válida.
        //-----------------------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_micro_regiao ' +
                ' where   cod_micro_regiao  = :cod_micro_regiao ' +
                '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_micro_regiao').AsInteger      := CodMicroReigao;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(921, Self.ClassName, 'EfetivarCadastro', []);
          Result := -921;
          Exit;
        End;
        Q.Close;

        //Abre transação
        BeginTran;

        //--------------------------
        // Tenta Atualizar Registro
        //--------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_municipio  set ' +
                '  dta_efetivacao_cadastro = getDate() ' +
                ' where cod_municipio = :cod_municipio');
  {$ENDIF}
        //--------------------------------------------
        // Atribui o Tipo de dados para os parâmetros
        //--------------------------------------------
        Q.ParamByName('cod_municipio').DataType     := ftInteger;
        AtribuiValorParametro(Q.ParamByName('cod_municipio'),CodLocalidade);
        Q.ExecSQL;

        // Cofirma transação
        Commit;

        // Retorna status "ok" do método
        Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(485, Self.ClassName, 'EfetivarCadastro', [E.Message]);
        Result := -485;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntLocalidades.CancelarEfetivacao(CodLocalidade : Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('CancelarEfetivacao');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(180) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'CancelarEfetivacao', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
        //-------------------------------------------------
        // Verifica a existência da Localidade - Municipio
        //-------------------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_municipio ' +
                ' where   cod_municipio  = :cod_municipio ' +
                '   and dta_fim_validade is null ');
  {$ENDIF}
        Q.ParamByName('cod_municipio').AsInteger      := CodLocalidade;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(399, Self.ClassName, 'CancelarEfetivacao', [IntToStr(CodLocalidade)]);
          Result := -399;
          Exit;
        End;
        Q.Close;

        //Abre transação
        BeginTran;

        //--------------------------
        // Tenta Atualizar Registro
        //--------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('update tab_municipio  set ' +
                '  dta_efetivacao_cadastro = null ' +
                ' where cod_municipio = :cod_municipio');
  {$ENDIF}
        //--------------------------------------------
        // Atribui o Tipo de dados para os parâmetros
        //--------------------------------------------
        Q.ParamByName('cod_municipio').DataType     := ftInteger;
        AtribuiValorParametro(Q.ParamByName('cod_municipio'),CodLocalidade);
        Q.ExecSQL;

        // Cofirma transação
        Commit;

        // Retorna status "ok" do método
        Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(486, Self.ClassName, 'CancelarEfetivacao', [E.Message]);
        Result := -486;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.

