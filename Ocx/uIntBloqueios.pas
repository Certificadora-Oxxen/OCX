unit uIntBloqueios;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntBloqueio, dbtables, sysutils, db;

type
  { TIntBloqueios }
  TIntBloqueios = class(TIntClasseBDNavegacaoBasica)
  private
    FIntBloqueio : TIntBloqueio;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Pesquisar(CodAplicacaoBloqueio, NomUsuario: String;
      CodPessoa: Integer; NomPessoa, CodNaturezaPessoa,
      NumCNPJCPF, SglProdutor: String; CodMotivoBloqueio: Integer; DtaInicio,
      DtaFim: TDateTime; IndApenasBloqueados: String; CodOrdenacao: Integer): Integer;
    function Inserir(CodAplicacaoBloqueio: String; CodUsuario,
      CodPessoaProdutor, CodMotivoBloqueio: Integer;
      TxtObservacaoBloqueio, TxtObservacaoUsuario,
      TxtProcedimentoUsuario: String): Integer;
    function Excluir(CodAplicacaoBloqueio: String; CodUsuario,
      CodPessoaProdutor: Integer): Integer;
    function Buscar(CodAplicacaoBloqueio: String; CodUsuario,
      CodPessoaProdutor: Integer; DtaInicioBloqueio: TDateTime): Integer;
    property IntBloqueio : TIntBloqueio read FIntBloqueio write FIntBloqueio;
  end;

implementation

{ TIntBloqueios }
constructor TIntBloqueios.Create;
begin
  inherited;
  FIntBloqueio := TIntBloqueio.Create;
end;

destructor TIntBloqueios.Destroy;
begin
  FIntBloqueio.Free;
  inherited;
end;

