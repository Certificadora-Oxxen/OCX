unit uPropriedadesRurais;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uPropriedadeRural,
  uIntPropriedadesRurais, uIntPropriedadeRural;

type
  TPropriedadesRurais = class(TASPMTSObject, IPropriedadesRurais)
  private
    FIntPropriedadesRurais : TIntPropriedadesRurais;
    FInicializado : Boolean;
    FPropriedadeRural: TPropriedadeRural;

  protected
    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function Get_PropriedadeRural: IPropriedadeRural; safecall;
    function Pesquisar(CodPropriedadeRural: Integer; const NomPropriedadeRural,
      NumImovelReceitaFederal: WideString; CodLocalizacaoSISBOV: Integer;
      QtdAreaMinima, QtdAreaMaxima: Double; const NomMunicipio,
      NumMunicipioIBGE, NomMicroRegiao: WideString; CodMicroRegiaoSISBOV,
      CodEstado: Integer; const SglEstado: WideString; CodPais: Integer;
      const IndCadastroEfetivado, IndExportadoSisbov: WideString): Integer;
      safecall;
    function Inserir(const NomPropriedadeRural,
      NumImovelReceitaFederal: WideString; CodTipoInscricao, NumLatitude,
      NumLongitude: Integer; QtdArea: Double; const NomPessoaContato,
      NumTelefone, NumFax: WideString; DtaInicioCertificacao: TDateTime;
      const TxtObservacao, OrientLa, OrientLo: WideString;
      TipoPro: Integer): Integer; safecall;
    function Alterar(CodPropriedadeRural: Integer; const NomPropriedadeRural,
      NumImovelReceitaFederal: WideString; CodTipoInscricao, NumLatitude,
      NumLongitude: Integer; const QtdArea, NomPessoaContato, NumTelefone,
      NumFax: WideString; DtaInicioCertificacao: TDateTime;
      const TxtObservacao, OrientLa, OrientLo: WideString;
      TipoPro: Integer): Integer; safecall;
    function Excluir(CodPropriedadeRural: Integer): Integer; safecall;
    function Buscar(CodPropriedadeRural: Integer): Integer; safecall;
    function EfetivarCadastro(CodPropriedadeRural: Integer): Integer; safecall;
    function CancelarEfetivacao(CodPropriedadeRural: Integer): Integer;
      safecall;
    function DefinirEndereco(CodPropriedadeRural: Integer; const NomLogradouro,
      NomBairro, NumCEP: WideString; CodPais, CodEstado, CodMunicipio,
      CodDistrito: Integer): Integer; safecall;
    function DefinirEnderecoCorrespondencia(CodPropriedadeRural: Integer;
      const NomLogradouro, NomBairro, NumCEP: WideString; CodPais,
      CodEstado, CodMunicipio, CodDistrito: Integer): Integer; safecall;
    function LimparEndereco(CodPropriedadeRural: Integer): Integer; safecall;
    function LimparEnderecoCorrespondencia(
      CodPropriedadeRural: Integer): Integer; safecall;
    function PesquisarPropriedade(CodPessoaProdutor, CodEstado,
      CodPropriedadeRural: Integer;
      const NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov,
      CodFazenda: Integer): Integer; safecall;
    function PesquisarPorProdutor(CodPessoaProdutor: Integer): Integer;
      safecall;
    function DefinirProprietario(CodPropriedadeRural,
      CodProdutor: Integer): Integer; safecall;
    function ExcluirVistoria(CodVistoria: Integer): Integer; safecall;
    function InserirVistoria(CodPropriedadeRural, CodTecnico: Integer; DtaVistoria: TDateTime): Integer; safecall;
    function PesquisarVistoria(CodPropriedadeRural, CodTecnico: Integer; DtaVistoria: TDateTime): Integer; safecall;
    function ImprimirCertificado(CodPropriedadeRural: Integer): WideString;      safecall;
    function ConsultarSuspensao(CodPropriedadeRural: integer): integer; safecall;
    function SuspenderPropriedade(IdPropriedadeSisbov: Integer; IdMotivo: Integer;const Obs: WideString): Integer; safecall;
    function  IniciarVistoria(CodPropriedadeRural: integer; const dataAgendamento: WideString; CodTecnico: integer): integer;safecall;
    function ReagendarVistoria( CodPropriedadeRural: integer; const dataReAgendamento: WideString;  CodTecnico: integer;const Justificativa:WideString):integer;safecall;
    function LancarVistoria(CodPropriedadeRural: integer; const dataAgendamento: WideString):integer;safecall;
    function FinalizarVistoria(Cod_propriedade_rural: Integer;
      cancelar: WordBool): Integer; safecall;
    function EmitirParecerVistoria(CodPropriedadeRural:integer;const parecer:widestring):integer;safecall;
    function ConsultarVistorias(CodPropriedadeRural:integer;const DataVistoria:widestring):integer;safecall;
    function ProximaVistoria:integer;safecall;
    function VistoriaEof: WordBool; safecall;
    function ValorCampoVistoria(const NomeCampo:widestring):widestring;safecall;
    function IrAPrimeiraVistoria: Integer; safecall;

    function ConsultarQuestionarioVistoria(CodPropriedadeRural:integer;const DataVistoria:widestring):integer;safecall;
    function ProximoQuestionarioVistoria():integer;safecall;
    function IrAoPrimeiroQuestionarioVistoria():integer; safecall;
    function QuestionarioVistoriaEOF: WordBool; safecall;
    function ValorCampoQuestionarioVistoria(Const NomeCampo:widestring):widestring;safecall;
    function GravarRespostaQuestionario(CodPropriedadeRural:integer;const DataVistoria:widestring;CodItemSISBOV:integer;const Resposta,Conformidade:widestring):integer;safecall;
    function InformarPeriodoDeConfinamento(CodPropriedadeRural: Integer;
      const DataInicioConfinamento, DataFimConfinamento: WideString;
       Cancelar: WordBool): Integer; safecall;
    function InformarPeriodoConfinamento2(CodPropriedadeRural: Integer;
      const DataInicioConfinamento, DataFimConfinamento: WideString;
      Cancelar: WordBool): Integer; safecall;
    function RecuperarCheckList(CodPropriedadeRural: Integer;
      const dataAgendamento: WideString): Integer; safecall;
    function InformarAjusteRebanho(CodPropriedadeRural: Integer): Integer;
      safecall;


  public

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TPropriedadesRurais.AfterConstruction;
begin
  inherited;
  FPropriedadeRural := TPropriedadeRural.Create;
  FPropriedadeRural.ObjAddRef;
  FInicializado := False;
