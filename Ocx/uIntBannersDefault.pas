unit uIntBannersDefault;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntBannersDefault }
  TIntBannersDefault = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodGrupoPaginas: Integer): Integer;
    function Definir(CodGrupoPaginas, SeqPosicaoBanner,
      CodBannerDefault: Integer): Integer; safecall;
end;

implementation

{ TIntTiposBanner }

function TIntBannersDefault.Pesquisar(CodGrupoPaginas: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(16) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tbd.cod_grupo_paginas as CodGrupoPaginas, ');
  Query.SQL.Add('       tbd.seq_posicao_banner as SeqPosicaoBanner, ');
  Query.SQL.Add('       tb.nom_arquivo as NomArquivo, ');
  Query.SQL.Add('       tb.cod_tipo_banner as CodTipoBanner, ');
  Query.SQL.Add('       ttb.des_tipo_banner    as DesTipoBanner, ');
  Query.SQL.Add('       tbd.cod_banner    as CodBanner ');
  Query.SQL.Add('  from tab_banner_default tbd, ');
  Query.SQL.Add('       tab_tipo_banner ttb, ');
  Query.SQL.Add('       tab_banner tb ');
  Query.SQL.Add(' where tbd.cod_grupo_paginas = :cod_grupo_paginas ');
  Query.SQL.Add('   and tbd.cod_banner        = tb.cod_banner ');
  Query.SQL.Add('   and tb.cod_tipo_banner    = ttb.cod_tipo_banner ');
  Query.SQL.Add(' order by tbd.seq_posicao_banner ');
{$ENDIF}

  Try
    Query.ParamByName('cod_grupo_paginas').asInteger := CodGrupoPaginas;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(117, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -117;
      Exit;
    End;
  End;
end;

function TIntBannersDefault.Definir(CodGrupoPaginas: Integer; SeqPosicaoBanner: Integer;
    CodBannerDefault: Integer): Integer;
var
  Q : THerdomQuery;
  NovoRegistro : Boolean;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Definir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(17) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Definir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      If CodBannerDefault > 0 Then Begin
        // Verifica se banner pertence ao layout/posicao tipo pagina
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_layout_tipo_pagina tltp, ');
        Q.SQL.Add('       tab_grupo_paginas tgp, ');
        Q.SQL.Add('       tab_banner tb ');
        Q.SQL.Add('  where tb.cod_banner = :cod_banner ');
        Q.SQL.Add('     and tltp.cod_tipo_banner = tb.cod_tipo_banner ');
        Q.SQL.Add('     and tltp.cod_tipo_pagina = tgp.cod_tipo_pagina ');
        Q.SQL.Add('     and tltp.seq_posicao_banner = :seq_posicao_banner ');
        Q.SQL.Add('     and tgp.cod_grupo_paginas = :cod_grupo_paginas ');
        {$ENDIF}
        Q.ParamByName('cod_grupo_paginas').AsInteger  := CodGrupoPaginas;
        Q.ParamByName('seq_posicao_banner').AsInteger := SeqPosicaoBanner;
        Q.ParamByName('cod_banner').AsInteger         := CodBannerDefault;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(118, Self.ClassName, 'Definir', [IntToStr(CodGrupoPaginas), IntToStr(SeqPosicaoBanner), IntToStr(CodBannerDefault)]);
          Result := -118;
          Exit;
        End;
        Q.Close;

        // Verifica existencia do registro
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_banner_default ');
        Q.SQL.Add(' where cod_grupo_paginas  = :cod_grupo_paginas  ');
        Q.SQL.Add('   and seq_posicao_banner = :seq_posicao_banner ');
        {$ENDIF}
        Q.ParamByName('cod_grupo_paginas').AsInteger  := CodGrupoPaginas;
        Q.ParamByName('seq_posicao_banner').AsInteger := SeqPosicaoBanner;
        Q.Open;
        If not Q.IsEmpty Then Begin
          NovoRegistro := False;
        End Else Begin
          NovoRegistro := True;
        End;
      End Else Begin
        NovoRegistro := False;
      End;

      // Atualiza tab_banner_default
      Q.Close;
      Q.SQL.Clear;
      If NovoRegistro Then Begin
        {$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_banner_default ' +
                  ' (cod_grupo_paginas, ' +
                  '  seq_posicao_banner, ' +
                  '  cod_banner) ' +
                  'values' +
                  ' (:cod_grupo_paginas, ' +
                  '  :seq_posicao_banner, ' +
                  '  :cod_banner_default) ');
        {$ENDIF}
        Q.ParamByName('cod_banner_default').AsInteger         := CodBannerDefault;
      End Else Begin
        If CodBannerDefault > 0 Then Begin
          {$IFDEF MSSQL}
          Q.SQL.Add('update tab_banner_default ' +
                    '   set cod_banner = :cod_banner_default ' +
                    ' where cod_grupo_paginas   = :cod_grupo_paginas ' +
                    '   and seq_posicao_banner  = :seq_posicao_banner ');
          {$ENDIF}
          Q.ParamByName('cod_banner_default').AsInteger         := CodBannerDefault;
        End Else Begin
          {$IFDEF MSSQL}
          Q.SQL.Add('delete tab_banner_default ' +
                    ' where cod_grupo_paginas   = :cod_grupo_paginas ' +
                    '   and seq_posicao_banner  = :seq_posicao_banner ');
          {$ENDIF}
        End;
      End;
      Q.ParamByName('cod_grupo_paginas').AsInteger  := CodGrupoPaginas;
      Q.ParamByName('seq_posicao_banner').AsInteger := SeqPosicaoBanner;
      Q.ExecSQL;

      // Retorna código do banner criado
      Result := 0
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(119, Self.ClassName, 'Definir', [E.Message]);
        Result := -119;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

end.
