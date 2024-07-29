// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Luiz Humberto Canival
// *  Versão             : 1
// *  Data               : 27/05/2003
// *  Documentação       : Atributo de animais
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de caracteristicas de Tipos de Avaliação
// ************************************************************************************************
// *  Últimas Alterações
// ************************************************************************************************

unit UIntCaracteristicasAvaliacao;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntCaracteristicaAvaliacao, dbtables, sysutils, db;

type
  { TIntCaracteristicasAvaliacao }
  TIntCaracteristicasAvaliacao = class(TIntClasseBDNavegacaoBasica)
  private
    FIntCaracteristicaAvaliacao : TIntCaracteristicaAvaliacao;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Buscar(CodTipoAvaliacao, CodCaracteristica: Integer): Integer;
    function Inserir(CodTipoAvaliacao: Integer;
                     SglCaracteristica, DesCaracteristica: String;
                     CodUnidadeMedida: Integer; IndSexo: String;
                     ValLimiteMinimo, ValLimiteMaximo: Double): Integer;
    function Alterar(CodTipoAvaliacao, CodCaracteristica: Integer;
                     SglCaracteristica,DesCaracteristica: String;
                     CodUnidadeMedida: Integer; IndSexo: String;
                     ValLimiteMinimo, ValLimiteMaximo: Double): Integer;
    function Excluir(CodTipoAvaliacao, CodCaracteristica: Integer): Integer;
    function Pesquisar(CodTipoAvaliacao: Integer;
                       DesCaracteristica, CodOrdenacao: String): Integer;
    function PesquisarCaracteristica(CodTipoAvaliacao: Integer; CodOrdenacao: String): Integer;
    property IntCaracteristicaAvaliacao : TIntCaracteristicaAvaliacao read FIntCaracteristicaAvaliacao write FIntCaracteristicaAvaliacao;
  end;

implementation

{ TIntLote }
constructor TIntCaracteristicasAvaliacao.Create;
begin
  inherited;
  FIntCaracteristicaAvaliacao := TIntCaracteristicaAvaliacao.Create;
end;

destructor TIntCaracteristicasAvaliacao.Destroy;
begin
  FIntCaracteristicaAvaliacao.Free;
  inherited;
end;

