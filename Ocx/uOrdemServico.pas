unit uOrdemServico;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Boitata_TLB, StdVcl;

type
  TOrdemServico = class(TAutoObject, IOrdemServico)
  private
    FCodOrdemServico: Integer;
    FNumOrdemServico: Integer;
    FCodPessoaProdutor: Integer;
    FSglProdutor: String;
    FNomProdutor: String;
    FNumCNPJCPFProdutor: String;
    FCodPropriedadeRural: Integer;
    FNomPropriedadeRural: String;
    FNumImovelReceitaFederal: String;
    FCodPessoaTecnico: Integer;
    FNomTecnico: String;
    FNumCNPJCPFTecnico: String;
    FCodPessoaVendedor: Integer;
    FNomVendedor: String;
    FNumCNPJCPFVendedor: String;
    FQtdAnimais: Integer;
    FNumSolicitacaoSISBOV: Integer;
    FCodPaisSISBOVInicial: Integer;
    FCodEstadoSISBOVInicial: Integer;
    FCodMicroRegiaoSISBOVInicial: Integer;
    FCodAnimalSISBOVInicial: Integer;
    FNumDVSISBOVInicial: Integer;
    FCodFormaPagamentoOS: Integer;
    FDesFormaPagamentoOS: String;
    FEnderecoEntregaCert: IEndereco;
    FCodIdentificacaoDupla: Integer;
    FSglIdentificacaoDupla: String;
    FDesIdentificacaoDupla: String;
    FCodFabricanteIdentificador: Integer;
    FNomReduzidoFabricante: String;
    FCodformaPagamentoIdent: Integer;
    FDesFormaPagamentoIdent: String;
    FEnderecoEntregaIdent: IEndereco;
    FEnderecoCobrancaIdent: IEndereco;
    FCodModeloIdentificador1: Integer;
    FSglModeloIdentificador1: String;
    FDesModeloIdentificador1: String;
    FCodModeloIdentificador2: Integer;
    FSglModeloIdentificador2: String;
    FDesModeloIdentificador2: String;
    FCodProdutoAcessorio1: Integer;
    FSglProdutoAcessorio1: String;
    FDesProdutoAcessorio1: String;
    FQtdProdutoAcessorio1: Integer;
    FCodProdutoAcessorio2: Integer;
    FSglProdutoAcessorio2: String;
    FDesProdutoAcessorio2: String;
    FQtdProdutoAcessorio2: Integer;
    FCodProdutoAcessorio3: Integer;
    FSglProdutoAcessorio3: String;
    FDesProdutoAcessorio3: String;
    FQtdProdutoAcessorio3: Integer;
    FNumPedidoFabricante: Integer;
    FCodArquivoRemessaPedido: Integer;
    FNumRemessa: Integer;
    FDtaCadastramento: TDateTime;
    FCodUsuarioCadastramento: Integer;
    FNomUsuarioCadastramento: String;
    FDtaUltimaAlteracao: TDateTime;
    FCodUsuarioUltimaAlteracao: Integer;
    FNomUsuarioUltimaAlteracao: String;
    FCodSituacaoOS: Integer;
    FSglSituacaoOS: String;
    FDesSituacaoOS: String;
    FTxtObservacao: String;
    FNumCNPJCPFProdutorFormatado: String;
    FNumCNPJCPFTecnicoFormatado: String;
    FNumCNPJCPFVendedorFormatado: String;
    FIndEnviaPedidoIdentificador: String;
    FNomUsuarioPedido: String;
    FCodUsuarioPedido: Integer;
    FDtaPedido: TDateTime;
    FTxtObservacaoPedido: String;
    FIndAnimaisRegistrados: String;
    FDtaEnvio: TDateTime;
    FNomServicoEnvio: String;
    FNumConhecimento: String;
    FCodLocalizacaoSisbov: Integer;
    FCodBoleto: Integer;
    FIndTransmissaoSisbov: String;
  protected
    function Get_CodAnimalSISBOVInicial: Integer; safecall;
    function Get_CodArquivoRemessaPedido: Integer; safecall;
    function Get_CodEstadoSISBOVInicial: Integer; safecall;
    function Get_CodFabricanteIdentificador: Integer; safecall;
    function Get_CodFormaPagamentoIdent: Integer; safecall;
    function Get_CodFormaPagamentoOS: Integer; safecall;
    function Get_CodIdentificacaoDupla: Integer; safecall;
    function Get_CodMicroRegiaoSISBOVInicial: Integer; safecall;
    function Get_CodModeloIdentificador1: Integer; safecall;
    function Get_CodOrdemServico: Integer; safecall;
    function Get_CodPaisSISBOVInicial: Integer; safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_CodPessoaTecnico: Integer; safecall;
    function Get_CodPessoaVendedor: Integer; safecall;
    function Get_CodProdutoAcessorio1: Integer; safecall;
    function Get_CodProdutoAcessorio2: Integer; safecall;
    function Get_CodProdutoAcessorio3: Integer; safecall;
    function Get_CodPropriedadeRural: Integer; safecall;
    function Get_CodSituacaoOS: Integer; safecall;
    function Get_CodUsuarioCadastramento: Integer; safecall;
    function Get_CodUsuarioUltimaAlteracao: Integer; safecall;
    function Get_DesFormaPagamentoIdent: WideString; safecall;
    function Get_DesIdentificacaoDupla: WideString; safecall;
    function Get_DesModeloIdentificador1: WideString; safecall;
    function Get_DesModeloIdentificador2: WideString; safecall;
    function Get_DesProdutoAcessorio1: WideString; safecall;
    function Get_DesProdutoAcessorio2: WideString; safecall;
    function Get_DesProdutoAcessorio3: WideString; safecall;
    function Get_DesSituacaoOS: WideString; safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    function Get_DtaUltimaAlteracao: TDateTime; safecall;
    function Get_EnderecoCobrancaIdent: IEndereco; safecall;
    function Get_EnderecoEntregaCert: IEndereco; safecall;
    function Get_EnderecoentregaIdent: IEndereco; safecall;
    function Get_NomProdutor: WideString; safecall;
    function Get_NomPropriedadeRural: WideString; safecall;
    function Get_NomReduzidoFabricante: WideString; safecall;
    function Get_NomTecnico: WideString; safecall;
    function Get_NomUsuarioCadastramento: WideString; safecall;
    function Get_NomUsuarioUltimaAlteracao: WideString; safecall;
    function Get_NomVendedor: WideString; safecall;
    function Get_NumCNPJCPFProdutor: WideString; safecall;
    function Get_numCNPJCPFTecnico: WideString; safecall;
    function Get_NumCNPJCPFVendedor: WideString; safecall;
    function Get_NumDVSISBOVInicial: Integer; safecall;
    function Get_NumImovelReceitaFederal: WideString; safecall;
    function Get_NumPedidoFabricante: Integer; safecall;
    function Get_NumRemessa: Integer; safecall;
    function Get_NumSolicitacaoSISBOV: Integer; safecall;
    function Get_QtdAnimais: Integer; safecall;
    function Get_QtdProdutoAcessorio1: Integer; safecall;
    function Get_QtdProdutoAcessorio2: Integer; safecall;
    function Get_QtdProdutoAcessorio3: Integer; safecall;
    function Get_SglIdentificacaoDupla: WideString; safecall;
    function Get_SglModeloIdentificador2: WideString; safecall;
    function Get_SglProdutoAcessorio1: WideString; safecall;
    function Get_SglProdutoAcessorio2: WideString; safecall;
    function Get_SglProdutoAcessorio3: WideString; safecall;
    function Get_SglProdutor: WideString; safecall;
    function Get_SglSituacaoOS: WideString; safecall;
    function Get_TxtObservacao: WideString; safecall;
    function Get_CodModeloIdentificador2: Integer; safecall;
    function Get_SglModeloIdentificador1: WideString; safecall;
    function Get_DesFormaPagamentoOS: WideString; safecall;
    function Get_NumOrdemServico: Integer; safecall;
    function Get_NumCNPJCPFProdutorFormatado: WideString; safecall;
    function Get_NumCNPJCPFTecnicoFormatado: WideString; safecall;
    function Get_NumCNPJCPFVendedorFormatado: WideString; safecall;
    function Get_IndEnviaPedidoIdentificador: WideString; safecall;
    function Get_NomUsuarioPedido: WideString; safecall;
    function Get_CodUsuarioPedido: Integer; safecall;
    function Get_DtaPedido: TDateTime; safecall;
    function Get_TxtObservacaoPedido: WideString; safecall;
    function Get_IndAnimaisRegistrados: WideString; safecall;
    function Get_DtaEnvio: TDateTime; safecall;
    function Get_NomServicoEnvio: WideString; safecall;
    function Get_NumConhecimento: WideString; safecall;
    function Get_CodLocalizacaoSisbov: Integer; safecall;
    function Get_CodBoleto: Integer; safecall;
    function Get_IndTransmissaoSisbov: WideString; safecall;
  public
    property CodOrdemServico: Integer read FCodOrdemServico write FCodOrdemServico;
    property NumOrdemServico: Integer read FNumOrdemServico write FNumOrdemServico;
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property SglProdutor: String read FSglProdutor write FSglProdutor;
    property NomProdutor: String read FNomProdutor write FNomProdutor;
    property NumCNPJCPFProdutor: String read FNumCNPJCPFProdutor write FNumCNPJCPFProdutor;
    property CodPropriedadeRural: Integer read FCodPropriedadeRural write FCodPropriedadeRural;
    property NomPropriedadeRural: String read FNomPropriedadeRural write FNomPropriedadeRural;
    property NumImovelReceitaFederal: String read FNumImovelReceitaFederal write FNumImovelReceitaFederal;
    property CodPessoaTecnico: Integer read FCodPessoaTecnico write FCodPessoaTecnico;
    property NomTecnico: String read FNomTecnico write FNomTecnico;
    property NumCNPJCPFTecnico: String read FNumCNPJCPFTecnico write FNumCNPJCPFTecnico;
    property CodPessoaVendedor: Integer read FCodPessoaVendedor write FCodPessoaVendedor;
    property NomVendedor: String read FNomVendedor write FNomVendedor;
    property NumCNPJCPFVendedor: String read FNumCNPJCPFVendedor write FNumCNPJCPFVendedor;
    property QtdAnimais: Integer read FQtdAnimais write FQtdAnimais;
    property NumSolicitacaoSISBOV: Integer read FNumSolicitacaoSISBOV write FNumSolicitacaoSISBOV;
    property CodPaisSISBOVInicial: Integer read FCodPaisSISBOVInicial write FCodPaisSISBOVInicial;
    property CodEstadoSISBOVInicial: Integer read FCodEstadoSISBOVInicial write FCodEstadoSISBOVInicial;
    property CodMicroRegiaoSISBOVInicial: Integer read FCodMicroRegiaoSISBOVInicial write FCodMicroRegiaoSISBOVInicial;
    property CodAnimalSISBOVInicial: Integer read FCodAnimalSISBOVInicial write FCodAnimalSISBOVInicial;
    property NumDVSISBOVInicial: Integer read FNumDVSISBOVInicial write FNumDVSISBOVInicial;
    property CodFormaPagamentoOS: Integer read FCodFormaPagamentoOS write FCodFormaPagamentoOS;
    property DesFormaPagamentoOS: String read FDesFormaPagamentoOS write FDesFormaPagamentoOS;
    property EnderecoEntregaCert: IEndereco read FEnderecoEntregaCert write FEnderecoEntregaCert;
    property CodIdentificacaoDupla: Integer read FCodIdentificacaoDupla write FCodIdentificacaoDupla;
    property SglIdentificacaoDupla: String read FSglIdentificacaoDupla write FSglIdentificacaoDupla;
    property DesIdentificacaoDupla: String read FDesIdentificacaoDupla write FDesIdentificacaoDupla;
    property CodFabricanteIdentificador: Integer read FCodFabricanteIdentificador write FCodFabricanteIdentificador;
    property NomReduzidoFabricante: String read FNomReduzidoFabricante write FNomReduzidoFabricante;
    property CodformaPagamentoIdent: Integer read FCodformaPagamentoIdent write FCodformaPagamentoIdent;
    property DesFormaPagamentoIdent: String read FDesFormaPagamentoIdent write FDesFormaPagamentoIdent;
    property EnderecoEntregaIdent: IEndereco read FEnderecoEntregaIdent write FEnderecoEntregaIdent;
    property EnderecoCobrancaIdent: IEndereco read FEnderecoCobrancaIdent write FEnderecoCobrancaIdent;
    property CodModeloIdentificador1: Integer read FCodModeloIdentificador1 write FCodModeloIdentificador1;
    property SglModeloIdentificador1: String read FSglModeloIdentificador1 write FSglModeloIdentificador1;
    property DesModeloIdentificador1: String read FDesModeloIdentificador1 write FDesModeloIdentificador1;
    property CodModeloIdentificador2: Integer read FCodModeloIdentificador2 write FCodModeloIdentificador2;
    property SglModeloIdentificador2: String read FSglModeloIdentificador2 write FSglModeloIdentificador2;
    property DesModeloIdentificador2: String read FDesModeloIdentificador2 write FDesModeloIdentificador2;
    property CodProdutoAcessorio1: Integer read FCodProdutoAcessorio1 write FCodProdutoAcessorio1;
    property SglProdutoAcessorio1: String read FSglProdutoAcessorio1 write FSglProdutoAcessorio1;
    property DesProdutoAcessorio1: String read FDesProdutoAcessorio1 write FDesProdutoAcessorio1;
    property QtdProdutoAcessorio1: Integer read FQtdProdutoAcessorio1 write FQtdProdutoAcessorio1;
    property CodProdutoAcessorio2: Integer read FCodProdutoAcessorio2 write FCodProdutoAcessorio2;
    property SglProdutoAcessorio2: String read FSglProdutoAcessorio2 write FSglProdutoAcessorio2;
    property DesProdutoAcessorio2: String read FDesProdutoAcessorio2 write FDesProdutoAcessorio2;
    property QtdProdutoAcessorio2: Integer read FQtdProdutoAcessorio2 write FQtdProdutoAcessorio2;
    property CodProdutoAcessorio3: Integer read FCodProdutoAcessorio3 write FCodProdutoAcessorio3;
    property SglProdutoAcessorio3: String read FSglProdutoAcessorio3 write FSglProdutoAcessorio3;
    property DesProdutoAcessorio3: String read FDesProdutoAcessorio3 write FDesProdutoAcessorio3;
    property QtdProdutoAcessorio3: Integer read FQtdProdutoAcessorio3 write FQtdProdutoAcessorio3;
    property NumPedidoFabricante: Integer read FNumPedidoFabricante write FNumPedidoFabricante;
    property CodArquivoRemessaPedido: Integer read FCodArquivoRemessaPedido write FCodArquivoRemessaPedido;
    property NumRemessa: Integer read FNumRemessa write FNumRemessa;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property CodUsuarioCadastramento: Integer read FCodUsuarioCadastramento write FCodUsuarioCadastramento;
    property NomUsuarioCadastramento: String read FNomUsuariocadastramento write FNomUsuariocadastramento;
    property DtaUltimaAlteracao: TDateTime read FDtaUltimaAlteracao write FDtaUltimaAlteracao;
    property CodUsuarioUltimaAlteracao: Integer read FCodUsuarioUltimaAlteracao write FCodUsuarioUltimaAlteracao;
    property NomUsuarioUltimaAlteracao: String read FNomUsuarioUltimaAlteracao write FNomUsuarioUltimaAlteracao;
    property CodSituacaoOS: Integer read FCodSituacaoOS write FCodSituacaoOS;
    property SglSituacaoOS: String read FSglSituacaoOS write FSglSituacaoOS;
    property DesSituacaoOS: String read FDesSituacaoOS write FDesSituacaoOS;
    property TxtObservacao: String read FTxtObservacao write FTxtObservacao;
    property NumCNPJCPFProdutorFormatado: String read FNumCNPJCPFProdutorFormatado write FNumCNPJCPFProdutorFormatado;
    property NumCNPJCPFTecnicoFormatado: String read FNumCNPJCPFTecnicoFormatado write FNumCNPJCPFTecnicoFormatado;
    property NumCNPJCPFVendedorFormatado: String read FNumCNPJCPFVendedorFormatado write FNumCNPJCPFVendedorFormatado;
    property IndEnviaPedidoIdentificador: String read FIndEnviaPedidoIdentificador write FIndEnviaPedidoIdentificador;
    property NomUsuarioPedido: String read FNomUsuarioPedido write FNomUsuarioPedido;
    property CodUsuarioPedido: Integer read FCodUsuarioPedido write FCodUsuarioPedido;
    property DtaPedido: TDateTime read FDtaPedido write FDtaPedido;
    property TxtObservacaoPedido: String read FTxtObservacaoPedido write FTxtObservacaoPedido;
    property IndAnimaisRegistrados: String read FIndAnimaisRegistrados write FIndAnimaisRegistrados;
    property DtaEnvio: TDateTime read FDtaEnvio write FDtaEnvio;
    property NomServicoEnvio: String read FNomServicoEnvio write FNomServicoEnvio;
    property NumConhecimento: String read FNumConhecimento write FNumConhecimento;
    property CodLocalizacaoSisbov: Integer read FCodLocalizacaoSisbov write FCodLocalizacaoSisbov;
    property CodBoleto: Integer read FCodBoleto write FCodBoleto;
    property IndTransmissaoSisbov: String read FIndTransmissaoSisbov write FIndTransmissaoSisbov;
  end;

