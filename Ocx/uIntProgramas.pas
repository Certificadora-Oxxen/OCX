unit uIntProgramas;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntPrograma, dbtables, sysutils, db;

type
  { TIntProgramas }
  TIntProgramas = class(TIntClasseBDNavegacaoBasica)
  private
    FIntPrograma : TIntPrograma;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodGrupoPaginas: Integer; DtaInicioAnuncio, DtaFimAnuncio: TDateTime;
      IndAnunciosInativos, IndOrdemCrescente: Boolean): Integer;
    function Inserir(CodGrupoPaginas, SeqPosicaoBanner: Integer;
      DtaInicioAnuncio, DtaFimAnuncio: TDateTime;
      CodBanner: Integer): Integer;
    function Alterar(CodGrupoPaginas, SeqPosicaoBanner: Integer;
      DtaInicioAnuncio, DtaInicioAnuncioNova, DtaFimAnuncioNova: TDateTime;
      CodBannerNovo: Integer): Integer;
    function Excluir(CodGrupoPaginas, SeqPosicaoBanner: Integer;
      DtaInicioAnuncio: TDateTime): Integer;
    function Buscar(CodGrupoPaginas, SeqPosicaoBanner: Integer;
      DtaInicioAnuncio: TDateTime): Integer;
    function PesquisarUltimos(CodGrupoPaginas, QtdDiasRetroativos: Integer): Integer;
    property IntPrograma : TIntPrograma read FIntPrograma write FIntPrograma;
  end;

implementation

{ TIntProgramas }
constructor TIntProgramas.Create;
begin
  inherited;
  FIntPrograma := TIntPrograma.Create;
end;

destructor TIntProgramas.Destroy;
begin
  FIntPrograma.Free;
  inherited;
end;

