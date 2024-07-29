// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 09/09/2002
// *  Documentação       : Eventos de Movimentação - Especificação das
// *                       classes.doc
// *  Código Classe      : 56
// *  Descrição Resumida : Cadastro de Tipos Eventos
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    09/09/2002    Criação
// *   Hitalo    24/09/2002    Alterar método pesquisar  adicionando o parametro IndRestritoSistema.
// *
// ********************************************************************
unit uIntTiposEvento;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens;

type
  { TIntTiposEvento }
  TIntTiposEvento = class(TIntClasseBDLeituraBasica)
  public
    function Pesquisar(CodGrupoEvento : Integer;IndEventoSisBov,IndRestritoSistema : String) : Integer;
    function PesquisarCoberturas(IndEventoSisbov, IndRestritoSistema, CodOrdenacao: String): Integer;
  end;

implementation

{ TIntTiposEvento}
function TIntTiposEvento.Pesquisar(CodGrupoEvento : Integer;IndEventoSisBov,IndRestritoSistema : String) : Integer;
var
  sInd : String;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(252) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  if (UpperCase(IndEventoSisBov) =  'S') or (UpperCase(IndEventoSisBov) =  'N') then begin
    sInd := ' and tt.ind_evento_sisbov = ''' + UpperCase(IndEventoSisBov) + '''';
  end;
  if (UpperCase(IndRestritoSistema) =  'S') or (UpperCase(IndRestritoSistema) =  'N') then begin
    sInd := ' and tt.ind_restrito_sistema = ''' + UpperCase(IndRestritoSistema) + '''';
  end;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tg.cod_grupo_evento as CodGrupoEvento ' +
  '     , tg.sgl_grupo_evento as SglGrupoEvento ' +
  '     , tg.des_grupo_evento as DesGrupoEvento ' +
  '     , tt.cod_tipo_evento as CodTipoEvento ' +
  '     , tt.sgl_tipo_evento as SglTipoEvento ' +
  '     , tt.des_tipo_evento as DesTipoEvento ' +
  '     , tt.Ind_evento_sisBov as IndEventoSisBov ' +
  '     , tt.ind_restrito_sistema  as IndRestritoSistema' +
  '     , tg.num_ordem, tt.num_ordem ' +
  '  from tab_grupo_evento tg ' +
  '     , tab_tipo_evento tt ' +
  ' where ((tg.cod_grupo_evento = :cod_grupo_evento) or (-1 = :cod_grupo_evento))  ' +
  '   and tg.cod_grupo_evento = tt.cod_grupo_evento ' +
  '   and tt.dta_fim_validade is null ' +
  sInd +
  ' order by tt.des_tipo_evento ');
{$ENDIF}
  Query.ParamByName('cod_grupo_evento').asInteger := CodGrupoEvento;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(772, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -772;
      Exit;
    End;
  End;
end;

function TIntTiposEvento.PesquisarCoberturas(IndEventoSisbov,
  IndRestritoSistema, CodOrdenacao: String): Integer;
const
  Metodo: Integer = 474;
  NomeMetodo: String = 'PesquisarCoberturas';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  If Not Conexao.PodeExecutarMetodo(Metodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Try
    Query.Close;
    Query.SQL.Text :=
      'select tg.cod_grupo_evento as CodGrupoEvento ' +
      '     , tg.sgl_grupo_evento as SglGrupoEvento ' +
      '     , tg.des_grupo_evento as DesGrupoEvento ' +
      '     , tt.cod_tipo_evento as CodTipoEvento ' +
      '     , tt.sgl_tipo_evento as SglTipoEvento ' +
      '     , tt.des_tipo_evento as DesTipoEvento ' +
      '     , tt.Ind_evento_sisBov as IndEventoSisBov ' +
      '     , tt.ind_restrito_sistema  as IndRestritoSistema' +
      '     , tg.num_ordem, tt.num_ordem ' +
      '  from tab_grupo_evento tg ' +
      '     , tab_tipo_evento tt ' +
      ' where tg.cod_grupo_evento = tt.cod_grupo_evento ' +
      '   and tt.dta_fim_validade is null ' +
      '   and tt.cod_tipo_evento in (23, 26, 27) '; // Evento de cobertura
    if (UpperCase(IndEventoSisBov) =  'S') or (UpperCase(IndEventoSisBov) =  'N') then begin
      Query.SQL.Text := Query.SQL.Text +
        ' and tt.ind_evento_sisbov = ''' + UpperCase(IndEventoSisBov) + '''';
    end;
    if (UpperCase(IndRestritoSistema) =  'S') or (UpperCase(IndRestritoSistema) =  'N') then begin
      Query.SQL.Text := Query.SQL.Text +
        ' and tt.ind_restrito_sistema = ''' + UpperCase(IndRestritoSistema) + '''';
    end;
    if CodOrdenacao = 'S' then begin
      Query.SQL.Text := Query.SQL.Text +
        'order by SglTipoEvento';
    end else if CodOrdenacao = 'D' then begin
      Query.SQL.Text := Query.SQL.Text +
        'order by DesTipoEvento';
    end;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1561, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1561;
      Exit;
    End;
  End;
end;

end.
