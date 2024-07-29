unit uIntTarefasAutomaticas;

interface

uses  SysUtils, Classes, uConexao, uIntMensagens, uIntAnimais, uIntCodigosSISBOV, uIntFazendas,
  ActiveX, uIntEventos, uIntClassesBasicas;

type

TTarefasAutomaticas = class(TIntClasseBDNavegacaoBasica)
  private
    FInicializado: Boolean;
  public
    constructor Create; Override;
    function Inicializar(EConexao: TConexao;
                         EMensagem: TIntMensagens): Integer; Override;

    function VerificaProcessosAutomaticos(): Integer;
end;


TIntTarefasAutomaticas = class(TThread)
  private
    FConexao: TConexao;
    FMensagem: TIntMensagens;
    FCodTarefa,
    FCodTipoTarefa: Integer;

    function AplicarEventoDesmame(ECodTarefa: Integer): Integer;

    function AtualizarExecucaoProcessosAutomaticos(): Integer;

    function GetRetorno(): Integer;
  protected
    procedure Execute; override;
  public
    constructor CreateTarefa(ECodTarefa: Integer;
                             ECodTipoTarefa: Integer;
                             EConexao: TConexao;
                             EMensagens: TIntMensagens);

    property CodTarefa: Integer read FCodTarefa;
    property Retorno: Integer read GetRetorno;    
end;

implementation

uses SqlExpr;

{ TIntTarefasAutomaticas }

function TIntTarefasAutomaticas.AplicarEventoDesmame(ECodTarefa: Integer): Integer;
const
  NomMetodo: String = 'AplicarEventoDesmame';
  CodCategoriaAnimalMamando: Integer = 1;
  CodTipoEventoDesmame:      Integer = 2;
var
  Animais: TIntAnimais;
  Eventos: TIntEventos;
  Qry: THerdomQuery;

  CodEvento,
  CodAptidao,
  CodPessoaProdutor,
  CodFazendaCorrente: Integer;
  NomProdutorCorrente: String;
begin
  Animais := TIntAnimais.Create;
  Result := Animais.Inicializar(FConexao, FMensagem);
  if Result < 0 then
  begin
    Exit;
  end;

  Eventos := TIntEventos.Create;
  Result := Eventos.Inicializar(FConexao, FMensagem);
  if Result < 0 then
  begin
    Exit;
  end;

  Qry := THerdomQuery.Create(FConexao, nil);
  try
    try
      with Qry do
      begin
        SQL.Clear;
        SQL.Add(' select ta.cod_pessoa_produtor as CodPessoaProdutor ');
        SQL.Add('      , ta.cod_fazenda_corrente as CodFazendaCorrente ');
        SQL.Add('      , ta.cod_aptidao as CodAptidao ');
        SQL.Add('      , ta.cod_animal as CodAnimal ');
        SQL.Add('      , tpr.qtd_idade_maxima_desmame as IdadeDesmameAnimal ');
        SQL.Add('      , (getdate() - ta.dta_nascimento) as IdadeAnimalData ');
        SQL.Add('      , cast((getdate() - ta.dta_nascimento) as int) as IdadeAnimal ');
        SQL.Add('   from tab_animal ta ');
        SQL.Add('      , tab_produtor tpr ');
        SQL.Add('  where ta.dta_fim_validade     is null ');
        SQL.Add('    and tpr.dta_fim_validade    is null ');
        SQL.Add('    and tpr.cod_pessoa_produtor            = ta.cod_pessoa_produtor ');
        SQL.Add('    and ta.cod_categoria_animal            = :cod_categoria_animal_mamando ');
        SQL.Add('    and tpr.ind_aplicar_desmame_automatico = :ind_aplicar_desmame_automatico ');
        SQL.Add('    and tpr.qtd_idade_maxima_desmame <= (getdate() - ta.dta_nascimento) ');
        SQL.Add('  order ');
        SQL.Add('     by ta.cod_pessoa_produtor ');
        SQL.Add('      , ta.cod_fazenda_corrente ');
        ParamByName('cod_categoria_animal_mamando').AsInteger  := CodCategoriaAnimalMamando;
        ParamByName('ind_aplicar_desmame_automatico').AsString := 'S';
        Open;

        if IsEmpty then
        begin
          Exit;
        end;

        CodPessoaProdutor := -1;
        CodFazendaCorrente  := -1;
        CodEvento         := -1;
        CodAptidao        := -1;

        while not Eof do
        begin
          // Se o animal tiver uma idade inferior a idade correta para desmame
          // o evento não deverá ser aplicado.
          if (FieldByName('IdadeDesmameAnimal').AsInteger > FieldByName('IdadeAnimal').AsInteger) then
          begin
            Next;
            Continue;
          end;

          if (CodPessoaProdutor <> FieldByName('CodPessoaProdutor').AsInteger) or
             (CodFazendaCorrente <> FieldByName('CodFazendaCorrente').AsInteger) or
             (CodAptidao <> FieldByName('CodAptidao').AsInteger) then
          begin
            if (CodPessoaProdutor <> FieldByName('CodPessoaProdutor').AsInteger) then
            begin
              // Define o produtor como sendo o produtor corrente
              Result := FConexao.DefinirProdutorTrabalho(FieldByName('CodPessoaProdutor').AsInteger, NomProdutorCorrente);
              if Result < 0 then
              begin
                Exit;
              end;
              CodPessoaProdutor := FConexao.CodProdutorTrabalho;
            end;
            
            if (CodFazendaCorrente <> FieldByName('CodFazendaCorrente').AsInteger) then
            begin
              CodFazendaCorrente := FieldByName('CodFazendaCorrente').AsInteger
            end;

            if (CodAptidao <> FieldByName('CodAptidao').AsInteger) then
            begin
              CodAptidao := FieldByName('CodAptidao').AsInteger;
            end;

            //Insere a capa do evento
            FConexao.BeginTran;
            Result := Eventos.InserirDesmame(Date,
                                             CodAptidao,
                                             99,
                                             'Evento aplicado automaticamente pelo sistema.',
                                             CodFazendaCorrente,
                                             ECodTarefa);
            if Result < 0 then
            begin
              FConexao.Rollback;
              CodPessoaProdutor := -1;
              CodFazendaCorrente  := -1;
              CodEvento         := -1;
              CodAptidao        := -1;
              Next;
              Continue;
            end;
            CodEvento := Result;
            FConexao.Commit;
          end;

          // Aplica o evento de desmame os animais com idade superior a
          // idade de desmame.
          FConexao.BeginTran;
          Result := Animais.AplicarEvento(FieldByName('CodAnimal').AsString,
                                          -1,
                                          '',
                                          -1,
                                          -1,
                                          CodEvento,
                                          'N');
          FConexao.Commit;
          if Result < 0 then
          begin
            Next;
            Continue;
          end;
          Next;
        end;
      end;
      Result := 0;
    except
      on E:Exception do
      begin
        FMensagem.Adicionar(2243, Self.ClassName, NomMetodo, [E.Message]);
        Result := -2243;
        FConexao.Rollback;
        Exit;
      end;
    end;
  finally
    Animais.Free;
    Eventos.Free;
  end;