function TIntCaracteristicasAvaliacao.Buscar(CodTipoAvaliacao, CodCaracteristica: Integer): Integer;
const
  NomMetodo: String = 'Buscar';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(460) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tta.cod_tipo_avaliacao    as CodTipoAvaliacao, ');
      Q.SQL.Add('       tca.cod_caracteristica    as CodCaracteristica, ');
      Q.SQL.Add('       tta.sgl_tipo_avaliacao    as SglTipoAvaliacao, ');
      Q.SQL.Add('       tta.des_tipo_avaliacao    as DesTipoAvaliacao, ');
      Q.SQL.Add('       tca.sgl_caracteristica    as SglCaracteristica, ');
      Q.SQL.Add('       tca.des_caracteristica    as DesCaracteristica, ');
      Q.SQL.Add('       tca.cod_unidade_medida    as CodUnidadeMedida, ');
      Q.SQL.Add('       tum.sgl_unidade_medida    as SglUnidadeMedida, ');
      Q.SQL.Add('       tum.des_unidade_medida    as DesUnidadeMedida, ');
      Q.SQL.Add('       tca.val_limite_minimo     as ValLimiteMinimo, ');
      Q.SQL.Add('       tca.val_limite_maximo     as ValLimiteMaximo, ');
      Q.SQL.Add('       tca.ind_sexo              as IndSexo ');
      Q.SQL.Add(' from tab_tipo_avaliacao tta, ');
      Q.SQL.Add('      tab_caracteristica_avaliacao tca, ');
      Q.SQL.Add('      tab_unidade_medida tum ');
      Q.SQL.Add(' where tca.cod_tipo_avaliacao = :CodTipoAvaliacao ');
      Q.SQL.Add(' and   tca.cod_caracteristica = :CodCaracteristica ');
      Q.SQL.Add(' and   tta.cod_tipo_avaliacao = tca.cod_tipo_avaliacao ');
      Q.SQL.Add(' and   tum.cod_unidade_medida = tca.cod_unidade_medida ');
{$ENDIF}
      Q.ParamByName('CodTipoAvaliacao').AsInteger   := CodTipoAvaliacao;
      Q.ParamByName('CodCaracteristica').AsInteger  := CodCaracteristica;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1510, Self.ClassName, NomMetodo, []);
        Result := -1510;
        Exit;
      End;

      // Obtem informações do registro
      IntCaracteristicaAvaliacao.CodTipoAvaliacao    := Q.FieldByName('CodTipoAvaliacao').AsInteger;
      IntCaracteristicaAvaliacao.CodCaracteristica   := Q.FieldByName('CodCaracteristica').AsInteger;
      IntCaracteristicaAvaliacao.SglTipoAvaliacao    := Q.FieldByName('SglTipoAvaliacao').AsString;
      IntCaracteristicaAvaliacao.DesTipoAvaliacao    := Q.FieldByName('DesTipoAvaliacao').AsString;
      IntCaracteristicaAvaliacao.SglCaracteristica   := Q.FieldByName('SglCaracteristica').AsString;
      IntCaracteristicaAvaliacao.DesCaracteristica   := Q.FieldByName('DesCaracteristica').AsString;
      IntCaracteristicaAvaliacao.CodUnidadeMedida    := Q.FieldByName('CodUnidadeMedida').AsInteger;
      IntCaracteristicaAvaliacao.SglUnidadeMedida    := Q.FieldByName('SglUnidadeMedida').AsString;
      IntCaracteristicaAvaliacao.DesUnidadeMedida    := Q.FieldByName('DesUnidadeMedida').AsString;
      IntCaracteristicaAvaliacao.IndSexo             := Q.FieldByName('IndSexo').AsString;
      IntCaracteristicaAvaliacao.ValLimiteMinimo     := Q.FieldByName('ValLimiteMinimo').AsFloat;
      IntCaracteristicaAvaliacao.ValLimiteMaximo     := Q.FieldByName('ValLimiteMaximo').AsFloat;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1511, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1511;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntCaracteristicasAvaliacao.Inserir(CodTipoAvaliacao: Integer;
                     SglCaracteristica, DesCaracteristica: String;
                     CodUnidadeMedida: Integer; IndSexo: String;
                     ValLimiteMinimo, ValLimiteMaximo: Double): Integer;
const
  NomMetodo: String = 'Inserir';