function TIntBloqueios.Pesquisar(CodAplicacaoBloqueio, NomUsuario: String;
                                 CodPessoa: Integer; NomPessoa, CodNaturezaPessoa,
                                 NumCNPJCPF, SglProdutor: String; CodMotivoBloqueio: Integer; DtaInicio,
                                 DtaFim: TDateTime; IndApenasBloqueados: String; CodOrdenacao: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(42) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  If ( UpperCase(CodAplicacaoBloqueio) <> 'U' ) And
     ( UpperCase(CodAplicacaoBloqueio) <> 'P' ) Then Begin
    Mensagens.Adicionar(189, Self.ClassName, 'Pesquisar', []);
    Result := -189;
    Exit;
  End;

  if ((DtaInicio > 0) or (DtaFim > 0)) and (UpperCase(IndApenasBloqueados) = 'S') then begin
    Mensagens.Adicionar(2037, Self.ClassName, 'Pesquisar', []);
    Result := -2037;
    Exit;
  end;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;

  If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
    Query.SQL.Add('select tmb.cod_aplicacao_bloqueio as CodAplicacaoBloqueio, ');
    Query.SQL.Add('       tu.cod_usuario as CodUsuario, ');
    Query.SQL.Add('       tu.nom_usuario as NomUsuario, ');
    Query.SQL.Add('       tpe.cod_pessoa as CodPessoa, ');
    Query.SQL.Add('       tpe.nom_pessoa as NomPessoa, ');
    Query.SQL.Add('       tpe.cod_natureza_pessoa as CodNaturezaPessoa, ');
    Query.SQL.Add('       case tpe.cod_natureza_pessoa ');
    Query.SQL.Add('         when ''F'' then convert(varchar(18), ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 1, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 4, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 7, 3) + ''-'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 10, 2)) ');
    Query.SQL.Add('         when ''J'' then convert(varchar(18), ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 1, 2) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 3, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 6, 3) + ''/'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 9, 4) + ''-'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 13, 2)) ');
    Query.SQL.Add('       end as NumCNPJCPF, ');
    Query.SQL.Add('       tmb.cod_motivo_bloqueio as CodMotivoBloqueio, ');
    Query.SQL.Add('       tmb.des_motivo_bloqueio as DesMotivoBloqueio, ');
    Query.SQL.Add('       tbloq.dta_inicio_bloqueio as DtaInicioBloqueio, ');
    Query.SQL.Add('       tbloq.dta_fim_bloqueio as DtaFimBloqueio, ');
    Query.SQL.Add('       tpa.cod_papel as CodPapel, ');
    Query.SQL.Add('       tpa.des_papel as DesPapel ');
    Query.SQL.Add('from tab_usuario tu, ');
    Query.SQL.Add('     tab_bloqueio_usuario tbloq, ');
    Query.SQL.Add('     tab_motivo_bloqueio tmb, ');
    Query.SQL.Add('     tab_pessoa tpe, ');
    Query.SQL.Add('     tab_papel tpa ');
    Query.SQL.Add('where tu.cod_usuario = tbloq.cod_usuario ');
    Query.SQL.Add('  and tbloq.cod_motivo_bloqueio = tmb.cod_motivo_bloqueio ');
    Query.SQL.Add('  and tu.cod_pessoa = tpe.cod_pessoa ');
    Query.SQL.Add('  and tu.cod_papel = tpa.cod_papel ');
  End Else
  If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin

    Query.SQL.Add('select tmb.cod_aplicacao_bloqueio as CodAplicacaoBloqueio, ');
    Query.SQL.Add('       tu.cod_usuario as CodUsuario, ');
    Query.SQL.Add('       tu.nom_usuario as NomUsuario, ');
    Query.SQL.Add('       tpe.cod_pessoa as CodPessoa, ');
    Query.SQL.Add('       tpe.nom_pessoa as NomPessoa, ');
    Query.SQL.Add('       tpe.cod_natureza_pessoa as CodNaturezaPessoa, ');
    Query.SQL.Add('       case tpe.cod_natureza_pessoa ');
    Query.SQL.Add('         when ''F'' then convert(varchar(18), ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 1, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 4, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 7, 3) + ''-'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 10, 2)) ');
    Query.SQL.Add('         when ''J'' then convert(varchar(18), ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 1, 2) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 3, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 6, 3) + ''/'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 9, 4) + ''-'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 13, 2)) ');
    Query.SQL.Add('       end as NumCNPJCPF, ');
    Query.SQL.Add('       tmb.cod_motivo_bloqueio as CodMotivoBloqueio, ');
    Query.SQL.Add('       tmb.des_motivo_bloqueio as DesMotivoBloqueio, ');
    Query.SQL.Add('       tbloq.dta_inicio_bloqueio as DtaInicioBloqueio, ');
    Query.SQL.Add('       tbloq.dta_fim_bloqueio as DtaFimBloqueio, ');
    Query.SQL.Add('       tpa.cod_papel as CodPapel, ');
    Query.SQL.Add('       tpa.des_papel as DesPapel ');
    Query.SQL.Add('from tab_produtor tp, ');
    Query.SQL.Add('     tab_usuario tu, ');
    Query.SQL.Add('     tab_bloqueio_produtor tbloq, ');
    Query.SQL.Add('     tab_motivo_bloqueio tmb, ');
    Query.SQL.Add('     tab_pessoa tpe, ');
    Query.SQL.Add('     tab_papel tpa ');
    Query.SQL.Add('where tp.cod_pessoa_produtor = tpe.cod_pessoa ');
    Query.SQL.Add('  and tpe.cod_pessoa = tu.cod_pessoa ');
    Query.SQL.Add('  and tp.cod_pessoa_produtor = tbloq.cod_pessoa_produtor ');
    Query.SQL.Add('  and tbloq.cod_motivo_bloqueio = tmb.cod_motivo_bloqueio ');
    Query.SQL.Add('   and tu.cod_papel = tpa.cod_papel ');
    Query.SQL.Add('   and tu.cod_papel = 4 --Produtor ');
  End;

  If NomUsuario <> '' Then Begin
    Query.SQL.Add('   and tu.nom_usuario like :nom_usuario ');
  End;

  Query.SQL.Add('   and ( (tpe.cod_pessoa = :cod_pessoa) or (:cod_pessoa = -1)) ');

  If NomPessoa <> '' Then Begin
    Query.SQL.Add('   and tpe.nom_pessoa like :nom_pessoa ');
  End;

  If ( UpperCase(CodNaturezaPessoa) = 'F' ) or
     ( UpperCase(CodNaturezaPessoa) = 'J' ) Then Begin
    Query.SQL.Add('   and tpe.cod_natureza_pessoa = :cod_natureza_pessoa ');
  End;

  If ( (UpperCase(CodNaturezaPessoa) = 'F') and (Length(NumCNPJCPF) = 11) ) or
     ( (UpperCase(CodNaturezaPessoa) = 'J') and (Length(NumCNPJCPF) = 14) ) Then Begin
    Query.SQL.Add('   and tpe.num_cnpj_cpf = :num_cnpj_cpf ');
  End;

  if (SglProdutor <> '') then begin
    Query.SQL.Add('   and tp.sgl_produtor like :sgl_produtor');
  end;

  Query.SQL.Add('  and ( (tbloq.cod_motivo_bloqueio = :cod_motivo_bloqueio) or (:cod_motivo_bloqueio = -1)) ');

  if (DtaFim > 0) then begin
    Query.SQL.Add('  and tbloq.dta_inicio_bloqueio < :dta_fim_bloqueio ');
  end;
  if (DtaInicio > 0 ) then begin
    Query.SQL.Add('  and ISNULL(tbloq.dta_fim_bloqueio, ''2079-06-06'') >= :dta_inicio_bloqueio ');
  end;

  if (UpperCase(IndApenasBloqueados) = 'S') then begin
    Query.SQL.Add('  and tbloq.dta_fim_bloqueio is null ');
  end;

  If (NomUsuario = '') and (UpperCase(CodAplicacaoBloqueio) = 'P') Then Begin
    Query.SQL.Add('union select tmb.cod_aplicacao_bloqueio as CodAplicacaoBloqueio, ');
    Query.SQL.Add('       null as CodUsuario, ');
    Query.SQL.Add('       null as NomUsuario, ');
    Query.SQL.Add('       tpe.cod_pessoa as CodPessoa, ');
    Query.SQL.Add('       tpe.nom_pessoa as NomPessoa, ');
    Query.SQL.Add('       tpe.cod_natureza_pessoa as CodNaturezaPessoa, ');
    Query.SQL.Add('       case tpe.cod_natureza_pessoa ');
    Query.SQL.Add('         when ''F'' then convert(varchar(18), ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 1, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 4, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 7, 3) + ''-'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 10, 2)) ');
    Query.SQL.Add('         when ''J'' then convert(varchar(18), ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 1, 2) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 3, 3) + ''.'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 6, 3) + ''/'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 9, 4) + ''-'' + ');
    Query.SQL.Add('                             substring(tpe.num_cnpj_cpf, 13, 2)) ');
    Query.SQL.Add('       end as NumCNPJCPF, ');
    Query.SQL.Add('       tmb.cod_motivo_bloqueio as CodMotivoBloqueio, ');
    Query.SQL.Add('       tmb.des_motivo_bloqueio as DesMotivoBloqueio, ');
    Query.SQL.Add('       tbloq.dta_inicio_bloqueio as DtaInicioBloqueio, ');
    Query.SQL.Add('       tbloq.dta_fim_bloqueio as DtaFimBloqueio, ');
    Query.SQL.Add('       null as CodPapel, ');
    Query.SQL.Add('       null as DesPapel ');
    Query.SQL.Add('from tab_produtor tp, ');
    Query.SQL.Add('     tab_bloqueio_produtor tbloq, ');
    Query.SQL.Add('     tab_motivo_bloqueio tmb, ');
    Query.SQL.Add('     tab_pessoa tpe ');
    Query.SQL.Add('where tp.cod_pessoa_produtor = tpe.cod_pessoa ');
    Query.SQL.Add('  and tp.cod_pessoa_produtor = tbloq.cod_pessoa_produtor ');
    Query.SQL.Add('  and tbloq.cod_motivo_bloqueio = tmb.cod_motivo_bloqueio ');
    Query.SQL.Add('   and ( (tpe.cod_pessoa = :cod_pessoa) or (:cod_pessoa = -1)) ');
    Query.SQL.Add('   and cod_pessoa not in (select cod_pessoa from tab_usuario) ');

    If NomPessoa <> '' Then Begin
      Query.SQL.Add('   and tpe.nom_pessoa like :nom_pessoa ');
    End;

    If ( UpperCase(CodNaturezaPessoa) = 'F' ) or
       ( UpperCase(CodNaturezaPessoa) = 'J' ) Then Begin
      Query.SQL.Add('   and tpe.cod_natureza_pessoa = :cod_natureza_pessoa ');
    End;

    If ( (UpperCase(CodNaturezaPessoa) = 'F') and (Length(NumCNPJCPF) = 11) ) or
       ( (UpperCase(CodNaturezaPessoa) = 'J') and (Length(NumCNPJCPF) = 14) ) Then Begin
      Query.SQL.Add('   and tpe.num_cnpj_cpf = :num_cnpj_cpf ');
    End;

    if (SglProdutor <> '') then begin
      Query.SQL.Add('   and tp.sgl_produtor like :sgl_produtor');
    end;

    Query.SQL.Add('  and ( (tbloq.cod_motivo_bloqueio = :cod_motivo_bloqueio) or (:cod_motivo_bloqueio = -1)) ');

    if (DtaInicio > 0 ) then begin
      Query.SQL.Add('  and ISNULL(tbloq.dta_fim_bloqueio, ''2079-06-06'') >= :dta_inicio_bloqueio ');
    end;
    if (DtaFim > 0) then begin
      Query.SQL.Add('  and tbloq.dta_inicio_bloqueio < :dta_fim_bloqueio ');
    end;
    
    if (UpperCase(IndApenasBloqueados) = 'S') then begin
      Query.SQL.Add('  and tbloq.dta_fim_bloqueio is null ');
    end;
 end;

 Case CodOrdenacao Of
    1 :
      Begin
        Query.SQL.Add('order by DtaInicioBloqueio desc');
        If UpperCase(CodAplicacaoBloqueio) = 'U' Then
          Query.SQL.Add(' , NomUsuario ')
        Else
        If UpperCase(CodAplicacaoBloqueio) = 'P' Then
          Query.SQL.Add(' , NomPessoa ');
      End;
    2 :
      Begin
        If UpperCase(CodAplicacaoBloqueio) = 'U' Then
          Query.SQL.Add('order by NomUsuario asc')
        Else
        If UpperCase(CodAplicacaoBloqueio) = 'P' Then
          Query.SQL.Add('order by NomPessoa asc');

        Query.SQL.Add(' , DtaInicioBloqueio desc');
      End;
    3 :
      Begin
        Query.SQL.Add('order by DesMotivoBloqueio asc ');
        Query.SQL.Add(' , DtaInicioBloqueio desc ');
      End;
    4 :
      Begin
        Query.SQL.Add(' order by DesMotivoBloqueio asc ');
        If UpperCase(CodAplicacaoBloqueio) = 'U' Then
          Query.SQL.Add(' , NomUsuario ')
        Else
        If UpperCase(CodAplicacaoBloqueio) = 'P' Then
          Query.SQL.Add(' , NomPessoa ');
      End;
  End;

