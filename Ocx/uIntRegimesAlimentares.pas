// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 23/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Regime Alimentar - Classe Auxiliar
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    23/07/2002    Criação
// *   Hitalo    15/08/2002    Adicionar o Metodo PesquisarRelacionamento
// *
// *
// ********************************************************************
unit uIntRegimesAlimentares;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntRegimesAlientares }
  TIntRegimesAlimentares = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodAptidao: Integer; IndAnimalMamando,
      IndIncluirNaoDefinido, CodOrdenacao: String): Integer;
    function PesquisarRelacionamento: Integer;
  end;

implementation

{ TIntRegimesAlientares }
function TIntRegimesAlimentares.Pesquisar(CodAptidao: Integer; IndAnimalMamando,
  IndIncluirNaoDefinido, CodOrdenacao: String): Integer;
var
  sMamando: String;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(88) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  if Trim(IndAnimalMamando)='' then begin
    sMamando := '';
  end else begin
    if UpperCase(IndAnimalMamando)='S' then begin
      sMamando := ' and (tra.ind_animal_mamando = ''S'' or tra.ind_animal_mamando = ''A'')';
    end
    else if UpperCase(IndAnimalMamando)='N' then begin
      sMamando := ' and (tra.ind_animal_mamando = ''N'' or tra.ind_animal_mamando = ''A'')';
    end;
  end;

  Query.Close;
  Query.SQL.Clear;
  {$IFDEF MSSQL}
  if CodAptidao <> - 1 then begin
    Query.SQL.Add('select tra.cod_regime_alimentar as CodRegimeAlimentar ');
    Query.SQL.Add('     , tra.sgl_regime_alimentar as SglRegimeAlimentar ');
    Query.SQL.Add('     , tra.des_regime_alimentar as DesRegimeAlimentar ');
    Query.SQL.Add('     , case tra.Ind_animal_mamando  ');
    Query.SQL.Add('       when ''S'' then ''Sim'' ');
    Query.SQL.Add('       when ''N'' then ''Não'' ');
    Query.SQL.Add('       when ''A'' then ''Ambos'' ');
    Query.SQL.Add('       end as IndAnimalMamando ');
    Query.SQL.Add('  from tab_Regime_Alimentar tra');
    Query.SQL.Add('     , tab_Regime_Alimentar_aptidao traa');
    Query.SQL.Add('     , tab_aptidao ta');
    Query.SQL.Add(' where traa.cod_regime_alimentar = tra.cod_regime_alimentar ');
    Query.SQL.Add('   and traa.cod_aptidao = ta.cod_aptidao ');
    Query.SQL.Add('   and ta.cod_aptidao = :cod_aptidao ');
    Query.SQL.Add('   and tra.dta_fim_validade is null');
    Query.SQL.Add('   and ta.dta_fim_validade is null');
  end else begin
    Query.SQL.Add('select tra.cod_regime_alimentar as CodRegimeAlimentar ');
    Query.SQL.Add('     , tra.sgl_regime_alimentar as SglRegimeAlimentar ');
    Query.SQL.Add('     , tra.des_regime_alimentar as DesRegimeAlimentar ');
    Query.SQL.Add('     , case tra.Ind_animal_mamando  ');
    Query.SQL.Add('       when ''S'' then ''Sim'' ');
    Query.SQL.Add('       when ''N'' then ''Não'' ');
    Query.SQL.Add('       when ''A'' then ''Ambos'' ');
    Query.SQL.Add('       end as IndAnimalMamando ');
    Query.SQL.Add('  from tab_Regime_Alimentar tra ');
    Query.SQL.Add(' where tra.dta_fim_validade is null');
  end;
  Query.SQL.Add(sMamando);
  if IndIncluirNaoDefinido = 'N' then
  begin
    Query.SQL.Add(' and tra.cod_regime_alimentar <> 99 ');
  end;

  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by tra.cod_regime_alimentar')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by tra.sgl_regime_alimentar ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by tra.des_regime_alimentar ');
{$ENDIF}
  if CodAptidao <> - 1 then begin
    Query.ParamByName('cod_aptidao').AsInteger         := CodAptidao;
  end;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(338, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -338;
      Exit;
    End;
  End;
end;

function TIntRegimesAlimentares.PesquisarRelacionamento: Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(197) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarRelacionamento', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select traa.cod_regime_alimentar as CodRegimeAlimentar ');
  Query.SQL.Add('     , traa.cod_aptidao as CodAptidao ');
  Query.SQL.Add('  from tab_Regime_Alimentar tra');
  Query.SQL.Add('     , tab_Regime_Alimentar_aptidao traa');
  Query.SQL.Add('     , tab_aptidao ta');
  Query.SQL.Add(' where traa.cod_regime_alimentar = tra.cod_regime_alimentar ');
  Query.SQL.Add('   and traa.cod_aptidao = ta.cod_aptidao ');
  Query.SQL.Add('   and tra.dta_fim_validade is null');
  Query.SQL.Add('   and ta.dta_fim_validade is null');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(533, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -533;
      Exit;
    End;
  End;
end;
end.

