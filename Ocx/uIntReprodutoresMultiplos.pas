// ********************************************************************
// *  Projeto            : BoiTata                                  
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 27/11/2002
// *  Documentação       : Animais - Definição das Classes
// *  Código Classe      : 73
// *  Descrição Resumida : Cadastro de Reprodutor Multiplo
// ********************************************************************
// *  Últimas Alterações
// *  Hitalo   27/11/2002  criacao
// *
// ********************************************************************
unit uIntReprodutoresMultiplos;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,
     uIntReprodutorMultiplo, uferramentas;

type
  TDadosAnimal = record
    CodAnimal : Integer;
    CodFazendaManejo : Integer;
    CodAnimalManejo : String;
    CodAnimalCertificadora: String;
    CodPaisSisbov : Integer;
    CodEstadoSisbov : Integer;
    CodMicroRegiaoSisbov : Integer;
    CodAnimalSisbov : Integer;
    NumDVSisbov : Integer;
    CodSituacaoSisbov : String;
    DtaIdentificacaoSisbov : TDateTime;
    NumImovelIdentificacao : String;
    CodPropriedadeIdentificacao : Integer;
    CodFazendaIdentificacao : Integer;
    DtaNascimento : TDatetime;
    NumImovelNascimento : String;
    CodPropriedadeNascimento : Integer;
    CodFazendaNascimento : Integer;
    DtaCompra : TDateTime;
    CodPessoaSecundariaCriador : Integer;
    NomAnimal : String;
    DesApelido : String;
    CodAssociacaoRaca : Integer;
    CodGrauSangue : Integer;
    CodEspecie : Integer;
    CodAptidao : Integer;
    CodRaca : Integer;
    CodPelagem : Integer;
    IndSexo : String;
    CodTipoOrigem : Integer;
    CodAnimalPai : Integer;
    CodAnimalMae : Integer;
    CodAnimalReceptor : Integer;
    IndAnimalCastrado: String;
    CodRegimeAlimentar : Integer;
    CodCategoriaAnimal : Integer;
    CodTipoLugar : Integer;
    CodLoteCorrente : Integer;
    CodLocalCorrente : Integer;
    CodFazendaCorrente : Integer;
    NumImovelCorrente : String;
    CodPropriedadeCorrente : Integer;
    NumCNPJCPFCorrente : String;
    CodPessoaCorrente : Integer;
    CodPessoaSecundariaCorrente : Integer;
    DtaUltimoEvento : TDateTime;
    DtaUltimoEventoAnterior : TDateTime;
    DtaAplicacaoUltimoEvento : TDateTime;
    DtaAplicacaoUltimoEventoAnterior : TDateTime;
    CodRegistroLog: Integer;
    DtaEfetivacaoCadastro: TDatetime;
    CodArquivoSisbov : Integer;
    CodAnimalAssociado : Integer;
    QtdPesoAnimal : extended;
    NumTransponder: String;
    CodTipoIdentificador1: Integer;
    CodPosicaoIdentificador1: Integer;
    CodTipoIdentificador2: Integer;
    CodPosicaoIdentificador2: Integer;
    CodTipoIdentificador3: Integer;
    CodPosicaoIdentificador3: Integer;
    CodTipoIdentificador4: Integer;
    CodPosicaoIdentificador4: Integer;
    NumGta: String;
    DtaEmissaoGta: TDateTime;
    NumNotaFiscal: Integer;
  end;
  TIntReprodutoresMultiplos = class(TIntClasseBDNavegacaoBasica)
  private
    FIntReprodutorMultiplo : TIntReprodutorMultiplo;
    function InserirInt(CodFazendaManejo : Integer;CodReprodutorMultiploManejo : String;CodEspecie : Integer; TxtObservacao : String;CodTipoAcesso : Integer): Integer;
    function ObterNroMaxRM(CodFazendaManejo: Integer): Integer;
    function VerificaNumLetra(Valor: String; Tamanho: Integer;
      NomParametro: String): Integer;
    function VerificaCodReprodutorMultiploManejo(CodAnimalManejo: String): Integer;
    function InserirErroOperacaoAnimal(DadosAnimal: TDadosAnimal; DtaOperacao: TDateTime;
     TxtMensagem: String; CodOperacaoCadastro, CodTipoMensagem: Integer): Integer;
    function BuscaDadosAnimal(CodAnimal,CodFazendaManejo: Integer;
     CodAnimalManejo: String; var DadosAnimal: TDadosAnimal): Integer;
    procedure LimpaDadosAnimal(var DadosAnimal: TDadosAnimal);
  public
    constructor Create; override;
    destructor Destroy; override;

    function ProximoCodReprodutorMultiplo: Integer;
    function Inserir(CodFazendaManejo : Integer;CodReprodutorMultiploManejo : String;CodEspecie : Integer; TxtObservacao : String): Integer;
    function Excluir(CodReprodutorMultiplo : Integer): Integer;
    function AdicionarTouro(CodReprodutorMultiplo,CodAnimal,CodFazendaManejo : Integer;CodAnimalManejo : String;DtaInicioUso, DtaFimUso: TDateTime): Integer;
    function Copiar(CodReprodutorMultiplo,CodFazendaManejo : Integer;CodReprodutorMultiploManejo : String): Integer;
    function Pesquisar(CodFazendaManejo,CodEspecie: Integer;IndAtivo : String;CodAnimal,CodFazendaManejoAnimal : Integer;CodAnimalManejo: String) : Integer;
    function Buscar(CodReprodutorMultiplo : Integer): Integer;
    function Alterar(CodReprodutorMultiplo : Integer;CodReprodutorMultiploManejo,TxtObservacao : String): Integer;
    function Ativar(CodReprodutorMultiplo : Integer): Integer;
    function Desativar(CodReprodutorMultiplo : Integer): Integer;
    function RetirarTouro(CodReprodutorMultiplo,CodAnimal : Integer): Integer;
    function PesquisarTouros(CodReprodutorMultiplo: Integer): Integer;
    function AdicionarTouros(CodReprodutorMultiplo: Integer; CodAnimais: String;
      CodFazendaManejo: Integer; CodAnimaisManejo: String;DtaInicioUso, DtaFimUso: TDateTime): Integer;
    function RetirarTouros(CodReprodutorMultiplo: Integer; CodAnimais: String;
      CodFazendaManejo: Integer; CodAnimaisManejo: String): Integer;

    property IntReprodutorMultiplo : TIntReprodutorMultiplo read FIntReprodutorMultiplo write FIntReprodutorMultiplo;
  end;

implementation

constructor TIntReprodutoresMultiplos.Create;
begin
  inherited;
  FIntReprodutorMultiplo := TIntReprodutorMultiplo.Create;
end;

destructor TIntReprodutoresMultiplos.Destroy;
begin
  FIntReprodutorMultiplo.Free;
  inherited;
end;

function TIntReprodutoresMultiplos.VerificaNumLetra(Valor: String;
  Tamanho: Integer; NomParametro: String): Integer;
var
  X : Integer;
begin
  Result := 0;
  If Length(Valor) > Tamanho Then Begin
    Mensagens.Adicionar(537, Self.ClassName, 'VerificaNumLetra', [NomParametro, IntToStr(Tamanho)]);
    Result := -537;
    Exit;
  End;

  For X := 1 to Length(Valor) do Begin
    If Pos(Copy(Valor, X, 1), '0123456789ABCDEFGHIJKLMNOPQRSTUVXYWZ') = 0 Then Begin
      Mensagens.Adicionar(538, Self.ClassName, 'VerificaNumLetra', [NomParametro]);
      Result := -538;
      Exit;
    End;
  End;
end;

function TIntReprodutoresMultiplos.VerificaCodReprodutorMultiploManejo(
  CodAnimalManejo: String): Integer;
begin
  If Trim(CodAnimalManejo) = '' Then Begin
    Mensagens.Adicionar(1199, Self.ClassName, 'VerificaCodReprodutorMultiploManejo', []);
    Result := -1199;
    Exit;
  End;
  Result := VerificaNumLetra(CodAnimalManejo, Conexao.QtdCaracteresManejoProdutor, 'Código de manejo do reprodutor múltiplo');
end;

function TIntReprodutoresMultiplos.Inserir(CodFazendaManejo : Integer;CodReprodutorMultiploManejo : String;CodEspecie : Integer; TxtObservacao : String): Integer;
Const
  CodMetodo : Integer = 359;
  NomeMetodo : String = 'Inserir';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;

  Try
    // Retorna código do registro inserido
    Result := InserirInt(CodFazendaManejo ,CodReprodutorMultiploManejo,CodEspecie,TxtObservacao, 2);
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1159, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1159;
      Exit;
    End;
  End;
end;

function TIntReprodutoresMultiplos.InserirInt(CodFazendaManejo : Integer;CodReprodutorMultiploManejo : String;CodEspecie : Integer; TxtObservacao : String;CodTipoAcesso : Integer): Integer;
var
  Q : THerdomQuery;
  CodReprodutorMultiplo,NroMaxRM : Integer;
  IndAtivo : String;
Const
  NomMetodo : String = 'Inserir';