implementation

uses ComServ;

function TOrdemServico.Get_CodAnimalSISBOVInicial: Integer;
begin
  Result := FCodAnimalSISBOVInicial;
end;

function TOrdemServico.Get_CodArquivoRemessaPedido: Integer;
begin
  Result := FCodArquivoRemessaPedido;
end;

function TOrdemServico.Get_CodEstadoSISBOVInicial: Integer;
begin
  Result := FCodEstadoSISBOVInicial;
end;

function TOrdemServico.Get_CodFabricanteIdentificador: Integer;
begin
  Result := FCodFabricanteIdentificador;
end;

function TOrdemServico.Get_CodFormaPagamentoIdent: Integer;
begin
  Result := FCodformaPagamentoIdent;
end;

function TOrdemServico.Get_CodFormaPagamentoOS: Integer;
begin
  Result := FCodFormaPagamentoOS;
end;

function TOrdemServico.Get_CodIdentificacaoDupla: Integer;
begin
  Result := FCodIdentificacaoDupla;
end;

function TOrdemServico.Get_CodMicroRegiaoSISBOVInicial: Integer;
begin
  Result := FCodMicroRegiaoSISBOVInicial;
end;

function TOrdemServico.Get_CodModeloIdentificador1: Integer;
begin
  Result := FCodModeloIdentificador1;
