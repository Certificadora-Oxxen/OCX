// ********************************************************************
// *  Projeto : BoiTata
// *  Sistema : Controle de Acesso
// *  Desenvolvedor : Hitalo Cordeiro Silva
// *  Versão  : 1
// *  Data : 16/07/2002
// *  Descrição Resumida : Perfil do Usuário
// *
// ********************************************************************
// *  Últimas Alterações
// *  Analista      Data     Descrição Alteração
// *   Hitalo    16/07/2002  Adicionar Data Fim na Propriedade e no
// *                         metodo pesquisar
// *
// *
// *
// ********************************************************************

unit uIntPerfis;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntPerfil, dbtables, sysutils, db;

type
  { TIntAnunciantes }
  TIntPerfis = class(TIntClasseBDNavegacaoBasica)
  private
    FIntPerfil : TIntPerfil;

    function RotinaInserirItemMenu(ECodPerfil,
                                   ECodPapel,
                                   ECodItemMenu,
                                   ECodClasse,
                                   ECodErro: Integer): Integer;

    function RotinaInserirItemMenuFuncao(ECodPerfil,
                                         ECodPapel,
                                         ECodItemMenu,
                                         ECodClasse,
                                         ECodErro: Integer): Integer;

    function RotinaExcluirItemMenu(ECodPerfil,
                                   ECodPapel,
                                   ECodItemMenu,
                                   ECodClasse,
                                   ECodErro: Integer): Integer;

    function RotinaExcluirItemMenuFuncao(ECodPerfil,
                                         ECodPapel,
                                         ECodItemMenu,
                                         ECodClasse,
                                         ECodErro: Integer): Integer;
  public
    constructor Create; override;

    destructor Destroy; override;

    function Pesquisar(ECodPapel: Integer;
                       EIndPesquisarDesativados : boolean): Integer;

    function PesquisarItemMenu(ECodPerfil,
                               ECodMenu: Integer): Integer;

    function PesquisarFuncoes(ECodPerfil,
                              ECodMenu: Integer): Integer;

    function Buscar(ECodPerfil: Integer): Integer;

    function Alterar(ECodPerfil: Integer;
                     ENomPerfil,
                     EDesPerfil: String): Integer;

    function Inserir(ENomPerfil: String;
                     ECodPapel: Integer;
                     EDesPerfil: String): Integer;

    function InserirItemMenu(ECodPerfil,
                             ECodItemMenu: Integer): Integer;

    function InserirFuncao(ECodPerfil,
                           ECodFuncao: Integer): Integer;

    function Excluir(ECodPerfil: Integer): Integer;

    function ExcluirItemMenu(ECodPerfil,
                             ECodItemMenu: Integer): Integer;

    function ExcluirFuncao(ECodPerfil,
                           ECodFuncao: Integer): Integer;

    property IntPerfil: TIntPerfil read FIntPerfil write FIntPerfil;
  end;

implementation

{ TIntPerfis }

function TIntPerfis.Alterar(ECodPerfil: Integer;
                            ENomPerfil,
                            EDesPerfil: String): Integer;
