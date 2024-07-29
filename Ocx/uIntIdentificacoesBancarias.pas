unit uIntIdentificacoesBancarias;

interface

uses SysUtils,
     uIntClassesBasicas;

type

  TIntIdentificacoesBancarias = class(TIntClasseBDLeituraBasica)
    public
      function Pesquisar(CodIdentificacaoBancaria: Integer): Integer;
  end;

implementation

uses SqlExpr;

{ TIntIdentificacoesBancarias }

function TIntIdentificacoesBancarias.Pesquisar(CodIdentificacaoBancaria: Integer): Integer;
const
  NomMetodo: String = 'Pesquisar';
  CodMetodo: Integer = 626;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Try
    with Query do
    begin
      SQL.Clear;
      SQL.Add('select ' +
              '       cod_identificacao_bancaria as CodIdentificacaoBancaria ' +
              '     , nom_banco as NomBanco ' +
              '     , nom_reduzido_banco as NomReduzidoBanco ' +              
              '     , cod_convenio_banco as CodConvenioBanco ' +
              '     , cod_banco_compensacao as CodBancoCompensacao ' +
              '     , cod_agencia_conta as CodAgenciaConta ' +
              '     , cod_dv_agencia as CodDVAgencia ' +
              '     , cod_conta_corrente as CodContaCorrente ' +
              '     , cod_dv_conta_corrente as CodDVContaCorrente ' +
              '     , cod_dv_conta_agencia as CodDVContaAgencia ' +
              '     , num_ordem as NumOrdem ' +
              '     , ind_default as IndDefault ' +
              '  from ' +
              '       tab_identificacao_bancaria ' +
              ' where dta_fim_validade is null ');
      if CodIdentificacaoBancaria > 0 then
      begin
        SQL.Add(' and cod_identificacao_bancaria = :cod_identificacao_bancaria');
        ParamByName('cod_identificacao_bancaria').AsInteger := CodIdentificacaoBancaria;
      end;
      SQL.Add(' order by num_ordem ');
      Open;
    end;
    Result := 0;
  Except
    on E:Exception do
    begin
      Mensagens.Adicionar(2134, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2134;
      Exit;
    end;
  end;
end;

end.
