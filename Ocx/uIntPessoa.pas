unit uIntPessoa;

{$DEFINE MSSQL}

interface

uses SysUtils, dbTables, uIntClassesBasicas, uConexao, uIntMensagens;

type
  TIntPessoa = class(TIntClasseBDBasica)
  private
    FCodPessoa: Integer;
    FNomPessoa: String;
    FNomReduzidoPessoa: String;
    FCodNaturezaPessoa: String;
    FNumCNPJCPF: String;
    FNumCNPJCPFFormatado: String;
    FDtaNascimento: TDateTime;
    FCodTelefonePrincipal: Integer;
    FSglTelefonePrincipal: String;
    FTxtTelefonePrincipal: String;
    FCodEMailPrincipal: Integer;
    FSglEMailPrincipal: String;
    FTxtEMailPrincipal: String;
    FCodTipoEndereco: Integer;
    FSglTipoEndereco: String;
    FDesTipoEndereco: String;
    FNomLogradouro: String;
    FNomBairro: String;
    FNumCEP: String;
    FCodPais: Integer;
    FNomPais: String;
    FCodEstado: Integer;
    FSglEstado: String;
    FCodMunicipio: Integer;
    FNomMunicipio: String;
    FNumMunicipioIBGE: String;
    FCodDistrito: Integer;
    FNomDistrito: String;
    FTxtObservacao: String;
    FDtaCadastramento: TDateTime;
    FIndProdutorBloqueado: String;
    FDtaEfetivacaoCadastro: TDateTime;
    FCodGrauInstrucao: Integer;
    FDesGrauInstrucao: String;
    FDesCursoSuperior: String;
    FSglConselhoRegional: String;
    FNumConselhoRegional: String;
    FSglProdutor: String;
    FIndEfetivadoUmaVez: String;
    FCodPessoaGestor: Integer;
    FNomGestor: String;
    FNomReduzidoGestor: String;
    FSexo: String;
    FNumIE: String;
    FDtaExp: TDateTime;
    FOrgaoIE: String;
    FUFIE: String;
    FIndEfetivadoUmaVezTecnico: String;
    FDtaEfetivacaoCadastroTecnico: TDateTime;
    FIndTecnicoAtivo: String;
  public
    function CarregaPropriedades(ECodPessoa: Integer;
                                 EConexaoBD: TConexao;
                                 EMensagens: TIntMensagens): Integer;

    property CodPessoa: Integer read FCodPessoa write FCodPessoa;
    property NomPessoa: String read FNomPessoa write FNomPessoa;
    property NomReduzidoPessoa: String read FNomReduzidoPessoa write FNomReduzidoPessoa;
    property CodNaturezaPessoa: String read FCodNaturezaPessoa write FCodNaturezaPessoa;
    property NumCNPJCPF: String read FNumCNPJCPF write FNumCNPJCPF;
    property NumCNPJCPFFormatado: String read FNumCNPJCPFFormatado write FNumCNPJCPFFormatado;
    property DtaNascimento: TDateTime read FDtaNascimento write FDtaNascimento;
    property CodTelefonePrincipal: Integer read FCodTelefonePrincipal write FCodTelefonePrincipal;
    property SglTelefonePrincipal: String read FSglTelefonePrincipal write FSglTelefonePrincipal;
    property TxtTelefonePrincipal: String read FTxtTelefonePrincipal write FTxtTelefonePrincipal;
    property CodEMailPrincipal: Integer read FCodEMailPrincipal write FCodEMailPrincipal;
    property SglEMailPrincipal: String read FSglEMailPrincipal write FSglEMailPrincipal;
    property TxtEMailPrincipal: String read FTxtEMailPrincipal write FTxtEMailPrincipal;
    property CodTipoEndereco: Integer read FCodTipoEndereco write FCodTipoEndereco;
    property SglTipoEndereco: String read FSglTipoEndereco write FSglTipoEndereco;
    property DesTipoEndereco: String read FDesTipoEndereco write FDesTipoEndereco;
    property NomLogradouro: String read FNomLogradouro write FNomLogradouro;
    property NomBairro: String read FNomBairro write FNomBairro;
    property NumCEP: String read FNumCEP write FNumCEP;
    property CodPais: Integer read FCodPais write FCodPais;
    property NomPais: String read FNomPais write FNomPais;
    property CodEstado: Integer read FCodEstado write FCodEstado;
    property SglEstado: String read FSglEstado write FSglEstado;
    property CodMunicipio: Integer read FCodMunicipio write FCodMunicipio;
    property NomMunicipio: String read FNomMunicipio write FNomMunicipio;
    property NumMunicipioIBGE: String read FNumMunicipioIBGE write FNumMunicipioIBGE;
    property CodDistrito: Integer read FCodDistrito write FCodDistrito;
    property NomDistrito: String read FNomDistrito write FNomDistrito;
    property TxtObservacao: String read FTxtObservacao write FTxtObservacao;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property IndProdutorBloqueado: String read FIndProdutorBloqueado write FIndProdutorBloqueado;
    property DtaEfetivacaoCadastro: TDateTime read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
    property CodGrauInstrucao: Integer read FCodGrauInstrucao write FCodGrauInstrucao;
    property DesGrauInstrucao: String read FDesGrauInstrucao write FDesGrauInstrucao;
    property DesCursoSuperior: String read FDesCursoSuperior write FDesCursoSuperior;
    property SglConselhoRegional: String read FSglConselhoRegional write FSglConselhoRegional;
    property NumConselhoRegional: String read FNumConselhoRegional write FNumConselhoRegional;
    property SglProdutor: String read FSglProdutor write FSglProdutor;
    property IndEfetivadoUmaVez: String read FIndEfetivadoUmaVez write FIndEfetivadoUmaVez;
    property CodPessoaGestor: Integer read FCodPessoaGestor write FCodPessoaGestor;
    property NomGestor: String read FNomGestor write FNomGestor;
    property NomReduzidoGestor: String read FNomReduzidoGestor write FNomReduzidoGestor;
    property Sexo: String read FSexo write FSexo;
    property NumIE: String read FNumIE write FNumIE;
    property DtaExp: TDateTime read FDtaExp write FDtaExp;
    property OrgaoIE: String read FOrgaoIE write FOrgaoIE;
    property UFIE: String read FUFIE write FUFIE;
    property IndEfetivadoUmaVezTecnico: String read FIndEfetivadoUmaVezTecnico write FIndEfetivadoUmaVezTecnico;
    property DtaEfetivacaoCadastroTecnico: TDateTime read FDtaEfetivacaoCadastroTecnico write FDtaEfetivacaoCadastroTecnico;
    property IndTecnicoAtivo: String read FIndTecnicoAtivo write FIndTecnicoAtivo;
  end;