var
  Q : THerdomQuery;
  Flag : Boolean;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('Alterar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(49) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  end;

  // Verifica existencia do parametro NomPerfil
  if ENomPerfil = '' then begin
    Mensagens.Adicionar(230, Self.ClassName, 'Inserir', []);
    Result := -230;
    Exit;
  end;

  Result := TrataString(ENomPerfil, 50, 'Nome do perfil');
  if Result < 0 then Exit;

  // Verifica existencia do parametro DesPerfil
  if EDesPerfil = '' then begin
    Mensagens.Adicionar(231, Self.ClassName, 'Inserir', []);
    Result := -231;
    Exit;
  end;

  Result := TrataString(EDesPerfil, 255, 'Descrição do perfil');
  if Result < 0 then Exit;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_perfil ');
      Q.SQL.Add(' where cod_perfil = :cod_perfil ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(222, Self.ClassName, 'Alterar', [IntToStr(ECodPerfil)]);
        Result := -222;
        Exit;
      end;
      Q.Close;

      // Verifica existencia de nome
      if ENomPerfil <> '' then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_perfil ');
        Q.SQL.Add(' where nom_perfil = :nom_perfil ');
        Q.SQL.Add('   and cod_perfil != :cod_perfil ');
        Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('nom_perfil').AsString := ENomPerfil;
        Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
        Q.Open;
        if not Q.IsEmpty then begin
          //alterar esta mensagem para "Nome do Perfil existente."
          Mensagens.Adicionar(226, Self.ClassName, 'Alterar', [IntToStr(ECodPerfil)]);
          Result := -226;
          Exit;
        end;
        Q.Close;
      end;


      //Inicio Transacao
      beginTran;
      Flag := False;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_perfil ');

      if ENomPerfil <> '' then begin
        Q.SQL.Add(' set nom_perfil = :nom_perfil ');
        Flag := True;
      end;

      if EDesPerfil <> '' then begin
        if Flag then begin
          Q.SQL.Add(' , ');
        end else begin
          Q.SQL.Add(' set ');
        end;
        Q.SQL.Add(' des_perfil = :des_perfil ');
      end;

      Q.SQL.Add(' where cod_perfil = :cod_perfil ');

{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      if ENomPerfil <> '' then begin
        Q.ParamByName('nom_perfil').AsString := ENomPerfil;
      end;
      if EDesPerfil <> '' then begin
        Q.ParamByName('des_perfil').AsString := EDesPerfil;
      end;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Commit;
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(227, Self.ClassName, 'Alterar', [E.Message]);
        Result := -227;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntPerfis.Buscar(ECodPerfil: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('Buscar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(47) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tpe.cod_perfil, ');
      Q.SQL.Add('       tpe.nom_perfil, ');
      Q.SQL.Add('       tpa.cod_papel, ');
      Q.SQL.Add('       tpa.des_papel, ');
      Q.SQL.Add('       tpe.des_perfil, ');
      Q.SQL.Add('       tpe.dta_fim_validade ');
      Q.SQL.Add('from tab_perfil tpe, ');
      Q.SQL.Add('     tab_papel tpa ');
      Q.SQL.Add('where tpe.cod_perfil = :cod_perfil and tpe.cod_perfil <> 1');
//hitalo      Q.SQL.Add('  and tpe.dta_fim_validade is null ');
      Q.SQL.Add('  and tpe.cod_papel = tpa.cod_papel ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;

      // Verifica se existe registro para busca
      if Q.IsEmpty then begin
        Mensagens.Adicionar(222, Self.ClassName, 'Buscar', [IntToStr(ECodPerfil)]);
        Result := -222;
        Exit;
      end;

      // Obtem informações do registro
      IntPerfil.CodPerfil       := Q.FieldByName('cod_perfil').AsInteger;
      IntPerfil.NomPerfil       := Q.FieldByName('nom_perfil').AsString;
      IntPerfil.CodPapel        := Q.FieldByName('cod_papel').AsInteger;
      IntPerfil.DesPapel        := Q.FieldByName('des_papel').AsString;
      IntPerfil.DesPerfil       := Q.FieldByName('des_perfil').AsString;
      IntPerfil.DtaFimValidade  := Q.FieldByName('dta_fim_validade').AsDateTime;
      // Retorna status "ok" do método
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(223, Self.ClassName, 'Buscar', [E.Message]);
        Result := -223;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

constructor TIntPerfis.Create;
begin
  inherited;
  FIntPerfil := TIntPerfil.Create;
end;

destructor TIntPerfis.Destroy;
begin
  FIntPerfil.Free;
  inherited;
end;

function TIntPerfis.Excluir(ECodPerfil: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('Excluir');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(48) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_perfil ');
      Q.SQL.Add(' where cod_perfil = :cod_perfil ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(222, Self.ClassName, 'Excluir', [IntToStr(ECodPerfil)]);
        Result := -222;
        Exit;
      end;
      Q.Close;

      // Consiste se há banner ativo para esse anunciante
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_usuario ');
      Q.SQL.Add(' where cod_perfil = :cod_perfil ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(224, Self.ClassName, 'Excluir', [IntToStr(ECodPerfil)]);
        Result := -224;
        Exit;
      end;
      Q.Close;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_perfil ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_perfil = :cod_perfil ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(225, Self.ClassName, 'Excluir', [E.Message]);
        Result := -225;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;


function TIntPerfis.ExcluirFuncao(ECodPerfil, ECodFuncao: Integer): Integer;
var
  Q, QAux, QAux2 : THerdomQuery;
  CodPapel, CodRegistroLog, CodItemMenuPai, CodErro, CodClasse : Integer;
begin
  CodErro := 257;
  CodClasse := 68;

  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('ExcluirFuncao');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodClasse) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'ExcluirFuncao', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  QAux := THerdomQuery.Create(Conexao, nil);
  QAux2 := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Verifica existencia do registro Perfil
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_papel from tab_perfil ');
      Q.SQL.Add(' where cod_perfil = :cod_perfil ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(222, Self.ClassName, 'ExcluirFuncao', [IntToStr(ECodPerfil)]);
        Result := -222;
        Exit;
      end else begin
        CodPapel := Q.FieldByName('cod_papel').AsInteger;
      end;
      Q.Close;

      // Verifica existencia do registro Função
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add(' from tab_funcao ');
      Q.SQL.Add(' where cod_funcao = :cod_funcao ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_funcao').AsInteger := ECodFuncao;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(254, Self.ClassName, 'ExcluirFuncao', [IntToStr(ECodFuncao)]);
        Result := -254;
        Exit;
      end;
      Q.Close;

      // Verifica se a Função não existe na tab_perfil_funcao
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_perfil_funcao ');
      Q.SQL.Add('where cod_funcao = :cod_funcao ');
      Q.SQL.Add('  and cod_perfil = :cod_perfil ');
{$ENDIF}
      Q.ParamByName('cod_funcao').AsInteger := ECodFuncao;
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if Q.IsEmpty then begin
        Result := 0;
        Exit;
      end else begin
        CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      end;
      Q.Close;

      // Abre transação
      beginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_perfil_funcao', CodRegistroLog, 4, CodClasse);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Exclui o perfil
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_perfil_funcao ');
      Q.SQL.Add('where cod_perfil = :cod_perfil ');
      Q.SQL.Add('  and cod_funcao = :cod_funcao ');
{$ENDIF}

      // Excluir Funcoes do Item Menu
      Q.ParamByName('cod_perfil').AsInteger        := ECodPerfil;
      Q.ParamByName('cod_funcao').AsInteger        := ECodFuncao;
      Q.ExecSQL;

      //Verifica se o função é a última função no perfil para o item de menu do perfil.
      //Se for a ultima então deverá ser excluido o item de menu.
      QAux.SQL.Clear;
{$IFDEF MSSQL}
      QAux.SQL.Add('select timf.cod_item_menu ');
      QAux.SQL.Add('from tab_item_menu_funcao timf, ');
      QAux.SQL.Add('     tab_perfil_item_menu tpim ');
      QAux.SQL.Add('where timf.cod_funcao = :cod_funcao ');
      QAux.SQL.Add('  and timf.cod_papel = tpim.cod_papel ');
      QAux.SQL.Add('  and timf.cod_item_menu = tpim.cod_item_menu ');
      QAux.SQL.Add('  and tpim.cod_perfil = :cod_perfil ');
      QAux.SQL.Add('  and not exists (select 1 from tab_item_menu_funcao timf2, ');
      QAux.SQL.Add('                                tab_perfil_funcao tpf2 ');
      QAux.SQL.Add('                   where timf2.cod_item_menu = timf.cod_item_menu ');
      QAux.SQL.Add('                     and timf2.cod_papel = timf.cod_papel ');
      QAux.SQL.Add('                     and tpf2.cod_funcao = timf2.cod_funcao ');
      QAux.SQL.Add('                     and tpf2.cod_perfil = :cod_perfil ) ');
{$ENDIF}
      QAux.ParamByName('cod_perfil').AsInteger        := ECodPerfil;
      QAux.ParamByName('cod_funcao').AsInteger        := ECodFuncao;
      QAux.Open;

      if not QAux.IsEmpty  then begin
        while not QAux.EOF Do begin
          //Rotina para exclusao dos Pais do Item Menu
          CodItemMenuPai := QAux.FieldByName('cod_item_menu').AsInteger;

          while CodItemMenuPai > 0 Do begin
            // Verifica se o Item Menu tem Pai
            QAux2.SQL.Clear;
{$IFDEF MSSQL}
            QAux2.SQL.Add('select 1 from tab_item_menu tim, ');
            QAux2.SQL.Add('              tab_perfil_item_menu tpi ');
            QAux2.SQL.Add('where tim.cod_item_pai = :cod_item_pai ');
            QAux2.SQL.Add('  and tim.cod_papel = :cod_papel ');
            QAux2.SQL.Add('  and tpi.cod_papel = tim.cod_papel ');
            QAux2.SQL.Add('  and tpi.cod_item_menu = tim.cod_item_menu ');
            QAux2.SQL.Add('  and tpi.cod_perfil = :cod_perfil ');
{$ENDIF}
            QAux2.ParamByName('cod_item_pai').AsInteger  := CodItemMenuPai;
            QAux2.ParamByName('cod_papel').AsInteger     := CodPapel;
            QAux2.ParamByName('cod_perfil').AsInteger    := ECodPerfil;
            QAux2.Open;
            if QAux2.IsEmpty then begin

              //Exclusão do Menu Item Pai
              Result := RotinaExcluirItemMenu(ECodPerfil, CodPapel, CodItemMenuPai, CodClasse, CodErro);
              if Result < 0 then begin
                Rollback;
                Exit;
              end;

              // Verifica se o Item Menu tem Pai
              QAux2.SQL.Clear;
{$IFDEF MSSQL}
              QAux2.SQL.Add('select cod_item_pai ');
              QAux2.SQL.Add(' from tab_item_menu ');
              QAux2.SQL.Add(' where cod_item_menu = :cod_item_menu ');
              QAux2.SQL.Add('   and cod_papel = :cod_papel ');
              QAux2.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
              QAux2.ParamByName('cod_item_menu').AsInteger     := CodItemMenuPai;
              QAux2.ParamByName('cod_papel').AsInteger         := CodPapel;
              QAux2.Open;
              if not QAux2.IsEmpty then begin
                // Armazena o Item Menu Pai
                CodItemMenuPai := 0;
                if not QAux2.FieldByName('cod_item_pai').IsNull then begin
                  CodItemMenuPai := QAux2.FieldByName('cod_item_pai').AsInteger;
                end;
              end else begin
                CodItemMenuPai := 0;
              end;
            end else begin
              CodItemMenuPai := 0;
            end;
          end;

          QAux.Next;
        end;
      end;

      // Confirma transação
      Commit;
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(CodErro, Self.ClassName, 'ExcluirFuncao', [E.Message]);
        Result := - CodErro;
        Exit;
      end;
    end;
  finally
    Q.Free;
    QAux.Free;
  end;
end;

function TIntPerfis.ExcluirItemMenu(ECodPerfil, ECodItemMenu: Integer): Integer;
var
  Q, QAux : THerdomQuery;
  CodPapel, CodItemMenuPai, CodErro, CodClasse : Integer;
begin
  CodErro := 248;
  CodClasse := 65;

  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('ExcluirItemMenu');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodClasse) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'ExcluirItemMenu', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  QAux := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Verifica existencia do registro Perfil
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_papel from tab_perfil ');
      Q.SQL.Add(' where cod_perfil = :cod_perfil ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(222, Self.ClassName, 'ExcluirItemMenu', [IntToStr(ECodPerfil)]);
        Result := -222;
        Exit;
      end else begin
        CodPapel := Q.FieldByName('cod_papel').AsInteger;
      end;
      Q.Close;

      // Verifica existencia do registro Item Menu
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select qtd_filhos, cod_item_pai ');
      Q.SQL.Add(' from tab_item_menu ');
      Q.SQL.Add(' where cod_item_menu = :cod_item_menu ');
      Q.SQL.Add('   and cod_papel = :cod_papel ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_item_menu').AsInteger := ECodItemMenu;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(244, Self.ClassName, 'ExcluirItemMenu', [IntToStr(ECodItemMenu)]);
        Result := -244;
        Exit;
      end else begin
        // Verifica se o Item Menu nao tem filhos
        if Q.FieldByName('qtd_filhos').AsInteger > 0 then begin
          Mensagens.Adicionar(246, Self.ClassName, 'ExcluirItemMenu', []);
          Result := -246;
          Exit;
        end else begin
          // Armazena o Item Menu Pai
          CodItemMenuPai := 0;
          if not Q.FieldByName('cod_item_pai').IsNull then begin
            CodItemMenuPai := Q.FieldByName('cod_item_pai').AsInteger;
          end;
        end;
      end;
      Q.Close;

      // Verifica se o Papel do Perfil é igual ao do Item Menu
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('from tab_item_menu ti, ');
      Q.SQL.Add('     tab_perfil tp ');
      Q.SQL.Add('where ti.cod_papel = tp.cod_papel ');
      Q.SQL.Add('  and tp.cod_perfil = :cod_perfil ');
      Q.SQL.Add('  and ti.cod_item_menu = :cod_item_menu ');
      Q.SQL.Add('  and ti.dta_fim_validade is null ');
      Q.SQL.Add('  and tp.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.ParamByName('cod_item_menu').AsInteger := ECodItemMenu;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(250, Self.ClassName, 'ExcluirItemMenu', []);
        Result := -250;
        Exit;
      end;
      Q.Close;

      // Verifica se o Item Menu não existe na tab_perfil_item_menu
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_perfil_item_menu ');
      Q.SQL.Add('where cod_item_menu = :cod_item_menu ');
      Q.SQL.Add('  and cod_papel = :cod_papel ');
      Q.SQL.Add('  and cod_perfil = :cod_perfil ');
{$ENDIF}
      Q.ParamByName('cod_item_menu').AsInteger := ECodItemMenu;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if Q.IsEmpty then begin
        Result := 0;
        Exit;
      end;
      Q.Close;


      // Abre transação
      beginTran;
      //Exclusão do Menu Item
      Result := RotinaExcluirItemMenu(ECodPerfil, CodPapel, ECodItemMenu, CodClasse, CodErro);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
      //Exclusão da Funcao do Item Menu
      Result := RotinaExcluirItemMenuFuncao(ECodPerfil, CodPapel, ECodItemMenu, CodClasse, CodErro);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      //Rotina para exclusao dos Pais do Item Menu
      while CodItemMenuPai > 0 Do begin
        // Verifica se o Item Menu tem Pai
        QAux.SQL.Clear;
{$IFDEF MSSQL}
        QAux.SQL.Add('select 1 from tab_item_menu tim, ');
        QAux.SQL.Add('              tab_perfil_item_menu tpi ');
        QAux.SQL.Add('where tim.cod_item_pai = :cod_item_pai ');
        QAux.SQL.Add('  and tim.cod_papel = :cod_papel ');
        QAux.SQL.Add('  and tpi.cod_papel = tim.cod_papel ');
        QAux.SQL.Add('  and tpi.cod_item_menu = tim.cod_item_menu ');
        QAux.SQL.Add('  and tpi.cod_perfil = :cod_perfil ');
{$ENDIF}
        QAux.ParamByName('cod_item_pai').AsInteger  := CodItemMenuPai;
        QAux.ParamByName('cod_papel').AsInteger     := CodPapel;
        QAux.ParamByName('cod_perfil').AsInteger    := ECodPerfil;
        QAux.Open;
        if QAux.IsEmpty then begin

          //Exclusão do Menu Item Pai
          Result := RotinaExcluirItemMenu(ECodPerfil, CodPapel, CodItemMenuPai, CodClasse, CodErro);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

          // Verifica se o Item Menu tem Pai
          QAux.SQL.Clear;
{$IFDEF MSSQL}
          QAux.SQL.Add('select cod_item_pai ');
          QAux.SQL.Add(' from tab_item_menu ');
          QAux.SQL.Add(' where cod_item_menu = :cod_item_menu ');
          QAux.SQL.Add('   and cod_papel = :cod_papel ');
          QAux.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
          QAux.ParamByName('cod_item_menu').AsInteger     := CodItemMenuPai;
          QAux.ParamByName('cod_papel').AsInteger         := CodPapel;
          QAux.Open;
          if not QAux.IsEmpty then begin
            // Armazena o Item Menu Pai
            CodItemMenuPai := 0;
            if not QAux.FieldByName('cod_item_pai').IsNull then begin
              CodItemMenuPai := QAux.FieldByName('cod_item_pai').AsInteger;
            end;
          end else begin
            CodItemMenuPai := 0;
          end;
        end else begin
          CodItemMenuPai := 0;
        end;
      end;

      // Confirma transação
      Commit;
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(CodErro, Self.ClassName, 'ExcluirItemMenu', [E.Message]);
        Result := - CodErro;
        Exit;
      end;
    end;
  finally
    Q.Free;
    QAux.Free;
  end;
end;

function TIntPerfis.Inserir(ENomPerfil: String;
                            ECodPapel: Integer;
                            EDesPerfil: String): Integer;
var
  Q : THerdomQuery;
  CodPerfil : Integer;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('Inserir');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(50) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  end;

  // Verifica existencia do parametro NomPerfil
  if ENomPerfil = '' then begin
    Mensagens.Adicionar(230, Self.ClassName, 'Inserir', []);
    Result := -230;
    Exit;
  end;

  Result := TrataString(ENomPerfil, 50, 'Nome do perfil');
  if Result < 0 then Exit;

  // Verifica existencia do parametro DesPerfil
  if EDesPerfil = '' then begin
    Mensagens.Adicionar(231, Self.ClassName, 'Inserir', []);
    Result := -231;
    Exit;
  end;

  Result := TrataString(EDesPerfil, 255, 'Descrição do perfil');
  if Result < 0 then Exit;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_perfil ');
      Q.SQL.Add(' where nom_perfil = :nom_perfil ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_perfil').AsString := ENomPerfil;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(226, Self.ClassName, 'Inserir', [ENomPerfil]);
        Result := -226;
        Exit;
      end;
      Q.Close;

      // Verifica existencia do registro papel
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_papel ');
      Q.SQL.Add(' where cod_papel = :cod_papel ');
{$ENDIF}
      Q.ParamByName('cod_papel').AsInteger := ECodPapel;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(229, Self.ClassName, 'Inserir', [IntToStr(ECodPapel)]);
        Result := -229;
        Exit;
      end;
      Q.Close;

      // Verifica existencia do parametro NomPerfil
      if ENomPerfil = '' then begin
        Mensagens.Adicionar(230, Self.ClassName, 'Inserir', []);
        Result := -230;
        Exit;
      end;

      // Verifica existencia do parametro DesPerfil
      if EDesPerfil = '' then begin
        Mensagens.Adicionar(231, Self.ClassName, 'Inserir', []);
        Result := -231;
        Exit;
      end;

      // Abre transação
      beginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_perfil), 0) + 1 as cod_perfil from tab_perfil');
{$ENDIF}
      Q.Open;
      CodPerfil := Q.FieldByName('cod_perfil').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_perfil ');
      Q.SQL.Add(' (cod_perfil, ');
      Q.SQL.Add('  nom_perfil, ');
      Q.SQL.Add('  cod_papel, ');
      Q.SQL.Add('  des_perfil, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_perfil, ');
      Q.SQL.Add('  :nom_perfil, ');
      Q.SQL.Add('  :cod_papel, ');
      Q.SQL.Add('  :des_perfil, ');
      Q.SQL.Add('  NULL) ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := CodPerfil;
      Q.ParamByName('nom_perfil').AsString  := ENomPerfil;
      Q.ParamByName('cod_papel').AsInteger  := ECodPapel;
      Q.ParamByName('des_perfil').AsString  := EDesPerfil;

      Q.ExecSQL;

      // Confirma transação
      Commit;

      // Retorna código do banner criado
      Result := CodPerfil;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(228, Self.ClassName, 'Inserir', [E.Message]);
        Result := -228;
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function TIntPerfis.InserirFuncao(ECodPerfil,
                                  ECodFuncao: Integer): Integer;
var
  Q, QAux : THerdomQuery;
  CodPapel, CodRegistroLog, CodErro, CodClasse : Integer;
begin
  CodErro := 256;
  CodClasse := 67;

  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('InserirFuncao');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodClasse) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'InserirFuncao', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  QAux := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Verifica existencia do registro Perfil
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_papel from tab_perfil ');
      Q.SQL.Add(' where cod_perfil = :cod_perfil ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(222, Self.ClassName, 'InserirFuncao', [IntToStr(ECodPerfil)]);
        Result := -222;
        Exit;
      end else begin
        CodPapel := Q.FieldByName('cod_papel').AsInteger;
      end;
      Q.Close;

      // Verifica existencia do registro Função
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add(' from tab_funcao ');
      Q.SQL.Add(' where cod_funcao = :cod_funcao ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_funcao').AsInteger := ECodFuncao;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(254, Self.ClassName, 'InserirFuncao', [IntToStr(ECodFuncao)]);
        Result := -254;
        Exit;
      end;
      Q.Close;

      // Verifica se a Funççao já está inserida na tab_perfil_funcao
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_perfil_funcao ');
      Q.SQL.Add('where cod_funcao = :cod_funcao ');
      Q.SQL.Add('  and cod_perfil = :cod_perfil ');
{$ENDIF}
      Q.ParamByName('cod_funcao').AsInteger := ECodFuncao;
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if not Q.IsEmpty then begin
        Result := 0;
        Exit;
      end;
      Q.Close;

      // Verifica se a função está relacionada com algum item de menu do perfil
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('from tab_item_menu_funcao timf, ');
      Q.SQL.Add('     tab_perfil_item_menu tpim, ');
      Q.SQL.Add('     tab_perfil tper ');
      Q.SQL.Add('where timf.cod_papel = :cod_papel ');
      Q.SQL.Add('  and timf.cod_funcao = :cod_funcao ');
      Q.SQL.Add('  and timf.dta_fim_validade is null ');

      Q.SQL.Add('  and tpim.cod_papel = timf.cod_papel ');
      Q.SQL.Add('  and tpim.cod_item_menu = timf.cod_item_menu ');

      Q.SQL.Add('  and tper.cod_perfil = tpim.cod_perfil ');
      Q.SQL.Add('  and tper.dta_fim_validade is null ');
      Q.SQL.Add('  and tper.cod_perfil = :cod_perfil ');

{$ENDIF}
      Q.ParamByName('cod_papel').AsInteger  := CodPapel;
      Q.ParamByName('cod_funcao').AsInteger := ECodFuncao;
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(255, Self.ClassName, 'InserirFuncao', []);
        Result := -255;
        Exit;
      end;
      Q.Close;

      // Abre transação
      beginTran;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      if CodRegistroLog < 0 then begin
        Result := CodRegistroLog;
        Exit;
      end;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_perfil_funcao ');
      Q.SQL.Add('(cod_perfil, ');
      Q.SQL.Add(' cod_funcao, ');
      Q.SQL.Add(' cod_registro_log) ');
      Q.SQL.Add('values ');
      Q.SQL.Add('(:cod_perfil, ');
      Q.SQL.Add(' :cod_funcao, ');
      Q.SQL.Add(' :cod_registro_log) ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.ParamByName('cod_funcao').AsInteger := ECodFuncao;
      Q.ParamByName('cod_registro_log').AsInteger := CodRegistroLog;

      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_perfil_funcao', CodRegistroLog, 1, CodClasse);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Confirma transação
      Commit;
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(CodErro, Self.ClassName, 'InserirFuncao', [E.Message]);
        Result := - CodErro;
        Exit;
      end;
    end;
  finally
    Q.Free;
    QAux.Free;
  end;
end;

function TIntPerfis.InserirItemMenu(ECodPerfil,
                                    ECodItemMenu: Integer): Integer;
var
  Q, QAux : THerdomQuery;
  CodPapel, CodItemMenuPai, CodErro, CodClasse : Integer;
begin
  CodErro := 247;
  CodClasse := 64;

  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('InserirItemMenu');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodClasse) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'InserirItemMenu', []);
    Result := -188;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  QAux := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Verifica existencia do registro Perfil
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_papel from tab_perfil ');
      Q.SQL.Add(' where cod_perfil = :cod_perfil ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(222, Self.ClassName, 'InserirItemMenu', [IntToStr(ECodPerfil)]);
        Result := -222;
        Exit;
      end else begin
        CodPapel := Q.FieldByName('cod_papel').AsInteger;
      end;
      Q.Close;

      // Verifica existencia do registro Item Menu
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select qtd_filhos, cod_item_pai ');
      Q.SQL.Add(' from tab_item_menu ');
      Q.SQL.Add(' where cod_item_menu = :cod_item_menu ');
      Q.SQL.Add('   and cod_papel = :cod_papel ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_item_menu').AsInteger := ECodItemMenu;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(244, Self.ClassName, 'InserirItemMenu', [IntToStr(ECodItemMenu)]);
        Result := -244;
        Exit;
      end else begin
        // Verifica se o Item Menu nao tem filhos
        if Q.FieldByName('qtd_filhos').AsInteger > 0 then begin
          Mensagens.Adicionar(246, Self.ClassName, 'InserirItemMenu', []);
          Result := -246;
          Exit;
        end else begin
          // Armazena o Item Menu Pai
          CodItemMenuPai := 0;
          if not Q.FieldByName('cod_item_pai').IsNull then begin
            CodItemMenuPai := Q.FieldByName('cod_item_pai').AsInteger;
          end;
        end;
      end;
      Q.Close;

      // Verifica se o Papel do Perfil é igual ao do Item Menu
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 ');
      Q.SQL.Add('from tab_item_menu ti, ');
      Q.SQL.Add('     tab_perfil tp ');
      Q.SQL.Add('where ti.cod_papel = tp.cod_papel ');
      Q.SQL.Add('  and tp.cod_perfil = :cod_perfil ');
      Q.SQL.Add('  and ti.cod_item_menu = :cod_item_menu ');
      Q.SQL.Add('  and ti.dta_fim_validade is null ');
      Q.SQL.Add('  and tp.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.ParamByName('cod_item_menu').AsInteger := ECodItemMenu;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(245, Self.ClassName, 'InserirItemMenu', []);
        Result := -245;
        Exit;
      end;
      Q.Close;

      // Verifica se o Item Menu já está inserido na tab_perfil_item_menu
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_perfil_item_menu ');
      Q.SQL.Add('where cod_item_menu = :cod_item_menu ');
      Q.SQL.Add('  and cod_papel = :cod_papel ');
      Q.SQL.Add('  and cod_perfil = :cod_perfil ');
{$ENDIF}
      Q.ParamByName('cod_item_menu').AsInteger := ECodItemMenu;
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.ParamByName('cod_perfil').AsInteger := ECodPerfil;
      Q.Open;
      if not Q.IsEmpty then begin
        Result := 0;
        Exit;
      end;
      Q.Close;


      // Abre transação
      beginTran;
      //Insercao do Menu Item
      Result := RotinaInserirItemMenu(ECodPerfil, CodPapel, ECodItemMenu, CodClasse, CodErro);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;
      //Insercao da Funcao do Item Menu
      Result := RotinaInserirItemMenuFuncao(ECodPerfil, CodPapel, ECodItemMenu, CodClasse, CodErro);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      //Rotina para insercao dos Pais do Item Menu
      while CodItemMenuPai > 0 Do begin
        //Insercao do Menu Item Pai
        Result := RotinaInserirItemMenu(ECodPerfil, CodPapel, CodItemMenuPai, CodClasse, CodErro);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
        //Insercao da Funcao do Item Menu Pai
        Result := RotinaInserirItemMenuFuncao(ECodPerfil, CodPapel, CodItemMenuPai, CodClasse, CodErro);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;

        // Verifica se o Item Menu tem Pai
        QAux.SQL.Clear;
{$IFDEF MSSQL}
        QAux.SQL.Add('select cod_item_pai ');
        QAux.SQL.Add(' from tab_item_menu ');
        QAux.SQL.Add(' where cod_item_menu = :cod_item_menu ');
        QAux.SQL.Add('   and cod_papel = :cod_papel ');
        QAux.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
        QAux.ParamByName('cod_item_menu').AsInteger     := CodItemMenuPai;
        QAux.ParamByName('cod_papel').AsInteger         := CodPapel;
        QAux.Open;
        if not QAux.IsEmpty then begin
          // Armazena o Item Menu Pai
          CodItemMenuPai := 0;
          if not QAux.FieldByName('cod_item_pai').IsNull then begin
            CodItemMenuPai := QAux.FieldByName('cod_item_pai').AsInteger;
          end;
        end else begin
          CodItemMenuPai := 0;
        end;
      end;

      // Confirma transação
      Commit;
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(CodErro, Self.ClassName, 'InserirItemMenu', [E.Message]);
        Result := - CodErro;
        Exit;
      end;
    end;
  finally
    Q.Free;
    QAux.Free;
  end;
end;


{* Função responsável por retornar os perfis cadastrados no sistema (tab_perfil).

   @param ECodPapel Integer
   @param EIndPesquisarDesativados Boolean

   @return 0 Valor retornado quando a execução do método ocorrer com sucesso.
   @return -188 Valor retornado quando o usuário que for executar o método
                (usuário logado no sistema) não possuir acesso ao método, ou seja,
                o usuário não tem acesso ao método.
   @return -2186 Valor retornado quando o usuário logado no sistema for um gestor
                 e o mesmo tentar filtrar por papeis diferentes de técnico e
                 produtor.
   @return -221 Valor retornado quando ocorrer alguma exceção durante a execução
                do método.
}
function TIntPerfis.Pesquisar(ECodPapel: Integer;
                              EIndPesquisarDesativados: Boolean): Integer;
const
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(46) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  end;

  if (Conexao.CodPapelUsuario = 9) and (not ECodPapel in [3, 4]) then
  begin
    Mensagens.Adicionar(2186, Self.ClassName, NomMetodo, []);
    Result := -2186;
    Exit;
  end; 

  Query.Close;
  {$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add(' select tper.cod_perfil as CodPerfil ');
  Query.SQL.Add('      , tper.nom_perfil as NomPerfil ');
  Query.SQL.Add('      , tpap.des_papel as DesPapel   ');
  Query.SQL.Add('      , tper.dta_fim_validade as dtaFimValidade ');
  Query.SQL.Add('   from tab_perfil tper ');
  Query.SQL.Add('      , tab_papel tpap ');
  Query.SQL.Add('  where ((tper.dta_fim_validade is null) or (:ind_pesquisar_desativados = 1)) ');
  Query.SQL.Add('    and tper.cod_papel = tpap.cod_papel and tper.cod_perfil <> 1');

  if ECodPapel >= 0 then
  begin
    Query.SQL.Add('  and tper.cod_papel = :cod_papel ');
  end;

  // Caso o usuário logado seja um Gestor, apenas os perfis de técnico e
  // produtor deverão ser listados.
  if (Conexao.CodPapelUsuario = 9) and (ECodPapel < 0) then
  begin
    Query.SQL.Add('  and tper.cod_papel in (3, 4) ');
  end;


  Query.SQL.Add('  order by tper.nom_perfil ');
  {$ENDIF}

  if ECodPapel >= 0 then
  begin
    Query.ParamByName('cod_papel').AsInteger := ECodPapel;
  end;

  if EIndPesquisarDesativados then
  begin
    Query.ParamByName('ind_pesquisar_desativados').AsInteger := 1;
  end
  else
  begin
    Query.ParamByName('ind_pesquisar_desativados').AsInteger := 0;
  end;

  try
    Query.Open;
    Result := 0;
  except
    on E: exception do
    begin
      Mensagens.Adicionar(221, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -221;
      Exit;
    end;
  end;
end;

function TIntPerfis.PesquisarFuncoes(ECodPerfil,
                                     ECodMenu: Integer): Integer;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('PesquisarFuncoes');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(69) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarFuncoes', []);
    Result := -188;
    Exit;
  end;

  // Verifica parametro CodPerfil
  if ECodPerfil = -1 then begin
    Mensagens.Adicionar(251, Self.ClassName, 'PesquisarFuncoes', []);
    Result := -251;
    Exit;
  end;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;

  Query.SQL.Add('select tim.cod_item_menu as CodItemMenu, ');
  Query.SQL.Add('       tim.txt_titulo as TxtTitulo, ');
  Query.SQL.Add('       tf.cod_funcao as CodFuncao, ');
  Query.SQL.Add('       tf.nom_funcao as NomFuncao, ');
  Query.SQL.Add('       case when tpf.cod_funcao is null ');
  Query.SQL.Add('         then ''N'' ');
  Query.SQL.Add('         else ''S'' ');
  Query.SQL.Add('       end as IndPertencePerfil ');

  Query.SQL.Add('from tab_perfil tper, ');
  Query.SQL.Add('     tab_item_menu tim, ');
  Query.SQL.Add('     tab_item_menu_funcao timf, ');
  Query.SQL.Add('     tab_funcao tf, ');
  Query.SQL.Add('     tab_perfil_funcao tpf, ');
  Query.SQL.Add('     tab_perfil_item_menu tpim ');

  Query.SQL.Add('where tim.cod_papel = tper.cod_papel ');
  Query.SQL.Add('  and tim.cod_papel = timf.cod_papel ');
  Query.SQL.Add('  and tim.cod_item_menu = timf.cod_item_menu ');

  if ECodMenu > 0 then begin
    Query.SQL.Add('  and tim.cod_menu = :cod_menu ');
  end;

  Query.SQL.Add('  and tf.cod_funcao = timf.cod_funcao ');

  Query.SQL.Add('  and tpf.cod_perfil =* tper.cod_perfil ');
  Query.SQL.Add('  and tpf.cod_funcao =* timf.cod_funcao ');

  Query.SQL.Add('  and tpim.cod_perfil = tper.cod_perfil ');
  Query.SQL.Add('  and tpim.cod_papel = timf.cod_papel ');
  Query.SQL.Add('  and tpim.cod_item_menu = timf.cod_item_menu ');

  Query.SQL.Add('  and tper.cod_perfil = :cod_perfil ');

  Query.SQL.Add('order by tf.Num_ordem ');
{$ENDIF}

  Query.ParamByName('cod_perfil').AsInteger := ECodPerfil;

  if ECodMenu > 0 then begin
    Query.ParamByName('cod_menu').AsInteger := ECodMenu;
  end;

  try
    Query.Open;
    Result := 0;
  except
    on E: exception do begin
      Rollback;
      Mensagens.Adicionar(253, Self.ClassName, 'PesquisarFuncoes', [E.Message]);
      Result := -253;
      Exit;
    end;
  end;
end;

function TIntPerfis.PesquisarItemMenu(ECodPerfil,
                                      ECodMenu: Integer): Integer;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('PesquisarItemMenu');
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(66) then begin
    Mensagens.Adicionar(188, Self.ClassName, 'PesquisarItemMenu', []);
    Result := -188;
    Exit;
  end;

  // Verifica parametro CodPerfil
  if ECodPerfil = -1 then begin
    Mensagens.Adicionar(251, Self.ClassName, 'PesquisarItemMenu', []);
    Result := -251;
    Exit;
  end;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;

  Query.SQL.Add('select tim.cod_item_menu as CodItemMenu, ');
  Query.SQL.Add('       tim.txt_titulo as TxtTitulo, ');
  Query.SQL.Add('       tim.num_nivel as NumNivel, ');
  Query.SQL.Add('       tim.qtd_filhos as QtdFilhos, ');
  Query.SQL.Add('       tpag.cod_pagina as CodPagina, ');
  Query.SQL.Add('       tpag.des_pagina as DesPagina, ');

  Query.SQL.Add('       case when tpim.cod_item_menu is null ');
  Query.SQL.Add('         then ''N'' ');
  Query.SQL.Add('         else ''S'' ');
  Query.SQL.Add('       end as IndPertencePerfil ');

  Query.SQL.Add('from tab_item_menu tim, ');
  Query.SQL.Add('     tab_perfil tper, ');
  Query.SQL.Add('     tab_pagina tpag, ');
  Query.SQL.Add('     tab_perfil_item_menu tpim ');
  Query.SQL.Add('where tper.cod_papel = tim.cod_papel ');
  Query.SQL.Add('  and tpag.cod_pagina =* tim.cod_pagina ');

  Query.SQL.Add('  and tpim.cod_perfil =* tper.cod_perfil ');
  Query.SQL.Add('  and tpim.cod_papel =* tper.cod_papel ');
  Query.SQL.Add('  and tpim.cod_item_menu =* tim.cod_item_menu ');

  Query.SQL.Add('  and tper.dta_fim_validade is null ');
  Query.SQL.Add('  and tim.dta_fim_validade is null ');

  if ECodMenu > 0 then begin
    Query.SQL.Add('  and tim.cod_menu = :cod_menu ');
  end;

  Query.SQL.Add('  and tper.cod_perfil = :cod_perfil ');

  Query.SQL.Add('order by tim.num_ordem ');
{$ENDIF}

  Query.ParamByName('cod_perfil').AsInteger := ECodPerfil;

  if ECodMenu > 0 then begin
    Query.ParamByName('cod_menu').AsInteger := ECodMenu;
  end;

  try
    Query.Open;
    Result := 0;
  except
    on E: exception do begin
      Rollback;
      Mensagens.Adicionar(252, Self.ClassName, 'PesquisarItemMenu', [E.Message]);
      Result := -252;
      Exit;
    end;
  end;
end;

function TIntPerfis.RotinaInserirItemMenuFuncao(ECodPerfil,
                                                ECodPapel,
                                                ECodItemMenu,
                                                ECodClasse,
                                                ECodErro: Integer): Integer;
var
  Q, QAux : THerdomQuery;
  CodRegistroLog : Integer;
begin

  Q := THerdomQuery.Create(Conexao, nil);
  QAux := THerdomQuery.Create(Conexao, nil);
  try
    try

      //Insercao das Funcoes do Item Menu
      QAux.SQL.Clear;
{$IFDEF MSSQL}
      QAux.SQL.Add('select cod_funcao from tab_item_menu_funcao tim ');
      QAux.SQL.Add('where tim.cod_item_menu = :cod_item_menu ');
      QAux.SQL.Add('  and tim.cod_papel = :cod_papel ');
      QAux.SQL.Add('  and tim.dta_fim_validade is null ');
      QAux.SQL.Add('  and not exists ( select 1 from tab_perfil_funcao tpf ');
      QAux.SQL.Add('                   where tpf.cod_perfil = :cod_perfil ');
      QAux.SQL.Add('                     and tpf.cod_funcao = tim.cod_funcao ) ');
{$ENDIF}
      QAux.ParamByName('cod_item_menu').AsInteger     := ECodItemMenu;
      QAux.ParamByName('cod_papel').AsInteger         := ECodPapel;
      QAux.ParamByName('cod_perfil').AsInteger        := ECodPerfil;
      QAux.Open;
      if not QAux.IsEmpty then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_perfil_funcao ');
        Q.SQL.Add('(cod_perfil, ');
        Q.SQL.Add(' cod_funcao, ');
        Q.SQL.Add(' cod_registro_log ');
        Q.SQL.Add(') ');
        Q.SQL.Add('values ');
        Q.SQL.Add('(:cod_perfil, ');
        Q.SQL.Add(' :cod_funcao, ');
        Q.SQL.Add(' :cod_registro_log ');
        Q.SQL.Add(') ');
{$ENDIF}
        while not QAux.EOF Do begin
          // Pega próximo CodRegistroLog
          CodRegistroLog := ProximoCodRegistroLog;
          if CodRegistroLog < 0 then begin
            Result := CodRegistroLog;
            Exit;
          end;

          // Inserir Funcoes do Item Menu
          Q.ParamByName('cod_perfil').AsInteger        := ECodPerfil;
          Q.ParamByName('cod_funcao').AsInteger        := QAux.FieldByName('cod_funcao').AsInteger;
          //VERIFICAR REGISTRO DE LOG
          Q.ParamByName('cod_registro_log').AsInteger  := CodRegistroLog;
          Q.ExecSQL;

          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
          Result := GravarLogOperacao('tab_perfil_funcao', CodRegistroLog, 1, ECodClasse);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

          QAux.Next;
        end;
      end;
      QAux.Close;

      // Retorna código do banner criado
      Result := 0;
    except
      on E: exception do begin
        Mensagens.Adicionar(ECodErro, Self.ClassName, 'RotinaInserirItemMenuFuncao', [E.Message]);
        Result := -ECodErro;
        Exit;
      end;
    end;
  finally
    Q.Free;
    QAux.Free;
  end;
end;

function TIntPerfis.RotinaInserirItemMenu(ECodPerfil,
                                          ECodPapel,
                                          ECodItemMenu,
                                          ECodClasse,
                                          ECodErro: Integer): Integer;
var
  Q, QAux : THerdomQuery;
  CodRegistroLog : Integer;
begin

  Q := THerdomQuery.Create(Conexao, nil);
  QAux := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Tenta Inserir Registro
      QAux.SQL.Clear;
{$IFDEF MSSQL}
      QAux.SQL.Add('select 1 from tab_perfil_item_menu ');
      QAux.SQL.Add('where cod_perfil = :cod_perfil ');
      QAux.SQL.Add('  and cod_papel = :cod_papel ');
      QAux.SQL.Add('  and cod_item_menu = :cod_item_menu ');
{$ENDIF}
      QAux.ParamByName('cod_perfil').AsInteger        := ECodPerfil;
      QAux.ParamByName('cod_papel').AsInteger         := ECodPapel;
      QAux.ParamByName('cod_item_menu').AsInteger     := ECodItemMenu;
      QAux.Open;

      if QAux.IsEmpty then begin

        // Pega próximo CodRegistroLog
        CodRegistroLog := ProximoCodRegistroLog;
        if CodRegistroLog < 0 then begin
          Result := CodRegistroLog;
          Exit;
        end;

        // Tenta Inserir Registro
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_perfil_item_menu ');
        Q.SQL.Add('(cod_perfil, ');
        Q.SQL.Add(' cod_papel, ');
        Q.SQL.Add(' cod_item_menu, ');
        Q.SQL.Add(' cod_registro_log ');
        Q.SQL.Add(') ');
        Q.SQL.Add('values ');
        Q.SQL.Add('(:cod_perfil, ');
        Q.SQL.Add(' :cod_papel, ');
        Q.SQL.Add(' :cod_item_menu, ');
        Q.SQL.Add(' :cod_registro_log ');
        Q.SQL.Add(') ');
{$ENDIF}
        Q.ParamByName('cod_perfil').AsInteger        := ECodPerfil;
        Q.ParamByName('cod_papel').AsInteger         := ECodPapel;
        Q.ParamByName('cod_item_menu').AsInteger     := ECodItemMenu;
        Q.ParamByName('cod_registro_log').AsInteger  := CodRegistroLog;

        Q.ExecSQL;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
        Result := GravarLogOperacao('tab_perfil_item_menu', CodRegistroLog, 1, ECodClasse);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
      end;


      // Retorna código do banner criado
      Result := 0;
    except
      on E: exception do begin
        Mensagens.Adicionar(ECodErro, Self.ClassName, 'RotinaInserirItemMenu', [E.Message]);
        Result := -ECodErro;
        Exit;
      end;
    end;
  finally
    Q.Free;
    QAux.Free;
  end;
end;

function TIntPerfis.RotinaExcluirItemMenu(ECodPerfil,
                                          ECodPapel,
                                          ECodItemMenu,
                                          ECodClasse,
                                          ECodErro: Integer): Integer;
var
  Q, QAux : THerdomQuery;
  CodRegistroLog : Integer;
begin


  Q := THerdomQuery.Create(Conexao, nil);
  QAux := THerdomQuery.Create(Conexao, nil);
  try
    try

      // Tenta Inserir Registro
      QAux.SQL.Clear;
{$IFDEF MSSQL}
      QAux.SQL.Add('select cod_registro_log from tab_perfil_item_menu ');
      QAux.SQL.Add('where cod_perfil = :cod_perfil ');
      QAux.SQL.Add('  and cod_papel = :cod_papel ');
      QAux.SQL.Add('  and cod_item_menu = :cod_item_menu ');
{$ENDIF}
      QAux.ParamByName('cod_perfil').AsInteger        := ECodPerfil;
      QAux.ParamByName('cod_papel').AsInteger         := ECodPapel;
      QAux.ParamByName('cod_item_menu').AsInteger     := ECodItemMenu;

      QAux.Open;

      if not QAux.IsEmpty then begin
        CodRegistroLog := QAux.FieldByName('cod_registro_log').AsInteger;

        // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
        // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
        Result := GravarLogOperacao('tab_perfil_item_menu', CodRegistroLog, 4, ECodClasse);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;

        // Tenta Excluir Registro
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_perfil_item_menu ');
        Q.SQL.Add('where cod_perfil = :cod_perfil ');
        Q.SQL.Add('  and cod_papel = :cod_papel ');
        Q.SQL.Add('  and cod_item_menu = :cod_item_menu ');
  {$ENDIF}
        Q.ParamByName('cod_perfil').AsInteger        := ECodPerfil;
        Q.ParamByName('cod_papel').AsInteger         := ECodPapel;
        Q.ParamByName('cod_item_menu').AsInteger     := ECodItemMenu;

        Q.ExecSQL;
      end;

      Result := 0;
    except
      on E: exception do begin
        Mensagens.Adicionar(ECodErro, Self.ClassName, 'RotinaExcluirItemMenu', [E.Message]);
        Result := -ECodErro;
        Exit;
      end;
    end;
  finally
    Q.Free;
    QAux.Free;
  end;
end;

function TIntPerfis.RotinaExcluirItemMenuFuncao(ECodPerfil,
                                                ECodPapel,
                                                ECodItemMenu,
                                                ECodClasse,
                                                ECodErro: Integer): Integer;
var
  Q, QAux : THerdomQuery;
  CodRegistroLog : Integer;
begin


  Q := THerdomQuery.Create(Conexao, nil);
  QAux := THerdomQuery.Create(Conexao, nil);
  try
    try

      //Exclusão das Funcoes do Item Menu
      QAux.SQL.Clear;
{$IFDEF MSSQL}
      QAux.SQL.Add('select tim.cod_funcao, ');
      QAux.SQL.Add('       tpf.cod_registro_log ');
      QAux.SQL.Add('from tab_item_menu_funcao tim , ');
      QAux.SQL.Add('     tab_perfil_funcao tpf ');
      QAux.SQL.Add('where tim.cod_item_menu = :cod_item_menu ');
      QAux.SQL.Add('  and tim.cod_papel = :cod_papel ');
      QAux.SQL.Add('  and tim.cod_funcao = tpf.cod_funcao ');
      QAux.SQL.Add('  and tpf.cod_perfil = :cod_perfil ');
{$ENDIF}
      QAux.ParamByName('cod_item_menu').AsInteger     := ECodItemMenu;
      QAux.ParamByName('cod_papel').AsInteger         := ECodPapel;
      QAux.ParamByName('cod_perfil').AsInteger        := ECodPerfil;
      QAux.Open;
      if not QAux.IsEmpty then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_perfil_funcao ');
        Q.SQL.Add('where cod_perfil = :cod_perfil ');
        Q.SQL.Add('  and cod_funcao = :cod_funcao ');
{$ENDIF}
        while not QAux.EOF Do begin
          CodRegistroLog := QAux.FieldByName('cod_registro_log').AsInteger;

          // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
          // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
          Result := GravarLogOperacao('tab_perfil_funcao', CodRegistroLog, 4, ECodClasse);
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

          // Excluir Funcoes do Item Menu
          Q.ParamByName('cod_perfil').AsInteger        := ECodPerfil;
          Q.ParamByName('cod_funcao').AsInteger        := QAux.FieldByName('cod_funcao').AsInteger;
          Q.ExecSQL;

          QAux.Next;
        end;
      end;
      QAux.Close;

      Result := 0;
    except
      on E: exception do begin
        Mensagens.Adicionar(ECodErro, Self.ClassName, 'RotinaExcluirItemMenuFuncao', [E.Message]);
        Result := ECodErro * -1;
        Exit;
      end;
    end;
  finally
    Q.Free;
    QAux.Free;
  end;
end;

end.