end;

function TOrdemServico.Get_CodModeloIdentificador2: Integer;
begin
  Result := FCodModeloIdentificador2;
end;

function TOrdemServico.Get_CodOrdemServico: Integer;
begin
  Result := FCodOrdemServico;
end;

function TOrdemServico.Get_CodPaisSISBOVInicial: Integer;
begin
  Result := FCodPaisSISBOVInicial;
end;

function TOrdemServico.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

function TOrdemServico.Get_CodPessoaTecnico: Integer;
begin
  Result := FCodPessoaTecnico;
end;

function TOrdemServico.Get_CodPessoaVendedor: Integer;
begin
  Result := FCodPessoaVendedor;
end;

function TOrdemServico.Get_CodProdutoAcessorio1: Integer;
begin
  Result := FCodProdutoAcessorio1;
end;

function TOrdemServico.Get_CodProdutoAcessorio2: Integer;
begin
  Result := FCodProdutoAcessorio2;
end;

function TOrdemServico.Get_CodProdutoAcessorio3: Integer;
begin
  Result := FCodProdutoAcessorio3;
end;

function TOrdemServico.Get_CodPropriedadeRural: Integer;
begin
  Result := FCodPropriedadeRural;
end;

function TOrdemServico.Get_CodSituacaoOS: Integer;
begin
  Result := FCodSituacaoOS;