var
  Q : THerdomQuery;
  CodCaracteristica : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(456) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  // Trata sigla do Caracteristica de avaliacao
  Result := VerificaString(SglCaracteristica, 'Sigla da caracteristica de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglCaracteristica, 4, 'Sigla da caracteristica de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata descrição do Caracteristica de avaliacao
  Result := VerificaString(DesCaracteristica, 'Descrição da caracteristica de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(DesCaracteristica, 30, 'Descrição da caracteristica de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  //---------------------------------------
  // Trata sexo
  //---------------------------------------
  IndSexo := UpperCase(Trim(IndSexo));
  If (IndSexo <> 'A') and (IndSexo <> 'M') and (IndSexo <> 'F') Then Begin
    Mensagens.Adicionar(1605, Self.ClassName, NomMetodo, []);
    Result := -1605;
    Exit;
  End;

  //---------------------------------------
  // Trata valores mínimos e máximos
  //---------------------------------------
  if ValLimiteMinimo < 0 then begin
    Mensagens.Adicionar(1525, Self.ClassName, NomMetodo, [ValLimiteMinimo]);
    Result := -1525;
    Exit;
  end;

  if ValLimiteMaximo <= 0 then begin
    Mensagens.Adicionar(1525, Self.ClassName, NomMetodo, [ValLimiteMaximo]);
    Result := -1525;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_caracteristica_avaliacao ');
      Q.SQL.Add(' where sgl_caracteristica = :sgl_caracteristica ');
      Q.SQL.Add(' and   cod_tipo_avaliacao = :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_caracteristica').AsString  := SglCaracteristica;
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1512, Self.ClassName, NomMetodo, [SglCaracteristica]);
        Result := -1512;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade da descrição
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_caracteristica_avaliacao ');
      Q.SQL.Add(' where des_caracteristica = :des_caracteristica ');
      Q.SQL.Add(' and   cod_tipo_avaliacao = :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_caracteristica').AsString  := DesCaracteristica;
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1513, Self.ClassName, NomMetodo, [DesCaracteristica]);
        Result := -1513;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_Caracteristica), 0) + 1 as cod_caracteristica ');
      Q.SQL.Add('  from tab_caracteristica_avaliacao ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao');

      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
{$ENDIF}
      Q.Open;
      CodCaracteristica := Q.FieldByName('cod_caracteristica').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_caracteristica_avaliacao ');
      Q.SQL.Add(' (cod_tipo_avaliacao, ');
      Q.SQL.Add('  cod_caracteristica, ');
      Q.SQL.Add('  sgl_caracteristica, ');
      Q.SQL.Add('  des_caracteristica, ');
      Q.SQL.Add('  cod_unidade_medida, ');
      Q.SQL.Add('  ind_sexo, ');
      Q.SQL.Add('  val_limite_minimo, ');
      Q.SQL.Add('  val_limite_maximo) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_tipo_avaliacao, ');
      Q.SQL.Add('  :cod_caracteristica, ');
      Q.SQL.Add('  :sgl_caracteristica, ');
      Q.SQL.Add('  :des_caracteristica, ');
      Q.SQL.Add('  :cod_unidade_medida, ');
      Q.SQL.Add('  :ind_sexo, ');
      Q.SQL.Add('  :val_limite_minimo, ');
      Q.SQL.Add('  :val_limite_maximo) ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('cod_caracteristica').AsInteger := CodCaracteristica;
      Q.ParamByName('sgl_caracteristica').AsString  := SglCaracteristica;
      Q.ParamByName('des_caracteristica').AsString  := DesCaracteristica;
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.ParamByName('ind_sexo').AsString   := IndSexo;
      Q.ParamByName('val_limite_minimo').AsFloat   := ValLimiteMinimo;
      Q.ParamByName('val_limite_maximo').AsFloat   := ValLimiteMaximo;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodCaracteristica;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1514, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1514;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntCaracteristicasAvaliacao.Alterar(CodTipoAvaliacao, CodCaracteristica: Integer;
                     SglCaracteristica,DesCaracteristica: String;
                     CodUnidadeMedida: Integer; IndSexo: String;
                     ValLimiteMinimo, ValLimiteMaximo: Double): Integer;
const
  NomMetodo: String = 'Alterar';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(457) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  //-----------------------------------
  // Trata sigla do Caracteristica de avaliacao
  //-----------------------------------
  Result := VerificaString(SglCaracteristica, 'Sigla da caracteristica de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglCaracteristica, 4, 'Sigla da caracteristica de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;
  //---------------------------------------
  // Trata descrição do Caracteristica de avaliacao
  //---------------------------------------
  Result := VerificaString(DesCaracteristica, 'Descrição da caracteristica de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(DesCaracteristica, 30, 'Descrição da caracteristica de avaliação');
  If Result < 0 Then Begin
    Exit;
  End;

  //---------------------------------------
  // Trata sexo
  //---------------------------------------
  IndSexo := UpperCase(Trim(IndSexo));
  If (IndSexo <> 'A') and (IndSexo <> 'M') and (IndSexo <> 'F') Then Begin
    Mensagens.Adicionar(1605, Self.ClassName, NomMetodo, []);
    Result := -1605;
    Exit;
  End;

  //---------------------------------------
  // Trata valores mínimos e máximos
  //---------------------------------------
  if ValLimiteMinimo < 0 then begin
    Mensagens.Adicionar(1525, Self.ClassName, NomMetodo, [ValLimiteMinimo]);
    Result := -1525;
    Exit;
  end;

  if ValLimiteMaximo <= 0 then begin
    Mensagens.Adicionar(1525, Self.ClassName, NomMetodo, [ValLimiteMaximo]);
    Result := -1525;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_caracteristica_avaliacao ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   cod_caracteristica = :cod_caracteristica ');
      Q.SQL.Add(' and   dta_fim_validade   is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('cod_caracteristica').AsInteger := CodCaracteristica;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1510, Self.ClassName, 'Alterar', []);
        Result := -1510;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_caracteristica_avaliacao  ');
      Q.SQL.Add(' where sgl_caracteristica =  :sgl_caracteristica ');
      Q.SQL.Add(' and   cod_tipo_avaliacao =  :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   cod_caracteristica != :cod_caracteristica ');
      Q.SQL.Add(' and   dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_caracteristica').AsInteger := CodCaracteristica;
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('sgl_caracteristica').AsString  := SglCaracteristica;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1512, Self.ClassName, NomMetodo, [SglCaracteristica]);
        Result := -1512;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de descrição
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_caracteristica_avaliacao ');
      Q.SQL.Add(' where des_caracteristica  = :des_caracteristica ');
      Q.SQL.Add(' and   cod_tipo_avaliacao =  :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   cod_caracteristica != :cod_caracteristica ');
      Q.SQL.Add(' and   dta_fim_validade is null ');

{$ENDIF}
      Q.ParamByName('cod_caracteristica').AsInteger := CodCaracteristica;
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('des_caracteristica').AsString  := DesCaracteristica;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1513, Self.ClassName, NomMetodo, [DesCaracteristica]);
        Result := -1513;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_caracteristica_avaliacao ');
      Q.SQL.Add('   set sgl_caracteristica = :sgl_caracteristica ');
      Q.SQL.Add('     , des_caracteristica = :des_caracteristica ');
      Q.SQL.Add('     , cod_unidade_medida = :cod_unidade_medida ');
      Q.SQL.Add('     , ind_sexo = :ind_sexo ');
      Q.SQL.Add('     , val_limite_minimo  = :val_limite_minimo ');
      Q.SQL.Add('     , val_limite_maximo  = :val_limite_maximo ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   cod_caracteristica = :cod_caracteristica ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('cod_caracteristica').AsInteger := CodCaracteristica;
      Q.ParamByName('sgl_caracteristica').AsString  := SglCaracteristica;
      Q.ParamByName('des_caracteristica').AsString  := DesCaracteristica;
      Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
      Q.ParamByName('ind_sexo').AsString := IndSexo;
      Q.ParamByName('val_limite_minimo').AsFloat    := ValLimiteMinimo;
      Q.ParamByName('val_limite_maximo').AsFloat    := ValLimiteMaximo;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1507, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1507;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntCaracteristicasAvaliacao.Excluir(CodTipoAvaliacao, CodCaracteristica: Integer): Integer;
const
  NomMetodo: String = 'Excluir';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(458) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------------------
      // Verifica existência do registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_caracteristica_avaliacao ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   cod_caracteristica = :cod_caracteristica ');
      Q.SQL.Add(' and   dta_fim_validade   is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('cod_caracteristica').AsInteger := CodCaracteristica;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1510, Self.ClassName, NomMetodo, []);
        Result := -1510;
        Exit;
      End;
      Q.Close;

       //--------------------------------------------------------------
      // Verifica existência de registro na tabela de evento avaliacao
      //---------------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal_evento_avaliacao ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   cod_caracteristica = :cod_caracteristica ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('cod_caracteristica').AsInteger := CodCaracteristica;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1524, Self.ClassName, NomMetodo, []);
        Result := -1524;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Excluir as caracteristicas associadas
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_caracteristica_avaliacao ');
      Q.SQL.Add(' set   dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
      Q.SQL.Add(' and   cod_caracteristica = :cod_caracteristica ');
{$ENDIF}
      Q.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
      Q.ParamByName('cod_caracteristica').AsInteger := CodCaracteristica;
      Q.ExecSQL;

      // Confirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1515, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1515;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntCaracteristicasAvaliacao.Pesquisar(CodTipoAvaliacao: Integer;
                       DesCaracteristica, CodOrdenacao: String): Integer;
const
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(459) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tca.cod_tipo_avaliacao as CodTipoAvaliacao ');
  Query.SQL.Add('     , tta.sgl_tipo_avaliacao as SglTipoAvaliacao ');
  Query.SQL.Add('     , tta.des_tipo_avaliacao as DesTipoAvaliacao ');
  Query.SQL.Add('     , tca.cod_caracteristica as CodCaracteristica ');
  Query.SQL.Add('     , tca.sgl_caracteristica as SglCaracteristica ');
  Query.SQL.Add('     , tca.des_caracteristica as DesCaracteristica ');
  Query.SQL.Add('     , tca.cod_unidade_medida as CodUnidadeMedida ');
  Query.SQL.Add('     , tum.sgl_unidade_medida as SglUnidadeMedida ');
  Query.SQL.Add('     , tca.val_limite_minimo  as ValLimiteMinimo ');
  Query.SQL.Add('     , tca.val_limite_maximo  as ValLimiteMaximo ');
  Query.SQL.Add(' from tab_tipo_avaliacao tta ');
  Query.SQL.Add('    , tab_caracteristica_avaliacao tca ');
  Query.SQL.Add('    , tab_unidade_medida tum ');
  Query.SQL.Add(' where tta.cod_tipo_avaliacao = tca.cod_tipo_avaliacao ');
  Query.SQL.Add('   and tca.cod_unidade_medida = tum.cod_unidade_medida ');
  Query.SQL.Add('   and tca.dta_fim_validade   is null ');
  if (CodTipoAvaliacao > 0) and (Length(DesCaracteristica) > 0) then begin
     Query.SQL.Add(' and   tta.cod_tipo_avaliacao = :cod_tipo_avaliacao ');
     Query.SQL.Add(' and   tca.des_caracteristica like :des_caracteristica ');

     Query.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
     Query.ParamByName('des_caracteristica').AsString  := '%' + DesCaracteristica + '%';
  end
  else if CodTipoAvaliacao > 0 then begin
     Query.SQL.Add(' and  tta.cod_tipo_avaliacao = :cod_tipo_avaliacao ');
     Query.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;
  end
  else if Length(DesCaracteristica) > 0 then begin
     query.SQL.Add(' and  tca.des_caracteristica like :des_caracteristica ');
     Query.ParamByName('des_caracteristica').AsString  := '%' + DesCaracteristica + '%';
  end;
  Query.SQL.Add(' order by tca.cod_tipo_avaliacao ');
  if CodOrdenacao = 'C' then
     Query.SQL.Add(' , tca.cod_caracteristica ')
  else if CodOrdenacao = 'S' then
     Query.SQL.Add(' , tca.sgl_caracteristica ')
  else if CodOrdenacao = 'D' then
     Query.SQL.Add(' , tca.des_caracteristica ')
  else if CodOrdenacao = 'T' then
     Query.SQL.Add(' , tta.des_tipo_avaliacao ');
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1517, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1517;
      Exit;
    End;
  End;
end;

function TIntCaracteristicasAvaliacao.PesquisarCaracteristica(CodTipoAvaliacao: Integer;
                       CodOrdenacao: String): Integer;
const
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(462) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_caracteristica as CodCaracteristica ');
  Query.SQL.Add('     , sgl_caracteristica as SglCaracteristica ');
  Query.SQL.Add('     , des_caracteristica as DesCaracteristica ');
  Query.SQL.Add(' from  tab_caracteristica_avaliacao ');
  Query.SQL.Add(' where cod_tipo_avaliacao = :cod_tipo_avaliacao ');
  Query.SQL.Add(' and   dta_fim_validade   is null ');

  Query.ParamByName('cod_tipo_avaliacao').AsInteger := CodTipoAvaliacao;

  if CodOrdenacao = 'C' then
     Query.SQL.Add(' order by cod_caracteristica ')
  else if CodOrdenacao = 'S' then
     Query.SQL.Add(' order by sgl_caracteristica ')
  else if CodOrdenacao = 'D' then
     Query.SQL.Add(' order by des_caracteristica ');
{$ENDIF}

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1517, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1517;
      Exit;
    End;
  End;
end;
end.
