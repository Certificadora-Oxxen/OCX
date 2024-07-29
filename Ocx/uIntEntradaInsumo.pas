// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       : Controle de Insumos - Definição das Classes
// *  Código Classe      : 64
// *  Descrição Resumida : Cadastro de Entradas de Insumo
// ************************************************************************
// *  Últimas Alterações
// *  Hitalo   01/10/2002  adiconar NumCNPJCPFRevendedor, TxtObservacao
// *
// ********************************************************************
unit uIntEntradaInsumo;

interface
type
  TIntEntradaInsumo = class
 private
    FCodPessoaProdutor:Integer;
    FCodEntradaInsumo:Integer;
    FCodFazenda:Integer;
    FSglFazenda:String;
    FNomFazenda:String;
    FCodTipoInsumo:Integer;
    FSglTipoInsumo:String;
    FDesTipoInsumo:String;
    FIndAdmitePartidaLote:String;
    FCodSubTipoInsumo:Integer;
    FSglSubTipoInsumo:String;
    FDesSubTipoInsumo:String;
    FCodInsumo:Integer;
    FDesInsumo:String;
    FCodFabricanteInsumo:Integer;
    FNomFabricanteInsumo:String;
    FNumRegistroFabricante:Integer;
    FCodPessoaSecundaria:Integer;
    FNomRevendedor:String;
    FNumCNPJCPFRevendedorFormatado:String;
    FDtaCompra:TdateTime;
    FNumNotaFiscal:Integer;
    FNumPartidaLote:String;
    FDtaValidade:TdateTime;
    FQtdInsumo:Double;
    FCodUnidadeMedida     :Integer;
    FSglUnidadeMedida     :String;
    FNumCNPJCPFRevendedor :String;
    FTxtObservacao        :String;
    FCusto:double;
  public
    property     CodPessoaProdutor              :Integer     read FCodPessoaProdutor               write FCodPessoaProdutor;
    property     CodEntradaInsumo               :Integer     read FCodEntradaInsumo                write FCodEntradaInsumo;
    property     CodFazenda                     :Integer     read FCodFazenda                      write FCodFazenda;
    property     SglFazenda                     :String      read FSglFazenda                      write FSglFazenda;
    property     NomFazenda                     :String      read FNomFazenda                      write FNomFazenda;
    property     CodTipoInsumo                  :Integer     read FCodTipoInsumo                   write FCodTipoInsumo;
    property     SglTipoInsumo                  :String      read FSglTipoInsumo                   write FSglTipoInsumo;
    property     DesTipoInsumo                  :String      read FDesTipoInsumo                   write FDesTipoInsumo;
    property     IndAdmitePartidaLote           :String      read FIndAdmitePartidaLote            write FIndAdmitePartidaLote;
    property     CodSubTipoInsumo               :Integer     read FCodSubTipoInsumo                write FCodSubTipoInsumo;
    property     SglSubTipoInsumo               :String      read FSglSubTipoInsumo                write FSglSubTipoInsumo;
    property     DesSubTipoInsumo               :String      read FDesSubTipoInsumo                write FDesSubTipoInsumo;
    property     CodInsumo                      :Integer     read FCodInsumo                       write FCodInsumo;
    property     DesInsumo                      :String      read FDesInsumo                       write FDesInsumo;
    property     CodFabricanteInsumo            :Integer     read FCodFabricanteInsumo             write FCodFabricanteInsumo;
    property     NomFabricanteInsumo            :String      read FNomFabricanteInsumo             write FNomFabricanteInsumo;
    property     NumRegistroFabricante          :Integer     read FNumRegistroFabricante           write FNumRegistroFabricante;
    property     CodPessoaSecundaria            :Integer     read FCodPessoaSecundaria             write FCodPessoaSecundaria;
    property     NomRevendedor                  :String      read FNomRevendedor                   write FNomRevendedor;
    property     NumCNPJCPFRevendedorFormatado  :String      read FNumCNPJCPFRevendedorFormatado   write FNumCNPJCPFRevendedorFormatado;
    property     DtaCompra                      :TdateTime   read FDtaCompra                       write FDtaCompra;
    property     NumNotaFiscal                  :Integer     read FNumNotaFiscal                   write FNumNotaFiscal;
    property     NumPartidaLote                 :String      read FNumPartidaLote                  write FNumPartidaLote;
    property     DtaValidade                    :TdateTime   read FDtaValidade                     write FDtaValidade;
    property     QtdInsumo                      :Double      read FQtdInsumo                       write FQtdInsumo;
    property     CodUnidadeMedida               :Integer     read FCodUnidadeMedida                write FCodUnidadeMedida;
    property     SglUnidadeMedida               :String      read FSglUnidadeMedida                write FSglUnidadeMedida;
    property     NumCNPJCPFRevendedor           :String      read FNumCNPJCPFRevendedor            write FNumCNPJCPFRevendedor;
    property     TxtObservacao                  :String      read FTxtObservacao                   write FTxtObservacao;
    property     Custo                          :Double      read Fcusto                           write FCusto;
  end;

implementation

end.