end;

procedure TPropriedadesRurais.BeforeDestruction;
begin
  If FIntPropriedadesRurais <> nil Then Begin
    FIntPropriedadesRurais.Free;
  End;
  If FPropriedadeRural <> nil Then Begin
    FPropriedadeRural.ObjRelease;
    FPropriedadeRural := nil;
  End;
  inherited;
end;

function TPropriedadesRurais.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPropriedadesRurais := TIntPropriedadesRurais.Create;
  Result := FIntPropriedadesRurais.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TPropriedadesRurais.BOF: WordBool;
begin
  Result := FIntPropriedadesRurais.BOF;
end;

function TPropriedadesRurais.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.Deslocar(QtdRegistros);
end;

function TPropriedadesRurais.EOF: WordBool;
begin
  Result := FIntPropriedadesRurais.EOF;
end;

function TPropriedadesRurais.NumeroRegistros: Integer;
begin
  Result := FIntPropriedadesRurais.NumeroRegistros;
end;

function TPropriedadesRurais.ValorCampo(
  const NomeColuna: WideString): OleVariant;
begin
  Result := FIntPropriedadesRurais.ValorCampo(NomeColuna);
end;

procedure TPropriedadesRurais.FecharPesquisa;
begin
  FIntPropriedadesRurais.FecharPesquisa;
end;

procedure TPropriedadesRurais.IrAoAnterior;
begin
  FIntPropriedadesRurais.IrAoAnterior;
