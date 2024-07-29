library XHerdom;

uses
  ComServ,
  uArquivo in 'uArquivo.pas',
  uImportacaoExcel in 'uImportacaoExcel.pas' {ImportacaoExcel: CoClass},
  uImportacao in 'uImportacao.pas',
  uIntImportacaoExcel in 'uIntImportacaoExcel.pas',
  uErroImportacao in 'uErroImportacao.pas' {ErroImportacao: CoClass},
  uIntErroImportacao in 'uIntErroImportacao.pas',
  uETabErro in 'uETabErro.pas',
  XHerdom_TLB in 'XHerdom_TLB.pas',
  uFerramentas in 'uFerramentas.pas',
  Boitata_TLB in 'C:\Borland\Delphi7\Imports\Boitata_TLB.pas';

{$E ocx}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
