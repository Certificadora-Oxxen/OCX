unit uPessoas;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntPessoas, uIntMensagens,
  uConexao, uPessoa;

type
  TPessoas = class(TASPMTSObject, IPessoas)
  private
    FIntPessoas   : TIntPessoas;
    FInicializado : Boolean;
    FPessoa       : TPessoa;
  protected
    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(CodPessoa: Integer; const NomPessoa: WideString;
      CodPapel: Integer; const CodNaturezaPessoa, NumCNPJCPF, IndBloqueio,
      IndIncluirCertificadoraDonaSistema: WideString;
      IndPesquisarDesativados: WordBool; const SglProdutor, CodOrdenacao,
      IndCadastroEfetivado, IndExportadoSisbov,
      CodTipoAcessoNaoDesejado: WideString): Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function Inserir(const NomPessoa, NomReduzidoPessoa, CodNaturezaPessoa,
      NumCNPJCPF: WideString; DtaNascimento: TDateTime;
      const TxtObservacao: WideString; CodPapel: Integer;
      const SglProdutor: WideString; CodGrauInstrucao: Integer;
      const DesCursoSuperior, SglConselhoRegional,
      NumConselhoRegional: WideString; CodPessoaGestor: Integer;
      const Sexo, NumIE, OrgaoIE, UFIE: WideString;
      DtaExp: TDateTime): Integer; safecall;
    function Alterar(CodPessoa: Integer; const NomPessoa, NomReduzidoPessoa,
      NumCNPJCPF: WideString; DtaNascimento: TDateTime;
      const TxtObservacao, SglProdutor: WideString;
      CodGrauInstrucao: Integer; const DesCursoSuperior,
      SglConselhoRegional, NumConselhoRegional: WideString;
      CodPessoaGestor: Integer; const Sexo, NumIE, OrgaoIE,
      UFIE: WideString; DtaExp: TDateTime;
      const IndTecnicoAtivo: WideString): Integer; safecall;
    function Buscar(CodPessoa: Integer): Integer; safecall;
    function Excluir(CodPessoa: Integer): Integer; safecall;
    function AdicionarPapel(CodPessoa, CodPapel: Integer;
      const SglProdutor: WideString; CodGrauInstrucao: Integer;
      const DesCursoSuperior, SglConselhoRegional,
      NumConselhoRegional: WideString; CodPessoaGestor: Integer;
      const IndTecnicoAtivo: WideString): Integer; safecall;
    function RetirarPapel(CodPessoa, CodPapel: Integer): Integer; safecall;
    function PossuiPapel(CodPessoa, CodPapel: Integer): Integer; safecall;
    function EfetivarCadastro(CodPessoa: Integer): Integer; safecall;
    function CancelarEfetivacao(CodPessoa: Integer): Integer; safecall;
    function DefinirEndereco(CodPessoa, CodTipoEndereco: Integer;
      const NomLogradouro, NomBairro, NumCEP: WideString; CodPais,
      CodEstado, CodMunicipio, CodDistrito: Integer): Integer; safecall;
    function Get_Pessoa: IPessoa; safecall;
    function DefinirParametrosProdutor(QtdCaracteres: Integer;
      const IndConsultaPublica: WideString; CodTipoAgrupamentoRacas,
      QtdDenominadorCompRacial, QtdDiasEntreCoberturas,
      QtdDiasDescansoReprodutivo, QtdDiasDiagnosticoGestacao: Integer;
      const CodSituacaoSisBov: WideString; CodAptidao: Integer;
      const IndMostrarNome, IndMostrarIdentificadores,
      IndTransfereEmbrioes, IndMostrarFiltroCompRacial, IndEstacaoMonta,
      IndTrabalhaAssociacaoRaca: WideString; QtdIdadeMinimaDesmame,
      QtdIdadeMaximaDesmame: Integer;
      const IndAplicarDesmameAutomatico: WideString): Integer; safecall;
    function PesquisarAvancado(CodPessoa: Integer; const NomPessoa: WideString;
      CodPapel: Integer; const CodNaturezaPessoa, NumCNPJCPF, IndBloqueio,
      IndIncluirCertificadoraDonaSistema: WideString;
      IndPesquisarDesativados: WordBool; const SglProdutor, CodOrdenacao,
      IndCadastroEfetivado, IndExportadoSisbov,
      CodTipoAcessoNaoDesejado: WideString; CodEstado: Integer;
      const NomMunicipio, CodMicroRegiao, NomLogradouro: WideString;
      DiaNascimentoInicio, MesNascimentoInicio, DiaNascimentoFim,
      MesNascimentoFim: Integer): Integer; safecall;
    function GerarRelatorio(CodPessoa: Integer; const NomPessoa: WideString;
      CodPapel: Integer; const CodNaturezaPessoa, NumCNPJCPF, IndBloqueio,
      IndIncluirCertificadoraDonaSistema: WideString;
      IndPesquisarDesativados: WordBool; const SglProdutor, CodOrdenacao,
      IndCadastroEfetivado, IndExportadoSisbov,
      CodTipoAcessoNaoDesejado: WideString; CodEstado: Integer;
      const NomMunicipio, CodMicroRegiao, NomLogradouro: WideString;
      DiaNascimentoInicio, MesNascimentoInicio, DiaNascimentoFim,
      MesNascimentoFim, Tipo, QtdQuebraRelatorio: Integer): WideString;
      safecall;
    function PesquisarPorPropriedadeRural(
      CodPropriedadeRural: Integer): Integer; safecall;
    function LimparEndereco(CodPessoa: Integer): Integer; safecall;
    function PesquisarGestores(CodPessoaGestor: Integer): Integer; safecall;
    function ExcluirComentario(CodPessoa, CodComentario: Integer): Integer;
      safecall;
    function InserirComentario(CodPessoa: Integer; const TxtComentario: WideString): Integer; safecall;
    function PesquisarComentario(CodPessoa, CodComentario: Integer): Integer;
      safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ, uIntPessoa;