end;

procedure TPropriedadesRurais.IrAoPrimeiro;
begin
  FIntPropriedadesRurais.IrAoPrimeiro;
end;

procedure TPropriedadesRurais.IrAoProximo;
begin
  FIntPropriedadesRurais.IrAoProximo;
end;

procedure TPropriedadesRurais.IrAoUltimo;
begin
  FIntPropriedadesRurais.IrAoUltimo;
end;

procedure TPropriedadesRurais.Posicionar(NumRegistro: Integer);
begin
  FIntPropriedadesRurais.Posicionar(NumRegistro);
end;

function TPropriedadesRurais.Get_PropriedadeRural: IPropriedadeRural;
begin
  FPropriedadeRural.CodPropriedadeRural := FIntPropriedadesRurais.IntPropriedadeRural.CodPropriedadeRural;
  FPropriedadeRural.NomPropriedadeRural := FIntPropriedadesRurais.IntPropriedadeRural.NomPropriedadeRural;
  FPropriedadeRural.NumImovelReceitaFederal := FIntPropriedadesRurais.IntPropriedadeRural.NumImovelReceitaFederal;
  FPropriedadeRural.CodTipoInscricao := FIntPropriedadesRurais.IntPropriedadeRural.CodTipoInscricao;
  FPropriedadeRural.NumLatitude := FIntPropriedadesRurais.IntPropriedadeRural.NumLatitude;
  FPropriedadeRural.NumLongitude := FIntPropriedadesRurais.IntPropriedadeRural.NumLongitude;
  FPropriedadeRural.QtdArea := FIntPropriedadesRurais.IntPropriedadeRural.QtdArea;
  FPropriedadeRural.NomLogradouro := FIntPropriedadesRurais.IntPropriedadeRural.NomLogradouro;
  FPropriedadeRural.NomBairro := FIntPropriedadesRurais.IntPropriedadeRural.NomBairro;
  FPropriedadeRural.NumCEP := FIntPropriedadesRurais.IntPropriedadeRural.NumCEP;
  FPropriedadeRural.CodPais := FIntPropriedadesRurais.IntPropriedadeRural.CodPais;
  FPropriedadeRural.NomPais := FIntPropriedadesRurais.IntPropriedadeRural.NomPais;
  FPropriedadeRural.CodPaisSisbov := FIntPropriedadesRurais.IntPropriedadeRural.CodPaisSisbov;
  FPropriedadeRural.CodEstado := FIntPropriedadesRurais.IntPropriedadeRural.CodEstado;
  FPropriedadeRural.SglEstado := FIntPropriedadesRurais.IntPropriedadeRural.SglEstado;
  FPropriedadeRural.CodEstadoSisbov := FIntPropriedadesRurais.IntPropriedadeRural.CodEstadoSisbov;
  FPropriedadeRural.CodMicroRegiao := FIntPropriedadesRurais.IntPropriedadeRural.CodMicroRegiao;
  FPropriedadeRural.NomMicroRegiao := FIntPropriedadesRurais.IntPropriedadeRural.NomMicroRegiao;
  FPropriedadeRural.CodMicroRegiaoSisbov := FIntPropriedadesRurais.IntPropriedadeRural.CodMicroRegiaoSisbov;
  FPropriedadeRural.CodMunicipio := FIntPropriedadesRurais.IntPropriedadeRural.CodMunicipio;
  FPropriedadeRural.NomMunicipio := FIntPropriedadesRurais.IntPropriedadeRural.NomMunicipio;
  FPropriedadeRural.CodDistrito := FIntPropriedadesRurais.IntPropriedadeRural.CodDistrito;
  FPropriedadeRural.NomDistrito := FIntPropriedadesRurais.IntPropriedadeRural.NomDistrito;
  FPropriedadeRural.NomPessoaContato := FIntPropriedadesRurais.IntPropriedadeRural.NomPessoaContato;
  FPropriedadeRural.NumTelefone := FIntPropriedadesRurais.IntPropriedadeRural.NumTelefone;
  FPropriedadeRural.NumFax := FIntPropriedadesRurais.IntPropriedadeRural.NumFax;
  FPropriedadeRural.NomLogradouroCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.NomLogradouroCorrespondencia;
  FPropriedadeRural.NomBairroCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.NomBairroCorrespondencia;
  FPropriedadeRural.NumCEPCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.NumCEPCorrespondencia;
  FPropriedadeRural.CodPaisCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.CodPaisCorrespondencia;
  FPropriedadeRural.NomPaisCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.NomPaisCorrespondencia;
  FPropriedadeRural.CodPaisSisbovCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.CodPaisSisbovCorrespondencia;
  FPropriedadeRural.CodEstadoCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.CodEstadoCorrespondencia;
  FPropriedadeRural.SglEstadoCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.SglEstadoCorrespondencia;
  FPropriedadeRural.CodEstadoSisbovCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.CodEstadoSisbovCorrespondencia;
  FPropriedadeRural.CodMunicipioCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.CodMunicipioCorrespondencia;
  FPropriedadeRural.NomMunicipioCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.NomMunicipioCorrespondencia;
  FPropriedadeRural.CodDistritoCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.CodDistritoCorrespondencia;
  FPropriedadeRural.NomDistritoCorrespondencia := FIntPropriedadesRurais.IntPropriedadeRural.NomDistritoCorrespondencia;
  FPropriedadeRural.DtaInicioCertificacao := FIntPropriedadesRurais.IntPropriedadeRural.DtaInicioCertificacao;
  FPropriedadeRural.DtaCadastramento := FIntPropriedadesRurais.IntPropriedadeRural.DtaCadastramento;
  FPropriedadeRural.DtaEfetivacaoCadastro := FIntPropriedadesRurais.IntPropriedadeRural.DtaEfetivacaoCadastro;
  FPropriedadeRural.TxtObservacao := FIntPropriedadesRurais.IntPropriedadeRural.TxtObservacao;
  FPropriedadeRural.IndEfetivadoUmaVez := FIntPropriedadesRurais.IntPropriedadeRural.IndEfetivadoUmaVez;
  FPropriedadeRural.OrientacaoLat := FIntPropriedadesRurais.IntPropriedadeRural.OrientacaoLat;
  FPropriedadeRural.OrientacaoLon := FIntPropriedadesRurais.IntPropriedadeRural.OrientacaoLon;
  FPropriedadeRural.CodPessoaProprietario := FIntPropriedadesRurais.IntPropriedadeRural.CodPessoaProprietario;
  FPropriedadeRural.NomPessoaProprietario := FIntPropriedadesRurais.IntPropriedadeRural.NomPessoaProprietario;
  FPropriedadeRural.CodNaturezaPessoaProp := FIntPropriedadesRurais.IntPropriedadeRural.CodNaturezaPessoaProp;
  FPropriedadeRural.NumCNPJCPFFormatadoProp := FIntPropriedadesRurais.IntPropriedadeRural.NumCNPJCPFFormatadoProp;
  FPropriedadeRural.CodTipoPropriedadeRural := FIntPropriedadesRurais.IntPropriedadeRural.CodTipoPropriedadeRural;
  FPropriedadeRural.DesTipoPropriedadeRural := FIntPropriedadesRurais.IntPropriedadeRural.DesTipoPropriedadeRural;
  FPropriedadeRural.CodIdPropriedadeSisbov := FIntPropriedadesRurais.IntPropriedadeRural.CodIdPropriedadeSisbov;
  FPropriedadeRural.DtaInicioConfinamento  := FIntPropriedadesRurais.IntPropriedadeRural.DtaInicioConfinamento;
  FPropriedadeRural.DtaFimConfinamento  := FIntPropriedadesRurais.IntPropriedadeRural.DtaFimConfinamento;
  FPropriedadeRural.DtaInicioPeriodoAjusteRebanho :=  FIntPropriedadesRurais.IntPropriedadeRural.DtaInicioPeriodoAjusteRebanho;


  Result := FPropriedadeRural;