{$ENDIF}

  If NomUsuario <> '' Then Begin
    Query.ParamByName('nom_usuario').AsString := '%' + NomUsuario + '%';
  End;

  Query.ParamByName('cod_pessoa').AsInteger := CodPessoa;

  If NomPessoa <> '' Then Begin
    Query.ParamByName('nom_pessoa').AsString := '%' + NomPessoa + '%';
  End;

  If ( UpperCase(CodNaturezaPessoa) = 'F' ) or
     ( UpperCase(CodNaturezaPessoa) = 'J' ) Then Begin
    Query.ParamByName('cod_natureza_pessoa').AsString  := CodNaturezaPessoa;
  End;

  If ( (UpperCase(CodNaturezaPessoa) = 'F') and (Length(NumCNPJCPF) = 11) ) or
     ( (UpperCase(CodNaturezaPessoa) = 'J') and (Length(NumCNPJCPF) = 14) ) Then Begin
    Query.ParamByName('num_cnpj_cpf').AsString := NumCNPJCPF + '%';
  End;

  if (SglProdutor <> '') and (UpperCase(CodAplicacaoBloqueio) = 'P') then begin
    Query.ParamByName('sgl_produtor').AsString := '%' + SglProdutor + '%';
  end;

  Query.ParamByName('cod_motivo_bloqueio').AsInteger := CodMotivoBloqueio;
  if (DtaInicio > 0 ) then begin
    Query.ParamByName('dta_inicio_bloqueio').AsDateTime := Trunc(DtaInicio);
  end;
  if (DtaFim > 0) then begin
    Query.ParamByName('dta_fim_bloqueio').AsDateTime := DtaFim + 1;
  end;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(190, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -190;
      Exit;
    End;
  End;
end;

function TIntBloqueios.Inserir(CodAplicacaoBloqueio: String; CodUsuario,
                               CodPessoaProdutor, CodMotivoBloqueio: Integer;
                               TxtObservacaoBloqueio, TxtObservacaoUsuario,
                               TxtProcedimentoUsuario: String): Integer;
var
  Q, QAux : THerdomQuery;
  CodUsuarioConectado : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(44) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  If ( UpperCase(CodAplicacaoBloqueio) <> 'U' ) And
     ( UpperCase(CodAplicacaoBloqueio) <> 'P' ) Then Begin
    Mensagens.Adicionar(189, Self.ClassName, 'Inserir', []);
    Result := -189;
    Exit;
  End;

  If TxtObservacaoBloqueio <> '' Then Begin
    Result := TrataString(TxtObservacaoBloqueio, 255, 'Observação do bloqueio');
    If Result < 0 then Exit;
  End;

  If TxtObservacaoUsuario <> '' Then Begin
    Result := TrataString(TxtObservacaoUsuario, 255, 'Observação do usuário');
    If Result < 0 then Exit;
  End;

  If TxtProcedimentoUsuario <> '' Then Begin
    Result := TrataString(TxtProcedimentoUsuario, 255, 'Procedimento do usuário');
    If Result < 0 then Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do Usuario/Produtor
      Q.SQL.Clear;
{$IFDEF MSSQL}
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('from tab_usuario ');
        Q.SQL.Add('where cod_usuario = :cod_usuario ');
      End Else
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('from tab_produtor ');
        Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa_produtor ');
      End;
{$ENDIF}
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario
      Else
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;

      Q.Open;
      If Q.IsEmpty Then Begin
        If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
          Mensagens.Adicionar(198, Self.ClassName, 'Inserir', [IntToStr(CodUsuario)]);
          Result := -198;
        End
        Else
        If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin
          Mensagens.Adicionar(197, Self.ClassName, 'Inserir', [IntToStr(CodPessoaProdutor)]);
          Result := -197;
        End;
        Exit;
      End;
      Q.Close;

      // Verifica se nao existe bloqueio
      Q.SQL.Clear;
{$IFDEF MSSQL}
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('from tab_bloqueio_usuario ');
        Q.SQL.Add('where cod_usuario = :cod_usuario ');
        Q.SQL.Add('  and dta_fim_bloqueio IS NULL ');
      End Else
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin
        Q.SQL.Add('select 1 ');
        Q.SQL.Add('from tab_bloqueio_produtor ');
        Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa_produtor ');
        Q.SQL.Add('  and dta_fim_bloqueio IS NULL ');
      End;
{$ENDIF}
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario
      Else
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;

      Q.Open;
      If not Q.IsEmpty Then Begin
        QAux := THerdomQuery.Create(Conexao, nil);
        Try
          QAux.SQL.Clear;
          If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
          {$IFDEF MSSQL}
            QAux.SQL.Add('select nom_usuario from tab_usuario ');
            QAux.SQL.Add('where cod_usuario = :cod_usuario ');
          {$ENDIF}
            QAux.ParamByName('cod_usuario').AsInteger := CodUsuario;
            QAux.Open;

            Mensagens.Adicionar(200, Self.ClassName, 'Inserir', [QAux.FieldByName('nom_usuario').AsString]);
            Result := -200;
            Exit;
          End
          Else
          If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin
          {$IFDEF MSSQL}
            QAux.SQL.Add('select tpe.nom_pessoa ');
            QAux.SQL.Add('from tab_produtor tpr, ');
            QAux.SQL.Add('     tab_pessoa tpe ');
            QAux.SQL.Add('where tpr.cod_pessoa_produtor = :cod_pessoa_produtor ');
            QAux.SQL.Add('  and tpr.cod_pessoa_produtor = tpe.cod_pessoa ');
          {$ENDIF}
            QAux.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
            QAux.Open;

            Mensagens.Adicionar(199, Self.ClassName, 'Inserir', [QAux.FieldByName('nom_pessoa').AsString]);
            Result := -199;
            Exit;
          End;
        Finally
          QAux.Free;
        End;
      End;
      Q.Close;

      // Verifica existencia do motivo de bloqueio
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('from tab_motivo_bloqueio ');
      Q.SQL.Add('where cod_motivo_bloqueio = :cod_motivo_bloqueio ');
{$ENDIF}
      Q.ParamByName('cod_motivo_bloqueio').AsInteger := CodMotivoBloqueio;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(203, Self.ClassName, 'Inserir', [IntToStr(CodMotivoBloqueio)]);
        Result := -203;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('from tab_aplicacao_bloqueio tab, ');
      Q.SQL.Add('     tab_motivo_bloqueio tmb ');
      Q.SQL.Add('where tab.cod_aplicacao_bloqueio = :cod_aplicacao_bloqueio ');
      Q.SQL.Add('  and tab.cod_aplicacao_bloqueio = tmb.cod_aplicacao_bloqueio ');
      Q.SQL.Add('  and tmb.cod_motivo_bloqueio = :cod_motivo_bloqueio ');
{$ENDIF}
      Q.ParamByName('cod_aplicacao_bloqueio').AsString := CodAplicacaoBloqueio;
      Q.ParamByName('cod_motivo_bloqueio').AsInteger := CodMotivoBloqueio;
      Q.Open;
      If Q.IsEmpty Then Begin
        QAux := THerdomQuery.Create(Conexao, nil);
        Try
          QAux.SQL.Clear;
          {$IFDEF MSSQL}
          QAux.SQL.Add('select des_motivo_bloqueio from tab_motivo_bloqueio ');
          QAux.SQL.Add('where cod_motivo_bloqueio = :cod_motivo_bloqueio ');
          {$ENDIF}
          QAux.ParamByName('cod_motivo_bloqueio').AsInteger := CodMotivoBloqueio;
          QAux.Open;

          Mensagens.Adicionar(195, Self.ClassName, 'Inserir', [QAux.FieldByName('des_motivo_bloqueio').AsString, CodAplicacaoBloqueio]);
          Result := -195;
          Exit;
        Finally
          QAux.Free;
        End;
      End;
      Q.Close;

      //Usuario Conectado
       CodUsuarioConectado := Conexao.CodUsuario;

      // Abre transação
      BeginTran;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin
        Q.SQL.Add('update tab_produtor ');
        Q.SQL.Add('set ind_produtor_bloqueado = ''S'' ');
        Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa_produtor ');
      End Else
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
        Q.SQL.Add('update tab_usuario ');
        Q.SQL.Add('set ind_usuario_bloqueado = ''S'' ');
        Q.SQL.Add('where cod_usuario = :cod_usuario ');
      End;
{$ENDIF}
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor
      Else
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;

      Q.ExecSQL;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin
        Q.SQL.Add('insert into tab_bloqueio_produtor ( ');
        Q.SQL.Add('cod_pessoa_produtor, ');
        Q.SQL.Add('dta_inicio_bloqueio, ');
        Q.SQL.Add('dta_fim_bloqueio, ');
        Q.SQL.Add('cod_motivo_bloqueio, ');
        Q.SQL.Add('txt_observacao_bloqueio, ');
        Q.SQL.Add('txt_observacao_usuario, ');
        Q.SQL.Add('txt_procedimento_usuario, ');
        Q.SQL.Add('dta_insercao_registro, ');
        Q.SQL.Add('cod_usuario_insercao ');
        Q.SQL.Add(') values ( ');
        Q.SQL.Add(':cod_pessoa_produtor, ');
        Q.SQL.Add('getdate(), ');
        Q.SQL.Add('NULL, ');
        Q.SQL.Add(':cod_motivo_bloqueio, ');
        Q.SQL.Add(':txt_observacao_bloqueio, ');
        Q.SQL.Add(':txt_observacao_usuario, ');
        Q.SQL.Add(':txt_procedimento_usuario, ');
        Q.SQL.Add('getdate(), ');
        Q.SQL.Add(':cod_usuario_insercao ');
        Q.SQL.Add(') ');
      End Else
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
        Q.SQL.Add('insert into tab_bloqueio_usuario ( ');
        Q.SQL.Add('cod_usuario, ');
        Q.SQL.Add('dta_inicio_bloqueio, ');
        Q.SQL.Add('dta_fim_bloqueio, ');
        Q.SQL.Add('cod_motivo_bloqueio, ');
        Q.SQL.Add('txt_observacao_bloqueio, ');
        Q.SQL.Add('txt_observacao_usuario, ');
        Q.SQL.Add('txt_procedimento_usuario, ');
        Q.SQL.Add('dta_insercao_registro, ');
        Q.SQL.Add('cod_usuario_insercao ');
        Q.SQL.Add(') values ( ');
        Q.SQL.Add(':cod_usuario, ');
        Q.SQL.Add('getdate(), ');
        Q.SQL.Add('NULL, ');
        Q.SQL.Add(':cod_motivo_bloqueio, ');
        Q.SQL.Add(':txt_observacao_bloqueio, ');
        Q.SQL.Add(':txt_observacao_usuario, ');
        Q.SQL.Add(':txt_procedimento_usuario, ');
        Q.SQL.Add('getdate(), ');
        Q.SQL.Add(':cod_usuario_insercao ');
        Q.SQL.Add(') ');
      End;
{$ENDIF}
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor
      Else
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;

      Q.ParamByName('cod_motivo_bloqueio').AsInteger := CodMotivoBloqueio;

      If TxtObservacaoBloqueio = '' Then Begin
        Q.ParamByName('txt_observacao_bloqueio').DataType := ftString;
        Q.ParamByName('txt_observacao_bloqueio').Clear;
      End Else Begin
        Q.ParamByName('txt_observacao_bloqueio').AsString := TxtObservacaoBloqueio;
      End;

      If TxtObservacaoUsuario = '' Then Begin
        Q.ParamByName('txt_observacao_usuario').DataType := ftString;
        Q.ParamByName('txt_observacao_usuario').Clear;
      End Else Begin
        Q.ParamByName('txt_observacao_usuario').AsString := TxtObservacaoUsuario;
      End;

      If TxtProcedimentoUsuario = '' Then Begin
        Q.ParamByName('txt_procedimento_usuario').DataType := ftString;
        Q.ParamByName('txt_procedimento_usuario').Clear;
      End Else Begin
        Q.ParamByName('txt_procedimento_usuario').AsString := TxtProcedimentoUsuario;
      End;

      Q.ParamByName('cod_usuario_insercao').AsInteger := CodUsuarioConectado;

      Q.ExecSQL;

      // Cofirma transação
      Commit;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(196, Self.ClassName, 'Inserir', [E.Message]);
        Result := -196;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntBloqueios.Excluir(CodAplicacaoBloqueio: String; CodUsuario,
                               CodPessoaProdutor: Integer): Integer;
var
  Q, QAux : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(45) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin
        Q.SQL.Add('select 1 from tab_bloqueio_produtor ');
        Q.SQL.Add('where dta_fim_bloqueio is null ');
        Q.SQL.Add('  and cod_pessoa_produtor = :cod_pessoa_produtor ');
      End Else
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
        Q.SQL.Add('select 1 from tab_bloqueio_usuario ');
        Q.SQL.Add('where dta_fim_bloqueio is null ');
        Q.SQL.Add('  and cod_usuario = :cod_usuario ');
      End;
{$ENDIF}
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor
      Else
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;

      Q.Open;
      If Q.IsEmpty Then Begin
        QAux := THerdomQuery.Create(Conexao, nil);
        Try
          QAux.SQL.Clear;
          If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
          {$IFDEF MSSQL}
            QAux.SQL.Add('select nom_usuario from tab_usuario ');
            QAux.SQL.Add('where cod_usuario = :cod_usuario ');
          {$ENDIF}
            QAux.ParamByName('cod_usuario').AsInteger := CodUsuario;
            QAux.Open;

            Mensagens.Adicionar(202, Self.ClassName, 'Excluir', [QAux.FieldByName('nom_usuario').AsString]);
            Result := -202;
            Exit;
          End
          Else
          If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin
          {$IFDEF MSSQL}
            QAux.SQL.Add('select tpe.nom_pessoa ');
            QAux.SQL.Add('from tab_produtor tpr, ');
            QAux.SQL.Add('     tab_pessoa tpe ');
            QAux.SQL.Add('where tpr.cod_pessoa_produtor = :cod_pessoa_produtor ');
            QAux.SQL.Add('  and tpr.cod_pessoa_produtor = tpe.cod_pessoa ');
          {$ENDIF}
            QAux.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
            QAux.Open;

            Mensagens.Adicionar(201, Self.ClassName, 'Excluir', [QAux.FieldByName('nom_pessoa').AsString]);
            Result := -201;
            Exit;
          End;
        Finally
          QAux.Free;
        End;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin
        Q.SQL.Add('update tab_bloqueio_produtor ');
        Q.SQL.Add('set dta_fim_bloqueio = getdate() ');
        Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa_produtor ');
      End Else
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
        Q.SQL.Add('update tab_bloqueio_usuario ');
        Q.SQL.Add('set dta_fim_bloqueio = getdate() ');
        Q.SQL.Add('where cod_usuario = :cod_usuario ');
      End;
{$ENDIF}
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor
      Else
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;

      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then Begin
        Q.SQL.Add('update tab_produtor ');
        Q.SQL.Add('set ind_produtor_bloqueado = ''N''  ');
        Q.SQL.Add('where cod_pessoa_produtor = :cod_pessoa_produtor ');
      End Else
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
        Q.SQL.Add('update tab_usuario ');
        Q.SQL.Add('set ind_usuario_bloqueado = ''N'', ');
        Q.SQL.Add('    qtd_logins_incorretos = 0 ');
        Q.SQL.Add('where cod_usuario = :cod_usuario ');
      End;
{$ENDIF}
      If UpperCase(CodAplicacaoBloqueio) = 'P' Then
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor
      Else
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;

      Q.ExecSQL;

      // Retorna status "ok" do método
      Commit;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(242, Self.ClassName, 'Excluir', [E.Message]);
        Result := -242;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntBloqueios.Buscar(CodAplicacaoBloqueio: String; CodUsuario,
                              CodPessoaProdutor: Integer; DtaInicioBloqueio: TDateTime): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(43) Then Begin
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
      If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
        Q.SQL.Add('select tbloq.dta_inicio_bloqueio, ');
        Q.SQL.Add('       tbloq.dta_fim_bloqueio, ');
        Q.SQL.Add('       tmb.cod_motivo_bloqueio, ');
        Q.SQL.Add('       tmb.cod_aplicacao_bloqueio, ');
        Q.SQL.Add('       tmb.des_motivo_bloqueio, ');
        Q.SQL.Add('       tmb.txt_motivo_usuario, ');
        Q.SQL.Add('       tbloq.txt_observacao_bloqueio, ');
        Q.SQL.Add('       tbloq.txt_observacao_usuario, ');
        Q.SQL.Add('       tmb.txt_procedimento_usuario, ');
        Q.SQL.Add('       tbloq.cod_usuario, ');
        Q.SQL.Add('       -1 as cod_pessoa_produtor, ');
        Q.SQL.Add('       tub.nom_usuario as nom_usuario_bloqueado, ');
        Q.SQL.Add('       tp.nom_pessoa, ');
        Q.SQL.Add('       tbloq.cod_usuario_insercao, ');
        Q.SQL.Add('       tur.nom_usuario ');
        Q.SQL.Add('  from tab_bloqueio_usuario tbloq, ');
        Q.SQL.Add('       tab_usuario tub, ');
        Q.SQL.Add('       tab_motivo_bloqueio tmb, ');
        Q.SQL.Add('       tab_pessoa tp, ');
        Q.SQL.Add('       tab_usuario tur ');
        Q.SQL.Add(' where tbloq.cod_motivo_bloqueio = tmb.cod_motivo_bloqueio ');
        Q.SQL.Add('   and tur.cod_usuario = tbloq.cod_usuario_insercao ');
        Q.SQL.Add('   and tbloq.cod_usuario = :cod_usuario ');
        Q.SQL.Add('   and tub.cod_usuario = tbloq.cod_usuario ');
        Q.SQL.Add('   and tp.cod_pessoa = tub.cod_pessoa ');
      End Else Begin
        Q.SQL.Add('select tbloq.dta_inicio_bloqueio, ');
        Q.SQL.Add('       tbloq.dta_fim_bloqueio, ');
        Q.SQL.Add('       tmb.cod_motivo_bloqueio, ');
        Q.SQL.Add('       tmb.cod_aplicacao_bloqueio, ');
        Q.SQL.Add('       tmb.des_motivo_bloqueio, ');
        Q.SQL.Add('       tmb.txt_motivo_usuario, ');
        Q.SQL.Add('       tbloq.txt_observacao_bloqueio, ');
        Q.SQL.Add('       tbloq.txt_observacao_usuario, ');
        Q.SQL.Add('       tbloq.txt_procedimento_usuario, ');
        Q.SQL.Add('       -1 as cod_usuario, ');
        Q.SQL.Add('       tbloq.cod_pessoa_produtor, ');
        Q.SQL.Add('       null as nom_usuario_bloqueado, ');
        Q.SQL.Add('       pes.nom_pessoa as nom_pessoa, ');
        Q.SQL.Add('       tbloq.cod_usuario_insercao, ');
        Q.SQL.Add('       tur.nom_usuario ');
        Q.SQL.Add('  from tab_bloqueio_produtor tbloq, ');
        Q.SQL.Add('       tab_pessoa pes, ');
        Q.SQL.Add('       tab_motivo_bloqueio tmb, ');
        Q.SQL.Add('       tab_usuario tur ');
        Q.SQL.Add(' where tbloq.cod_motivo_bloqueio = tmb.cod_motivo_bloqueio ');
        Q.SQL.Add('   and tur.cod_usuario = tbloq.cod_usuario_insercao ');
        Q.SQL.Add('   and tbloq.cod_pessoa_produtor = :cod_pessoa_produtor ');
        Q.SQL.Add('   and pes.cod_pessoa = tbloq.cod_pessoa_produtor ');
      End;

      If DtaInicioBloqueio > 0 Then Begin
        Q.SQL.Add('  and tbloq.dta_inicio_bloqueio = :dta_inicio_bloqueio ');
      End Else Begin
        Q.SQL.Add('  and tbloq.dta_fim_bloqueio is null ');
      End;
{$ENDIF}

      If UpperCase(CodAplicacaoBloqueio) = 'U' Then Begin
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      End Else Begin
        Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      End;

      If DtaInicioBloqueio > 0 Then Begin
        Q.ParamByName('dta_inicio_bloqueio').AsDateTime := DtaInicioBloqueio;
      End;

      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(191, Self.ClassName, 'Buscar',
                                 [CodAplicacaoBloqueio, IntToStr(CodUsuario),
                                 IntTostr(CodPessoaProdutor), DateTimeToStr(DtaInicioBloqueio)]);
        Result := -191;
        Exit;
      End;

      // Obtem informações do registro
      FIntBloqueio.DtaInicioBloqueio      := Q.FieldByName('dta_inicio_bloqueio').AsDateTime;
      FIntBloqueio.DtaFimBloqueio         := Q.FieldByName('dta_fim_bloqueio').AsDateTime;
      FIntBloqueio.CodMotivoBloqueio      := Q.FieldByName('cod_motivo_bloqueio').AsInteger;
      FIntBloqueio.CodAplicacaoBloqueio   := Q.FieldByName('cod_aplicacao_bloqueio').AsString;
      FIntBloqueio.TxtMotivoBloqueio      := Q.FieldByName('des_motivo_bloqueio').AsString;
      FIntBloqueio.TxtObservacaoBloqueio  := Q.FieldByName('txt_observacao_bloqueio').AsString;
      FIntBloqueio.TxtObservacaoUsuario   := Q.FieldByName('txt_observacao_usuario').AsString;
      FIntBloqueio.TxtProcedimentoUsuario := Q.FieldByName('txt_procedimento_usuario').AsString;
      FIntBloqueio.CodUsuario             := Q.FieldByName('cod_usuario').AsInteger;
      FIntBloqueio.CodPessoaProdutor      := Q.FieldByName('cod_pessoa_produtor').AsInteger;
      FIntBloqueio.TxtMotivoUsuario       := Q.FieldByName('txt_motivo_usuario').AsString;
      FIntBloqueio.CodUsuarioResponsavel  := Q.FieldByName('cod_usuario_insercao').AsInteger;
      FIntBloqueio.NomUsuarioResponsavel  := Q.FieldByName('nom_usuario').AsString;
      FIntBloqueio.NomUsuario             := Q.FieldByName('nom_usuario_bloqueado').AsString;
      FIntBloqueio.NomPessoa              := Q.FieldByName('nom_pessoa').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(194, Self.ClassName, 'Buscar', [E.Message]);
        Result := -194;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

end.