function TIntProgramas.Pesquisar(CodGrupoPaginas: Integer; DtaInicioAnuncio,
  DtaFimAnuncio: TDateTime; IndAnunciosInativos, IndOrdemCrescente: Boolean): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(28) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tpa.cod_grupo_paginas as CodGrupoPaginas, ');
  Query.SQL.Add('       tgp.des_grupo_paginas as DesGrupoPaginas, ');
  Query.SQL.Add('       tpa.seq_posicao_banner as SeqPosicaoBanner, ');
  Query.SQL.Add('       tltp.des_posicao_banner as DesPosicaoBanner, ');
  Query.SQL.Add('       tpa.dta_inicio_anuncio as DtaInicioAnuncio, ');
  Query.SQL.Add('       tpa.dta_fim_anuncio as DtaFimAnuncio, ');
  Query.SQL.Add('       tpa.cod_banner as CodBanner, ');
  Query.SQL.Add('       tb.nom_arquivo as NomArquivo ');
  Query.SQL.Add('  from tab_programa_anuncio tpa, ');
  Query.SQL.Add('       tab_grupo_paginas tgp, ');
  Query.SQL.Add('       tab_layout_tipo_pagina tltp, ');
  Query.SQL.Add('       tab_banner tb ');
  Query.SQL.Add(' where tgp.cod_grupo_paginas = tpa.cod_grupo_paginas ');
  Query.SQL.Add('   and tltp.cod_tipo_pagina = tgp.cod_tipo_pagina ');
  Query.SQL.Add('   and tltp.seq_posicao_banner = tpa.seq_posicao_banner ');
  Query.SQL.Add('   and tb.cod_banner = tpa.cod_banner ');
  Query.SQL.Add('   and ((tpa.cod_grupo_paginas = :cod_grupo_paginas) or (:cod_grupo_paginas = -1)) ');
  Query.SQL.Add('   and ((tpa.dta_inicio_anuncio between :dta_inicio_anuncio and :dta_fim_anuncio ');
  Query.SQL.Add('    or tpa.dta_fim_anuncio between  :dta_inicio_anuncio and :dta_fim_anuncio) ');
  Query.SQL.Add('    or :dta_inicio_anuncio is null) ');
  Query.SQL.Add('   and ((:ind_anuncios_inativos = 1) or (:ind_anuncios_inativos = 0 and ');
  Query.SQL.Add('                                        getdate() between tpa.dta_inicio_anuncio and tpa.dta_fim_anuncio)) ');
  If IndOrdemCrescente Then Begin
    Query.SQL.Add(' order by tpa.dta_inicio_anuncio, ');
  End Else Begin
    Query.SQL.Add(' order by tpa.dta_inicio_anuncio desc, ');
  End;
  Query.SQL.Add('          tgp.des_grupo_paginas, ');
  Query.SQL.Add('          tpa.seq_posicao_banner ');
{$ENDIF}

  Query.ParamByName('cod_grupo_paginas').AsInteger      := CodGrupoPaginas;
  If DtaInicioAnuncio = 0 Then Begin
    Query.ParamByName('dta_inicio_anuncio').DataType := ftDateTime;
    Query.ParamByName('dta_inicio_anuncio').Clear;
    Query.ParamByName('dta_fim_anuncio').DataType := ftDateTime;
    Query.ParamByName('dta_fim_anuncio').Clear;
  End Else Begin
    Query.ParamByName('dta_inicio_anuncio').AsDateTime := DtaInicioAnuncio
  End;
  If DtaFimAnuncio = 0 Then Begin
    Query.ParamByName('dta_inicio_anuncio').DataType := ftDateTime;
    Query.ParamByName('dta_inicio_anuncio').Clear;
    Query.ParamByName('dta_fim_anuncio').DataType := ftDateTime;
    Query.ParamByName('dta_fim_anuncio').Clear;
  End Else Begin
    Query.ParamByName('dta_fim_anuncio').AsDateTime := DtaFimAnuncio
  End;
  If IndAnunciosInativos Then Begin
    Query.ParamByName('ind_anuncios_inativos').AsInteger := 1;
  End Else Begin
    Query.ParamByName('ind_anuncios_inativos').AsInteger := 0;
  End;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(144, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -144;
      Exit;
    End;
  End;
end;

function TIntProgramas.Inserir(CodGrupoPaginas, SeqPosicaoBanner: Integer;
  DtaInicioAnuncio, DtaFimAnuncio: TDateTime; CodBanner: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(29) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_programa_anuncio ');
      Q.SQL.Add(' where :dta_inicio_anuncio between dta_inicio_anuncio and dta_fim_anuncio ');
      Q.SQL.Add('   and cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and seq_posicao_banner = :seq_posicao_banner ');
      Q.SQL.Add('union ');
      Q.SQL.Add('select 1 from tab_programa_anuncio ');
      Q.SQL.Add(' where :dta_fim_anuncio between dta_inicio_anuncio and dta_fim_anuncio ');
      Q.SQL.Add('   and cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and seq_posicao_banner = :seq_posicao_banner ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.ParamByName('seq_posicao_banner').AsInteger := SeqPosicaoBanner;
      Q.ParamByName('dta_inicio_anuncio').AsDateTime := DtaInicioAnuncio;
      Q.ParamByName('dta_fim_anuncio').AsDateTime := DtaFimAnuncio;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(149, Self.ClassName, 'Inserir', []);
        Result := -149;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_grupo_paginas ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(126, Self.ClassName, 'Inserir', [IntToStr(CodGrupoPaginas)]);
        Result := -126;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_banner ');
      Q.SQL.Add(' where cod_banner = :cod_banner ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(108, Self.ClassName, 'Inserir', [IntToStr(CodBanner)]);
        Result := -108;
        Exit;
      End;
      Q.Close;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_programa_anuncio ');
      Q.SQL.Add(' (cod_grupo_paginas, ');
      Q.SQL.Add('  seq_posicao_banner, ');
      Q.SQL.Add('  dta_inicio_anuncio, ');
      Q.SQL.Add('  dta_fim_anuncio, ');
      Q.SQL.Add('  cod_banner) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_grupo_paginas, ');
      Q.SQL.Add('  :seq_posicao_banner, ');
      Q.SQL.Add('  :dta_inicio_anuncio, ');
      Q.SQL.Add('  :dta_fim_anuncio, ');
      Q.SQL.Add('  :cod_banner) ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger   := CodGrupoPaginas;
      Q.ParamByName('seq_posicao_banner').AsInteger  := SeqPosicaoBanner;
      Q.ParamByName('dta_inicio_anuncio').AsDateTime := DtaInicioAnuncio;
      Q.ParamByName('dta_fim_anuncio').AsDateTime    := DtaFimAnuncio;
      Q.ParamByName('cod_banner').AsInteger          := CodBanner;
      Q.ExecSQL;

      // Retorna Status Ok
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(145, Self.ClassName, 'Inserir', [E.Message]);
        Result := -145;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntProgramas.Alterar(CodGrupoPaginas, SeqPosicaoBanner: Integer;
  DtaInicioAnuncio, DtaInicioAnuncioNova, DtaFimAnuncioNova: TDateTime;
  CodBannerNovo: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(30) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterarr', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica inexistencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_programa_anuncio ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and seq_posicao_banner = :seq_posicao_banner ');
      Q.SQL.Add('   and dta_inicio_anuncio = :dta_inicio_anuncio ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.ParamByName('seq_posicao_banner').AsInteger := SeqPosicaoBanner;
      Q.ParamByName('dta_inicio_anuncio').AsDateTime := DtaInicioAnuncio;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(150, Self.ClassName, 'Alterar', []);
        Result := -150;
        Exit;
      End;
      Q.Close;

      // Verifica existencia de outro registro com mesmo período
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_programa_anuncio ');
      Q.SQL.Add(' where :dta_inicio_anuncio_nova between dta_inicio_anuncio and dta_fim_anuncio ');
      Q.SQL.Add('   and (cod_grupo_paginas != :cod_grupo_paginas ');
      Q.SQL.Add('    or seq_posicao_banner != :seq_posicao_banner ');
      Q.SQL.Add('    or dta_inicio_anuncio != :dta_inicio_anuncio) ');
      Q.SQL.Add('union ');
      Q.SQL.Add('select 1 from tab_programa_anuncio ');
      Q.SQL.Add(' where :dta_fim_anuncio_nova between dta_inicio_anuncio and dta_fim_anuncio ');
      Q.SQL.Add('   and (cod_grupo_paginas != :cod_grupo_paginas ');
      Q.SQL.Add('    or seq_posicao_banner != :seq_posicao_banner ');
      Q.SQL.Add('    or dta_inicio_anuncio != :dta_inicio_anuncio) ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.ParamByName('seq_posicao_banner').AsInteger := SeqPosicaoBanner;
      Q.ParamByName('dta_inicio_anuncio').AsDateTime := DtaInicioAnuncio;
      Q.ParamByName('dta_inicio_anuncio_nova').AsDateTime := DtaInicioAnuncioNova;
      Q.ParamByName('dta_fim_anuncio_nova').AsDateTime := DtaFimAnuncioNova;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(149, Self.ClassName, 'Alterar', []);
        Result := -149;
        Exit;
      End;
      Q.Close;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_programa_anuncio ');
      Q.SQL.Add('   set dta_inicio_anuncio = :dta_inicio_anuncio_nova, ');
      Q.SQL.Add('       dta_fim_anuncio = :dta_fim_anuncio_nova, ');
      Q.SQL.Add('       cod_banner = :cod_banner_novo ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and seq_posicao_banner = :seq_posicao_banner ');
      Q.SQL.Add('   and dta_inicio_anuncio = :dta_inicio_anuncio ');
{$ENDIF}
      Q.ParamByName('dta_inicio_anuncio_nova').AsDateTime := DtaInicioAnuncioNova;
      Q.ParamByName('dta_fim_anuncio_nova').AsDateTime := DtaFimAnuncioNova;
      Q.ParamByName('cod_banner_novo').AsInteger := CodBannerNovo;
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.ParamByName('seq_posicao_banner').AsInteger := SeqPosicaoBanner;
      Q.ParamByName('dta_inicio_anuncio').AsDateTime := DtaInicioAnuncio;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(146, Self.ClassName, 'Alterar', [E.Message]);
        Result := -146;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntProgramas.Excluir(CodGrupoPaginas, SeqPosicaoBanner: Integer;
  DtaInicioAnuncio: TDateTime): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(32) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Verifica inexistencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_programa_anuncio ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and seq_posicao_banner = :seq_posicao_banner ');
      Q.SQL.Add('   and dta_inicio_anuncio = :dta_inicio_anuncio ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.ParamByName('seq_posicao_banner').AsInteger := SeqPosicaoBanner;
      Q.ParamByName('dta_inicio_anuncio').AsDateTime := DtaInicioAnuncio;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(150, Self.ClassName, 'Alterar', []);
        Result := -150;
        Exit;
      End;
      Q.Close;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_programa_anuncio ');
      Q.SQL.Add(' where cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and seq_posicao_banner = :seq_posicao_banner ');
      Q.SQL.Add('   and dta_inicio_anuncio = :dta_inicio_anuncio ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.ParamByName('seq_posicao_banner').AsInteger := SeqPosicaoBanner;
      Q.ParamByName('dta_inicio_anuncio').AsDateTime := DtaInicioAnuncio;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(147, Self.ClassName, 'Excluir', [E.Message]);
        Result := -147;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntProgramas.Buscar(CodGrupoPaginas, SeqPosicaoBanner: Integer;
  DtaInicioAnuncio: TDateTime): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(31) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tpa.cod_grupo_paginas, ');
      Q.SQL.Add('       tgp.des_grupo_paginas, ');
      Q.SQL.Add('       tpa.seq_posicao_banner, ');
      Q.SQL.Add('       tltp.des_posicao_banner, ');
      Q.SQL.Add('       tpa.dta_inicio_anuncio, ');
      Q.SQL.Add('       tpa.dta_fim_anuncio, ');
      Q.SQL.Add('       tpa.cod_banner, ');
      Q.SQL.Add('       tb.nom_arquivo ');
      Q.SQL.Add('  from tab_programa_anuncio tpa, ');
      Q.SQL.Add('       tab_banner tb, ');
      Q.SQL.Add('       tab_grupo_paginas tgp, ');
      Q.SQL.Add('       tab_layout_tipo_pagina tltp ');
      Q.SQL.Add(' where tb.cod_banner = tpa.cod_banner  ');
      Q.SQL.Add('   and tgp.cod_grupo_paginas = tpa.cod_grupo_paginas ');
      Q.SQL.Add('   and tltp.cod_tipo_pagina = tgp.cod_tipo_pagina ');
      Q.SQL.Add('   and tltp.seq_posicao_banner = tpa.seq_posicao_banner ');
      Q.SQL.Add('   and tpa.cod_grupo_paginas = :cod_grupo_paginas ');
      Q.SQL.Add('   and tpa.seq_posicao_banner = :seq_posicao_banner ');
      Q.SQL.Add('   and tpa.dta_inicio_anuncio = :dta_inicio_anuncio ');
{$ENDIF}
      Q.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
      Q.ParamByName('seq_posicao_banner').AsInteger := SeqPosicaoBanner;
      Q.ParamByName('dta_inicio_anuncio').AsDateTime := DtaInicioAnuncio;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(150, Self.ClassName, 'Buscar', []);
        Result := -150;
        Exit;
      End;

      // Obtem informações do registro
      IntPrograma.CodGrupoPaginas  := Q.FieldByName('cod_grupo_paginas').AsInteger;
      IntPrograma.SeqPosicaoBanner := Q.FieldByName('seq_posicao_banner').AsInteger;
      IntPrograma.DtaInicioAnuncio := Q.FieldByName('dta_inicio_anuncio').AsDateTime;
      IntPrograma.DtaFimAnuncio    := Q.FieldByName('dta_fim_anuncio').AsDateTime;
      IntPrograma.CodBanner        := Q.FieldByName('cod_banner').AsInteger;
      IntPrograma.DesGrupoPaginas  := Q.FieldByName('des_grupo_paginas').AsString;
      IntPrograma.DesPosicaoBanner := Q.FieldByName('des_posicao_banner').AsString;
      IntPrograma.NomArquivo       := Q.FieldByName('nom_arquivo').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(148, Self.ClassName, 'Buscar', [E.Message]);
        Result := -148;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntProgramas.PesquisarUltimos(CodGrupoPaginas, QtdDiasRetroativos: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarUltimos');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(33) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarUltimos', []);
    Result := -188;
    Exit;
  End;

  Try
    Query.Close;
    // Tenta Buscar Registro
    Query.SQL.Clear;
{$IFDEF MSSQL}
    Query.SQL.Add('select tpa.cod_grupo_paginas as CodGrupoPaginas, ');
    Query.SQL.Add('       tpa.seq_posicao_banner as SeqPosicaoBanner, ');
    Query.SQL.Add('       tltp.des_posicao_banner as DesPosicaoBanner, ');
    Query.SQL.Add('       tpa.dta_inicio_anuncio as DtaInicioAnuncio, ');
    Query.SQL.Add('       tpa.dta_fim_anuncio as DtaFimAnuncio, ');
    Query.SQL.Add('       tpa.cod_banner as CodBanner, ');
    Query.SQL.Add('       tb.nom_arquivo as NomArquivo');
    Query.SQL.Add('  from tab_programa_anuncio tpa, ');
    Query.SQL.Add('       tab_grupo_paginas tgp, ');
    Query.SQL.Add('       tab_layout_tipo_pagina tltp, ');
    Query.SQL.Add('       tab_banner tb ');
    Query.SQL.Add(' where tgp.cod_grupo_paginas = tpa.cod_grupo_paginas ');
    Query.SQL.Add('   and tltp.cod_tipo_pagina = tgp.cod_tipo_pagina ');
    Query.SQL.Add('   and tltp.seq_posicao_banner = tpa.seq_posicao_banner ');
    Query.SQL.Add('   and tb.cod_banner = tpa.cod_banner ');
    Query.SQL.Add('   and tpa.cod_grupo_paginas = :cod_grupo_paginas ');
    Query.SQL.Add('   and tpa.dta_fim_anuncio >= dateadd(dd, (:qtd_dias_retroativos * -1), getdate()) ');
    Query.SQL.Add(' order by tltp.des_posicao_banner, ');
    Query.SQL.Add('          tpa.dta_inicio_anuncio desc ');
{$ENDIF}
    Query.ParamByName('cod_grupo_paginas').AsInteger := CodGrupoPaginas;
    Query.ParamByName('qtd_dias_retroativos').AsInteger := QtdDiasRetroativos;
    Query.Open;

    // Retorna status "ok" do método
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(153, Self.ClassName, 'PesquisarUltimos', [E.Message]);
      Result := -153;
      Exit;
    End;
  End;
end;
end.