procedure TPessoas.AfterConstruction;
begin
  inherited;
  FPessoa := TPessoa.Create;
  FPessoa.ObjAddRef;
  FInicializado := False;
end;

procedure TPessoas.BeforeDestruction;
begin
  If FIntPessoas <> nil Then Begin
    FIntPessoas.Free;
  End;
  If FPessoa <> nil Then Begin
    FPessoa.ObjRelease;
    FPessoa := nil;
  End;
  inherited;
end;

function TPessoas.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPessoas := TIntPessoas.Create;
  Result := FIntPessoas.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TPessoas.BOF: WordBool;
begin
  Result := FIntPessoas.BOF;
end;

function TPessoas.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntPessoas.Deslocar(QtdRegistros);
end;

function TPessoas.EOF: WordBool;
begin
  Result := FIntPessoas.EOF;
end;

function TPessoas.NumeroRegistros: Integer;
begin
  Result := FIntPessoas.NumeroRegistros;
end;

function TPessoas.Pesquisar(CodPessoa: Integer;
  const NomPessoa: WideString; CodPapel: Integer; const CodNaturezaPessoa,
  NumCNPJCPF, IndBloqueio, IndIncluirCertificadoraDonaSistema: WideString;
  IndPesquisarDesativados: WordBool; const SglProdutor, CodOrdenacao,
  IndCadastroEfetivado, IndExportadoSisbov,
  CodTipoAcessoNaoDesejado: WideString): Integer;
begin
  Result := FIntPessoas.Pesquisar(CodPessoa, NomPessoa, CodPapel, CodNaturezaPessoa,
              NumCNPJCPF, IndBloqueio, IndIncluirCertificadoraDonaSistema,
              IndPesquisarDesativados, SglProdutor, CodOrdenacao,
              IndCadastroEfetivado, IndExportadoSisbov, CodTipoAcessoNaoDesejado);
end;

function TPessoas.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntPessoas.ValorCampo(NomeColuna);
end;

procedure TPessoas.FecharPesquisa;
begin
  FIntPessoas.FecharPesquisa;
end;

