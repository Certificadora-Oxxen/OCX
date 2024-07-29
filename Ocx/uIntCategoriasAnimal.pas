// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 24/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 30
// *  Descrição Resumida : Cadastro de Categoria Animal - Classe Auxiliar
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    24/07/2002    Criação
// *   Hitalo    15/08/2002    Adicionar o Metodo PesquisarRelacionamento
// *   Hitalo    24/09/2002    Alterar método pesquisar trocando parametros IndorigemMudanca,
// *                           IndDestinoMudanca por  IndRestritoSistema.
// *
// ********************************************************************
unit uIntCategoriasAnimal;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TInCategoriasAnimal }
  TIntCategoriasAnimal = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodAptidao: Integer; IndAnimalAtivo, IndSexo : String; NumIdade : Integer;IndAnimalCastrado,CodOrdenacao,IndRestritoSistema: String) : Integer;
    function PesquisarRelacionamento: Integer;
  end;

implementation

{ TIntCategoriasAnimal}
function TIntCategoriasAnimal.Pesquisar(CodAptidao: Integer; IndAnimalAtivo,IndSexo : String; NumIdade : Integer;IndAnimalCastrado,CodOrdenacao,IndRestritoSistema: String) : Integer;
var
  sInd : String;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(89) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  sInd :='';

  if (UpperCase(IndAnimalAtivo)='S') or (UpperCase(IndAnimalAtivo)='N') then begin
    sInd := ' and tca.ind_animal_ativo = ''' + UpperCase(IndAnimalAtivo) + '''';
  end;
  if (UpperCase(IndRestritoSistema)='S') or (UpperCase(IndRestritoSistema)='N') then begin
    sInd := sInd +  ' and tca.ind_restrito_sistema = ''' + UpperCase(IndRestritoSistema) + '''';
  end;
  if UpperCase(IndSexo) = 'M' then
    sInd := sInd +  ' and (tca.ind_sexo = ''M'' or tca.ind_sexo = ''A'')'
  else if UpperCase(IndSexo) = 'F' then
    sInd := sInd +  ' and (tca.ind_sexo = ''F'' or tca.ind_sexo = ''A'')'
  else if UpperCase(IndSexo) = 'A' then
    sInd := sInd +  ' and tca.ind_sexo = ''A''';
  //------------------
  // Animal Cadastrado
  //-------------------
  if UpperCase(IndAnimalCastrado) = 'S' then
    sInd := sInd +  ' and (tca.ind_animal_castrado = ''S'' or tca.ind_animal_castrado = ''A'')'
  else if UpperCase(IndAnimalCastrado) = 'N' then
    sInd := sInd +  ' and (tca.ind_animal_castrado = ''N'' or tca.ind_animal_castrado = ''A'')'
  else if UpperCase(IndAnimalCastrado) = 'A' then
    sInd := sInd +  ' and tca.ind_animal_castrado = ''A''';

  Query.Close;
  Query.SQL.Clear;
  {$IFDEF MSSQL}
  if CodAptidao <> - 1 then begin
    Query.SQL.Add('select tca.cod_categoria_animal as CodCategoriaAnimal ' + 
    '     , tca.sgl_categoria_animal as SglCategoriaAnimal ' +
    '     , tca.des_categoria_animal as DesCategoriaAnimal ' +
    '     , tca.Ind_animal_ativo as IndAnimalAtivo ' +
    '     , tca.ind_animal_castrado as IndAnimalCastrado ' +
    '     , tca.ind_restrito_sistema as IndRestritoSistema ' +
    '     , dbo.fnt_idade(0, tca.num_idade_minima) as DesIdadeMinima '+
    '     , dbo.fnt_idade(0, tca.num_idade_maxima) as DesIdadeMaxima '+
    '  from tab_categoria_animal tca' +
    '     , tab_categoria_animal_aptidao tcaa' +
    '     , tab_aptidao ta' +
    ' where tcaa.cod_categoria_animal = tca.cod_categoria_animal ' +
    '   and tcaa.cod_aptidao = ta.cod_aptidao ' +
    '   and ta.cod_aptidao = :cod_aptidao ' +
    '   and tca.dta_fim_validade is null' +
    '   and ta.dta_fim_validade is null');
  end else begin
    Query.SQL.Add('select tca.cod_categoria_animal as CodCategoriaAnimal ' +
    '     , tca.sgl_categoria_animal as SglCategoriaAnimal ' +
    '     , tca.des_categoria_animal as DesCategoriaAnimal ' +
    '     , tca.Ind_animal_ativo as IndAnimalAtivo ' +
    '     , tca.ind_animal_castrado as IndAnimalCastrado ' +
    '     , tca.ind_restrito_sistema as IndRestritoSistema ' +
    '     , dbo.fnt_idade(0, tca.num_idade_minima) as DesIdadeMinima '+
    '     , dbo.fnt_idade(0, tca.num_idade_maxima) as DesIdadeMaxima '+
    '  from tab_categoria_animal tca ' +
    ' where tca.dta_fim_validade is null');
  end;

  if NumIdade <> -1 then begin
    Query.SQL.Add('   and tca.num_idade_minima >= :num_idade ');
    Query.SQL.Add('   and tca.num_idade_maxima <= :num_idade');
  end;
  Query.SQL.Add( sInd);

  if CodOrdenacao = 'C' then
    Query.SQL.Add(' order by tca.cod_categoria_animal ')
  else if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by tca.sgl_categoria_animal ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by tca.des_categoria_animal ');
{$ENDIF}
  if CodAptidao <> - 1 then begin
    Query.ParamByName('cod_aptidao').AsInteger     := CodAptidao;
  end;
  if NumIdade <> -1 then begin
    Query.ParamByName('num_idade').AsInteger := NumIdade;
  end;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(357, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -357;
      Exit;
    End;
  End;
end;

function TIntCategoriasAnimal.PesquisarRelacionamento: Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('PesquisarRelacionamento');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(196) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarRelacionamento', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
  Query.SQL.Add('select tcaa.cod_categoria_animal as CodCategoriaAnimal ');
  Query.SQL.Add('     , tcaa.cod_aptidao as CodAptidao ');
  Query.SQL.Add('  from tab_categoria_animal tca');
  Query.SQL.Add('     , tab_categoria_animal_aptidao tcaa');
  Query.SQL.Add('     , tab_aptidao ta');
  Query.SQL.Add(' where tcaa.cod_categoria_animal = tca.cod_categoria_animal ');
  Query.SQL.Add('   and tcaa.cod_aptidao = ta.cod_aptidao ');
  Query.SQL.Add('   and tca.dta_fim_validade is null');
  Query.SQL.Add('   and ta.dta_fim_validade is null');
{$ENDIF}
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(532, Self.ClassName, 'PesquisarRelacionamento', [E.Message]);
      Result := -532;
      Exit;
    End;
  End;
end;
end.