end;

function TIntTarefasAutomaticas.AtualizarExecucaoProcessosAutomaticos(): Integer;
const
  NomMetodo: String = 'AtualizarExecucaoProcessosAutomaticos';
var
  Qry: THerdomQuery;
begin
  Qry := THerdomQuery.Create(FConexao, nil);
  try
    try
      with Qry do
      begin
        FConexao.BeginTran;
        SQL.Clear;
        SQL.Add(' update tab_parametro_sistema ');
        SQL.Add('    set val_parametro_sistema = :dta_sistema');
        SQL.Add('  where cod_parametro_sistema = :cod_parametro_sistema ');
        ParamByName('dta_sistema').AsString            := DateToStr(Trunc(Now));
        ParamByName('cod_parametro_sistema').AsInteger := 113;
        ExecSQL;
        FConexao.Commit;

        Result := 0; 
      end;
    except
      on E:Exception do
      begin
        FMensagem.Adicionar(2245, Self.ClassName, NomMetodo, [E.Message]);
        FConexao.RollBack;
        Result := -2245;
        Exit;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

constructor TIntTarefasAutomaticas.CreateTarefa(ECodTarefa: Integer;
                                                ECodTipoTarefa: Integer;
                                                EConexao: TConexao;
                                                EMensagens: TIntMensagens);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FCodTarefa     := ECodTarefa;
  FCodTipoTarefa := ECodTipoTarefa;
  FConexao       := EConexao;
  FMensagem      := EMensagens;
  Priority := tpLowest;
  Suspended := False;  
end;

procedure TIntTarefasAutomaticas.Execute;
const
  NomMetodo: String = 'NomMetodo';
begin
  try
    CoInitialize(nil);
    try
      case FCodTipoTarefa of
        7:
        begin
          ReturnValue := AplicarEventoDesmame(FCodTarefa);
        end;
        else
        begin
          FMensagem.Adicionar(2046, Self.ClassName, NomMetodo, []);
          ReturnValue := -2046;
          Exit;
        end;
      end;

      ReturnValue := AtualizarExecucaoProcessosAutomaticos();
      if ReturnValue < 0 then
      begin
        Exit;
      end;
    except
      on E:Exception do
      begin
        FMensagem.Adicionar(2045, Self.ClassName, NomMetodo, [E.Message]);
        ReturnValue := -2045;
        Exit;
      end;
    end;
  finally
    CoUninitialize;
  end;
end;

function TIntTarefasAutomaticas.GetRetorno: Integer;
begin
  Result := ReturnValue;
end;

{ TTarefasAutomaticas }

constructor TTarefasAutomaticas.Create();
begin
  inherited;
  FInicializado := False;
end;

function TTarefasAutomaticas.Inicializar(EConexao: TConexao;
                                         EMensagem: TIntMensagens): Integer;
begin
  FInicializado := True;
  Result := inherited Inicializar(EConexao, EMensagem);
end;

function TTarefasAutomaticas.VerificaProcessosAutomaticos(): Integer;
const
  NomMetodo: String = '';
var
  DtaUltimaExecucao: TDateTime;
begin
  try
    DtaUltimaExecucao := StrToDateTimeDef(ValorParametro(113), Now);
    if Trunc(DtaUltimaExecucao) < Trunc(Now) then
    begin
      Result := VerificarAgendamentoTarefa(7, []);
      if Result <= 0 then
      begin
        Exit;
      end;

      Result := SolicitarAgendamentoTarefa(7, [], DtaSistema);
      if Result < 0 then
      begin
        Exit;
      end;

      if Result >= 0 then begin
        Mensagens.Adicionar(1995, Self.Classname, NomMetodo, []);
      end;
    end
    else
    begin
      Result := 0;
    end;
  except
    on E:Exception do
    begin
      Mensagens.Adicionar(2244, Self.ClassName, NomMetodo, [E.Message]);
      Result := -2244;
      Exit;
    end;
  end;
end;

end.