procedure TPessoas.IrAoAnterior;
begin
  FIntPessoas.IrAoAnterior;
end;

procedure TPessoas.IrAoPrimeiro;
begin
  FIntPessoas.IrAoPrimeiro;
end;

procedure TPessoas.IrAoProximo;
begin
  FIntPessoas.IrAoProximo;
end;

procedure TPessoas.IrAoUltimo;
begin
  FIntPessoas.IrAoUltimo;
end;

procedure TPessoas.Posicionar(NumRegistro: Integer);
begin
  FIntPessoas.Posicionar(NumRegistro);
end;

function TPessoas.Inserir(const NomPessoa, NomReduzidoPessoa,
  CodNaturezaPessoa, NumCNPJCPF: WideString; DtaNascimento: TDateTime;
  const TxtObservacao: WideString; CodPapel: Integer;
  const SglProdutor: WideString; CodGrauInstrucao: Integer;
  const DesCursoSuperior, SglConselhoRegional,
  NumConselhoRegional: WideString; CodPessoaGestor: Integer; const Sexo,
  NumIE, OrgaoIE, UFIE: WideString; DtaExp: TDateTime): Integer;
begin
  Result := FIntPessoas.Inserir(
              NomPessoa
              , NomReduzidoPessoa
              , CodNaturezaPessoa
              , NumCNPJCPF
              , DtaNascimento
              , TxtObservacao
              , CodPapel
              , SglProdutor
              , CodGrauInstrucao
              , DesCursoSuperior
              , SglConselhoRegional
              , NumConselhoRegional
              , CodPessoaGestor
              , Sexo
              , NumIE
              , OrgaoIE
              , UFIE
              , DtaExp);
end;

function TPessoas.Alterar(CodPessoa: Integer; const NomPessoa,
  NomReduzidoPessoa, NumCNPJCPF: WideString; DtaNascimento: TDateTime;
  const TxtObservacao, SglProdutor: WideString; CodGrauInstrucao: Integer;
  const DesCursoSuperior, SglConselhoRegional,
  NumConselhoRegional: WideString; CodPessoaGestor: Integer; const Sexo,
  NumIE, OrgaoIE, UFIE: WideString; DtaExp: TDateTime;
  const IndTecnicoAtivo: WideString): Integer;
begin
  Result := FIntPessoas.Alterar( CodPessoa
                               , NomPessoa
                               , NomReduzidoPessoa
                               , NumCNPJCPF
                               , DtaNascimento
                               , TxtObservacao
                               , SglProdutor
                               , CodGrauInstrucao
                               , DesCursoSuperior
                               , SglConselhoRegional
                               , NumConselhoRegional
                               , CodPessoaGestor
                               , Sexo
                               , NumIE
                               , OrgaoIE
                               , UFIE
                               , DtaExp
                               , IndTecnicoAtivo);
end;

function TPessoas.Buscar(CodPessoa: Integer): Integer;
begin
  Result := FIntPessoas.Buscar(CodPessoa);
end;

function TPessoas.Excluir(CodPessoa: Integer): Integer;
begin
  Result := FIntPessoas.Excluir(CodPessoa)
end;

function TPessoas.AdicionarPapel(CodPessoa, CodPapel: Integer;
  const SglProdutor: WideString; CodGrauInstrucao: Integer;
  const DesCursoSuperior, SglConselhoRegional,
  NumConselhoRegional: WideString; CodPessoaGestor: Integer;
  const IndTecnicoAtivo: WideString): Integer;
begin
  Result := FIntPessoas.AdicionarPapel( CodPessoa
                                      , CodPapel
                                      , SglProdutor
                                      , CodGrauInstrucao
                                      , DesCursoSuperior
                                      , SglConselhoRegional
                                      , NumConselhoRegional
                                      , CodPessoaGestor
                                      , IndTecnicoAtivo );
end;

function TPessoas.RetirarPapel(CodPessoa, CodPapel: Integer): Integer;
begin
  Result := FIntPessoas.RetirarPapel(CodPessoa, CodPapel);
end;

