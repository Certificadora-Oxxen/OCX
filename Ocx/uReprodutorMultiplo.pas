// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 27/11/2002
// *  Documentação       : Animais - Definição das Classes
// *  Código Classe      : 73
// *  Descrição Resumida : Cadastro de Reprodutor Multiplo
// ********************************************************************
// *  Últimas Alterações
// *  Hitalo   27/11/2002  criacao
// *
// ********************************************************************
unit uReprodutorMultiplo;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TReprodutorMultiplo = class(TASPMTSObject, IReprodutorMultiplo)
  private
    FCodPessoaProdutor:Integer;
    FCodReprodutorMultiplo :Integer;
    FCodFazendaManejo : Integer;
    FSglFazendaManejo : WideString;
    FNomFazendaManejo : WideString;
    FCodReprodutorMultiploManejo : WideString;
    FCodEspecie : Integer;
    FSglEspecie : WideString;
    FDesEspecie : WideString;
    FTxtObservacao :  WideString;
    FIndAtivo : WideString;
    FDtaCadastramento : TDateTime;
  protected
    function Get_CodFazendaManejo: Integer; safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_CodReprodutorMultiplo: Integer; safecall;
    function Get_NomFazendaManejo: WideString; safecall;
    function Get_SglFazendaManejo: WideString; safecall;
    procedure Set_CodFazendaManejo(Value: Integer); safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_CodReprodutorMultiplo(Value: Integer); safecall;
    procedure Set_NomFazendaManejo(const Value: WideString); safecall;
    procedure Set_SglFazendaManejo(const Value: WideString); safecall;
    function Get_CodReprodutorMultiploManejo: WideString; safecall;
    procedure Set_CodReprodutorMultiploManejo(const Value: WideString);
      safecall;
    function Get_CodEspecie: Integer; safecall;
    function Get_DesEspecie: WideString; safecall;
    function Get_SglEspecie: WideString; safecall;
    procedure Set_CodEspecie(Value: Integer); safecall;
    procedure Set_DesEspecie(const Value: WideString); safecall;
    procedure Set_SglEspecie(const Value: WideString); safecall;
    function Get_TxtObservacao: WideString; safecall;
    procedure Set_TxtObservacao(const Value: WideString); safecall;
    function Get_IndAtivo: WideString; safecall;
    procedure Set_IndAtivo(const Value: WideString); safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    procedure Set_DtaCadastramento(Value: TDateTime); safecall;
  public
    property     CodPessoaProdutor              :Integer     read FCodPessoaProdutor               write FCodPessoaProdutor;
    property     CodReprodutorMultiplo          :Integer     read FCodReprodutorMultiplo           write FCodReprodutorMultiplo;
    property     CodFazendaManejo               :Integer     read FCodFazendaManejo                write FCodFazendaManejo;
    property     SglFazendaManejo               :WideString  read FSglFazendaManejo                write FSglFazendaManejo;
    property     NomFazendaManejo               :WideString  read FNomFazendaManejo                write FNomFazendaManejo;
    property     CodReprodutorMultiploManejo    :WideString  read FCodReprodutorMultiploManejo     write FCodReprodutorMultiploManejo;
    property     CodEspecie                     :Integer     read FCodEspecie                      write FCodEspecie;
    property     SglEspecie                     :WideString  read FSglEspecie                      write FSglEspecie;
    property     DesEspecie                     :WideString  read FDesEspecie                      write FDesEspecie;
    property     TxtObservacao                  :WideString  read FTxtObservacao                   write FTxtObservacao;
    property     IndAtivo                       :WideString  read FIndAtivo                        write FIndAtivo;
    property     DtaCadastramento               :TDateTime   read FDtaCadastramento                write FDtaCadastramento;
  end;

implementation

uses ComServ;

function TReprodutorMultiplo.Get_CodFazendaManejo: Integer;
begin
 result := FCodFazendaManejo ;
end;

function TReprodutorMultiplo.Get_CodPessoaProdutor: Integer;
begin
 result := FCodPessoaProdutor ;
end;

function TReprodutorMultiplo.Get_CodReprodutorMultiplo: Integer;
begin
 result := FCodReprodutorMultiplo;
end;

function TReprodutorMultiplo.Get_NomFazendaManejo: WideString;
begin
 result := FNomFazendaManejo;
end;

function TReprodutorMultiplo.Get_SglFazendaManejo: WideString;
begin
 result := FSglFazendaManejo ;
end;

procedure TReprodutorMultiplo.Set_CodFazendaManejo(Value: Integer);
begin
  FCodFazendaManejo := Value;
end;

procedure TReprodutorMultiplo.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

procedure TReprodutorMultiplo.Set_CodReprodutorMultiplo(Value: Integer);
begin
  FCodReprodutorMultiplo := Value;
end;

procedure TReprodutorMultiplo.Set_NomFazendaManejo(
  const Value: WideString);
begin
  FNomFazendaManejo := Value;
end;

procedure TReprodutorMultiplo.Set_SglFazendaManejo(
  const Value: WideString);
begin
  FSglFazendaManejo := Value;
end;

function TReprodutorMultiplo.Get_CodReprodutorMultiploManejo: WideString;
begin
 result := FCodReprodutorMultiploManejo ;
end;

procedure TReprodutorMultiplo.Set_CodReprodutorMultiploManejo(
  const Value: WideString);
begin
  FCodReprodutorMultiploManejo := Value;
end;

function TReprodutorMultiplo.Get_CodEspecie: Integer;
begin
 result := FCodEspecie ;
end;

function TReprodutorMultiplo.Get_DesEspecie: WideString;
begin
 result := FDesEspecie;
end;

function TReprodutorMultiplo.Get_SglEspecie: WideString;
begin
 result := FSglEspecie;
end;

procedure TReprodutorMultiplo.Set_CodEspecie(Value: Integer);
begin
  FCodEspecie := Value;
end;

procedure TReprodutorMultiplo.Set_DesEspecie(const Value: WideString);
begin
  FDesEspecie := Value;
end;

procedure TReprodutorMultiplo.Set_SglEspecie(const Value: WideString);
begin
  FSglEspecie := Value;
end;

function TReprodutorMultiplo.Get_TxtObservacao: WideString;
begin
 result := FTxtObservacao;
end;

procedure TReprodutorMultiplo.Set_TxtObservacao(const Value: WideString);
begin
  FTxtObservacao := Value;
end;

function TReprodutorMultiplo.Get_IndAtivo: WideString;
begin
 result := FIndAtivo;
end;

procedure TReprodutorMultiplo.Set_IndAtivo(const Value: WideString);
begin
  FIndAtivo := Value;
end;

function TReprodutorMultiplo.Get_DtaCadastramento: TDateTime;
begin
 result := FDtaCadastramento;
end;

procedure TReprodutorMultiplo.Set_DtaCadastramento(Value: TDateTime);
begin
  FDtaCadastramento := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TReprodutorMultiplo, Class_ReprodutorMultiplo,
    ciMultiInstance, tmApartment);
end.
