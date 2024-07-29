// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Daniel P. Nascimento
// *  Versão             : 1
// *  Data               : 28/08/2004
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Pedido de Identificadores - Classe Auxiliar
// ********************************************************************
// *  Últimas Alterações
// *
// ********************************************************************
unit uIntPedidoIdentificadores;

interface

uses uIntEndereco;

type
  TIntPedidoIdentificadores = class(TObject)
  private
       FPedidoIdentificadores:       Integer;
       FNomFabricanteIdentificador:  String;
       FNomReduzidoFabricante:       String;
       FNumCNPJFabricante:           String;
       FCodCertificadoraFabricante:  String;
       FCodTipoArquivoRemessa:       Integer;
       FNomArquivoRemessaPedido:     String;
       FNomArquivoFichaPedido:       String;
       FTxtCaminhoArquivo:           String;
       FNumRemessaFabricante:        Integer;
       FNumPedidoFabricante:         Integer;
       FNumOrdemServico:             Integer;
       FSglProdutor:                 String;
       FNomProdutor:                 String;
       FNomReduzidoProdutor:         String;
       FCodNaturezaPessoa:           String;
       FNumCNPJCPFProdutor:          String;
       FNumCNPJCPFProdutorFormatado: String;
       FNumTelefoneProdutor:         String;
       FNumFaxProdutor:              String;
       FTxtEMailProdutor:            String;
       FNumImovelReceitaFederal:     String;
       FNomFazenda:                  String;
       FSglEstadoFazenda:            String;
       FNumPropriedadeRuralFazenda:  String;
       FEnderecoPropriedadeRural:    TIntEndereco;
       FQtdAnimais:                  Integer;
       FNumSolicitacaoSISBOV:        Integer;
       FCodPaisSISBOV:               Integer;
       FCodEstadoSISBOV:             Integer;
       FCodMicroRegiaoSISBOV:        Integer;
       FCodAnimalSISBOVInicio:       Integer;
       FNumDVSISBOVInicio:           Integer;
       FCodAnimalSISBOVFim:          Integer;
       FNumDVSISBOVFim:              Integer;
       FSglIdentificacaoDupla:       String;
       FDesIdentificacaoDupla:       String;
       FCodFormaPagamentoFabricante: String;
       FDesFormaPagamentoIdent:      String;
       FCodModeloFabricante1:        String;
       FDesModeloIdentificador1:     String;
       FCodModeloFabricante2:        String;
       FDesModeloIdentificador2:     String;
       FCodProdutoFabricante1:       String;
       FDesProdutoAcessorio1:        String;
       FQtdProdutoAcessorio1:        Integer;
       FCodProdutoFabricante2:       String;
       FDesProdutoAcessorio2:        String;
       FQtdProdutoAcessorio2:        Integer;
       FCodProdutoFabricante3:       String;
       FDesProdutoAcessorio3:        String;
       FQtdProdutoAcessorio3:        Integer;
       FEnderecoEntregaIdent:        TIntEndereco;
       FEnderecoCobrancaIdent:       TIntEndereco;
       FDtaPedido:                   TDateTime;
       FNomUsuarioPedido:            String;
       FTxtObservacaoPedido:         String;
       FNomCertificadora:            String;
       FNomTratamentoUsuarioPedido:  String;
       FIndAnimaisRegistrados:       String;

       FIndDescompactarArquivoZip:   String;
  public
       property NumOrdemServico:             Integer   read FNumOrdemServico write FNumOrdemServico;
       property SglProdutor:                 String    read FSglProdutor write FSglProdutor;
       property NomProdutor:                 String    read FNomProdutor write FNomProdutor;
       property NomReduzidoProdutor:         String    read FNomReduzidoProdutor write FNomReduzidoProdutor;
       property CodNaturezaPessoa:           String    read FCodNaturezaPessoa write FCodNaturezaPessoa;
       property NumCNPJCPFProdutor:          String    read FNumCNPJCPFProdutor write FNumCNPJCPFProdutor;
       property NumCNPJCPFProdutorFormatado: String    read FNumCNPJCPFProdutorFormatado write FNumCNPJCPFProdutorFormatado;
       property NumTelefoneProdutor:         String    read FNumTelefoneProdutor write FNumTelefoneProdutor;
       property NumFaxProdutor:              String    read FNumFaxProdutor write FNumFaxProdutor;
       property TxtEMailProdutor:            String    read FTxtEMailProdutor write FTxtEMailProdutor;
       property NomFazenda:                  String    read FNomFazenda write FNomFazenda;
       property SglEstadoFazenda:            String    read FSglEstadoFazenda write FSglEstadoFazenda;
       property NumPropriedadeRuralFazenda:  String    read FNumPropriedadeRuralFazenda write FNumPropriedadeRuralFazenda;
       property NumImovelReceitaFederal:     String    read FNumImovelReceitaFederal write FNumImovelReceitaFederal;
       property EnderecoPropriedadeRural:    TIntEndereco read FEnderecoPropriedadeRural write FEnderecoPropriedadeRural;
       property QtdAnimais:                  Integer   read FQtdAnimais write FQtdAnimais;
       property NumSolicitacaoSISBOV:        Integer   read FNumSolicitacaoSISBOV write FNumSolicitacaoSISBOV;
       property CodPaisSISBOV:               Integer   read FCodPaisSISBOV write FCodPaisSISBOV;
       property CodEstadoSISBOV:             Integer   read FCodEstadoSISBOV write FCodEstadoSISBOV;
       property CodMicroRegiaoSISBOV:        Integer   read FCodMicroRegiaoSISBOV write FCodMicroRegiaoSISBOV;
       property CodAnimalSISBOVInicio:      Integer   read FCodAnimalSISBOVInicio write FCodAnimalSISBOVInicio;
       property NumDVSISBOVInicio:          Integer   read FNumDVSISBOVInicio write FNumDVSISBOVInicio;
       property CodAnimalSISBOVFim:        Integer   read FCodAnimalSISBOVFim write FCodAnimalSISBOVFim;
       property NumDVSISBOVFim:            Integer   read FNumDVSISBOVFim write FNumDVSISBOVFim;
       property SglIdentificacaoDupla:       String    read FSglIdentificacaoDupla write FSglIdentificacaoDupla;
       property DesIdentificacaoDupla:       String    read FDesIdentificacaoDupla write FDesIdentificacaoDupla;
       property CodFormaPagamentoFabricante: String    read FCodFormaPagamentoFabricante write FCodFormaPagamentoFabricante;
       property DesFormaPagamentoIdent:      String    read FDesFormaPagamentoIdent write FDesFormaPagamentoIdent;
       property EnderecoEntregaIdent:        TIntEndereco read FEnderecoEntregaIdent write FEnderecoEntregaIdent;
       property EnderecoCobrancaIdent:       TIntEndereco read FEnderecoCobrancaIdent write FEnderecoCobrancaIdent;
       property CodModeloFabricante1:        String    read FCodModeloFabricante1 write FCodModeloFabricante1;
       property DesModeloIdentificador1:     String    read FDesModeloIdentificador1 write FDesModeloIdentificador1;
       property CodModeloFabricante2:        String    read FCodModeloFabricante2 write FCodModeloFabricante2;
       property DesModeloIdentificador2:     String    read FDesModeloIdentificador2 write FDesModeloIdentificador2;
       property CodProdutoFabricante1:       String    read FCodProdutoFabricante1 write FCodProdutoFabricante1;
       property DesProdutoAcessorio1:        String    read FDesProdutoAcessorio1 write FDesProdutoAcessorio1;
       property QtdProdutoAcessorio1:        Integer   read FQtdProdutoAcessorio1 write FQtdProdutoAcessorio1;
       property CodProdutoFabricante2:       String    read FCodProdutoFabricante2 write FCodProdutoFabricante2;
       property DesProdutoAcessorio2:        String    read FDesProdutoAcessorio2 write FDesProdutoAcessorio2;
       property QtdProdutoAcessorio2:        Integer   read FQtdProdutoAcessorio2 write FQtdProdutoAcessorio2;
       property CodProdutoFabricante3:       String    read FCodProdutoFabricante3 write FCodProdutoFabricante3;
       property DesProdutoAcessorio3:        String    read FDesProdutoAcessorio3 write FDesProdutoAcessorio3;
       property QtdProdutoAcessorio3:        Integer   read FQtdProdutoAcessorio3 write FQtdProdutoAcessorio3;
       property NumPedidoFabricante:         Integer   read FNumPedidoFabricante write FNumPedidoFabricante;
       property DtaPedido:                   TDateTime read FDtaPedido write FDtaPedido;
       property NomUsuarioPedido:            String    read FNomUsuarioPedido write FNomUsuarioPedido;
       property TxtObservacaoPedido:         String    read FTxtObservacaoPedido write FTxtObservacaoPedido;

       property PedidoIdentificadores:       Integer read FPedidoIdentificadores write FPedidoIdentificadores;
       property NomFabricanteIdentificador:  String  read FNomFabricanteIdentificador write FNomFabricanteIdentificador;
       property NomReduzidoFabricante:       String  read FNomReduzidoFabricante write FNomReduzidoFabricante;
       property NumCNPJFabricante:           String  read FNumCNPJFabricante write FNumCNPJFabricante;
       property CodCertificadoraFabricante:  String  read FCodCertificadoraFabricante write FCodCertificadoraFabricante;
       property NumRemessaFabricante:        Integer read FNumRemessaFabricante write FNumRemessaFabricante;
       property NomArquivoRemessaPedido:     String  read FNomArquivoRemessaPedido write FNomArquivoRemessaPedido;
       property NomArquivoFichaPedido:       String  read FNomArquivoFichaPedido write FNomArquivoFichaPedido;
       property TxtCaminhoArquivo:           String  read FTxtCaminhoArquivo write FTxtCaminhoArquivo;
       property CodTipoArquivoRemessa:       Integer read FCodTipoArquivoRemessa write FCodTipoArquivoRemessa;
       property NomCertificadora:            String  read FNomCertificadora write FNomCertificadora;
       property NomTratamentoUsuarioPedido:  String  read FNomTratamentoUsuarioPedido write FNomTratamentoUsuarioPedido;
       property IndAnimaisRegistrados:       String  read FIndAnimaisRegistrados write FIndAnimaisRegistrados; 

       property IndDescompactarArquivoZip:   String read FIndDescompactarArquivoZip write FIndDescompactarArquivoZip;
  end;

implementation

end.