function TPessoas.PossuiPapel(CodPessoa, CodPapel: Integer): Integer;
begin
  Result := FIntPessoas.PossuiPapel(CodPessoa, CodPapel);
end;

function TPessoas.EfetivarCadastro(CodPessoa: Integer): Integer;
begin
  Result := FIntPessoas.EfetivarCadastro(CodPessoa);
end;

function TPessoas.CancelarEfetivacao(CodPessoa: Integer): Integer;
begin
  Result := FIntPessoas.CancelarEfetivacao(CodPessoa);
end;

function TPessoas.DefinirEndereco(CodPessoa, CodTipoEndereco: Integer;
  const NomLogradouro, NomBairro, NumCEP: WideString; CodPais, CodEstado,
  CodMunicipio, CodDistrito: Integer): Integer;
begin
  Result := FIntPessoas.DefinirEndereco(
              CodPessoa
              , CodTipoEndereco
              , NomLogradouro
              , NomBairro
              , NumCEP
              , CodPais
              , CodEstado
              , CodMunicipio
              , CodDistrito);
end;

function TPessoas.Get_Pessoa: IPessoa;
begin
  FPessoa.CodPessoa                    := FIntPessoas.IntPessoa.CodPessoa;
  FPessoa.NomPessoa                    := FIntPessoas.IntPessoa.NomPessoa;
  FPessoa.NomReduzidoPessoa            := FIntPessoas.IntPessoa.NomReduzidoPessoa;
  FPessoa.CodNaturezaPessoa            := FIntPessoas.IntPessoa.CodNaturezaPessoa;
  FPessoa.NumCNPJCPF                   := FIntPessoas.IntPessoa.NumCNPJCPF;
  FPessoa.NumCNPJCPFFormatado          := FIntPessoas.IntPessoa.NumCNPJCPFFormatado;
  FPessoa.DtaNascimento                := FIntPessoas.IntPessoa.DtaNascimento;
  FPessoa.CodTelefonePrincipal         := FIntPessoas.IntPessoa.CodTelefonePrincipal;
  FPessoa.SglTelefonePrincipal         := FIntPessoas.IntPessoa.SglTelefonePrincipal;
  FPessoa.TxtTelefonePrincipal         := FIntPessoas.IntPessoa.TxtTelefonePrincipal;
  FPessoa.CodEMailPrincipal            := FIntPessoas.IntPessoa.CodEMailPrincipal;
  FPessoa.SglEMailPrincipal            := FIntPessoas.IntPessoa.SglEMailPrincipal;
  FPessoa.TxtEMailPrincipal            := FIntPessoas.IntPessoa.TxtEMailPrincipal;
  FPessoa.CodTipoEndereco              := FIntPessoas.IntPessoa.CodTipoEndereco;
  FPessoa.SglTipoEndereco              := FIntPessoas.IntPessoa.SglTipoEndereco;
  FPessoa.DesTipoEndereco              := FIntPessoas.IntPessoa.DesTipoEndereco;
  FPessoa.NomLogradouro                := FIntPessoas.IntPessoa.NomLogradouro;
  FPessoa.NomBairro                    := FIntPessoas.IntPessoa.NomBairro;
  FPessoa.NumCEP                       := FIntPessoas.IntPessoa.NumCEP;
  FPessoa.CodPais                      := FIntPessoas.IntPessoa.CodPais;
  FPessoa.NomPais                      := FIntPessoas.IntPessoa.NomPais;
  FPessoa.CodEstado                    := FIntPessoas.IntPessoa.CodEstado;
  FPessoa.SglEstado                    := FIntPessoas.IntPessoa.SglEstado;
  FPessoa.CodMunicipio                 := FIntPessoas.IntPessoa.CodMunicipio;
  FPessoa.NomMunicipio                 := FIntPessoas.IntPessoa.NomMunicipio;
  FPessoa.NumMunicipioIBGE             := FIntPessoas.IntPessoa.NumMunicipioIBGE;
  FPessoa.CodDistrito                  := FIntPessoas.IntPessoa.CodDistrito;
  FPessoa.NomDistrito                  := FIntPessoas.IntPessoa.NomDistrito;
  FPessoa.TxtObservacao                := FIntPessoas.IntPessoa.TxtObservacao;
  FPessoa.DtaCadastramento             := FIntPessoas.IntPessoa.DtaCadastramento;
  FPessoa.SglProdutor                  := FIntPessoas.IntPessoa.SglProdutor;
  FPessoa.IndProdutorBloqueado         := FIntPessoas.IntPessoa.IndProdutorBloqueado;
  FPessoa.DtaEfetivacaoCadastro        := FIntPessoas.IntPessoa.DtaEfetivacaoCadastro;
  FPessoa.CodGrauInstrucao             := FIntPessoas.IntPessoa.CodGrauInstrucao;
  FPessoa.DesGrauInstrucao             := FIntPessoas.IntPessoa.DesGrauInstrucao;
  FPessoa.DesCursoSuperior             := FIntPessoas.IntPessoa.DesCursoSuperior;
  FPessoa.SglConselhoRegional          := FIntPessoas.IntPessoa.SglConselhoRegional;
  FPessoa.NumConselhoRegional          := FIntPessoas.IntPessoa.NumConselhoRegional;
  FPessoa.IndEfetivadoUmaVez           := FIntPessoas.IntPessoa.IndEfetivadoUmaVez;
  FPessoa.CodPessoaGestor              := FIntPessoas.IntPessoa.CodPessoaGestor;
  FPessoa.NomGestor                    := FIntPessoas.IntPessoa.NomGestor;
  FPessoa.NomReduzidoGestor            := FIntPessoas.IntPessoa.NomReduzidoGestor;
  FPessoa.Sexo                         := FIntPessoas.IntPessoa.Sexo;
  FPessoa.NumIE                        := FIntPessoas.IntPessoa.NumIE;
  FPessoa.OrgaoIE                      := FIntPessoas.IntPessoa.OrgaoIE;
  FPessoa.UFIE                         := FIntPessoas.IntPessoa.UFIE;
  FPessoa.DtaExp                       := FIntPessoas.IntPessoa.DtaExp;
  FPessoa.DtaEfetivacaoCadastroTecnico := FIntPessoas.IntPessoa.DtaEfetivacaoCadastroTecnico;
  FPessoa.IndEfetivadoUmaVezTecnico    := FIntPessoas.IntPessoa.IndEfetivadoUmaVezTecnico;
  FPessoa.IndTecnicoAtivo              := FIntPessoas.IntPessoa.IndTecnicoAtivo;

  Result := FPessoa;
