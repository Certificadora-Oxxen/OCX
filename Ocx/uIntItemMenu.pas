unit uIntItemMenu;

interface

type
  TIntItemMenu = class
  private
    FCodItemMenu : Integer;
    FTxtTitulo : String;
    FTxtHintItemMenu : String;
    FIndDestaqueTitulo : String;
    FCodItemPai : Integer;
    FNumOrdem : Integer;
    FNumNivel : Integer;
    FQtdFilhos : Integer;
    FCodPagina : Integer;
    FURLPagina : String;
  public
    property CodItemMenu : Integer         read FCodItemMenu        write FCodItemMenu;
    property TxtTitulo : String            read FTxtTitulo          write FTxtTitulo;
    property TxtHintItemMenu : String              read FTxtHintItemMenu            write FTxtHintItemMenu;
    property IndDestaqueTitulo : String    read FIndDestaqueTitulo  write FIndDestaqueTitulo;
    property CodItemPai : Integer          read FCodItemPai         write FCodItemPai;
    property NumOrdem : Integer            read FNumOrdem           write FNumOrdem;
    property NumNivel : Integer            read FNumNivel           write FNumNivel;
    property QtdFilhos : Integer           read FQtdFilhos          write FQtdFilhos;
    property CodPagina : Integer           read FCodPagina          write FCodPagina;
    property URLPagina : String            read FURLPagina          write FURLPagina;
  end;

implementation

end.
