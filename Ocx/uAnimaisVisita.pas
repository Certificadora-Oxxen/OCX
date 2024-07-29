// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 14/11/2002
// *  Documentação       : Anúnicio ded Banners - Definição das classes.doc
// *  Código Classe      : 72
// *  Descrição Resumida : Buscar dados do Animal Visita
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    14/11/2002    Criação
// *
// ********************************************************************

unit uAnimaisVisita;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uIntMensagens,uConexao,
  uIntAnimaisVisita, uAnimalVisita;

type
  TAnimaisVisita = class(TASPMTSObject, IAnimaisVisita)
  private
    FIntAnimaisVisita : TIntAnimaisVisita;
    FAnimalVisita : TAnimalVisita;
    FInicializado : Boolean;
  protected
    function Buscar(const CodAnimalSisbov: WideString): Integer; safecall;
    function EOF: WordBool; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    function Get_AnimalVisita: IAnimalVisita; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TAnimaisVisita.AfterConstruction;
begin
  inherited;
  FAnimalVisita := TAnimalVisita.Create;
  FAnimalVisita.ObjAddRef;
  FInicializado := False;
end;

procedure TAnimaisVisita.BeforeDestruction;
begin
  If FIntAnimaisVisita <> nil Then Begin
    FIntAnimaisVisita.Free;
  End;
  If FAnimalVisita <> nil Then Begin
    FAnimalVisita.ObjRelease;
    FAnimalVisita := nil;
  End;
  inherited;
end;

function TAnimaisVisita.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntAnimaisVisita := TIntAnimaisVisita.Create;
  Result := FIntAnimaisVisita.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TAnimaisVisita.Buscar(const CodAnimalSisbov: WideString): Integer;
begin
  result := FIntAnimaisVisita.Buscar(CodAnimalSisBov);
end;

function TAnimaisVisita.EOF: WordBool;
begin
  result := FIntAnimaisVisita.EOF;
end;

procedure TAnimaisVisita.IrAoPrimeiro;
begin
  FIntAnimaisVisita.IrAoPrimeiro;
end;

procedure TAnimaisVisita.IrAoProximo;
begin
  FIntAnimaisVisita.IrAoProximo;
end;

function TAnimaisVisita.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result := FIntAnimaisVisita.ValorCampo(NomCampo);
end;

function TAnimaisVisita.Get_AnimalVisita: IAnimalVisita;
begin
  FAnimalVisita.NomPessoaProdutor  := FIntAnimaisVisita.IntAnimalVisita.NomPessoaProdutor;
  FAnimalVisita.numCNPJCPFProdutorFormatado  := FIntAnimaisVisita.IntAnimalVisita.numCNPJCPFProdutorFormatado;
  FAnimalVisita.CodPessoaNatureza  := FIntAnimaisVisita.IntAnimalVisita.CodPessoaNatureza;

  FAnimalVisita.SglFazendaManejo := FIntAnimaisVisita.IntAnimalVisita.SglFazendaManejo;
  FAnimalVisita.CodAnimalManejo := FIntAnimaisVisita.IntAnimalVisita.CodAnimalManejo;
  FAnimalVisita.CodPaisSisbov := FIntAnimaisVisita.IntAnimalVisita.CodPaisSisbov;
  FAnimalVisita.CodEstadoSisbov := FIntAnimaisVisita.IntAnimalVisita.CodEstadoSisbov;
  FAnimalVisita.CodMicroRegiaoSisbov := FIntAnimaisVisita.IntAnimalVisita.CodMicroRegiaoSisbov;
  FAnimalVisita.CodAnimalSisbov := FIntAnimaisVisita.IntAnimalVisita.CodAnimalSisbov;
  FAnimalVisita.NumDVSisbov := FIntAnimaisVisita.IntAnimalVisita.NumDVSisbov;
  FAnimalVisita.NomAnimal := FIntAnimaisVisita.IntAnimalVisita.NomAnimal;
  FAnimalVisita.DesApelido := FIntAnimaisVisita.IntAnimalVisita.DesApelido;
  FAnimalVisita.DesRaca := FIntAnimaisVisita.IntAnimalVisita.DesRaca;
  FAnimalVisita.DesPelagem := FIntAnimaisVisita.IntAnimalVisita.DesPelagem;
  FAnimalVisita.IndSexo := FIntAnimaisVisita.IntAnimalVisita.IndSexo;
  FAnimalVisita.IndAnimalCastrado := FIntAnimaisVisita.IntAnimalVisita.IndAnimalCastrado;
  FAnimalVisita.SglAssociacaoRaca := FIntAnimaisVisita.IntAnimalVisita.SglAssociacaoRaca;
  FAnimalVisita.SglGrauSangue := FIntAnimaisVisita.IntAnimalVisita.SglGrauSangue;
  FAnimalVisita.NumRGD := FIntAnimaisVisita.IntAnimalVisita.NumRGD;
  FAnimalVisita.CodAnimalCertificadora := FIntAnimaisVisita.IntAnimalVisita.CodAnimalCertificadora;
  FAnimalVisita.DtaIdentificacaoSisbov := FIntAnimaisVisita.IntAnimalVisita.DtaIdentificacaoSisbov;
  FAnimalVisita.NumImovelIdentificacao := FIntAnimaisVisita.IntAnimalVisita.NumImovelIdentificacao;
  FAnimalVisita.NomPropriedadeIdentificacao := FIntAnimaisVisita.IntAnimalVisita.NomPropriedadeIdentificacao;
  FAnimalVisita.NomFazendaIdentificacao := FIntAnimaisVisita.IntAnimalVisita.NomFazendaIdentificacao;
  FAnimalVisita.NomMunicipioIdentificacao := FIntAnimaisVisita.IntAnimalVisita.NomMunicipioIdentificacao;
  FAnimalVisita.SglEstadoIdentificacao := FIntAnimaisVisita.IntAnimalVisita.SglEstadoIdentificacao;
  FAnimalVisita.NomArquivoImagemIdentificacao := FIntAnimaisVisita.IntAnimalVisita.NomArquivoImagemIdentificacao;
  FAnimalVisita.DtaNascimento := FIntAnimaisVisita.IntAnimalVisita.DtaNascimento;
  FAnimalVisita.NumImovelNascimento := FIntAnimaisVisita.IntAnimalVisita.NumImovelNascimento;
  FAnimalVisita.NomPropriedadeNascimento := FIntAnimaisVisita.IntAnimalVisita.NomPropriedadeNascimento;
  FAnimalVisita.NomFazendaNascimento := FIntAnimaisVisita.IntAnimalVisita.NomFazendaNascimento;
  FAnimalVisita.NomMunicipioNascimento := FIntAnimaisVisita.IntAnimalVisita.NomMunicipioNascimento;
  FAnimalVisita.SglEstadoNascimento := FIntAnimaisVisita.IntAnimalVisita.SglEstadoNascimento;
  FAnimalVisita.NomArquivoImagemNascimento := FIntAnimaisVisita.IntAnimalVisita.NomArquivoImagemNascimento;
  FAnimalVisita.DesEspecie := FIntAnimaisVisita.IntAnimalVisita.DesEspecie;
  FAnimalVisita.DesAptidao := FIntAnimaisVisita.IntAnimalVisita.DesAptidao;

  Result := FAnimalVisita;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAnimaisVisita, Class_AnimaisVisita,
    ciMultiInstance, tmApartment);
end.