end;

function TPessoas.DefinirParametrosProdutor(QtdCaracteres: Integer;
  const IndConsultaPublica: WideString; CodTipoAgrupamentoRacas,
  QtdDenominadorCompRacial, QtdDiasEntreCoberturas,
  QtdDiasDescansoReprodutivo, QtdDiasDiagnosticoGestacao: Integer;
  const CodSituacaoSisBov: WideString; CodAptidao: Integer;
  const IndMostrarNome, IndMostrarIdentificadores, IndTransfereEmbrioes,
  IndMostrarFiltroCompRacial, IndEstacaoMonta,
  IndTrabalhaAssociacaoRaca: WideString; QtdIdadeMinimaDesmame,
  QtdIdadeMaximaDesmame: Integer;
  const IndAplicarDesmameAutomatico: WideString): Integer;
begin
  Result := FIntPessoas.DefinirParametrosProdutor(QtdCaracteres,
  IndConsultaPublica, CodTipoAgrupamentoRacas, QtdDenominadorCompRacial,
  QtdDiasEntreCoberturas, QtdDiasDescansoReprodutivo, QtdDiasDiagnosticoGestacao,
  CodSituacaoSisBov, CodAptidao, IndMostrarNome, IndMostrarIdentificadores,
  IndTransfereEmbrioes, IndMostrarFiltroCompRacial, IndEstacaoMonta,
  IndTrabalhaAssociacaoRaca, QtdIdadeMinimaDesmame, QtdIdadeMaximaDesmame,
  IndAplicarDesmameAutomatico);