end;

function TPropriedadesRurais.Pesquisar(CodPropriedadeRural: Integer;
  const NomPropriedadeRural, NumImovelReceitaFederal: WideString;
  CodLocalizacaoSISBOV: Integer; QtdAreaMinima, QtdAreaMaxima: Double;
  const NomMunicipio, NumMunicipioIBGE, NomMicroRegiao: WideString;
  CodMicroRegiaoSISBOV, CodEstado: Integer; const SglEstado: WideString;
  CodPais: Integer; const IndCadastroEfetivado,
  IndExportadoSisbov: WideString): Integer;
begin
  Result := FIntPropriedadesRurais.Pesquisar(CodPropriedadeRural,
    NomPropriedadeRural, NumImovelReceitaFederal, CodLocalizacaoSisbov, QtdAreaMinima, QtdAreaMaxima,
    NomMunicipio, NumMunicipioIBGE, NomMicroRegiao,
    CodMicroRegiaoSisbov, CodEstado, SglEstado, CodPais, IndCadastroEfetivado, IndExportadoSisbov);
end;

function TPropriedadesRurais.Inserir(const NomPropriedadeRural,
  NumImovelReceitaFederal: WideString; CodTipoInscricao, NumLatitude,
  NumLongitude: Integer; QtdArea: Double; const NomPessoaContato,
  NumTelefone, NumFax: WideString; DtaInicioCertificacao: TDateTime;
  const TxtObservacao, OrientLa, OrientLo: WideString;
  TipoPro: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.Inserir(NomPropriedadeRural, NumImovelReceitaFederal, CodTipoInscricao, NumLatitude,
    NumLongitude, QtdArea, NomPessoaContato, NumTelefone, NumFax, DtaInicioCertificacao, TxtObservacao, OrientLa, OrientLo, TipoPro);
end;

function TPropriedadesRurais.Alterar(CodPropriedadeRural: Integer;
  const NomPropriedadeRural, NumImovelReceitaFederal: WideString;
  CodTipoInscricao, NumLatitude, NumLongitude: Integer; const QtdArea,
  NomPessoaContato, NumTelefone, NumFax: WideString;
  DtaInicioCertificacao: TDateTime; const TxtObservacao, OrientLa,
  OrientLo: WideString; TipoPro: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.Alterar(CodPropriedadeRural, NomPropriedadeRural,
    NumImovelReceitaFederal, CodTipoInscricao, NumLatitude, NumLongitude, QtdArea,
    NomPessoaContato, NumTelefone, NumFax, DtaInicioCertificacao, TxtObservacao, OrientLa, OrientLo, TipoPro);
end;

function TPropriedadesRurais.Excluir(
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.Excluir(CodPropriedadeRural);
end;

function TPropriedadesRurais.Buscar(CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.Buscar(CodPropriedadeRural);
end;

function TPropriedadesRurais.EfetivarCadastro(
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.EfetivarCadastro(CodPropriedadeRural);
end;

function TPropriedadesRurais.CancelarEfetivacao(
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.CancelarEfetivacao(CodPropriedadeRural);
end;

function TPropriedadesRurais.DefinirEndereco(CodPropriedadeRural: Integer;
  const NomLogradouro, NomBairro, NumCEP: WideString; CodPais, CodEstado,
  CodMunicipio, CodDistrito: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.DefinirEndereco(CodPropriedadeRural, NomLogradouro,
    NomBairro, NumCEP, CodPais, CodEstado, CodMunicipio, CodDistrito);
end;

function TPropriedadesRurais.DefinirEnderecoCorrespondencia(
  CodPropriedadeRural: Integer; const NomLogradouro, NomBairro,
  NumCEP: WideString; CodPais, CodEstado, CodMunicipio,
  CodDistrito: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.DefinirEnderecoCorrespondencia(CodPropriedadeRural, NomLogradouro,
    NomBairro, NumCEP, CodPais, CodEstado, CodMunicipio, CodDistrito);
end;

function TPropriedadesRurais.LimparEndereco(
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.LimparEndereco(CodPropriedadeRural);
end;

function TPropriedadesRurais.LimparEnderecoCorrespondencia(
  CodPropriedadeRural: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.LimparEnderecoCorrespondencia(CodPropriedadeRural);
end;

function TPropriedadesRurais.PesquisarPropriedade(CodPessoaProdutor,
  CodEstado, CodPropriedadeRural: Integer;
  const NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov,
  CodFazenda: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.PesquisarPropriedade(CodPessoaProdutor,
          CodEstado, CodPropriedadeRural, NumImovelReceitaFederal, CodLocalizacaoSisbov, CodFazenda);
end;

function TPropriedadesRurais.PesquisarPorProdutor(
  CodPessoaProdutor: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.PesquisarPorProdutor(CodPessoaProdutor);
end;

function TPropriedadesRurais.DefinirProprietario(CodPropriedadeRural,
  CodProdutor: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.DefinirProprietario(CodPropriedadeRural, CodProdutor);
end;

function TPropriedadesRurais.ExcluirVistoria(CodVistoria: Integer): Integer;
begin
  Result := FIntPropriedadesRurais.ExcluirVistoria(CodVistoria);
end;

function TPropriedadesRurais.InserirVistoria(CodPropriedadeRural, CodTecnico: Integer; DtaVistoria: TDateTime): Integer;
begin
  Result := FIntPropriedadesRurais.InserirVistoria(CodPropriedadeRural, CodTecnico, DtaVistoria);
end;

function TPropriedadesRurais.PesquisarVistoria(CodPropriedadeRural, CodTecnico: Integer; DtaVistoria: TDateTime): Integer;
begin
  Result := FIntPropriedadesRurais.PesquisarVistoria(CodPropriedadeRural, CodTecnico, DtaVistoria);
end;

function TPropriedadesRurais.ImprimirCertificado(
  CodPropriedadeRural: Integer): WideString;
begin
  Result := FIntPropriedadesRurais.ImprimirCertificado(CodPropriedadeRural);
end;

function TPropriedadesRurais.ConsultarSuspensao(
  CodPropriedadeRural: integer): integer;
begin
  result  :=  FIntPropriedadesRurais.ConsultarSuspensao(CodPropriedadeRural);
end;

function TPropriedadesRurais.suspenderPropriedade(IdPropriedadeSisbov,
  IdMotivo: integer; const Obs: widestring): integer;
begin
  result  :=  FIntPropriedadesRurais.SuspenderPropriedade(IdPropriedadeSisbov,IdMotivo,Obs);
end;

function TPropriedadesRurais.iniciarVistoria(CodPropriedadeRural: integer;
  const dataAgendamento: WideString; CodTecnico: integer): integer;
begin
  result  :=  FIntPropriedadesRurais.iniciarVistoria(CodPropriedadeRural,dataAgendamento,CodTecnico);
end;

function TPropriedadesRurais.ReagendarVistoria(
  CodPropriedadeRural: integer; const dataReAgendamento: WideString;
  CodTecnico: integer; const Justificativa: WideString): integer;
begin
  result  :=  FIntPropriedadesRurais.ReagendarVistoria(CodPropriedadeRural,dataReAgendamento,CodTecnico,Justificativa);
end;

function TPropriedadesRurais.LancarVistoria(CodPropriedadeRural: integer;
  const dataAgendamento: WideString): integer;
begin
   result :=  FIntPropriedadesRurais.LancarVistoria(CodPropriedadeRural,dataAgendamento);
end;

function TPropriedadesRurais.FinalizarVistoria(
  Cod_propriedade_rural: Integer; cancelar: WordBool): Integer;        
begin
  result  :=  FIntPropriedadesRurais.FinalizarVistoria(cod_propriedade_rural,cancelar);
end;

function TPropriedadesRurais.ConsultarVistorias(
  CodPropriedadeRural: integer; const DataVistoria: widestring): integer;
begin
  result  :=  FIntPropriedadesRurais.ConsultarVistorias(CodPropriedadeRural,DataVistoria);
end;

function TPropriedadesRurais.ProximaVistoria: integer;
begin
  result  :=  FIntPropriedadesRurais.ProximaVistoria;
end;

function TPropriedadesRurais.ValorCampoVistoria(
  const NomeCampo: widestring): widestring;
begin
  result  :=  FIntPropriedadesRurais.ValorCampoVistoria(NomeCampo);
end;

function TPropriedadesRurais.VistoriaEof: WordBool;
begin
  result  :=  FIntPropriedadesRurais.VistoriaEof;
end;

function TPropriedadesRurais.IrAPrimeiraVistoria: Integer;
begin
  result  :=  FIntPropriedadesRurais.IrAPrimeiraVistoria;
end;

function TPropriedadesRurais.IrAoPrimeiroQuestionarioVistoria: integer;
begin
  result  :=  FIntPropriedadesRurais.IrAoPrimeiroQuestionarioVistoria
end;

function TPropriedadesRurais.ProximoQuestionarioVistoria: integer;
begin
  result  :=  FIntPropriedadesRurais.ProximoQuestionarioVistoria;
end;

function TPropriedadesRurais.QuestionarioVistoriaEOF: WordBool;
begin
  result  :=  FIntPropriedadesRurais.QuestionarioVistoriaEOF;
end;

function TPropriedadesRurais.ValorCampoQuestionarioVistoria(
  const NomeCampo: widestring): widestring;
begin
  result  :=  FIntPropriedadesRurais.ValorCampoQuestionarioVistoria(NomeCampo);
end;

function TPropriedadesRurais.ConsultarQuestionarioVistoria(
  CodPropriedadeRural: integer; const DataVistoria: widestring): integer;
begin
  result  :=  FIntPropriedadesRurais.ConsultarQuestionarioVistoria(CodPropriedadeRural,DataVistoria);
end;

function TPropriedadesRurais.EmitirParecerVistoria(
  CodPropriedadeRural: integer; const parecer: widestring): integer;
begin
  result  :=  FIntPropriedadesRurais.EmitirParecerVistoria(CodPropriedadeRural,parecer);
end;

function TPropriedadesRurais.GravarRespostaQuestionario(
  CodPropriedadeRural: integer; const DataVistoria: widestring;
  CodItemSISBOV: integer; const Resposta, Conformidade: widestring): integer;
begin
  result  :=  FIntPropriedadesRurais.GravarRespostaQuestionario(CodPropriedadeRural,DataVistoria,CodItemSISBOV,Resposta,Conformidade);
end;

//------------------------------------------------------------------------------
//Essa Rotina está obsoleta, usar a informarPeriodoDeConfinamento2
//------------------------------------------------------------------------------
function TPropriedadesRurais.InformarPeriodoDeConfinamento(
  CodPropriedadeRural: Integer; const DataInicioConfinamento,
  DataFimConfinamento: WideString;  Cancelar: WordBool): Integer;
begin
  result  :=  FIntPropriedadesRurais.InformarPeriodoDeConfinamento(CodPropriedadeRural,DataInicioConfinamento,DataFimConfinamento,cancelar);
end;

function TPropriedadesRurais.InformarPeriodoConfinamento2(
  CodPropriedadeRural: Integer; const DataInicioConfinamento,
  DataFimConfinamento: WideString; Cancelar: WordBool): Integer;
begin
  result  :=  FIntPropriedadesRurais.informarPeriodoDeConfinamento2(CodPropriedadeRural,DataInicioConfinamento,DataFimConfinamento,Cancelar);
end;

function TPropriedadesRurais.RecuperarCheckList(
  CodPropriedadeRural: Integer;
  const dataAgendamento: WideString): Integer;
begin
  result  :=  FIntPropriedadesRurais.RecuperarCheckList(CodPropriedadeRural,dataAgendamento);
end;

function TPropriedadesRurais.InformarAjusteRebanho(
  CodPropriedadeRural: Integer): Integer;
begin
  result  :=  FIntPropriedadesRurais.InformarAjusteRebanho(CodPropriedadeRural);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPropriedadesRurais, Class_PropriedadesRurais,
    ciMultiInstance, tmApartment);
end.