end;

function TOrdemServico.Get_CodUsuarioCadastramento: Integer;
begin
  Result := FCodUsuarioCadastramento;
end;

function TOrdemServico.Get_CodUsuarioPedido: Integer;
begin
  Result := FCodUsuarioPedido;
end;

function TOrdemServico.Get_CodUsuarioUltimaAlteracao: Integer;
begin
  Result := FCodUsuarioUltimaAlteracao;
end;

function TOrdemServico.Get_DesFormaPagamentoIdent: WideString;
begin
  Result := FDesFormaPagamentoIdent;
end;

function TOrdemServico.Get_DesFormaPagamentoOS: WideString;
begin
  Result := FDesFormaPagamentoOS;
end;

function TOrdemServico.Get_DesIdentificacaoDupla: WideString;
begin
  Result := FDesIdentificacaoDupla;
end;

function TOrdemServico.Get_DesModeloIdentificador1: WideString;
begin
  Result := FDesModeloIdentificador1;
end;

function TOrdemServico.Get_DesModeloIdentificador2: WideString;
begin
  Result := FDesModeloIdentificador2;
end;

function TOrdemServico.Get_DesProdutoAcessorio1: WideString;
begin
  Result := FDesProdutoAcessorio1;
end;

function TOrdemServico.Get_DesProdutoAcessorio2: WideString;
begin
  Result := FDesProdutoAcessorio2;