begin
  result := -1;
  IndAtivo := 'S';
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  //-----------------
  //Valida Observacao
  //-----------------
  Result := TrataString(TxtObservacao,255,'Observação do produtor múltiplo');
  If Result < 0 Then Begin
    Exit;
  End;

  // Valida código de manejo informado
  CodReprodutorMultiploManejo := UpperCase(CodReprodutorMultiploManejo);
  Result := VerificaCodReprodutorMultiploManejo(CodReprodutorMultiploManejo);
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------------------------------------
      //Verifica o número máximo de RM ATIVOS por fazenda
      //-------------------------------------------------
      NroMaxRM := StrToInt(valorParametro(26));

      result := ObterNroMaxRM(CodFazendaManejo);
      if result < 0 then  exit;

      if result > NroMaxRM Then Begin
        if CodTipoAcesso = 1 then begin
          Mensagens.Adicionar(1160, Self.ClassName, NomMetodo, [IntToStr(CodFazendaManejo)]);
          Result := -1160;
          Exit;
        end else begin
          Mensagens.Adicionar(1175, Self.ClassName, NomMetodo, [IntToStr(CodFazendaManejo)]);
          IndAtivo :='N';
        end;
      End;
      Q.Close;

      //------------------------------------
      // Verifica a existência do CodEspecie
      //------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_especie ' +
                ' where cod_especie = :cod_especie ' +
                '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_especie').AsInteger := CodEspecie;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.clear;
        Mensagens.Adicionar(542, Self.ClassName, NomMetodo, []);
        Result := -542;
        Exit;
      End;
      Q.Close;
      //------------------------------------------
      // Verifica a existência do CodFazendaManejo
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_fazenda = :cod_fazenda_manejo ' +
                '   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.clear;
        Mensagens.Adicionar(310, Self.ClassName, NomMetodo, []);
        Result := -310;
        Exit;
      End;
      Q.Close;

      //------------------------------------------------------------------
      // Verifica duplicidade do CodFazendaManejo / CodReprodutorMultiplo
      //------------------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_reprodutor_multiplo '+
      ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
      '   and cod_fazenda_manejo = :cod_fazenda_manejo '+
      '   and cod_reprodutor_multiplo_manejo = :cod_reprodutor_multiplo_manejo '+
      ' union '+
      'select 1 from tab_animal '+
      ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
      '   and cod_fazenda_manejo = :cod_fazenda_manejo '+
      '   and cod_animal_manejo = :cod_reprodutor_multiplo_manejo '+
      '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
      Q.ParamByName('cod_reprodutor_multiplo_manejo').AsString := CodReprodutorMultiploManejo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.clear;
        Mensagens.Adicionar(1158, Self.ClassName, NomMetodo, []);
        Result := -1158;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      //-----------------------
      // Pega próximo código
      //-----------------------
      CodReprodutorMultiplo := ProximoCodReprodutorMultiplo;

      //-----------------------
      // Tenta Inserir Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_reprodutor_multiplo ' +
      ' (cod_pessoa_produtor, ' +
      '  cod_reprodutor_multiplo, ' +
      '  cod_fazenda_manejo, ' +
      '  cod_reprodutor_multiplo_manejo , ' +
      '  cod_especie  , ' +
      '  txt_observacao , ' +
      '  ind_ativo , ' +
      '  dta_cadastramento ) ' +
      'values ( ' +
      '  :cod_pessoa_produtor, ' +
      '  :cod_reprodutor_multiplo, ' +
      '  :cod_fazenda_manejo, ' +
      '  :cod_reprodutor_multiplo_manejo , ' +
      '  :cod_especie  , ' +
      '  :txt_observacao , ' +
      '  :ind_ativo , ' +
      '  getdate() ) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger            := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger        := CodReprodutorMultiplo;
      Q.ParamByName('cod_fazenda_manejo').AsInteger             := CodFazendaManejo;
      Q.ParamByName('cod_reprodutor_multiplo_manejo').AsString  := CodReprodutorMultiploManejo;
      Q.ParamByName('cod_especie').AsInteger                    := CodEspecie;
      if Trim(TxtObservacao)='' then begin
        Q.ParamByName('txt_observacao').DataType := ftString;
        Q.ParamByName('txt_observacao').Clear;
      end
      else begin
        Q.ParamByName('txt_observacao').asString := TxtObservacao;
      end;
      Q.ParamByName('ind_ativo').asString := IndAtivo;
      Q.ExecSQL;

      // Cofirma transação
      Commit;
      // Retorna código do registro inserido
      Result := CodReprodutorMultiplo;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.clear;
        Mensagens.Adicionar(1159, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1159;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.ProximoCodReprodutorMultiplo: Integer;
var
  Q : THerdomQuery;
Const
  NomMetodo : String = 'ProximoCodReprodutorMultiplo';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('NomMetodo');
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try

    // Obtem sequencia de CodAnimal
    BeginTran('OBTER_PROXIMO_CODIGO_ANIMAL');
    Try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_sequencia_codigo ' +
                '   set cod_animal = cod_animal + 1');
{$ENDIF}
      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_animal from tab_sequencia_codigo');
{$ENDIF}
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(206, Self.ClassName,NomMetodo, []);
        Result := -206;
        Rollback;
        Exit;
      End;

      Result := Q.FieldByName('cod_animal').AsInteger;
      Q.Close;

      // Confirma Transação
      Commit('OBTER_PROXIMO_CODIGO_ANIMAL');
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(207, Self.ClassName, NomMetodo, [E.Message]);
        Result := -207;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.Excluir(CodReprodutorMultiplo: Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo : Integer = 360;
  NomMetodo : String ='Excluir';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //-----------------------------------
      // Verifica a existência do registro
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_reprodutor_multiplo ');
      Q.SQL.Add(' where  cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add(' and    cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1176, Self.ClassName, NomMetodo, []);
        Result := -1176;
        Exit;
      End;
      Q.Close;

      //------------------------------------------------------
      // Verifica se não existe nenhum animal nascido deste RM
      //------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select  1 from tab_animal ');
      Q.SQL.Add('  where  cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('    and  cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1177, Self.ClassName, NomMetodo, []);
        Result := -1177;
        Exit;
      End;
      Q.Close;

      //---------------------------------------------
      // Verifica se não existe  eventos para esse RM
      //---------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select  1 from tab_evento_cobertura_rm ');
      Q.SQL.Add('  where  cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('    and  cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1178, Self.ClassName, NomMetodo, []);
        Result := -1178;
        Exit;
      End;
      Q.Close;

      //Abre transação
      BeginTran;

      //--------------------------------
      // Exclui os registros filhos  RM
      //--------------------------------
      Q.Close;
      Q.SQL.Clear;
  {$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_animal_reprodutor_multiplo ');
      Q.SQL.Add('  where  cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('    and  cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
  {$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.ExecSQL;

      //--------------------------
      // Exclui o registro pai RM
      //--------------------------
      Q.Close;
      Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_reprodutor_multiplo');
      Q.SQL.Add('  where  cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('    and  cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
  {$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1179, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1179;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.ObterNroMaxRM(CodFazendaManejo: Integer): Integer;
var
  Q : THerdomQuery;
Const
  NomMetodo : String = 'ObterNroMaxRm';
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //--------------------------
      //Obtem Número Maximo de RM
      //--------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select count(*) as QtdReprodutor from tab_reprodutor_multiplo ');
      Q.SQL.Add(' where cod_fazenda_manejo = :cod_fazenda_manejo ');
      Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and ind_ativo = ''S''');
{$ENDIF}
      Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      result := Q.FieldByName('QtdReprodutor').asInteger;
      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(496, Self.ClassName, NomMetodo, [E.Message, 'número máximo de RM ativos']);
        Result := -496;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.AdicionarTouro(CodReprodutorMultiplo,CodAnimal,CodFazendaManejo : Integer;CodAnimalManejo : String;
 DtaInicioUso, DtaFimUso: TDateTime): Integer;
var
  Q : THerdomQuery;
  CodEspecieRM,CodFazendaManejoRM : Integer;
  IndInserir: String;
Const
  NomMetodo : String = 'AdicionarTouro';
  CodMetodo : Integer = 365;
begin
  result := 0;
  IndInserir := 'S';
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  //verifica a Data de início e fim de uso
  if DtaFimUso < DtaInicioUso then begin
    Mensagens.Adicionar(1601, Self.ClassName, NomMetodo, []);
    Result := -1601;
    Exit;
  End;

  //----------------------------------------------------------------
  //Informar o CodAnimal ou (CodFazendaManejoManejo/CodAnimalManejo)
  //----------------------------------------------------------------
  if CodAnimal > 0 then begin
    if (CodFazendaManejo > 0 ) or (trim(CodAnimalManejo) <> '') then begin
      Mensagens.Adicionar(1181, Self.ClassName, NomMetodo, []);
      Result := -1181;
      Exit;
    end;
  end
  else if (CodFazendaManejo < 0 ) or (trim(CodAnimalManejo) = '') then begin
      Mensagens.Adicionar(1182, Self.ClassName, NomMetodo, []);
      Result := -1182;
      Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica a existência do RM
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select cod_especie, cod_fazenda_manejo from tab_reprodutor_multiplo ' +
                '  where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '    and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1176, Self.ClassName, NomMetodo, []);
        Result := -1176;
        Exit;
      End;
      CodEspecieRM        := Q.fieldByName('cod_especie').AsInteger;
      CodFazendaManejoRM  := Q.fieldByName('cod_fazenda_manejo').AsInteger;
      Q.Close;

      //----------------------------------------------------------
      // Verifica se existe algum evento para o RM(Vacas coberta)
      //---------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(sum(te.qtd_animais), 0) as qtd_vacas ' +
                '  from tab_evento_cobertura_rm tecr, tab_evento te ' +
                ' where te.cod_pessoa_produtor = tecr.cod_pessoa_produtor ' +
                '   and te.cod_evento = tecr.cod_evento ' +
                '   and tecr.cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and tecr.cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');

{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger     := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      If Q.FieldByName('qtd_Vacas').asInteger > 0 Then Begin
        Mensagens.Adicionar(1183, Self.ClassName, NomMetodo, []);
        Result := -1183;
        Exit;
      End;
      Q.Close;

      //-----------------------------------------------------------
      // Verifica a existência do CodFazendaManejo se for informado
      //-----------------------------------------------------------
      if CodFazendaManejo > 0 then begin
          Q.SQL.Clear;
    {$IFDEF MSSQL}
          Q.SQL.Add('select 1 from tab_fazenda ' +
                    ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                    '   and cod_fazenda = :cod_fazenda_manejo ' +
                    '   and dta_fim_validade is null');
    {$ENDIF}
          Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
          Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
          Q.Open;
          If Q.IsEmpty Then Begin
            Mensagens.Adicionar(310, Self.ClassName, NomMetodo, []);
            Result := -310;
            Exit;
          End;
          Q.Close;
      end;
      //-------------------------
      // Busca o codigo do Animal
      //-------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_animal,cod_especie,cod_fazenda_corrente,cod_categoria_animal from tab_animal ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      if CodAnimal = -1 then begin
        Q.SQL.Add('   and cod_fazenda_manejo = :cod_fazenda_manejo ' +
                  '   and cod_animal_manejo = :cod_animal_manejo ')
      end else begin
        Q.SQL.Add('   and cod_animal = :cod_animal ');
      end;
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      if (Conexao.CodPapelUsuario = 3) then begin
      Q.SQL.Add('   and (cod_pessoa_tecnico = :cod_pessoa_tecnico or cod_pessoa_tecnico is null) ');
      end;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      if CodAnimal = -1 then begin
        Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
        Q.ParamByName('cod_animal_manejo').AsString := CodAnimalManejo;
      end else begin
        Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      end;
      if (Conexao.CodPapelUsuario = 3) then begin
        Q.ParamByName('cod_pessoa_tecnico').AsInteger := Conexao.CodPessoa;
      end;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(679, Self.ClassName, NomMetodo, []);
        Result := -679;
        Exit;
      End;
      CodAnimal := Q.FieldByName('cod_animal').asInteger;

      //------------------------------------------
      // Verifica se a categoria do animal é touro
      //------------------------------------------
      if Q.FieldByName('cod_categoria_animal').asInteger <> 4 then begin
        Mensagens.Adicionar(1184, Self.ClassName, NomMetodo, []);
        Result := -1184;
        Exit;
      end;
      //-------------------------------------------------
      // Verifica se a espécie do animal é a mesma do RM
      //-------------------------------------------------
      if Q.FieldByName('cod_especie').asInteger <> CodEspecieRM then begin
        Mensagens.Adicionar(1185, Self.ClassName, NomMetodo, []);
        Result := -1185;
        Exit;
      end;
      //---------------------------------------------------------------------------
      // Verifica se a Fazenda Corrente do animal é a mesma da Fazenda Manejo do RM
      //---------------------------------------------------------------------------
      if Q.FieldByName('cod_fazenda_corrente').asInteger <> CodFazendaManejoRM then begin
        Mensagens.Adicionar(1186, Self.ClassName, NomMetodo, []);
        Result := -1186;
        Exit;
      end;
      Q.Close;

      //-----------------------------------------------------------
      // Verifica se o touro já participa de outro RM nesse período
      //-----------------------------------------------------------
      Q.SQL.Clear;
      Q.SQL.Add(' select 1 from tab_animal_reprodutor_multiplo ' +
                '  where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '    and cod_reprodutor_multiplo != :cod_reprodutor_multiplo ' +
                '    and cod_animal = :cod_animal '+
                '    and (dta_inicio_uso between :dta_inicio and :dta_fim or '+
                '         dta_fim_uso between :dta_inicio and :dta_fim '+
                '         or (dta_inicio_uso <= :dta_inicio and dta_fim_uso >= :dta_fim)) ');
      Q.Parambyname('cod_pessoa_produtor').asinteger := Conexao.CodProdutorTrabalho;
      Q.Parambyname('cod_reprodutor_multiplo').asinteger := CodReprodutorMultiplo;
      Q.Parambyname('cod_animal').asinteger := CodAnimal;
      Q.Parambyname('dta_inicio').asdatetime := DtaInicioUso;
      Q.Parambyname('dta_fim').asdatetime := DtaFimUso;
      Q.Open;
      If not Q.IsEmpty then begin
        Mensagens.Adicionar(1592, Self.ClassName, NomMetodo, []);
        Result := -1592;
        Exit;
      end;

      //--------------------------------
      // Verifica a duplicidade do Touro
      //---------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select 1 from tab_animal_reprodutor_multiplo ' +
                '  where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '    and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ' +
                '    and cod_animal = :cod_animal ');

{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      Q.Open;
      If not Q.IsEmpty Then Begin
        IndInserir := 'N';
      End;
      Q.Close;

      {
      //================
      // Fábio 16/02/2004:
      // Verificação removida conforme soliciatdo por Graciele.

      //verifica se o RM está participando de um evento de monta
      Q.SQL.Clear;
      Q.SQL.Add(' select te.dta_inicio, te.dta_fim '+
                ' from tab_evento_cobertura_reg_pasto tem, ' +
                '      tab_evento te '+
                '  where tem.cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '    and tem.cod_reprodutor_multiplo = :cod_reprodutor_multiplo '+
                '    and te.cod_pessoa_produtor = tem.cod_pessoa_produtor '+
                '    and te.cod_evento = tem.cod_evento ');
      Q.ParamByName('cod_pessoa_produtor').asinteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').asinteger := CodReprodutorMultiplo;
      Q.Open;
      if not Q.isEmpty then begin
        //verifica se a data de início e fim de uso do RM dão compatíveis com o evento de monta
        if not (((DtaInicioUso >= Q.Fieldbyname('dta_inicio').asdatetime) and (DtaInicioUso <= Q.Fieldbyname('dta_fim').asdatetime))
                or ((DtaFimUso >= Q.Fieldbyname('dta_inicio').asdatetime) and (DtaFimUso <= Q.Fieldbyname('dta_fim').asdatetime))
                or ((DtaInicioUso <= Q.FieldByname('dta_inicio').asdatetime) and (DtaFimUso >= Q.FieldbyName('dta_fim').asdatetime))) then begin
           Mensagens.Adicionar(1595, Self.ClassName, NomMetodo, []);
           Result := -1595;
           Exit;
        end;
      end;
      }

      //---------------
      // Abre transação
      //---------------
      BeginTran;

      if IndInserir = 'S' then begin
        //--------------------
        // Tenta Inserir Touro
        //--------------------
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_animal_reprodutor_multiplo ' +
        ' (   cod_pessoa_produtor ' +
        '   , cod_reprodutor_multiplo ' +
        '   , cod_animal  ' +
        '   , dta_inicio_uso  ' +
        '   , dta_fim_uso ) ' +
        'values ( ' +
        '     :cod_pessoa_produtor ' +
        '   , :cod_reprodutor_multiplo ' +
        '   , :cod_animal  ' +
        '   , :dta_inicio_uso  ' +
        '   , :dta_fim_uso ) ');
{$ENDIF}
      end else begin
        //--------------------
        // Tenta Inserir Touro
        //--------------------
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_animal_reprodutor_multiplo ' +
        ' set ' +
        '   dta_inicio_uso =:dta_inicio_uso ' +
        '   , dta_fim_uso =:dta_fim_uso ' +
        ' where ' +
        '   cod_pessoa_produtor = :cod_pessoa_produtor and ' +
        '   cod_reprodutor_multiplo = :cod_reprodutor_multiplo and ' +
        '   cod_animal = :cod_animal  ');
{$ENDIF}
      end;
      Q.ParamByName('cod_pessoa_produtor').AsInteger       := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger   := CodReprodutorMultiplo;
      Q.ParamByName('cod_animal').AsInteger                := CodAnimal;
      Q.ParamByName('dta_inicio_uso').AsDateTime           := DtaInicioUso;
      Q.ParamByName('dta_fim_uso').AsDateTime              := DtaFimUso;
      Q.ExecSQL;
      // Cofirma transação
      Commit;

    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1190, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1190;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.Copiar(CodReprodutorMultiplo,CodFazendaManejo : Integer;CodReprodutorMultiploManejo : String): Integer;
var
  Q : THerdomQuery;
  CodEspecieOr,CodReprodutorMultiploNovo,NroMaxTouro : Integer;
  CodReprodutorMultiploManejoOr, ErroFazendaCorrente,ErroTouroAtivo : String;
Const
  NomMetodo : String = 'Copiar';
  CodMetodo : Integer = 361;
begin
  result := 0;
  ErroFazendaCorrente :='';
  ErroTouroAtivo := '';
  NroMaxTouro := 0;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-------------------------------------------
      // Verifica a existência do RM a ser copiado
      //-------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select cod_especie,cod_reprodutor_multiplo_manejo from tab_reprodutor_multiplo ' +
                '  where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '    and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo; //Origem
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1176, Self.ClassName, NomMetodo, []);
        Result := -1176;
        Exit;
      End;
      CodReprodutorMultiploManejoOr := Q.FieldByName('cod_reprodutor_multiplo_manejo').asString;
      CodEspecieOr := Q.FieldByName('cod_especie').asInteger;
      Q.Close;

      //------------------------------------------
      // Verifica a existência do CodFazendaManejo
      //------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_fazenda ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_fazenda = :cod_fazenda_manejo ' +
                '   and dta_fim_validade is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(310, Self.ClassName, NomMetodo, []);
        Result := -310;
        Exit;
      End;
      Q.Close;

      //---------------
      // Abre transação
      //---------------
      BeginTran;

      Result:= InserirInt(CodFazendaManejo,CodReprodutorMultiploManejo,CodespecieOr,'Copiado do reprodutor manejo:' + CodReprodutorMultiploManejoOr,2);

      if Result < 0 then begin
        Rollback;  // desfaz transação se houver uma ativa
        exit;
      end;
      CodReprodutorMultiploNovo := result;
      //----------------------
      // Busca os touros do RM
      //----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ta.cod_animal, ta.cod_animal_manejo, tarm.dta_inicio_uso, tarm.dta_fim_uso '+
                ' from tab_animal_reprodutor_multiplo tarm, tab_animal ta ' +
                ' where tarm.cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and tarm.cod_reprodutor_multiplo = :cod_reprodutor_multiplo ' +
                '   and ta.cod_pessoa_produtor = tarm.cod_pessoa_produtor ' +
                '   and ta.cod_animal = tarm.cod_animal ');

{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      
      If Q.IsEmpty Then Begin
        Rollback;  // desfaz transação se houver uma ativa
        Mensagens.Adicionar(1192, Self.ClassName, NomMetodo, []);
        Result := -1192;
        Exit;
      End;
      //---------------------------------
      // Associa os touros com o novo RM
      //---------------------------------
      while not Q.Eof do begin
        result := AdicionarTouro(CodReprodutorMultiploNovo,Q.FieldByName('cod_animal').asInteger,-1,'',Q.FieldByName('dta_inicio_uso').asdatetime, Q.FieldByname('dta_fim_uso').asdatetime);
        if result < 0 then begin
          //-------------------------------------------------------------------------
          //Verifica se a fazenda corrente do Touro é a mesma da fazenda Manejo do RM
          //-------------------------------------------------------------------------
          if result = -1186 then begin
            ErroFazendaCorrente := ErroFazendaCorrente + Q.FieldByName('cod_animal_manejo').AsString + ',';
            //-----------------------------------------------------
            //Deleta a mensagem adicionado no metodo AdicionarTouro
            //-----------------------------------------------------
            Mensagens.Delete(Mensagens.Count-1);
          end else if result = -679 then begin
            ErroTouroAtivo := ErroTouroAtivo + Q.FieldByName('cod_animal_manejo').AsString + ',';
            //-----------------------------------------------------
            //Deleta a mensagem adicionado no metodo AdicionarTouro
            //-----------------------------------------------------
            Mensagens.Delete(Mensagens.Count-1);
          end else begin
            Rollback;  // desfaz transação se houver uma ativa
            Exit;
          end;
        end else NroMaxTouro := NroMaxTouro + 1;
        Q.Next;
      end;
      Q.Close;

      if trim(ErroFazendaCorrente) <> '' then begin
        ErroFazendaCorrente := copy(ErroFazendaCorrente,1,length(ErroFazendaCorrente)-1);
        Mensagens.Adicionar(1193, Self.ClassName, NomMetodo, [ErroFazendaCorrente]);
      end;
      if trim(ErroTouroAtivo) <> '' then begin
        ErroTouroAtivo := copy(ErroTouroAtivo,1,length(ErroTouroAtivo)-1);
        Mensagens.Adicionar(1194, Self.ClassName, NomMetodo, [ErroTouroAtivo]);
      end;

      if NroMaxTouro > 0 then
        Commit
      else begin
        Rollback;
        Mensagens.Adicionar(1195, Self.ClassName, NomMetodo, []);
      end;
      result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1191, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1191;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.Pesquisar(CodFazendaManejo,CodEspecie: Integer;IndAtivo : String;CodAnimal,CodFazendaManejoAnimal : Integer;CodAnimalManejo: String) : Integer;
Const
  CodMetodo  : Integer = 369; 
  NomMetodo : String = 'Pesquisar';
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
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  //----------------------------------------------------------------
  //Informar o CodAnimal ou (CodFazendaManejoManejo/CodAnimalManejo)
  //----------------------------------------------------------------
  if (CodFazendaManejoAnimal > 0 ) or (trim(CodAnimalManejo) <> '') or (CodAnimal > 0) then begin
    if CodAnimal > 0 then begin
      if (CodFazendaManejoAnimal > 0 ) or (trim(CodAnimalManejo) <> '') then begin
        Mensagens.Adicionar(1181, Self.ClassName, NomMetodo, []);
        Result := -1181;
        Exit;
      end;
    end
    else if (CodFazendaManejoAnimal < 0 ) or (trim(CodAnimalManejo) = '') then begin
        Mensagens.Adicionar(1182, Self.ClassName, NomMetodo, []);
        Result := -1182;
        Exit;
    end;
  end;

  if CodEspecie =-1 then begin
    Mensagens.Adicionar(542, Self.ClassName, NomMetodo, []);
    Result := -542;
    Exit;
  end;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tr.cod_pessoa_produtor as CodPessoaProdutor ' +
                '     , tr.cod_reprodutor_multiplo as CodReprodutorMultiplo ' +
                '     , tf.cod_fazenda as CodFazendaManejo ' +
                '     , tf.sgl_fazenda as SglFazendaManejo ' +
                '     , tr.cod_reprodutor_multiplo_manejo as CodReprodutorMultiploManejo ' +
                '     , te.sgl_especie as SglEspecie ' +
                '     , tr.ind_ativo as IndAtivo ');
  if (CodFazendaManejoAnimal > 0) or (CodAnimal > 0) then begin
    Query.SQL.Add(' , tar.dta_inicio_uso as DtaInicioUso ' +
                  ' , tar.dta_fim_uso as DtaFimUso ');
  end;
  Query.SQL.Add('  from tab_reprodutor_multiplo tr ' +
                '     , tab_especie te ' +
                '     , tab_fazenda tf ');
  if (CodFazendaManejoAnimal > 0) or (CodAnimal > 0) then begin
     Query.SQL.Add(' , tab_animal  ta ' +
                   ' , tab_animal_reprodutor_multiplo tar ');
  end;
  Query.SQL.Add(' where te.cod_especie = tr.cod_especie ' +
                '   and tr.Cod_especie = :Cod_especie' +
                '   and tf.cod_pessoa_produtor = tr.cod_pessoa_produtor' +
                '   and tf.cod_fazenda = tr.cod_fazenda_manejo ' +
                '   and ((tr.cod_fazenda_manejo = :cod_fazenda_manejo_reprodutor) or (:cod_fazenda_manejo_reprodutor = -1)) ' +
                '   and tr.cod_pessoa_produtor = :cod_pessoa_produtor');
  if IndAtivo = 'S' then
    Query.SQL.Add('   and tr.ind_ativo =''S'' ')
  else if IndAtivo = 'N' then
    Query.SQL.Add('   and tr.ind_ativo =''N'' ');

      if (CodFazendaManejoAnimal > 0) or (CodAnimal > 0) then begin
        Query.SQL.Add('   and tar.cod_pessoa_produtor = tr.cod_pessoa_produtor ' +
                      '   and tar.cod_reprodutor_multiplo = tr.cod_reprodutor_multiplo ' +
                      '   and ta.cod_pessoa_produtor = tar.cod_pessoa_produtor ' +
                      '   and ta.cod_animal = tar.cod_animal ' +
                      '   and ta.dta_fim_validade is null ');
      end;
      if CodFazendaManejoAnimal > 0 then begin
        Query.SQL.Add('   and ta.cod_fazenda_manejo = :cod_fazenda_manejo_animal ' +
                      '   and ta.cod_animal_manejo = :cod_animal_manejo ');
      end else if CodAnimal > 0  then begin
        Query.SQL.Add('   and ta.cod_animal = :cod_animal ');
      end;
{$ENDIF}
      Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Query.ParamByName('cod_fazenda_manejo_reprodutor').AsInteger := CodFazendaManejo;
      Query.ParamByName('cod_especie').AsInteger := CodEspecie;
      if CodFazendaManejoAnimal > 0 then begin
        Query.ParamByName('cod_fazenda_manejo_animal').AsInteger := CodFazendaManejoAnimal;
        Query.ParamByName('cod_animal_manejo').AsString := CodAnimalManejo;
      end else if CodAnimal > 0 then begin
        Query.ParamByName('cod_animal').AsInteger := CodAnimal;
      end;
  Try
//    Query.sql.SaveToFile('c:\rm.sql');
    Query.Open;

    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1196, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1196;
      Exit;
    End;
  End;
end;

function TIntReprodutoresMultiplos.Buscar(CodReprodutorMultiplo : Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo : Integer = 368;
  NomMetodo : String = 'Buscar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tr.cod_pessoa_produtor as CodPessoaProdutor ' +
                '     , tr.cod_reprodutor_multiplo as CodReprodutorMultiplo ' +
                '     , tf.cod_fazenda as CodFazendaManejo ' +
                '     , tf.sgl_fazenda as SglFazendaManejo ' +
                '     , tf.nom_fazenda as NomFazendaManejo ' +
                '     , tr.cod_reprodutor_multiplo_manejo as CodReprodutorMultiploManejo ' +
                '     , te.cod_especie as CodEspecie ' +
                '     , te.sgl_especie as SglEspecie ' +
                '     , te.des_especie as DesEspecie ' +
                '     , tr.txt_observacao as TxtObservacao ' +
                '     , tr.ind_ativo as IndAtivo ' +
                '     , tr.dta_cadastramento as DtaCadastramento ' +
                '  from tab_reprodutor_multiplo tr ' +
                '     , tab_especie te ' +
                '     , tab_fazenda tf ' +
                ' where te.cod_especie = tr.cod_especie ' +
                '   and tf.cod_pessoa_produtor = tr.cod_pessoa_produtor' +
                '   and tf.cod_fazenda = tr.cod_fazenda_manejo ' +
                '   and tr.cod_reprodutor_multiplo = :cod_reprodutor_multiplo');
{$ENDIF}
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;

      //--------------------------------
      // Verifica existência do registro
      //--------------------------------
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1198, Self.ClassName, NomMetodo, []);
        Result := -1198;
        Exit;
      End;

      // Obtem informações do registro
      FIntReprodutorMultiplo.CodPessoaProdutor           := Q.FieldByName('codPessoaProdutor').AsInteger;
      FIntReprodutorMultiplo.CodReprodutorMultiplo       := Q.FieldByName('CodReprodutorMultiplo').AsInteger;
      FIntReprodutorMultiplo.CodFazendaManejo            := Q.FieldByName('CodFazendaManejo').AsInteger;
      FIntReprodutorMultiplo.SglFazendaManejo            := Q.FieldByName('SglFazendaManejo').AsString;
      FIntReprodutorMultiplo.NomFazendaManejo            := Q.FieldByName('NomFazendaManejo').AsString;
      FIntReprodutorMultiplo.CodReprodutorMultiploManejo := Q.FieldByName('CodReprodutorMultiploManejo').AsString;
      FIntReprodutorMultiplo.CodEspecie                  := Q.FieldByName('CodEspecie').AsInteger;
      FIntReprodutorMultiplo.SglEspecie                  := Q.FieldByName('SglEspecie').AsString;
      FIntReprodutorMultiplo.DesEspecie                  := Q.FieldByName('DesEspecie').AsString;
      FIntReprodutorMultiplo.TxtObservacao               := Q.FieldByName('TxtObservacao').AsString;
      FIntReprodutorMultiplo.IndAtivo                    := Q.FieldByName('IndAtivo').AsString;
      FIntReprodutorMultiplo.DtaCadastramento            := Q.FieldByName('DtaCadastramento').AsDateTime;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1197, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1197;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.Alterar(CodReprodutorMultiplo : Integer;CodReprodutorMultiploManejo,TxtObservacao : String): Integer;
var
  Q : THerdomQuery;
  CodFazendaManejo : Integer;
Const
  CodMetodo : Integer = 362;
  NomMetodo : String = 'Alterar';
begin
  result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  //-----------------
  //Valida Observacao
  //-----------------
  Result := TrataString(TxtObservacao,255,'Observação do produtor múltiplo');
  If Result < 0 Then Begin
    Exit;
  End;

  // Valida código de manejo informado
  CodReprodutorMultiploManejo := UpperCase(CodReprodutorMultiploManejo);
  Result := VerificaCodReprodutorMultiploManejo(CodReprodutorMultiploManejo);
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica a existência do RM
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_fazenda_manejo from tab_reprodutor_multiplo ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1176, Self.ClassName, NomMetodo, []);
        Result := -1176;
        Exit;
      End;
      CodFazendaManejo := Q.FieldByName('cod_fazenda_manejo').asInteger;
      Q.Close;

      //------------------------------------------------------------------
      // Verifica duplicidade do CodFazendaManejo / CodReprodutorMultiplo
      //------------------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_reprodutor_multiplo ' +
      ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
      '   and cod_fazenda_manejo = :cod_fazenda_manejo ' +
      '   and cod_reprodutor_multiplo_manejo = :cod_reprodutor_multiplo_manejo ' +
      '   and cod_reprodutor_multiplo != :cod_reprodutor_multiplo ' +      
      ' union ' +
      'select 1 from tab_animal ' +
      ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
      '   and cod_fazenda_manejo = :cod_fazenda_manejo ' +
      '   and cod_animal_manejo = :cod_reprodutor_multiplo_manejo ' +
      '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
      Q.ParamByName('cod_reprodutor_multiplo_manejo').AsString := CodReprodutorMultiploManejo;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1158, Self.ClassName, NomMetodo, []);
        Result := -1158;
        Exit;
      End;
      Q.Close;

      //---------------
      // Abre transação
      //----------------
      BeginTran;


      //-----------------------
      // Tenta alterar Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_reprodutor_multiplo ' +
                '   set cod_reprodutor_multiplo_manejo = :cod_reprodutor_multiplo_manejo ' +
                '     , txt_observacao  = :txt_observacao ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_reprodutor_multiplo  = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger            := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger        := CodReprodutorMultiplo;
      Q.ParamByName('cod_reprodutor_multiplo_manejo').AsString  := CodReprodutorMultiploManejo;
      if Trim(TxtObservacao)='' then begin
        Q.ParamByName('txt_observacao').DataType := ftString;
        Q.ParamByName('txt_observacao').Clear;
      end else begin
        Q.ParamByName('txt_observacao').asString := TxtObservacao;
      end;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1200, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1200;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.Ativar(CodReprodutorMultiplo : Integer): Integer;
var
  Q : THerdomQuery;
  NroMaxRM,CodFazendaManejo : Integer;
Const
  CodMetodo : Integer = 363;
  NomMetodo : String = 'Ativar';
begin
  result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica a existência do RM
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_fazenda_manejo from tab_reprodutor_multiplo ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1176, Self.ClassName, NomMetodo, []);
        Result := -1176;
        Exit;
      End;
      CodFazendaManejo := Q.fieldByName('cod_fazenda_manejo').asInteger;
      Q.Close;

      //-------------------------------------------------
      //Verifica o número máximo de RM ATIVOS por fazenda
      //-------------------------------------------------
      NroMaxRM := StrToInt(valorParametro(26));

      result := ObterNroMaxRM(CodFazendaManejo);
      if result < 0 then  exit;

      if result > NroMaxRM Then Begin
          Mensagens.Adicionar(1160, Self.ClassName, NomMetodo, [IntToStr(CodFazendaManejo)]);
          Result := -1160;
          Exit;
      End;
      Q.Close;
      //---------------
      // Abre transação
      //----------------
      BeginTran;

      //-----------------------
      // Tenta alterar Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_reprodutor_multiplo ' +
                '   set ind_ativo = ''S''' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_reprodutor_multiplo  = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger            := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger        := CodReprodutorMultiplo;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1201, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1201;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.Desativar(CodReprodutorMultiplo : Integer): Integer;
var
  Q : THerdomQuery;
Const
  CodMetodo : Integer = 364;
  NomMetodo : String = 'Desativar';
begin
  result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica a existência do RM
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_reprodutor_multiplo ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;

      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1176, Self.ClassName, NomMetodo, []);
        Result := -1176;
        Exit;
      End;
      Q.Close;

      //---------------
      // Abre transação
      //----------------
      BeginTran;

      //-----------------------
      // Tenta alterar Registro
      //-----------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_reprodutor_multiplo ' +
                '   set ind_ativo = ''N''' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and cod_reprodutor_multiplo  = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger            := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger        := CodReprodutorMultiplo;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1202, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1202;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.RetirarTouro(CodReprodutorMultiplo,CodAnimal : Integer): Integer;
var
  Q : THerdomQuery;
  Cont: Integer;
Const
  NomMetodo : String = 'RetirarTouro';
  CodMetodo : Integer = 366;
begin
  result := 0;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //----------------------------
      // Verifica a existência do RM
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select 1 from tab_reprodutor_multiplo ' +
                '  where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '    and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1176, Self.ClassName, NomMetodo, []);
        Result := -1176;
        Exit;
      End;
      Q.Close;

      //--------------------------------
      // Verifica a existência do Touro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select 1 from tab_animal_reprodutor_multiplo ' +
                '  where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '    and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ' +
                '    and cod_animal = :cod_animal ');                 
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1205, Self.ClassName, NomMetodo, []);
        Result := -1205;
        Exit;
      End;
      Q.Close;

      //----------------------------------------------------------
      // Verifica se existe algum evento para o RM(Vacas coberta)
      //---------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(sum(te.qtd_animais), 0) as qtd_vacas ' +
                '  from tab_evento_cobertura_rm tecr, tab_evento te ' +
                ' where te.cod_pessoa_produtor = tecr.cod_pessoa_produtor ' +
                '   and te.cod_evento = tecr.cod_evento ' +
                '   and tecr.cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and tecr.cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');

{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger     := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      If Q.FieldByName('qtd_Vacas').asInteger > 0 Then Begin
        Mensagens.Adicionar(1183, Self.ClassName, NomMetodo, []);
        Result := -1183;
        Exit;
      End;
      Q.Close;

      //-------------------------------------------------
      // Verificar se o RM já cobriu algum animal válido
      //-------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' + 
                '   and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ' +
                '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;

      If not Q.IsEmpty Then Begin
        //-------------------------------------
        //Obrigar que fique pelo menos um touro
        //-------------------------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add(' select 1 from tab_animal_reprodutor_multiplo ' +
                  '  where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                  '    and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
  {$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
        Q.Open;

        Cont := 0;
        while (cont <= 2)
          and (not Q.Eof) do
        begin
          Q.Next;
          Inc(Cont);
        end;

        If Cont < 2 Then Begin
          Mensagens.Adicionar(1204, Self.ClassName, NomMetodo, []);
          Result := -1204;
          Exit;
        End;
        Q.Close;
      End;

      {
      //================
      // Fábio 16/02/2004:
      // Verificação removida conforme soliciatdo por Graciele.

      //verifica se o RM está participando de um evento de monta
      Q.SQL.Clear;
      Q.SQL.Add(' select 1 from tab_evento_cobertura_reg_pasto ' +
                '  where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '    and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
      Q.ParamByName('cod_pessoa_produtor').asinteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').asinteger := CodReprodutorMultiplo;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(1591, Self.ClassName, NomMetodo, []);
        Result := -1591;
        Exit;
      end;
      }

      //---------------
      // Abre transação
      //---------------
      BeginTran;

      //--------------------
      // Tenta excluir Touro
      //--------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_animal_reprodutor_multiplo ' +
                ' where cod_pessoa_produtor     = :cod_pessoa_produtor ' +
                '   and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ' +
                '   and cod_animal              = :cod_animal ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger       := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger   := CodReprodutorMultiplo;
      Q.ParamByName('cod_animal').AsInteger                := CodAnimal;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1203, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1203;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.PesquisarTouros(CodReprodutorMultiplo: Integer): Integer;
const
  CodMetodo : Integer = 367;
  NomMetodo : String ='PesquisarTouro';
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;
  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Text := 'select ta.cod_pessoa_produtor as CodPessoaProdutor ' +
                '     , ta.cod_animal as CodAnimal '+
                '     , tf.sgl_fazenda as SglFazendaManejo '+
                '     , ta.cod_animal_manejo as CodAnimalManejo '+
                '     , ta.cod_animal_certificadora as CodCertificadora '+
                '     , case ta.cod_pais_sisbov ' +
                '       when null then null ' +
                '       else right(''000'' + cast(ta.cod_pais_sisbov as varchar(3)),3) end as CodPaisSisBov '+
                '     , case ta.cod_animal_sisbov '+
                '       when null then null ' +
                '       else right(''00'' + cast(ta.cod_estado_sisbov as varchar(2)),2) + '+
                '     CASE ta.cod_micro_regiao_sisbov WHEN 0 THEN  ' +
                '       ''00''  ' +
                '       WHEN -1 THEN  ' +
                '       ''''  ' +
                '       ELSE  ' +
                '       right(''00'' + convert(varchar(2), ta.cod_micro_regiao_sisbov), 2) ' +
                '       END + ' +
                '       right(''000000000'' + cast(ta.cod_animal_sisbov as varchar(9)),9) + '+
                '       right(''0'' + cast(ta.num_dv_sisbov as varchar(1)),1) end as CodAnimalSisBov '+
                '     , ta.cod_situacao_sisBov as CodSituacaoSisBov '+
                '     , ta.des_apelido as DesApelido '+
                '     , tr.sgl_raca as SglRaca '+
                '     , ta.ind_sexo as IndSexo '+
                '     , tto.sgl_tipo_origem as SglOrigem '+
                '     , tc.sgl_categoria_animal as SglCategoria '+
                '     , tl.sgl_local as SglLocal '+
                '     , tlt.sgl_lote as SglLote '+
                '     , tfc.sgl_fazenda as SglFazendaCorrente '+
                '     , tlu.sgl_tipo_lugar as SglTipoLugar ' +
                '     , dbo.fnt_idade(ta.dta_nascimento, getdate()) as IdadeAnimal '+
                '     , tarm.dta_inicio_uso as DtaInicioUso '+
                '     , tarm.dta_fim_uso as DtaFimUso '+
                '  from tab_animal as ta '+
                '     , tab_fazenda as tf '+
                '     , tab_fazenda as tfc '+
                '     , tab_especie as te ' +
                '     , tab_raca as tr '+
                '     , tab_tipo_origem as tto '+
                '     , tab_categoria_animal as tc '+
                '     , tab_local as tl '+
                '     , tab_lote as tlt '+
                '     , tab_tipo_lugar as tlu ' +
                '     , tab_animal_reprodutor_multiplo tarm ' +
                ' where ta.dta_fim_validade is null '+
                '   and ta.cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and ta.cod_fazenda_manejo *= tf.cod_fazenda ' +
                '   and ta.cod_pessoa_produtor *= tf.cod_pessoa_produtor '+
                '   and ta.cod_fazenda_corrente *= tfc.cod_fazenda '+
                '   and ta.cod_pessoa_produtor *= tfc.cod_pessoa_produtor ' +
                '   and ta.cod_especie = te.cod_especie ' +
                '   and ta.cod_raca = tr.cod_raca ' +
                '   and ta.cod_tipo_origem = tto.cod_tipo_origem ' +
                '   and ta.cod_categoria_animal *= tc.cod_categoria_animal ' +
                '   and ta.cod_pessoa_produtor *= tl.cod_pessoa_produtor ' +
                '   and ta.cod_fazenda_corrente *= tl.cod_fazenda ' +
                '   and ta.cod_local_corrente *= tl.cod_local ' +
                '   and ta.cod_pessoa_produtor *= tlt.cod_pessoa_produtor ' +
                '   and ta.cod_fazenda_corrente *= tlt.cod_fazenda ' +
                '   and ta.cod_lote_corrente *= tlt.cod_lote ' +
                '   and ta.cod_tipo_lugar *= tlu.cod_tipo_lugar ';
                if (Conexao.CodPapelUsuario = 3) then begin
                Query.SQL.Text := Query.SQL.Text +
                '  and (ta.cod_pessoa_tecnico = :cod_pessoa_tecnico ' +
                '       or ta.cod_pessoa_tecnico is null) ' ;
                end;
                Query.SQL.Text := Query.SQL.Text +
                '   and tarm.cod_pessoa_produtor = ta.cod_pessoa_produtor ' +
                '   and tarm.cod_animal = ta.cod_animal ' +
                '   and tarm.cod_reprodutor_multiplo = :cod_reprodutor_multiplo ';
{$ENDIF}
  Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
  Query.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
  if (Conexao.CodPapelUsuario = 3) then begin
      Query.ParamByName('cod_pessoa_tecnico').AsInteger := Conexao.CodPessoa;
  end;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1207, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1207;
      Exit;
    End;
  End;
end;

procedure TIntReprodutoresMultiplos.LimpaDadosAnimal(var DadosAnimal: TDadosAnimal);
const
  NomeMetodo : String = 'LimpaDadosAnimal';
begin
  DadosAnimal.CodAnimal            := -1;
  DadosAnimal.CodAnimalCertificadora := '';
  DadosAnimal.CodPaisSisbov        := -1;
  DadosAnimal.CodEstadoSisbov      := -1;
  DadosAnimal.CodMicroRegiaoSisbov := -1;
  DadosAnimal.CodAnimalSisbov      := -1;
  DadosAnimal.NumDVSisbov          := -1;
  DadosAnimal.CodSituacaoSisbov    := '';
  DadosAnimal.DtaIdentificacaoSisbov := 0;
  DadosAnimal.NumImovelIdentificacao := '';
  DadosAnimal.CodPropriedadeIdentificacao := -1;
  DadosAnimal.CodFazendaIdentificacao := -1;
  DadosAnimal.DtaNascimento                    := 0;
  DadosAnimal.NumImovelNascimento := '';
  DadosAnimal.CodPropriedadeNascimento := -1;
  DadosAnimal.CodFazendaNascimento := -1;
  DadosAnimal.DtaCompra := 0;
  DadosAnimal.CodPessoaSecundariaCriador := -1;
  DadosAnimal.NomAnimal := '';
  DadosAnimal.DesApelido := '';
  DadosAnimal.CodAssociacaoRaca := -1;
  DadosAnimal.CodGrauSangue := -1;
  DadosAnimal.CodEspecie           := -1;
  DadosAnimal.CodAptidao           := -1;
  DadosAnimal.CodRaca              := -1;
  DadosAnimal.CodPelagem           := -1;
  DadosAnimal.IndSexo              := '';
  DadosAnimal.CodTipoOrigem        := -1;
  DadosAnimal.CodAnimalPai         := -1;
  DadosAnimal.CodAnimalMae         := -1;
  DadosAnimal.CodAnimalReceptor    := -1;
  DadosAnimal.IndAnimalCastrado                := '';
  DadosAnimal.CodRegimeAlimentar               := -1;
  DadosAnimal.CodCategoriaAnimal               := -1;
  DadosAnimal.CodTipoLugar                     := -1;
  DadosAnimal.CodLoteCorrente                  := -1;
  DadosAnimal.CodLocalCorrente                 := -1;
  DadosAnimal.CodFazendaCorrente               := -1;
  DadosAnimal.NumImovelCorrente                := '';
  DadosAnimal.CodPropriedadeCorrente           := -1;
  DadosAnimal.NumCNPJCPFCorrente               := '';
  DadosAnimal.CodPessoaCorrente                := -1;
  DadosAnimal.CodPessoaSecundariaCorrente      := -1;
  DadosAnimal.DtaUltimoEvento                  := 0;
  DadosAnimal.DtaUltimoEventoAnterior          := 0;
  DadosAnimal.DtaAplicacaoUltimoEvento         := 0;
  DadosAnimal.DtaAplicacaoUltimoEventoAnterior := 0;
  DadosAnimal.CodRegistroLog                   := -1;
  DadosAnimal.DtaEfetivacaoCadastro            := 0;
  DadosAnimal.CodArquivoSisbov                 := -1;
  DadosAnimal.CodAnimalAssociado               := -1;
  DadosAnimal.QtdPesoAnimal                    := 0;
  DadosAnimal.NumTransponder                   := '';
  DadosAnimal.CodTipoIdentificador1            := -1;
  DadosAnimal.CodPosicaoIdentificador1         := -1;
  DadosAnimal.CodTipoIdentificador2            := -1;
  DadosAnimal.CodPosicaoIdentificador2         := -1;
  DadosAnimal.CodTipoIdentificador3            := -1;
  DadosAnimal.CodPosicaoIdentificador3         := -1;
  DadosAnimal.CodTipoIdentificador4            := -1;
  DadosAnimal.CodPosicaoIdentificador4         := -1;
  DadosAnimal.NumGta                           := '';
  DadosAnimal.DtaEmissaoGta                    := 0;
  DadosAnimal.NumNotaFiscal                    := -1;
end;

function TIntReprodutoresMultiplos.BuscaDadosAnimal(CodAnimal,CodFazendaManejo: Integer;
  CodAnimalManejo: String; var DadosAnimal: TDadosAnimal): Integer;
const
  NomeMetodo : String = 'BuscaDadosAnimal';
var
  Q : THerdomQuery;
begin
  Result := 0;
  DadosAnimal.CodAnimal            := -1;
  DadosAnimal.CodAnimalCertificadora := '';
  DadosAnimal.CodPaisSisbov        := -1;
  DadosAnimal.CodEstadoSisbov      := -1;
  DadosAnimal.CodMicroRegiaoSisbov := -1;
  DadosAnimal.CodAnimalSisbov      := -1;
  DadosAnimal.NumDVSisbov          := -1;
  DadosAnimal.CodSituacaoSisbov    := '';
  DadosAnimal.DtaIdentificacaoSisbov := 0;
  DadosAnimal.NumImovelIdentificacao := '';
  DadosAnimal.CodPropriedadeIdentificacao := -1;
  DadosAnimal.CodFazendaIdentificacao := -1;
  DadosAnimal.DtaNascimento                    := 0;
  DadosAnimal.NumImovelNascimento := '';
  DadosAnimal.CodPropriedadeNascimento := -1;
  DadosAnimal.CodFazendaNascimento := -1;
  DadosAnimal.DtaCompra := 0;
  DadosAnimal.CodPessoaSecundariaCriador := -1;
  DadosAnimal.NomAnimal := '';
  DadosAnimal.DesApelido := '';
  DadosAnimal.CodAssociacaoRaca := -1;
  DadosAnimal.CodGrauSangue := -1;
  DadosAnimal.CodEspecie           := -1;
  DadosAnimal.CodAptidao           := -1;
  DadosAnimal.CodRaca              := -1;
  DadosAnimal.CodPelagem           := -1;
  DadosAnimal.IndSexo              := '';
  DadosAnimal.CodTipoOrigem        := -1;
  DadosAnimal.CodAnimalPai         := -1;
  DadosAnimal.CodAnimalMae         := -1;
  DadosAnimal.CodAnimalReceptor    := -1;
  DadosAnimal.IndAnimalCastrado                := '';
  DadosAnimal.CodRegimeAlimentar               := -1;
  DadosAnimal.CodCategoriaAnimal               := -1;
  DadosAnimal.CodTipoLugar                     := -1;
  DadosAnimal.CodLoteCorrente                  := -1;
  DadosAnimal.CodLocalCorrente                 := -1;
  DadosAnimal.CodFazendaCorrente               := -1;
  DadosAnimal.NumImovelCorrente                := '';
  DadosAnimal.CodPropriedadeCorrente           := -1;
  DadosAnimal.NumCNPJCPFCorrente               := '';
  DadosAnimal.CodPessoaCorrente                := -1;
  DadosAnimal.CodPessoaSecundariaCorrente      := -1;
  DadosAnimal.DtaUltimoEvento                  := 0;
  DadosAnimal.DtaUltimoEventoAnterior          := 0;
  DadosAnimal.DtaAplicacaoUltimoEvento         := 0;
  DadosAnimal.DtaAplicacaoUltimoEventoAnterior := 0;
  DadosAnimal.CodRegistroLog                   := -1;
  DadosAnimal.DtaEfetivacaoCadastro            := 0;
  DadosAnimal.CodArquivoSisbov                 := -1;
  DadosAnimal.CodAnimalAssociado               := -1;
  DadosAnimal.QtdPesoAnimal                    := 0;
  DadosAnimal.NumTransponder                   := '';
  DadosAnimal.CodTipoIdentificador1            := -1;
  DadosAnimal.CodPosicaoIdentificador1         := -1;
  DadosAnimal.CodTipoIdentificador2            := -1;
  DadosAnimal.CodPosicaoIdentificador2         := -1;
  DadosAnimal.CodTipoIdentificador3            := -1;
  DadosAnimal.CodPosicaoIdentificador3         := -1;
  DadosAnimal.CodTipoIdentificador4            := -1;
  DadosAnimal.CodPosicaoIdentificador4         := -1;
  DadosAnimal.NumGta                           := '';
  DadosAnimal.DtaEmissaoGta                    := 0;
  DadosAnimal.NumNotaFiscal                    := -1;

  // Obtem dados do animal
  Q := THerdomQuery.Create(conexao, nil);
  Try
    Try

      // Verifica o país informado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_animal, ' +
                '       cod_fazenda_manejo, ' +
                '       cod_animal_manejo, ' +
                '       cod_animal_certificadora, ' +
                '       cod_pais_sisbov, ' +
                '       cod_estado_sisbov, ' +
                '       cod_micro_regiao_sisbov,' +
                '       cod_animal_sisbov, ' +
                '       num_dv_sisbov, ' +
                '       cod_situacao_sisbov, ' +
                '       dta_identificacao_sisbov, ' +
                '       num_imovel_identificacao, ' +
                '       cod_propriedade_identificacao, ' +
                '       cod_fazenda_identificacao, ' +
                '       dta_nascimento, ' +
                '       num_imovel_nascimento, ' +
                '       cod_propriedade_nascimento, ' +
                '       cod_fazenda_nascimento, ' +
                '       dta_compra, ' +
                '       cod_pessoa_secundaria_criador, ' +
                '       nom_animal, ' +
                '       des_apelido, ' +
                '       cod_associacao_raca, ' +
                '       cod_grau_sangue, ' +
                '       cod_especie, ' +
                '       cod_aptidao, ' +
                '       cod_raca, ' +
                '       cod_pelagem, ' +
                '       ind_sexo, ' +
                '       cod_tipo_origem, ' +
                '       cod_animal_pai, ' +
                '       cod_animal_mae, ' +
                '       cod_animal_receptor, ' +
                '       ind_animal_castrado, ' +
                '       cod_regime_alimentar, ' +
                '       cod_categoria_animal, ' +
                '       cod_tipo_lugar, ' +
                '       cod_lote_corrente, ' +
                '       cod_local_corrente, ' +
                '       cod_fazenda_corrente, ' +
                '       num_imovel_corrente, ' +
                '       cod_propriedade_corrente, ' +
                '       num_cnpj_cpf_corrente, ' +
                '       cod_pessoa_corrente, ' +
                '       cod_pessoa_secundaria_corrente, ' +
                '       dta_ultimo_evento, ' +
                '       dta_aplicacao_ultimo_evento, ' +
                '       num_transponder, ' +
                '       cod_tipo_identificador_1, ' +
                '       cod_posicao_identificador_1, ' +
                '       cod_tipo_identificador_2, ' +
                '       cod_posicao_identificador_2, ' +
                '       cod_tipo_identificador_3, ' +
                '       cod_posicao_identificador_3, ' +
                '       cod_tipo_identificador_4, ' +
                '       cod_posicao_identificador_4, ' +
                '       num_gta, ' +
                '       dta_emissao_gta, ' +
                '       num_nota_fiscal, ' +
                '       cod_registro_log, ' +
                '       dta_efetivacao_cadastro, ' +
                '       cod_arquivo_sisbov, ' +
                '       -1 as cod_animal_associado ' +
                '  from tab_animal ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '   and dta_fim_validade is null ');
      If CodAnimal > 0 Then Begin
        Q.SQL.Add('   and cod_animal = :cod_animal ');
      End;
      If (CodFazendaManejo > 0) or (CodAnimalManejo <> '') Then Begin
        Q.SQL.Add('   and cod_fazenda_manejo = :cod_fazenda_manejo ' +
                  '   and cod_animal_manejo = :cod_animal_manejo ');
      End;
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      If CodAnimal > 0 Then Begin
        Q.ParamByName('cod_animal').AsInteger := CodAnimal;
      End;
      If (CodFazendaManejo > 0) or (CodAnimalManejo <> '') Then Begin
        If CodFazendaManejo > 0 Then Begin
          Q.ParamByName('cod_fazenda_manejo').AsInteger := CodFazendaManejo;
        End Else Begin
          Q.ParamByName('cod_fazenda_manejo').DataType := ftInteger;
          Q.ParamByName('cod_fazenda_manejo').Clear;
        End;
        Q.ParamByName('cod_animal_manejo').AsString := CodAnimalManejo;
      End;

      Q.Open;
      If Q.IsEmpty Then Begin
         Exit;
      End;

      DadosAnimal.CodAnimal                   := Q.FieldByName('cod_animal').AsInteger;
      DadosAnimal.CodFazendaManejo            := Q.FieldByName('cod_fazenda_manejo').AsInteger;
      DadosAnimal.CodAnimalManejo             := Q.FieldByName('cod_animal_manejo').AsString;
      DadosAnimal.CodAnimalCertificadora      := Q.FieldByName('cod_animal_certificadora').AsString;
      DadosAnimal.CodPaisSisbov               := Q.FieldByName('cod_pais_sisbov').AsInteger;
      DadosAnimal.CodEstadoSisbov             := Q.FieldByName('cod_estado_sisbov').AsInteger;
      DadosAnimal.CodMicroRegiaoSisbov        := Q.FieldByName('cod_micro_regiao_sisbov').AsInteger;
      DadosAnimal.CodAnimalSisbov             := Q.FieldByName('cod_animal_sisbov').AsInteger;
      DadosAnimal.NumDVSisbov                 := Q.FieldByName('num_dv_sisbov').AsInteger;
      DadosAnimal.CodSituacaoSisbov           := Q.FieldByName('cod_situacao_sisbov').AsString;
      DadosAnimal.DtaIdentificacaoSisbov      := Trunc(Q.FieldByName('dta_identificacao_sisbov').AsDateTime);
      DadosAnimal.NumImovelIdentificacao      := Q.FieldByName('num_imovel_identificacao').AsString;
      DadosAnimal.CodPropriedadeIdentificacao := Q.FieldByName('cod_propriedade_identificacao').AsInteger;
      DadosAnimal.CodFazendaIdentificacao     := Q.FieldByName('cod_fazenda_identificacao').AsInteger;
      DadosAnimal.DtaNascimento               := Q.FieldByName('dta_nascimento').AsDateTime;
      DadosAnimal.NumImovelNascimento         := Q.FieldByName('num_imovel_nascimento').AsString;
      DadosAnimal.CodPropriedadeNascimento    := Q.FieldByName('cod_propriedade_nascimento').AsInteger;
      DadosAnimal.CodFazendaNascimento        := Q.FieldByName('cod_fazenda_nascimento').AsInteger;
      DadosAnimal.DtaCompra                   := Q.FieldByName('dta_compra').AsDatetime;
      DadosAnimal.CodPessoaSecundariaCriador  := Q.FieldByName('cod_pessoa_secundaria_criador').AsInteger;
      DadosAnimal.NomAnimal                   := Q.FieldByName('nom_animal').AsString;
      DadosAnimal.DesApelido                  := Q.FieldByName('des_apelido').AsString;
      DadosAnimal.CodAssociacaoRaca           := Q.FieldByName('cod_associacao_raca').AsInteger;
      DadosAnimal.CodGrauSangue               := Q.FieldByName('cod_grau_sangue').AsInteger;
      DadosAnimal.CodEspecie                  := Q.FieldByName('cod_especie').AsInteger;
      DadosAnimal.CodAptidao                  := Q.FieldByName('cod_aptidao').AsInteger;
      DadosAnimal.CodRaca                     := Q.FieldByName('cod_raca').AsInteger;
      DadosAnimal.CodPelagem                  := Q.FieldByName('cod_pelagem').AsInteger;
      DadosAnimal.IndSexo                     := Q.FieldByName('ind_sexo').AsString;
      DadosAnimal.CodTipoOrigem               := Q.FieldByName('cod_tipo_origem').AsInteger;
      DadosAnimal.CodAnimalPai                := Q.FieldByName('cod_animal_pai').AsInteger;
      DadosAnimal.CodAnimalMae                := Q.FieldByName('cod_animal_mae').AsInteger;
      DadosAnimal.CodAnimalReceptor           := Q.FieldByName('cod_animal_receptor').AsInteger;
      DadosAnimal.IndAnimalCastrado           := Q.FieldByName('ind_animal_castrado').AsString;
      DadosAnimal.CodRegimeAlimentar          := Q.FieldByName('cod_regime_alimentar').AsInteger;
      DadosAnimal.CodCategoriaAnimal          := Q.FieldByName('cod_categoria_animal').AsInteger;
      DadosAnimal.CodTipoLugar                := Q.FieldByName('cod_tipo_lugar').AsInteger;
      DadosAnimal.CodLoteCorrente             := Q.FieldByName('cod_lote_corrente').AsInteger;
      DadosAnimal.CodLocalCorrente            := Q.FieldByName('cod_local_corrente').AsInteger;
      DadosAnimal.CodFazendaCorrente          := Q.FieldByName('cod_fazenda_corrente').AsInteger;
      DadosAnimal.NumImovelCorrente           := Q.FieldByName('num_imovel_corrente').AsString;
      DadosAnimal.CodPropriedadeCorrente      := Q.FieldByName('cod_propriedade_corrente').AsInteger;
      DadosAnimal.NumCNPJCPFCorrente          := Q.FieldByName('num_cnpj_cpf_corrente').AsString;
      DadosAnimal.CodPessoaCorrente           := Q.FieldByName('cod_pessoa_corrente').AsInteger;
      DadosAnimal.CodPessoaSecundariaCorrente := Q.FieldByName('cod_pessoa_secundaria_corrente').AsInteger;
      DadosAnimal.DtaUltimoEvento             := Q.FieldByName('dta_ultimo_evento').AsDatetime;
      DadosAnimal.DtaAplicacaoUltimoEvento    := Q.FieldByName('dta_aplicacao_ultimo_evento').AsDatetime;
      DadosAnimal.NumTransponder              := Q.FieldByName('num_transponder').AsString;
      DadosAnimal.CodTipoIdentificador1       := Q.FieldByName('cod_tipo_identificador_1').AsInteger;
      DadosAnimal.CodPosicaoIdentificador1    := Q.FieldByName('cod_posicao_identificador_1').AsInteger;
      DadosAnimal.CodTipoIdentificador2       := Q.FieldByName('cod_tipo_identificador_2').AsInteger;
      DadosAnimal.CodPosicaoIdentificador2    := Q.FieldByName('cod_posicao_identificador_2').AsInteger;
      DadosAnimal.CodTipoIdentificador3       := Q.FieldByName('cod_tipo_identificador_3').AsInteger;
      DadosAnimal.CodPosicaoIdentificador3    := Q.FieldByName('cod_posicao_identificador_3').AsInteger;
      DadosAnimal.CodTipoIdentificador4       := Q.FieldByName('cod_tipo_identificador_4').AsInteger;
      DadosAnimal.CodPosicaoIdentificador4    := Q.FieldByName('cod_posicao_identificador_4').AsInteger;
      DadosAnimal.NumGta                      := Q.FieldByName('num_gta').AsString;
      DadosAnimal.DtaEmissaoGta               := Q.FieldByName('dta_emissao_gta').AsDateTime;
      DadosAnimal.NumNotaFiscal               := Q.FieldByName('num_nota_fiscal').AsInteger;
      DadosAnimal.CodRegistroLog              := Q.FieldByName('cod_registro_log').AsInteger;
      DadosAnimal.DtaEfetivacaoCadastro       := Q.FieldByName('dta_efetivacao_cadastro').AsDateTime;
      DadosAnimal.CodArquivoSisbov            := Q.FieldByName('cod_arquivo_sisbov').AsInteger;
      DadosAnimal.CodAnimalAssociado          := Q.FieldByName('cod_animal_associado').AsInteger;

      Q.Close;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(693, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -693;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.InserirErroOperacaoAnimal(DadosAnimal: TDadosAnimal; DtaOperacao: TDateTime;
  TxtMensagem: String; CodOperacaoCadastro, CodTipoMensagem: Integer): Integer;
const
  NomeMetodo : String = 'InserirErroOperacaoAnimal';
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(conexao, nil);
  Try
    Try

      // Abre Transação
      BeginTran;

      Q.SQL.Clear;
      if DadosAnimal.CodAnimal > 0 then begin
{$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_erro_operacao_animal ' +
                  ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                  '   and cod_animal = :cod_animal ' +
                  '   and cod_operacao_cadastro = :cod_operacao_cadastro ');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_animal').AsInteger := DadosAnimal.CodAnimal;
        Q.ParamByName('cod_operacao_cadastro').AsInteger := CodOperacaoCadastro;
        Q.ExecSQL;
      end else begin if DadosAnimal.CodAnimalManejo <> '' then
{$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_erro_operacao_animal ' +
                  ' where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                  '   and cod_animal_manejo = :cod_animal ' +
                  '   and cod_operacao_cadastro = :cod_operacao_cadastro ');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_animal').AsString := DadosAnimal.CodAnimalManejo;
        Q.ParamByName('cod_operacao_cadastro').AsInteger := CodOperacaoCadastro;
        Q.ExecSQL;
      end;

      Q.SQL.Clear;
      {$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_erro_operacao_animal ' +
                '      (cod_pessoa_produtor, ' +
                '       cod_animal, ' +
                '       cod_operacao_cadastro, ' +
                '       dta_operacao, ' +
                '       cod_tipo_mensagem, ' +
                '       txt_mensagem, ' +
                '       des_apelido, ' +
                '       cod_fazenda_manejo, ' +
                '       cod_animal_manejo, ' +
                '       cod_animal_certificadora, ' +
                '       cod_situacao_sisbov, ' +
                '       cod_pais_sisbov, ' +
                '       cod_estado_sisbov, ' +
                '       cod_micro_regiao_sisbov, ' +
                '       cod_animal_sisbov, ' +
                '       num_dv_sisbov, ' +
                '       cod_raca, ' +
                '       ind_sexo, ' +
                '       cod_tipo_origem, ' +
                '       cod_categoria_animal, ' +
                '       cod_local_corrente, ' +
                '       cod_lote_corrente, ' +
                '       cod_tipo_lugar) ' +
                'values ' +
                '      (:cod_pessoa_produtor, ');
      if DadosAnimal.CodAnimal <= 0
         then Q.SQL.Add('  null, ')
         else Q.SQL.Add('  :cod_animal, ');
      Q.SQL.Add('       :cod_operacao_cadastro, ' +
                '       :dta_operacao, ' +
                '       :cod_tipo_mensagem, ' +
                '       :txt_mensagem, ' +
                '       :des_apelido, ' +
                '       :cod_fazenda_manejo, ' +
                '       :cod_animal_manejo, ' +
                '       :cod_animal_certificadora, ' +
                '       :cod_situacao_sisbov, ' +
                '       :cod_pais_sisbov, ' +
                '       :cod_estado_sisbov, ' +
                '       :cod_micro_regiao_sisbov, ' +
                '       :cod_animal_sisbov, ' +
                '       :num_dv_sisbov, ' +
                '       :cod_raca, ' +
                '       :ind_sexo, ' +
                '       :cod_tipo_origem, ' +
                '       :cod_categoria_animal, ' +
                '       :cod_local_corrente, ' +
                '       :cod_lote_corrente, ' +
                '       :cod_tipo_lugar) ');
      {$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      if DadosAnimal.CodAnimal > 0 then
         Q.ParamByName('cod_animal').AsInteger := DadosAnimal.CodAnimal;
      Q.ParamByName('cod_operacao_cadastro').AsInteger := CodOperacaoCadastro;
      Q.ParamByName('dta_operacao').AsDateTime := DtaOperacao;
      Q.ParamByName('cod_tipo_mensagem').AsInteger := CodTipoMensagem;
      Q.ParamByName('txt_mensagem').AsMemo := TxtMensagem;
      Q.ParamByName('des_apelido').AsString := DadosAnimal.DesApelido;
      Q.ParamByName('cod_fazenda_manejo').AsInteger := DadosAnimal.CodFazendaManejo;
      Q.ParamByName('cod_animal_manejo').AsString := DadosAnimal.CodAnimalManejo;
      Q.ParamByName('cod_animal_certificadora').AsString := DadosAnimal.CodAnimalCertificadora;
      Q.ParamByName('cod_situacao_sisbov').AsString := DadosAnimal.CodSituacaoSisbov;
      Q.ParamByName('cod_pais_sisbov').AsInteger := DadosAnimal.CodPaisSisbov;
      Q.ParamByName('cod_estado_sisbov').AsInteger := DadosAnimal.CodEstadoSisbov;
      Q.ParamByName('cod_micro_regiao_sisbov').AsInteger := DadosAnimal.CodMicroRegiaoSisbov;
      Q.ParamByName('cod_animal_sisbov').AsInteger := DadosAnimal.CodAnimalSisbov;
      Q.ParamByName('num_dv_sisbov').AsInteger := DadosAnimal.NumDVSisbov;
      Q.ParamByName('cod_raca').AsInteger := DadosAnimal.CodRaca;
      Q.ParamByName('ind_sexo').AsString := DadosAnimal.IndSexo;
      Q.ParamByName('cod_tipo_origem').AsInteger := DadosAnimal.CodTipoOrigem;
      Q.ParamByName('cod_categoria_animal').AsInteger := DadosAnimal.CodCategoriaAnimal;
      Q.ParamByName('cod_local_corrente').AsInteger := DadosAnimal.CodLocalCorrente;
      Q.ParamByName('cod_lote_corrente').AsInteger := DadosAnimal.CodLoteCorrente;
      Q.ParamByName('cod_tipo_lugar').AsInteger := DadosAnimal.CodTipoLugar;
      Q.ExecSQL;

      Commit;
      Result := 100;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1004, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1004;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.AdicionarTouros(
  CodReprodutorMultiplo: Integer; CodAnimais: String;
  CodFazendaManejo: Integer; CodAnimaisManejo: String;
  DtaInicioUso, DtaFimUso: TDateTime): Integer;
var
  Q : THerdomQuery;
  I, tipo : Integer;
  TotProc, ErrProc: Integer;
  CodAnimalAux, Aux : String;
  DadosAnimal :TdadosAnimal;
Const
  NomMetodo : String = 'AdicionarTouros';
  CodMetodo : Integer = 417;
begin
  TotProc := 0;
  ErrProc := 0;
  I:=1;
  tipo:= 0;
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  //----------------------------------------------------------------
  //Informar o CodAnimal ou (CodFazendaManejoManejo/CodAnimalManejo)
  //----------------------------------------------------------------
  if CodAnimais <> '' then begin
    if (CodFazendaManejo > 0 ) or (trim(CodAnimaisManejo) <> '') then begin
      Mensagens.Adicionar(1181, Self.ClassName, NomMetodo, []);
      Result := -1181;
      Exit;
    end;
  end
  else if (CodFazendaManejo < 0 ) or (trim(CodAnimaisManejo) = '') then begin
      Mensagens.Adicionar(1182, Self.ClassName, NomMetodo, []);
      Result := -1182;
      Exit;
  end;
  if CodAnimais <> '' then begin
     tipo := 1; //códigos dos Animais
     CodAnimalAux := CodAnimais;
  end;
  if CodAnimaisManejo <> '' then begin
     tipo := 2; //códigos manejos dos animais
     CodAnimalAux := CodAnimaisManejo;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.Close;
      //----------------------------
      // Verifica a existência do RM
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select cod_especie, cod_fazenda_manejo from tab_reprodutor_multiplo ' +
                '  where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '    and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1176, Self.ClassName, NomMetodo, []);
        Result := -1176;
        Exit;
      End;

      Q.Close;
      Q.SQL.Clear;
      if tipo = 1 then
         Q.SQL.Add('select 1 from tab_animal ' +
                   'where cod_animal = :cod_animal ' +
                   'and   cod_pessoa_produtor = :cod_pessoa_produtor ' +
                   'and   dta_fim_validade is null ');
      if tipo = 2 then
         Q.SQL.Add('select 1 from tab_animal ' +
                   'where cod_animal_manejo = :cod_animal ' +
                   'and   cod_fazenda_manejo = :cod_fazenda_manejo ' +
                   'and   cod_pessoa_produtor = :cod_pessoa_produtor ' +
                   'and   dta_fim_validade is null ');
      Aux := '';
      while I <= length(CodAnimalAux) do begin
            if ((CodAnimalAux[I] <> ',')) and (CodAnimalAux[I] <> ' ') then begin
               Aux := Aux + codAnimalAux[I]
            end;
            if (CodAnimalAux[I] = ',') or (I=length(CodAnimalAux)) then begin
                  if tipo = 1 then begin
                     Q.Parambyname('cod_animal').asinteger := strtoint(Aux);
                  end else begin
                     Q.Parambyname('cod_animal').asstring := Aux;
                     Q.ParamByName('cod_fazenda_manejo').asinteger := CodFazendaManejo;
                  end;
                  Q.Parambyname('cod_pessoa_produtor').asinteger := Conexao.CodProdutorTrabalho;
                  Q.Open;
                  If Q.eof then begin
                     LimpaDadosAnimal(DadosAnimal);
                     DadosAnimal.CodAnimalManejo := Aux;
                     DadosAnimal.CodFazendaManejo := CodFazendaManejo;
                     Result := InserirErroOperacaoAnimal(DadosAnimal, date, 'O animal não está cadastrado', 4, 1);
                     inc(ErrProc);
                  end else begin
                     if tipo = 1
                        then Result := BuscaDadosAnimal(strtoint(aux),-1,'',DadosAnimal)
                        else Result := BuscaDadosAnimal(-1,CodFazendaManejo,Aux,DadosAnimal);
                     if tipo = 1
                        then Result := AdicionarTouro(CodReprodutorMultiplo,Strtoint(Aux),-1,'',DtaInicioUso,DtaFimUso)
                        else Result := AdicionarTouro(CodReprodutorMultiplo,-1,CodFazendaManejo,Aux,DtaInicioUso,DtaFimUso);
                     if Result < 0 then begin
                        inc(ErrProc);
                        Result := InserirErroOperacaoAnimal(DadosAnimal, date, Mensagens.Items[0].Texto, 4, 1);
                        mensagens.Clear;
                     end else inc(TotProc);
                  end;
                  Q.close;
                  aux := '';
            end;
            inc(I);
    end;
    if ErrProc = 0
       then Mensagens.Adicionar(1358, Self.ClassName, NomMetodo, [IntToStr(TotProc)])
       else Mensagens.Adicionar(1359, Self.ClassName, NomMetodo, [IntToStr(TotProc),Inttostr(ErrProc)]);

    Result := 0;

    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1366, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1366;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntReprodutoresMultiplos.RetirarTouros(
  CodReprodutorMultiplo: Integer; CodAnimais: String;
  CodFazendaManejo: Integer; CodAnimaisManejo: String): Integer;
var
  Q : THerdomQuery;
  I, tipo : Integer;
  TotProc, ErrProc: Integer;
  CodAnimalAux, Aux : String;
  DadosAnimal :TdadosAnimal;
Const
  NomMetodo : String = 'RetirarTouros';
  CodMetodo : Integer = 418;
begin
  result := -1;
  TotProc := 0;
  ErrProc := 0;
  I:=1;
  tipo:= 0;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  End;

  //----------------------------------------------------------------
  //Informar o CodAnimal ou (CodFazendaManejoManejo/CodAnimalManejo)
  //----------------------------------------------------------------
  if CodAnimais <> '' then begin
    if (CodFazendaManejo > 0 ) or (trim(CodAnimaisManejo) <> '') then begin
      Mensagens.Adicionar(1181, Self.ClassName, NomMetodo, []);
      Result := -1181;
      Exit;
    end;
  end
  else if (CodFazendaManejo < 0 ) or (trim(CodAnimaisManejo) = '') then begin
      Mensagens.Adicionar(1182, Self.ClassName, NomMetodo, []);
      Result := -1182;
      Exit;
  end;
  if CodAnimais <> '' then begin
     tipo := 1; //códigos dos Animais
     CodAnimalAux := CodAnimais;
  end;
  if CodAnimaisManejo <> '' then begin
     tipo := 2; //códigos manejos dos animais
     CodAnimalAux := CodAnimaisManejo;
  end;
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.Close;
      //----------------------------
      // Verifica a existência do RM
      //----------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select cod_especie, cod_fazenda_manejo from tab_reprodutor_multiplo ' +
                '  where cod_pessoa_produtor = :cod_pessoa_produtor ' +
                '    and cod_reprodutor_multiplo = :cod_reprodutor_multiplo ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_reprodutor_multiplo').AsInteger := CodReprodutorMultiplo;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1176, Self.ClassName, NomMetodo, []);
        Result := -1176;
        Exit;
      End;

      Q.Close;
      Q.SQL.Clear;
      if tipo = 1 then
         Q.SQL.Add('select 1 from tab_animal ' +
                   'where cod_animal = :cod_animal ' +
                   'and   cod_pessoa_produtor = :cod_pessoa_produtor ' +
                   'and   dta_fim_validade is null ');
      if tipo = 2 then
         Q.SQL.Add('select 1 from tab_animal ' +
                   'where cod_animal_manejo = :cod_animal ' +
                   'and   cod_fazenda_manejo = :cod_fazenda_manejo ' +
                   'and   cod_pessoa_produtor = :cod_pessoa_produtor ' +
                   'and   dta_fim_validade is null ');
      Aux := '';
      while I <= length(CodAnimalAux) do begin
            if ((CodAnimalAux[I] <> ',')) and (CodAnimalAux[I] <> ' ') then begin
               Aux := Aux + codAnimalAux[I]
            end;
            if (CodAnimalAux[I] = ',') or (I=length(CodAnimalAux)) then begin
                  if tipo = 1 then begin
                     Q.Parambyname('cod_animal').asinteger := strtoint(Aux);
                  end else begin
                     Q.Parambyname('cod_animal').asstring := Aux;
                     Q.ParamByName('cod_fazenda_manejo').asinteger := CodFazendaManejo;
                  end;
                  Q.Parambyname('cod_pessoa_produtor').asinteger := Conexao.CodProdutorTrabalho;
                  Q.Open;
                  If Q.eof then begin
                     LimpaDadosAnimal(DadosAnimal);
                     DadosAnimal.CodAnimalManejo := Aux;
                     DadosAnimal.CodFazendaManejo := CodFazendaManejo;
                     Result := InserirErroOperacaoAnimal(DadosAnimal, date, 'O animal não está cadastrado', 4, 1);
                     inc(ErrProc);
                  end else begin
                     if tipo = 1
                        then Result := BuscaDadosAnimal(strtoint(aux),-1,'',DadosAnimal)
                        else Result := BuscaDadosAnimal(-1,CodFazendaManejo,Aux,DadosAnimal);
                     if tipo = 1
                        then Result := RetirarTouro(CodReprodutorMultiplo,DadosAnimal.CodAnimal)
                        else Result := RetirarTouro(CodReprodutorMultiplo,DadosAnimal.CodAnimal);
                     if Result < 0 then begin
                        inc(ErrProc);
                        Result := InserirErroOperacaoAnimal(DadosAnimal, date, Mensagens.Items[0].Texto, 4, 1);
                        mensagens.Clear;
                     end else inc(TotProc);
                  end;
                  Q.close;
                  aux := '';
            end;
            inc(I);
    end;
    if ErrProc = 0
       then Mensagens.Adicionar(1363, Self.ClassName, NomMetodo, [IntToStr(TotProc)])
       else Mensagens.Adicionar(1364, Self.ClassName, NomMetodo, [IntToStr(TotProc),Inttostr(ErrProc)]);

    Result := 0;

    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1365, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1365;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.
