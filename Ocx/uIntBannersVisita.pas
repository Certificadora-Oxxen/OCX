unit uIntBannersVisita;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens, Variants;

type
  { TIntBannersVisita }
  TIntBannersVisita = class(TIntClasseBDBasica)
  private
    FQuery : THerdomQuery;
    function IncrementaImpressao(CodPagina, CodBanner: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer; override;
    function Pesquisar(CodPagina: Integer; IncrementarImpressao: Boolean): Integer;
    function Localizar(SeqPosicaoBanner: Integer): Integer;
    function IncrementarCliques(CodPagina, CodBanner: Integer): Integer;
    function ValorCampo(NomeColuna: String): Variant;
    procedure FecharPesquisa;
    function QtdBannersPagina(CodPagina: Integer): Integer;
  end;

implementation

{ TIntBanners }
constructor TIntBannersVisita.Create;
begin
  inherited;
  FQuery := THerdomQuery.Create(nil);
end;

destructor TIntBannersVisita.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TIntBannersVisita.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  Result := (inherited Inicializar(ConexaoBD, Mensagens));
  If Result <> 0 Then Begin
    Exit;
  End;
  FQuery.SQLConnection := ConexaoBD.SQLConnection;
  Result := 0;
end;

function TIntBannersVisita.Pesquisar(CodPagina: Integer; IncrementarImpressao: Boolean): Integer;
begin
  Mensagens.Clear;

  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  FQuery.Close;

{$IFDEF MSSQL}
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select tpa.cod_banner as CodBanner, ');
  FQuery.SQL.Add('       tpa.seq_posicao_banner as SeqPosicaoBanner, ');
  FQuery.SQL.Add('       tb.nom_arquivo as NomArquivo, ');
  FQuery.SQL.Add('       tb.url_destino as URLDestino, ');
  FQuery.SQL.Add('       tb.txt_alternativo as TxtAlternativo, ');
  FQuery.SQL.Add('       ttt.txt_comando_target as TxtComandoTarget ');
  FQuery.SQL.Add('  from tab_programa_anuncio tpa, ');
  FQuery.SQL.Add('       tab_pagina tp, ');
  FQuery.SQL.Add('       tab_banner tb, ');
  FQuery.SQL.Add('       tab_tipo_target ttt ');
  FQuery.SQL.Add(' where tpa.cod_grupo_paginas = tp.cod_grupo_paginas ');
  FQuery.SQL.Add('   and tb.cod_banner = tpa.cod_banner ');
  FQuery.SQL.Add('   and ttt.cod_tipo_target = tb.cod_tipo_target ');
  FQuery.SQL.Add('   and convert(char(10), getdate(), 112) between ');
  FQuery.SQL.Add('       convert(char(10), tpa.dta_inicio_anuncio, 112) and convert(char(10), tpa.dta_fim_anuncio, 112) ');
  FQuery.SQL.Add('   and tp.cod_pagina = :cod_pagina ');
  FQuery.SQL.Add('union ');
  FQuery.SQL.Add('select tbd.cod_banner as CodBanner, ');
  FQuery.SQL.Add('       tbd.seq_posicao_banner as SeqPosicaoBanner, ');
  FQuery.SQL.Add('       tb.nom_arquivo as NomArquivo, ');
  FQuery.SQL.Add('       tb.url_destino as URLDestino, ');
  FQuery.SQL.Add('       tb.txt_alternativo as TxtAlternativo, ');
  FQuery.SQL.Add('       ttt.txt_comando_target as TxtComandoTarget ');
  FQuery.SQL.Add('  from tab_banner_default tbd, ');
  FQuery.SQL.Add('       tab_pagina tp, ');
  FQuery.SQL.Add('       tab_banner tb, ');
  FQuery.SQL.Add('       tab_tipo_target ttt ');
  FQuery.SQL.Add(' where tbd.cod_grupo_paginas = tp.cod_grupo_paginas ');
  FQuery.SQL.Add('   and tb.cod_banner = tbd.cod_banner ');
  FQuery.SQL.Add('   and ttt.cod_tipo_target = tb.cod_tipo_target ');
  FQuery.SQL.Add('   and tp.cod_pagina = :cod_pagina ');
  FQuery.SQL.Add('   and not exists (select 1 ');
  FQuery.SQL.Add('                     from tab_programa_anuncio tpa, ');
  FQuery.SQL.Add('                          tab_pagina tp ');
  FQuery.SQL.Add('                    where tpa.cod_grupo_paginas = tp.cod_grupo_paginas ');
  FQuery.SQL.Add('                      and convert(char(10), getdate(), 112) between ');
  FQuery.SQL.Add('                          convert(char(10), tpa.dta_inicio_anuncio, 112) and convert(char(10), tpa.dta_fim_anuncio, 112) ');
  FQuery.SQL.Add('                      and tpa.cod_grupo_paginas = tbd.cod_grupo_paginas ');
  FQuery.SQL.Add('                      and tpa.seq_posicao_banner = tbd.seq_posicao_banner ');
  FQuery.SQL.Add('                      and tp.cod_pagina = :cod_pagina) ');

{$ENDIF}
  FQuery.ParamByName('cod_pagina').AsInteger      := CodPagina;

  Try
    FQuery.Open;
    Result := 0;
    If IncrementarImpressao Then Begin
      While Not FQuery.EOF do Begin
        Result := IncrementaImpressao(CodPagina,
                                      FQuery.FieldByName('CodBanner').AsInteger);
        If Result < 0 Then Begin
          Exit;
        End;
        FQuery.Next;
      End;
      FQuery.Close;
      FQuery.Open;
    End;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(100, 'TIntBanners', 'Pesquisar', [E.Message]);
      Result := -100;
      Exit;
    End;
  End;
end;

function TIntBannersVisita.IncrementaImpressao(CodPagina, CodBanner: Integer): Integer;
var
  Q : THerdomQuery;
  DtaServidor : TDatetime;
  NovoRegistro : Boolean;
begin
  Mensagens.Clear;

  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('IncrementarImpressao');
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Obtem a data do servidor
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select getdate() as dta_servidor ');
{$ENDIF}
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(111, 'TIntBannersVisita', 'IncrementarImpressao', []);
        Result := -111;
        Exit;
      End;
      DtaServidor := Q.FieldByName('dta_servidor').AsDateTime;

      // Precisão = DIA
      DtaServidor := Trunc(DtaServidor);

      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_resultado_anuncio ');
      Q.SQL.Add(' where cod_pagina  = :cod_pagina ');
      Q.SQL.Add('   and cod_banner  = :cod_banner ');
      Q.SQL.Add('   and dta_anuncio = :dta_servidor ');
//      Q.SQL.Add('   and convert(char(10), dta_anuncio, 112) = convert(char(10), :dta_servidor, 112) ');
{$ENDIF}
      Q.ParamByName('cod_pagina').AsInteger := CodPagina;
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.ParamByName('dta_servidor').AsDatetime := DtaServidor;
      Q.Open;
      If not Q.IsEmpty Then Begin
        NovoRegistro := False;
      End Else Begin
        NovoRegistro := True;
      End;
      Q.Close;

      // Incrementa impressão
      Q.SQL.Clear;
      If NovoRegistro Then Begin
{$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_resultado_anuncio ');
        Q.SQL.Add(' (cod_pagina, ');
        Q.SQL.Add('  cod_banner, ');
        Q.SQL.Add('  dta_anuncio, ');
        Q.SQL.Add('  qtd_impressoes, ');
        Q.SQL.Add('  qtd_cliques) ');
        Q.SQL.Add('values');
        Q.SQL.Add(' (:cod_pagina, ');
        Q.SQL.Add('  :cod_banner, ');
        Q.SQL.Add('  :dta_anuncio, ');
        Q.SQL.Add('  1, ');
        Q.SQL.Add('  0) ');
{$ENDIF}
      End Else Begin
        Q.SQL.Add('update tab_resultado_anuncio ');
        Q.SQL.Add('   set qtd_impressoes = qtd_impressoes + 1 ');
        Q.SQL.Add(' where cod_pagina  = :cod_pagina ');
        Q.SQL.Add('   and cod_banner  = :cod_banner ');
        Q.SQL.Add('   and dta_anuncio = :dta_anuncio ');
      End;
      Q.ParamByName('cod_pagina').AsInteger := CodPagina;
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.ParamByName('dta_anuncio').AsDatetime := DtaServidor;
      Q.ExecSQL;

      // Retorna código do banner criado
      Result := 0
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(112, 'TIntBannersVisita', 'IncrementarImpressao', [E.Message]);
        Result := -112;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntBannersVisita.Localizar(SeqPosicaoBanner: Integer): Integer;
begin
  Mensagens.Clear;

  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Localizar');
    Exit;
  End;

  If FQuery.Active Then Begin
    If FQuery.Locate('SeqPosicaoBanner', SeqPosicaoBanner, []) Then Begin
      Result := 0;
    End;
  End;
end;

function TIntBannersVisita.IncrementarCliques(CodPagina, CodBanner: Integer): Integer;
var
  Q : THerdomQuery;
  DtaServidor : TDatetime;
  NovoRegistro : Boolean;
begin
  Mensagens.Clear;

  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('IncrementarCliques');
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Obtem a data do servidor
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select getdate() as dta_servidor ');
{$ENDIF}
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(111, 'TIntBannersVisita', 'IncrementarCliques', []);
        Result := -111;
        Exit;
      End;
      DtaServidor := Q.FieldByName('dta_servidor').AsDateTime;

      // Precisão = DIA
      DtaServidor := Trunc(DtaServidor);

      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_resultado_anuncio ');
      Q.SQL.Add(' where cod_pagina  = :cod_pagina ');
      Q.SQL.Add('   and cod_banner  = :cod_banner ');
      Q.SQL.Add('   and dta_anuncio = :dta_servidor ');
{$ENDIF}
      Q.ParamByName('cod_pagina').AsInteger := CodPagina;
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.ParamByName('dta_servidor').AsDatetime := DtaServidor;
      Q.Open;
      If not Q.IsEmpty Then Begin
        NovoRegistro := False;
      End Else Begin
        NovoRegistro := True;
      End;
      Q.Close;

      // Incrementa cliques
      Q.SQL.Clear;
      If NovoRegistro Then Begin
{$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_resultado_anuncio ');
        Q.SQL.Add(' (cod_pagina, ');
        Q.SQL.Add('  cod_banner, ');
        Q.SQL.Add('  dta_anuncio, ');
        Q.SQL.Add('  qtd_impressoes, ');
        Q.SQL.Add('  qtd_cliques) ');
        Q.SQL.Add('values');
        Q.SQL.Add(' (:cod_pagina, ');
        Q.SQL.Add('  :cod_banner, ');
        Q.SQL.Add('  :dta_anuncio, ');
        Q.SQL.Add('  1, ');
        Q.SQL.Add('  1) ');
{$ENDIF}
      End Else Begin
        Q.SQL.Add('update tab_resultado_anuncio ');
        Q.SQL.Add('   set qtd_cliques = qtd_cliques + 1 ');
        Q.SQL.Add(' where cod_pagina  = :cod_pagina ');
        Q.SQL.Add('   and cod_banner  = :cod_banner ');
        Q.SQL.Add('   and dta_anuncio = :dta_anuncio ');
      End;
      Q.ParamByName('cod_pagina').AsInteger := CodPagina;
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.ParamByName('dta_anuncio').AsDatetime := DtaServidor;
      Q.ExecSQL;

      // Retorna código do banner criado
      Result := 0
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(113, 'TIntBannersVisita', 'IncrementarCliques', [E.Message]);
        Result := -113;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntBannersVisita.ValorCampo(NomeColuna: String): Variant;
begin
  Result := null;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('ValorCampo');
    Exit;
  End;
  If FQuery.Active Then Begin
    Try
      Result := FQuery.FieldByName(NomeColuna).Value;
    Except
      Result := '#CAMPO_INEXISTENTE#';
    End;
  End;
end;

procedure TIntBannersVisita.FecharPesquisa;
begin
  If Not Inicializado Then Begin
    RaiseNaoInicializado('FecharPesquisa');
    Exit;
  End;
  If FQuery.Active Then Begin
    FQuery.Close;
  End;
end;

function TIntBannersVisita.QtdBannersPagina(CodPagina: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Mensagens.Clear;

  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('QtdBannersPagina');
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Obtem a data do servidor
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select count(tltp.cod_tipo_pagina) as qtd_paginas ' +
                '  from tab_layout_tipo_pagina tltp, ' +
                '       tab_pagina tp ' +
                ' where tltp.cod_tipo_pagina = tp.cod_tipo_pagina ' +
                '   and tp.cod_pagina = :cod_pagina ');
{$ENDIF}
      Q.ParamByName('cod_pagina').AsInteger := CodPagina;
      Q.Open;

      Result := Q.FieldByName('qtd_paginas').AsInteger;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1132, 'TIntBannersVisita', 'QtdBannersPagina', [E.Message]);
        Result := -1132;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;



end.