end;

function TOrdemServico.Get_DesProdutoAcessorio3: WideString;
begin
  Result := FDesProdutoAcessorio3;
end;

function TOrdemServico.Get_DesSituacaoOS: WideString;
begin
  Result := FDesSituacaoOS;
end;

function TOrdemServico.Get_DtaCadastramento: TDateTime;
begin
  Result := FDtaCadastramento;
end;

function TOrdemServico.Get_DtaPedido: TDateTime;
begin
  Result := FDtaPedido;
end;

function TOrdemServico.Get_DtaUltimaAlteracao: TDateTime;
begin
  Result := FDtaUltimaAlteracao;
end;

function TOrdemServico.Get_EnderecoCobrancaIdent: IEndereco;
begin
  Result := FEnderecoCobrancaIdent;
end;

function TOrdemServico.Get_EnderecoEntregaCert: IEndereco;
begin
  Result := FEnderecoEntregaCert;
end;

function TOrdemServico.Get_EnderecoentregaIdent: IEndereco;
begin
  Result := FEnderecoEntregaIdent;
end;

function TOrdemServico.Get_IndEnviaPedidoIdentificador: WideString;
begin
  Result := IndEnviaPedidoIdentificador;
end;

function TOrdemServico.Get_NomProdutor: WideString;
begin
  Result := FNomProdutor;