end;

function TPessoas.PesquisarAvancado(CodPessoa: Integer;
  const NomPessoa: WideString; CodPapel: Integer; const CodNaturezaPessoa,
  NumCNPJCPF, IndBloqueio, IndIncluirCertificadoraDonaSistema: WideString;
  IndPesquisarDesativados: WordBool; const SglProdutor, CodOrdenacao,
  IndCadastroEfetivado, IndExportadoSisbov,
  CodTipoAcessoNaoDesejado: WideString; CodEstado: Integer;
  const NomMunicipio, CodMicroRegiao, NomLogradouro: WideString;
  DiaNascimentoInicio, MesNascimentoInicio, DiaNascimentoFim,
  MesNascimentoFim: Integer): Integer;
begin
  Result := FIntPessoas.PesquisarAvancado(CodPessoa,
    NomPessoa, CodPapel, CodNaturezaPessoa, NumCNPJCPF, IndBloqueio,
    IndIncluirCertificadoraDonaSistema, IndPesquisarDesativados, SglProdutor,
    CodOrdenacao, IndCadastroEfetivado, IndExportadoSisbov,
    CodTipoAcessoNaoDesejado, CodEstado, NomMunicipio, CodMicroRegiao,
    NomLogradouro, DiaNascimentoInicio, MesNascimentoInicio, DiaNascimentoFim,
    MesNascimentoFim, False, '');
end;

function TPessoas.GerarRelatorio(CodPessoa: Integer;
  const NomPessoa: WideString; CodPapel: Integer; const CodNaturezaPessoa,
  NumCNPJCPF, IndBloqueio, IndIncluirCertificadoraDonaSistema: WideString;
  IndPesquisarDesativados: WordBool; const SglProdutor, CodOrdenacao,
  IndCadastroEfetivado, IndExportadoSisbov,
  CodTipoAcessoNaoDesejado: WideString; CodEstado: Integer;
  const NomMunicipio, CodMicroRegiao, NomLogradouro: WideString;
  DiaNascimentoInicio, MesNascimentoInicio, DiaNascimentoFim,
  MesNascimentoFim, Tipo, QtdQuebraRelatorio: Integer): WideString;
begin
  Result := FIntPessoas.GerarRelatorio(CodPessoa, NomPessoa, CodPapel,
    CodNaturezaPessoa, NumCNPJCPF, IndBloqueio,
    IndIncluirCertificadoraDonaSistema, IndPesquisarDesativados, SglProdutor,
    CodOrdenacao, IndCadastroEfetivado, IndExportadoSisbov,
    CodTipoAcessoNaoDesejado, CodEstado, NomMunicipio, CodMicroRegiao,
    NomLogradouro, DiaNascimentoInicio, MesNascimentoInicio, DiaNascimentoFim,
    MesNascimentoFim, Tipo, QtdQuebraRelatorio);
end;

function TPessoas.PesquisarPorPropriedadeRural(
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntPessoas.PesquisarPorPropriedadeRural(CodPropriedadeRural);
end;

function TPessoas.LimparEndereco(CodPessoa: Integer): Integer;
begin
  Result := FIntPessoas.LimparEndereco(CodPessoa);
end;

function TPessoas.PesquisarGestores(CodPessoaGestor: Integer): Integer;
begin
  Result := FIntPessoas.PesquisarGestores(CodPessoaGestor);
end;

function TPessoas.ExcluirComentario(CodPessoa, CodComentario: Integer): Integer;
begin
  Result := FIntPessoas.ExcluirComentario(CodPessoa, CodComentario);
end;

function TPessoas.InserirComentario(CodPessoa: Integer;  const TxtComentario: WideString): Integer;
begin
  Result := FIntPessoas.InserirComentario(CodPessoa, TxtComentario);
end;

function TPessoas.PesquisarComentario(CodPessoa, CodComentario: Integer): Integer;
begin
  Result := FIntPessoas.PesquisarComentario(CodPessoa, CodComentario);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPessoas, Class_Pessoas,
    ciMultiInstance, tmApartment);
end.