implementation

uses DB;

{ TIntPessoa }

function TIntPessoa.CarregaPropriedades(ECodPessoa: Integer;
                                        EConexaoBD: TConexao;
                                        EMensagens: TIntMensagens): Integer;
var
  Q : THerdomQuery;
begin
  if Not Inicializado then
  begin
    Result := Inicializar(EConexaoBD, EMensagens);
    if Result < 0 then
    begin
      Exit;
    end;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Tenta Buscar Registro
      // --------------------------
      // dados principais da pessoa
      // --------------------------
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select                                               ' +
                '  tp.cod_pessoa             as CodPessoa             ' +
                '  , tp.nom_pessoa           as NomPessoa             ' +
                '  , tp.nom_reduzido_pessoa  as NomReduzidoPessoa     ' +
                '  , tp.cod_natureza_pessoa  as CodNaturezaPessoa     ' +
                '  , tp.num_cnpj_cpf         as NumCNPJCPF            ' +
                '  , tp.ind_sexo             as IndSexo               ' +
                '  , tp.num_identidade       as NumIdentidade         ' +
                '  , tp.orgao_expedicao      as OrgaoExpedicao        ' +
                '  , tp.uf_expedicao         as UFExpedicao           ' +
                '  , tp.dta_expedicao        as DtaExpedicao        ' +
                '  , case tp.cod_natureza_pessoa                      ' +
                '    when ''F'' then convert(varchar(18),             ' +
                '      substring(tp.num_cnpj_cpf, 1, 3) + ''.'' +     ' +
                '      substring(tp.num_cnpj_cpf, 4, 3) + ''.'' +     ' +
                '      substring(tp.num_cnpj_cpf, 7, 3) + ''-'' +     ' +
                '      substring(tp.num_cnpj_cpf, 10, 2))             ' +
                '    when ''J'' then convert(varchar(18),             ' +
                '      substring(tp.num_cnpj_cpf, 1, 2) + ''.'' +     ' +
                '      substring(tp.num_cnpj_cpf, 3, 3) + ''.'' +     ' +
                '      substring(tp.num_cnpj_cpf, 6, 3) + ''/'' +     ' +
                '      substring(tp.num_cnpj_cpf, 9, 4) + ''-'' +     ' +
                '      substring(tp.num_cnpj_cpf, 13, 2))             ' +
                '    end                     as NumCNPJCPFFormatado   ' +
                '  , dta_nascimento          as DtaNascimento         ' +
                '  , tte.cod_tipo_endereco   as CodTipoEndereco       ' +
                '  , tte.sgl_tipo_endereco   as SglTipoEndereco       ' +
                '  , tte.des_tipo_endereco   as DesTipoEndereco       ' +
                '  , nom_logradouro          as NomLogradouro         ' +
                '  , nom_bairro              as NomBairro             ' +
                '  , num_cep                 as NumCEP                ' +
                '  , tpais.cod_pais          as CodPais               ' +
                '  , tpais.nom_pais          as NomPais               ' +
                '  , te.cod_estado           as CodEstado             ' +
                '  , te.sgl_estado           as SglEstado             ' +
                '  , tm.cod_municipio        as CodMunicipio          ' +
                '  , tm.nom_municipio        as NomMunicipio          ' +
                '  , tm.num_municipio_ibge   as NumMunicipioIBGE      ' +
                '  , td.cod_distrito         as CodDistrito           ' +
                '  , td.nom_distrito         as NomDistrito           ' +
                '  , txt_observacao          as TxtObservacao         ' +
                '  , dta_cadastramento       as DtaCadastramento      ' +
                '                                                     ' +
                'from                                                 ' +
                '  tab_pessoa tp                                      ' +
                '  , tab_tipo_endereco tte                            ' +
                '  , tab_pais tpais                                   ' +
                '  , tab_estado te                                    ' +
                '  , tab_municipio tm                                 ' +
                '  , tab_distrito td                                  ' +
                '  , tab_produtor tprod                               ' +
                '                                                     ' +
                'where                                                ' +
                '  tp.cod_pessoa = :cod_pessoa                        ' +
                '  and tte.cod_tipo_endereco =* tp.cod_tipo_endereco  ' +
                '  and tpais.cod_pais =* tp.cod_pais                  ' +
                '  and te.cod_estado =* tp.cod_estado                 ' +
                '  and tm.cod_municipio =* tp.cod_municipio           ' +
                '  and td.cod_distrito =* tp.cod_distrito             ' +
                '  and tprod.cod_pessoa_produtor =* tp.cod_pessoa     ' +
                '  and tp.dta_fim_validade is null                    ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := ECodPessoa;
      Q.Open;
      // Verifica existência do registro
      if Q.IsEmpty then begin
        Mensagens.Adicionar(212, Self.ClassName, 'CarregaPropriedades', [IntToStr(CodPessoa)]);
        Result := -212;
        Exit;
      End;

      // Obtem informações do registro
      Self.CodPessoa            := Q.FieldByName('CodPessoa').AsInteger;
      Self.NomPessoa            := Q.FieldByName('NomPessoa').AsString;
      Self.NomReduzidoPessoa    := Q.FieldByName('NomReduzidoPessoa').AsString;
      Self.CodNaturezaPessoa    := Q.FieldByName('CodNaturezaPessoa').AsString;
      Self.NumCNPJCPF           := Q.FieldByName('NumCNPJCPF').AsString;
      Self.Sexo                 := Q.FieldByName('IndSexo').AsString;
      Self.NumIE                := Q.FieldByName('NumIdentidade').AsString;
      Self.OrgaoIE              := Q.FieldByName('OrgaoExpedicao').AsString;
      Self.UFIE                 := Q.FieldByName('UFExpedicao').AsString;
      Self.DtaExp               := Q.FieldByName('DtaExpedicao').AsDateTime;
      Self.NumCNPJCPFFormatado  := Q.FieldByName('NumCNPJCPFFormatado').AsString;
      Self.DtaNascimento        := Q.FieldByName('DtaNascimento').AsDateTime;
      Self.CodTipoEndereco      := Q.FieldByName('CodTipoEndereco').AsInteger;
      Self.SglTipoEndereco      := Q.FieldByName('SglTipoEndereco').AsString;
      Self.DesTipoEndereco      := Q.FieldByName('DesTipoEndereco').AsString;
      Self.NomLogradouro        := Q.FieldByName('NomLogradouro').AsString;
      Self.NomBairro            := Q.FieldByName('NomBairro').AsString;
      Self.NumCEP               := Q.FieldByName('NumCEP').AsString;
      Self.CodPais              := Q.FieldByName('CodPais').AsInteger;
      Self.NomPais              := Q.FieldByName('NomPais').AsString;
      Self.CodEstado            := Q.FieldByName('CodEstado').AsInteger;
      Self.SglEstado            := Q.FieldByName('SglEstado').AsString;
      Self.CodMunicipio         := Q.FieldByName('CodMunicipio').AsInteger;
      Self.NomMunicipio         := Q.FieldByName('NomMunicipio').AsString;
      Self.NumMunicipioIBGE     := Q.FieldByName('NumMunicipioIBGE').AsString;
      Self.CodDistrito          := Q.FieldByName('CodDistrito').AsInteger;
      Self.NomDistrito          := Q.FieldByName('NomDistrito').AsString;
      Self.TxtObservacao        := Q.FieldByName('TxtObservacao').AsString;
      Self.DtaCadastramento     := Q.FieldByName('DtaCadastramento').AsDateTime;

      // --------
      // contatos
      // --------
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select                                             ');
      Q.SQL.Add('  tpc.cod_contato        as CodContato             ');
      Q.SQL.Add('  , ttc.sgl_tipo_contato as SglContato             ');
      Q.SQL.Add('  , tpc.txt_contato      as TxtContato             ');
      Q.SQL.Add('from                                               ');
      Q.SQL.Add('  tab_pessoa_contato tpc                           ');
      Q.SQL.Add('  , tab_tipo_contato ttc                           ');
      Q.SQL.Add('where                                              ');
      Q.SQL.Add('  tpc.cod_pessoa = :cod_pessoa                     ');
      Q.SQL.Add('  and ttc.cod_grupo_contato = :cod_grupo           ');
      Q.SQL.Add('  and ttc.cod_tipo_contato = tpc.cod_tipo_contato  ');
      Q.SQL.Add('  and tpc.ind_principal = ''S''                    ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_grupo').AsString := 'T'; // Telefone
      Q.Open;
      if Q.IsEmpty then
      begin
        Self.CodTelefonePrincipal := 0;
        Self.SglTelefonePrincipal := '';
        Self.TxtTelefonePrincipal := '';
      end
      else
      begin
        Self.CodTelefonePrincipal := Q.FieldByName('CodContato').AsInteger;
        Self.SglTelefonePrincipal := Q.FieldByName('SglContato').AsString;
        Self.TxtTelefonePrincipal := Q.FieldByName('TxtContato').AsString;
      end;

      Q.Close;
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.ParamByName('cod_grupo').AsString := 'E'; // EMail
      Q.Open;
      if Q.IsEmpty then
      begin
        Self.CodEMailPrincipal := 0;
        Self.SglEMailPrincipal := '';
        Self.TxtEMailPrincipal := '';
      end
      else
      begin
        Self.CodEMailPrincipal := Q.FieldByName('CodContato').AsInteger;
        Self.SglEMailPrincipal := Q.FieldByName('SglContato').AsString;
        Self.TxtEMailPrincipal := Q.FieldByName('TxtContato').AsString;
      end;

      // -----------------
      // dados do produtor
      // -----------------
      Q.Close;
      Q.SQL.Clear;
      Q.SQL.Text :=
        'select '+
        '  tprod.ind_produtor_bloqueado as IndProdutorBloqueado '+
        '  , tprod.dta_efetivacao_cadastro as DtaEfetivacaoCadastro '+
        '  , tprod.sgl_produtor as SglProdutor '+
        '  , tprod.ind_efetivado_uma_vez as IndEfetivadoUmaVez '+
        'from '+
        '  tab_produtor tprod '+
        'where '+
        '  tprod.cod_pessoa_produtor = :cod_pessoa '+
        '  and tprod.dta_fim_validade is null ';
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      if Q.IsEmpty then
      begin
        Self.IndProdutorBloqueado  := '';
        Self.DtaEfetivacaoCadastro := 0;
        Self.SglProdutor           := '';
        Self.IndEfetivadoUmaVez    := '';
      end
      else
      begin
        Self.IndProdutorBloqueado  := Q.FieldByName('IndProdutorBloqueado').AsString;
        Self.DtaEfetivacaoCadastro := Q.FieldByName('DtaEfetivacaoCadastro').AsDateTime;
        Self.SglProdutor           := Q.FieldByName('SglProdutor').AsString;
        Self.IndEfetivadoUmaVez    := Q.FieldByName('IndEfetivadoUmaVez').AsString;
      end;

      // ----------------
      // Dados do técnico
      // ----------------
      Q.Close;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('select                                                          ');
      Q.SQL.Add('    tgi.cod_grau_instrucao   as CodGrauInstrucao                ');
      Q.SQL.Add('  , tgi.des_grau_instrucao   as DesGrauInstrucao                ');
      Q.SQL.Add('  , tt.des_curso_superior    as DesCursoSuperior                ');
      Q.SQL.Add('  , tt.sgl_conselho_regional as SglConselhoRegional             ');
      Q.SQL.Add('  , tt.num_conselho_regional   as NumConselhoRegional           ');
      Q.SQL.Add('  , tp.cod_pessoa              as CodPessoaGestor               ');
      Q.SQL.Add('  , tp.nom_pessoa              as NomGestor                     ');
      Q.SQL.Add('  , tp.nom_reduzido_pessoa     as NomReduzidoGestor             ');
      Q.SQL.Add('  , tt.dta_efetivacao_cadastro as DtaEfetivacaoCadastroTecnico  ');
      Q.SQL.Add('  , tt.ind_efetivado_uma_vez   as IndEfetivadoUmaVezTecnico     ');
      Q.SQL.Add('  , tt.ind_tecnico_ativo       as IndTecnicoAtivo               ');
      Q.SQL.Add('from                                                            ');
      Q.SQL.Add('    tab_tecnico tt                                              ');
      Q.SQL.Add('  , tab_grau_instrucao tgi                                      ');
      Q.SQL.Add('  , tab_pessoa tp                                               ');
      Q.SQL.Add('where                                                           ');
      Q.SQL.Add('  tt.cod_pessoa_tecnico = :cod_pessoa                           ');
      Q.SQL.Add('  and tp.cod_pessoa =* tt.cod_pessoa_gestor                     ');
      Q.SQL.Add('  and tgi.cod_grau_instrucao =* tt.cod_grau_instrucao           ');
      Q.SQL.Add('  and tt.dta_fim_validade is null                               ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
      Q.Open;
      if Q.IsEmpty then
      begin
        Self.CodGrauInstrucao              := 0;
        Self.DesGrauInstrucao              := '';
        Self.DesCursoSuperior              := '';
        Self.SglConselhoRegional           := '';
        Self.NumConselhoRegional           := '';
        Self.CodPessoaGestor               := 0;
        Self.NomGestor                     := '';
        Self.NomReduzidoGestor             := '';
        Self.DtaEfetivacaoCadastroTecnico  := 0;
        Self.IndEfetivadoUmaVezTecnico     := '';
        Self.IndTecnicoAtivo               := '';
      end
      else
      begin
        Self.CodGrauInstrucao              := Q.FieldByName('CodGrauInstrucao').AsInteger;
        Self.DesGrauInstrucao              := Q.FieldByName('DesGrauInstrucao').AsString;
        Self.DesCursoSuperior              := Q.FieldByName('DesCursoSuperior').AsString;
        Self.SglConselhoRegional           := Q.FieldByName('SglConselhoRegional').AsString;
        Self.NumConselhoRegional           := Q.FieldByName('NumConselhoRegional').AsString;
        Self.CodPessoaGestor               := Q.FieldByName('CodPessoaGestor').AsInteger;
        Self.NomGestor                     := Q.FieldByName('NomGestor').AsString;
        Self.NomReduzidoGestor             := Q.FieldByName('NomReduzidoGestor').AsString;
        Self.DtaEfetivacaoCadastroTecnico  := Q.FieldByName('DtaEfetivacaoCadastroTecnico').AsDateTime;
        Self.IndEfetivadoUmaVezTecnico     := Q.FieldByName('IndEfetivadoUmaVezTecnico').AsString;
        Self.IndTecnicoAtivo               := Q.FieldByName('IndTecnicoAtivo').AsString;
      end;

      // Retorna status "ok" do método
      Result := 0;
    except
      on E:Exception do begin
        Rollback;
        Mensagens.Adicionar(446, Self.ClassName, 'CarregaPropriedades', [E.Message]);
        Result := -446;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

end.