end;

function TOrdemServico.Get_NomPropriedadeRural: WideString;
begin
  Result := FNomPropriedadeRural;
end;

function TOrdemServico.Get_NomReduzidoFabricante: WideString;
begin
  Result := FNomReduzidoFabricante;
end;

function TOrdemServico.Get_NomTecnico: WideString;
begin
  Result := FNomTecnico;
end;

function TOrdemServico.Get_NomUsuarioCadastramento: WideString;
begin
  Result := FNomUsuarioCadastramento;
end;

function TOrdemServico.Get_NomUsuarioPedido: WideString;
begin
  Result := FNomUsuarioPedido;
end;

function TOrdemServico.Get_NomUsuarioUltimaAlteracao: WideString;
begin
  Result := FNomUsuarioUltimaAlteracao;
end;

function TOrdemServico.Get_NomVendedor: WideString;
begin
  Result := FNomVendedor;
end;

function TOrdemServico.Get_NumCNPJCPFProdutor: WideString;
begin
  Result := FNumCNPJCPFProdutor;
end;

function TOrdemServico.Get_NumCNPJCPFProdutorFormatado: WideString;
begin
  Result := FNumCNPJCPFProdutorFormatado;
end;

function TOrdemServico.Get_numCNPJCPFTecnico: WideString;
begin
  Result := FNumCNPJCPFTecnico;
end;

function TOrdemServico.Get_NumCNPJCPFTecnicoFormatado: WideString;
begin
  Result := FNumCNPJCPFProdutorFormatado;
end;

function TOrdemServico.Get_NumCNPJCPFVendedor: WideString;
begin
  Result := FNumCNPJCPFVendedor;
end;

function TOrdemServico.Get_NumCNPJCPFVendedorFormatado: WideString;
begin
  Result := FNumCNPJCPFVendedorFormatado;
end;

function TOrdemServico.Get_NumDVSISBOVInicial: Integer;
begin
  Result := FNumDVSISBOVInicial;
end;

function TOrdemServico.Get_NumImovelReceitaFederal: WideString;
begin
  Result := FNumImovelReceitaFederal;
end;

function TOrdemServico.Get_NumOrdemServico: Integer;
begin
  Result := FNumOrdemServico;
end;

function TOrdemServico.Get_NumPedidoFabricante: Integer;
begin
  Result := FNumPedidoFabricante;
end;

function TOrdemServico.Get_NumRemessa: Integer;
begin
  Result := FNumRemessa;
end;

function TOrdemServico.Get_NumSolicitacaoSISBOV: Integer;
begin
  Result := FNumSolicitacaoSISBOV;
end;

function TOrdemServico.Get_QtdAnimais: Integer;
begin
  Result := FQtdAnimais;
end;

function TOrdemServico.Get_QtdProdutoAcessorio1: Integer;
begin
  Result := FQtdProdutoAcessorio1;
end;

function TOrdemServico.Get_QtdProdutoAcessorio2: Integer;
begin
  Result := FQtdProdutoAcessorio2;
end;

function TOrdemServico.Get_QtdProdutoAcessorio3: Integer;
begin
  Result := FQtdProdutoAcessorio3;
end;

function TOrdemServico.Get_SglIdentificacaoDupla: WideString;
begin
  Result := FSglIdentificacaoDupla;
end;

function TOrdemServico.Get_SglModeloIdentificador1: WideString;
begin
  Result := FSglModeloIdentificador1;
end;

function TOrdemServico.Get_SglModeloIdentificador2: WideString;
begin
  Result := FSglModeloIdentificador2;
end;

function TOrdemServico.Get_SglProdutoAcessorio1: WideString;
begin
  Result := FSglProdutoAcessorio1;
end;

function TOrdemServico.Get_SglProdutoAcessorio2: WideString;
begin
  Result := FSglProdutoAcessorio2;
end;

function TOrdemServico.Get_SglProdutoAcessorio3: WideString;
begin
  Result := FSglProdutoAcessorio3;
end;

function TOrdemServico.Get_SglProdutor: WideString;
begin
  Result := FSglProdutor;
end;

function TOrdemServico.Get_SglSituacaoOS: WideString;
begin
  Result := FSglSituacaoOS;
end;

function TOrdemServico.Get_TxtObservacao: WideString;
begin
  Result := FTxtObservacao;
end;

function TOrdemServico.Get_TxtObservacaoPedido: WideString;
begin
  Result := FTxtObservacaoPedido;
end;

function TOrdemServico.Get_IndAnimaisRegistrados: WideString;
begin
  Result := FIndAnimaisRegistrados;
end;

function TOrdemServico.Get_DtaEnvio: TDateTime;
begin
  Result := FDtaEnvio;
end;

function TOrdemServico.Get_NomServicoEnvio: WideString;
begin
  Result := FNomServicoEnvio;
end;

function TOrdemServico.Get_NumConhecimento: WideString;
begin
  Result := FNumConhecimento;
end;

function TOrdemServico.Get_CodLocalizacaoSisbov: Integer;
begin
  Result := FCodLocalizacaoSisbov;
end;

function TOrdemServico.Get_CodBoleto: Integer;
begin
  Result := FCodBoleto;
end;

function TOrdemServico.Get_IndTransmissaoSisbov: WideString;
begin
  Result := FIndTransmissaoSisbov;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TOrdemServico, Class_OrdemServico,
    ciMultiInstance, tmApartment);
end.
