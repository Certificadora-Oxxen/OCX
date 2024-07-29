// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       : Controle de Insumos - Definição das Classes
// *  Código Classe      : 64
// *  Descrição Resumida : Cadastro de Entradas de Insumo
// ************************************************************************
// *  Últimas Alterações
// *  Hitalo   01/10/2002  adicionar NumCNPJCPFRevendedor, TxtObservacao
// *  Hitalo   08/10/2002  adicionar metodo PesquisarRelatorio,GerarRelatorio
// *
// *
// *
// ********************************************************************
unit uIntEntradasInsumo;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,
     uIntEntradaInsumo, uferramentas, uIntRelatorios;

type
  TIntEntradasInsumo = class(TIntClasseBDNavegacaoBasica)
  private
   FIntEntradaInsumo : TIntEntradaInsumo;
    function PesquisarRelatorio(SglProdutor,NomPessoaProdutor : String;CodTipoInsumo,
          CodSubTipoInsumo: Integer; DesInsumo, NomFabricanteInsumo : String;
          NumRegistroFabricante: Integer; NomRevendedor, NumCnpjCpfRevendedor: String;
          DtaCompraInicio, DtaCompraFim: TDateTime;
          IndDataOrdemCrescente: String): Integer;
   
  public
    constructor Create; override;
    destructor Destroy; override;
    function Inserir(CodFazenda, CodTipoInsumo, CodSubTipoInsumo,
      CodInsumo: Integer; DesInsumo, NomFabricanteInsumo: String;
      NumRegistroFabricante, CodPessoaSecundaria: Integer;
      NomRevendedor, NumCNPJCPFRevendedor: String;
      DtaCompra: TDateTime; NumnotaFiscal: Integer;
      NumPartidaLote: String; DtaValidade: TDateTime;
      QtdInsumo: Double; CodUnidadeMedida: Integer;
      TxtObservacao: String;Custo:double = 0 ): Integer;
    function Alterar(CodEntradaInsumo, CodInsumo: Integer; DesInsumo,
      NomFabricanteInsumo: String; NumRegistroFabricante,
      CodPessoaSecundaria: Integer; NomRevendedor,
      NumCNPJCPFRevendedor: String; DtaCompra: TDateTime;
      NumnotaFiscal: Integer; NumPartidaLote: String;
      DtaValidade: TDateTime; QtdInsumo: Double; CodUnidadeMedida: Integer;
      TxtObservacao: String;Custo:Double): Integer;
    function Buscar(CodEntradaInsumo: Integer): Integer;
    function Excluir(CodEntradaEvendo: Integer): Integer;
    function Pesquisar(CodEntradaInsumoInicio, CodEntradaInsumoFim,
      CodTipoInsumo, CodSubTipoInsumo: Integer; DesInsumo,
      NomFabricanteInsumo: WideString; NumRegistroFabricante: Integer;
      NomRevendedor, NumCNPJCPFRevendedor: String;
      DtaCompraInicio, DtaCompraFim, DtaValidade: TDateTime;
      CodOrdenacao, OrdenacaoCrescente: String; CodFazenda:Integer;
      IndEntradasemFazenda, IndSubEventoSanitario:string): Integer;

    function RelatorioConsolidado(SglProdutor,
                                  NomPessoaProdutor: String;
                                  CodTipoInsumo,
                                  CodSubTipoInsumo: Integer;
                                  DesInsumo,
                                  NomFabricanteInsumo: String;
                                  NumRegistroFabricante: Integer;
                                  NomRevendedor,
                                  NumCnpjCpfRevendedor: String;
                                  DtaCompraInicio,
                                  DtaCompraFim: TDateTime;
                                  IndDataOrdemCrescente: String;
                                  Tipo,
                                  QtdQuebraRelatorio: Integer): String;

    property IntEntradaInsumo : TIntEntradaInsumo read FIntEntradaInsumo write FIntEntradaInsumo;
  end;

implementation

constructor TIntEntradasInsumo.Create;
begin
  inherited;
  FIntEntradaInsumo := TIntEntradaInsumo.Create;
end;

destructor TIntEntradasInsumo.Destroy;
begin
  FIntEntradaInsumo.Free;
  inherited;
end;

function TIntEntradasInsumo.Inserir(CodFazenda, CodTipoInsumo, CodSubTipoInsumo,
      CodInsumo: Integer; DesInsumo, NomFabricanteInsumo: String;
      NumRegistroFabricante, CodPessoaSecundaria: Integer;
      NomRevendedor, NumCNPJCPFRevendedor: String;
      DtaCompra: TDateTime; NumnotaFiscal: Integer;
      NumPartidaLote: String; DtaValidade: TDateTime;
      QtdInsumo: Double; CodUnidadeMedida: Integer;
      TxtObservacao: String;Custo:double = 0): Integer;
var
  Q : THerdomQuery;
  IndSubtipo, IndAdmite: String;
  cnpjcpfaux:string;
  I, CodEntradaInsumo:Integer;
  testaNump:boolean;
const
  NomMetodo : String = 'Inserir';
  CodMetodo : Integer = 296;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  // Verifica se produtor de trabalho foi definido
  if Conexao.CodProdutorTrabalho = -1 then begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
     //-------------------------------
     // Verifica se a fazenda é valida
     //-------------------------------
      if CodFazenda > 0 then begin
         Q.SQL.Clear;
{$IFDEF MSSQL}
         Q.SQL.Add('select 1 from tab_fazenda ');
         Q.SQL.Add(' where  cod_fazenda = :cod_fazenda');
         Q.SQL.Add('   and cod_pessoa_produtor = :cod_pessoa_produtor ');
         Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
         Q.ParamByName('cod_fazenda').AsInteger := CodFazenda;
         Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
         Q.Open;
         if Q.IsEmpty then begin
            Mensagens.Adicionar(310, Self.ClassName, NomMetodo, []);
            Result := -310;
            Exit;
         end;
         Q.Close;
      end;
     //--------------------------------------
     // Verifica se o tipo de insumo é valido
     //--------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ind_sub_tipo_obrigatorio as IndSubTipoObrigatorio, ');
      Q.SQL.Add(' ind_admite_partida_lote as IndAdmitePartidaLote ');
      Q.SQL.Add(' from tab_tipo_insumo ');
      Q.SQL.Add(' where  cod_tipo_insumo = :cod_tipo_insumo ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(800, Self.ClassName, NomMetodo, []);
        Result := -800;
        Exit;
      end else
        IndSubTipo := Q.fieldbyname('IndSubTipoObrigatorio').asstring;
        IndAdmite := Q.fieldbyname('IndAdmitePartidaLote').asstring;
      Q.Close;

     //-----------------------------------------
     // Verifica se o subtipo de insumo é valido
     //-----------------------------------------
      if IndSubTipo = 'S' then begin
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_sub_tipo_insumo ');
        Q.SQL.Add(' where  cod_sub_tipo_insumo = :cod_sub_tipo_insumo');
        Q.SQL.Add(' and    cod_tipo_insumo = :cod_tipo_insumo');
        Q.SQL.Add(' and    dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
        Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
        Q.Open;
        if Q.IsEmpty then begin
           Mensagens.Adicionar(811, Self.ClassName, NomMetodo, []);
           Result := -811;
           Exit;
        end;
        Q.Close;
      end
      else
        CodSubTipoInsumo := -1;

     //--------------------------------------
     // Verifica se o CodInsumo foi informado
     //--------------------------------------
     if CodInsumo < 0 then
        if DesInsumo = '' then
           begin
             Mensagens.Adicionar(884, Self.ClassName, NomMetodo, []);
             Result := -884;
             Exit;
           end;
     if (CodInsumo > 0) then begin
         DesInsumo := '';
         NomFabricanteInsumo := '';
         NumRegistroFabricante := -1;
     end;
     //------------------------------
     // Verifica se o insumo é valido
     //------------------------------
      if CodInsumo > 0 then begin
         Q.SQL.Clear;
{$IFDEF MSSQL}
         Q.SQL.Add('select 1 from tab_insumo ');
         Q.SQL.Add(' where  cod_insumo = :cod_insumo');
         Q.SQL.Add('   and cod_tipo_insumo =:cod_tipo_insumo ');
         Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
         Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
         Q.ParamByName('cod_insumo').AsInteger := CodInsumo;
         Q.Open;
         if Q.IsEmpty then begin
            Mensagens.Adicionar(867, Self.ClassName, NomMetodo, []);
            Result := -867;
            Exit;
         end;
         Q.Close;
      end;

      //-------------------------------------------------------------
      // Trata DesInsumo, NomFabricanteInsumo e NumRegistroFabricante
      //-------------------------------------------------------------
      if DesInsumo <> '' then begin
        Result := VerificaString(DesInsumo, 'Descrição Insumo');
        if Result < 0 then begin
           Exit;
        end;

        Result := TrataString(DesInsumo, 20, 'Descrição do Insumo');
        if Result < 0 then begin
           Exit;
        end;
        if NomFabricanteInsumo <> '' then begin
           Result := VerificaString(NomFabricanteInsumo, 'Nome do Fabricante');
           if Result < 0 then begin
              Exit;
           end;

           Result := TrataString(NomFabricanteInsumo, 30, 'Nome do Fabricante');
           if Result < 0 then begin
              Exit;
           end;
        end;

        if NomFabricanteInsumo = '' then NumRegistroFabricante := -1;
      end;

     //------------------------------------------------
     // Verifica se o CodPessoaSecundaria foi informado
     //------------------------------------------------
     if (CodPessoaSecundaria > 0) then begin
         NomRevendedor := '';
         NumCNPJCPFRevendedor := '';
     end;

     if (CodPessoaSecundaria < 0) and (NomRevendedor = '') then
        NumnotaFiscal := -1;

     if (NumCNPJCPFRevendedor <> '') and (NomRevendedor = '') then begin
        Mensagens.Adicionar(885, Self.ClassName, NomMetodo, []);
        Result := -885;
        Exit;
     end;

     //-----------------------------------------------------------------
     // Verifica, caso seja informado, se o CodPessoaSecundaria é valido
     //-----------------------------------------------------------------
      if CodPessoaSecundaria > 0 then begin
         Q.SQL.Clear;
{$IFDEF MSSQL}
         Q.SQL.Add(' select 1  ');
         Q.SQL.Add(' from tab_pessoa_secundaria as tps, ');
         Q.SQL.Add('      tab_pessoa_papel_secundario as tpps ');
         Q.SQL.Add(' where tpps.cod_papel_secundario = 4 ');
         Q.SQL.Add(' and   tpps.cod_pessoa_secundaria = tps.cod_pessoa_secundaria ');
         Q.SQL.Add(' and   tpps.cod_pessoa_produtor = tps.cod_pessoa_produtor ');
         Q.SQL.Add(' and   tps.cod_pessoa_produtor =:cod_pessoa_produtor ');
         Q.SQL.Add(' and   tps.cod_pessoa_secundaria = :cod_pessoa_secundaria ');
{$ENDIF}
         Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
         Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
         Q.Open;
         if Q.IsEmpty then begin
            Mensagens.Adicionar(418, Self.ClassName, NomMetodo, []);
            Result := -418;
            Exit;
         end;
         Q.Close;
      end;

      //------------------------------------------
      // Trata NomRevendedor, NumCNPJCPFRevendedor
      //------------------------------------------
      if NomRevendedor <> '' then begin
        Result := VerificaString(NomRevendedor, 'Nome do Revendedor');
        if Result < 0 then begin
           Exit;
        end;

        Result := TrataString(NomRevendedor, 30, 'Nome do Revendedor');
        if Result < 0 then begin
           Exit;
        end;

        if NumCNPJCPFRevendedor <> '' then begin
           if length(NumCNPJCPFRevendedor) <= 11 then begin
              Mensagens.Adicionar(1051, Self.ClassName, NomMetodo, []);
              Result := -1051;
              Exit;
           end;
           if length(NumCNPJCPFRevendedor) > 11 then cnpjcpfaux := copy(NumCNPJCPFRevendedor,1,12);
           if not VerificarCNPJCPF(cnpjcpfaux,NumCNPJCPFRevendedor, 'N') then begin
              Mensagens.Adicionar(424, Self.ClassName, NomMetodo, []);
              Result := -424;
              Exit;
           end;
        end;
      end;

      //----------------
      // Trata DtaCompra
      //----------------
      if DtaCompra = 0 then begin
         Mensagens.Adicionar(887, Self.ClassName, NomMetodo, []);
         Result := -887;
         Exit;
      end;

      //---------------------
      // Trata NumPartidaLote
      //---------------------
      if IndAdmite <> 'S'
         then NumPartidaLote := ''
         else begin
               testaNump := true;
               for I:= 1 to Length(NumPartidaLote) do
                    if not((NumPartidaLote[I] in ['A'..'Z']) or
                           (NumPartidaLote[I] in ['a'..'z']) or
                           (NumPartidaLote[I] in ['0'..'9']) or
                           (NumPartidaLote[I] = '-') or
                           (NumPartidaLote[I] = '/'))
                       then testaNump := false;
               if not testaNump then begin
                  Mensagens.Adicionar(888, Self.ClassName, NomMetodo, []);
                  Result := -888;
                  Exit;
               end;
         end;

      //---------------------
      // Trata DtaValidade
      //---------------------
      if DtaValidade <> 0 then
         if DtaValidade < DtaCompra then begin
            Mensagens.Adicionar(889, Self.ClassName, NomMetodo, []);
            Result := -889;
            Exit;
         end;

      //---------------------
      // Trata QtdInsumo
      //---------------------
      if (QtdInsumo <= 0) or (QtdInsumo > 9999999) then begin
         Mensagens.Adicionar(890, Self.ClassName, NomMetodo, []);
         Result := -890;
         Exit;
      end;

      //------------------------
      // Trata CodUnidadeMedida
      //------------------------
      if CodUnidadeMedida < 0 then begin
         Mensagens.Adicionar(891, Self.ClassName, NomMetodo, []);
         Result := -891;
         Exit;
      end else begin
         Q.SQL.Clear;
{$IFDEF MSSQL}
         Q.SQL.Add('select 1 ');
         Q.SQL.Add(' from tab_tipo_insumo_unidade_medida ');
         Q.SQL.Add(' where cod_unidade_medida = :cod_unidade_medida and ');
         Q.SQL.Add('       cod_tipo_insumo = :cod_tipo_insumo ');
{$ENDIF}
         Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
         Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
         Q.Open;
         if Q.IsEmpty then begin
            Mensagens.Adicionar(892, Self.ClassName, NomMetodo, []);
            Result := -892;
            Exit;
         end;
         Q.Close;
      end;
      //---------------
      // Abre transação
      //---------------
      beginTran;

      //--------------------
      // Pega próximo código
      //---------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_entrada_insumo), 0) + 1 as cod_entrada_insumo ');
      Q.SQL.Add('  from tab_entrada_insumo');
{$ENDIF}
      Q.Open;
      CodEntradaInsumo := Q.FieldByName('cod_entrada_insumo').AsInteger;
      //-------------------------
      // Tenta Inserir Registro
      //-------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_entrada_insumo ');
      Q.SQL.Add(' (cod_pessoa_produtor, ');
      Q.SQL.Add('  cod_entrada_insumo, ');
      Q.SQL.Add('  cod_fazenda, ');
      Q.SQL.Add('  cod_tipo_insumo, ');
      Q.SQL.Add('  cod_sub_tipo_insumo, ');
      Q.SQL.Add('  cod_insumo, ');
      Q.SQL.Add('  des_insumo, ');
      Q.SQL.Add('  nom_fabricante_insumo, ');
      Q.SQL.Add('  num_registro_fabricante, ');
      Q.SQL.Add('  num_cnpj_cpf_revendedor, ');
      Q.SQL.Add('  nom_revendedor, ');
      Q.SQL.Add('  cod_pessoa_secundaria, ');
      Q.SQL.Add('  dta_compra, ');
      Q.SQL.Add('  num_nota_fiscal, ');
      Q.SQL.Add('  num_partida_lote, ');
      Q.SQL.Add('  dta_validade, ');
      Q.SQL.Add('  qtd_insumo, ');
      Q.SQL.Add('  cod_unidade_medida, ');
      Q.SQL.Add('  txt_observacao, ');
      Q.SQL.Add('  dta_cadastramento,custo) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_pessoa_produtor, ');
      Q.SQL.Add('  :cod_entrada_insumo, ');
      if CodFazenda > 0
         then Q.SQL.Add('  :cod_fazenda, ')
         else Q.SQL.Add('  null, ');
      Q.SQL.Add('  :cod_tipo_insumo, ');
      if CodSubTipoInsumo < 0
         then Q.SQL.Add('  null, ')
         else Q.SQL.Add('  :cod_sub_tipo_insumo, ');
      if CodInsumo < 0
         then begin
           Q.SQL.Add('  null, ');
           Q.SQL.Add('  :des_insumo, ');
           if NomFabricanteInsumo <> ''
              then Q.SQL.Add('  :nom_fabricante_insumo, ')
              else Q.SQL.Add('  null, ');
           if NumRegistroFabricante > 0
              then Q.SQL.Add('  :num_registro_fabricante, ')
              else Q.SQL.Add('  null, ');
         end
         else begin
           Q.SQL.Add('  :cod_insumo, ');
           Q.SQL.Add('  null, ');
           Q.SQL.Add('  null, ');
           Q.SQL.Add('  null, ');
         end;
      if CodPessoaSecundaria < 0
         then begin
           if NumCNPJCPFRevendedor <> ''
              then Q.SQL.Add('  :num_cnpj_cpf_revendedor, ')
              else Q.SQL.Add('  null, ');
           if NomRevendedor <> ''
              then Q.SQL.Add('  :nom_revendedor, ')
              else Q.SQL.Add('  null, ');
           Q.SQL.Add('  null, ');
         end
         else begin
           Q.SQL.Add('  null, ');
           Q.SQL.Add('  null, ');
           Q.SQL.Add('  :cod_pessoa_secundaria, ');
         end;
      Q.SQL.Add('  :dta_compra, ');
      if NumnotaFiscal < 0
         then Q.SQL.Add('  null, ')
         else Q.SQL.Add('  :num_nota_fiscal, ');
      if NumPartidaLote = ''
         then Q.SQL.Add('  null, ')
         else Q.SQL.Add('  :num_partida_lote, ');
      if DtaValidade = 0
         then Q.SQL.Add('  null, ')
         else Q.SQL.Add('  :dta_validade, ');
      Q.SQL.Add('  :qtd_insumo, ');
      Q.SQL.Add('  :cod_unidade_medida, ');
      if TxtObservacao = ''
         then Q.SQL.Add('  null, ')
         else Q.SQL.Add('  :txt_observacao, ');
         //druzo 19/01/2010
         //      Q.SQL.Add('  getdate()) ');
      Q.SQL.Add('  getdate(), ');
      Q.SQL.Add('  :custo) ');
      q.ParamByName('custo').AsFloat  :=  Custo;
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger        := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_entrada_insumo').AsInteger         := CodEntradaInsumo;
      if CodFazenda > 0 then
         Q.ParamByName('cod_fazenda').AsInteger             := CodFazenda;
      Q.ParamByName('cod_tipo_insumo').AsInteger            := CodTipoInsumo;
      if CodSubTipoInsumo > 0
         then Q.ParamByName('cod_sub_tipo_insumo').AsInteger := CodSubTipoInsumo;
      if CodInsumo > 0
         then Q.ParamByName('cod_insumo').AsInteger := CodInsumo
         else begin
           Q.ParamByName('des_insumo').AsString := DesInsumo;
           if NomFabricanteInsumo <> ''
              then Q.ParamByName('nom_fabricante_insumo').AsString := NomFabricanteInsumo;
           if NumRegistroFabricante > 0
              then Q.ParamByName('num_registro_fabricante').AsInteger := NumregistroFabricante;
         end;
      if CodPessoaSecundaria > 0
         then Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria
         else begin
           if NumCNPJCPFRevendedor <> ''
              then Q.ParamByName('num_cnpj_cpf_revendedor').AsString := NumCNPJCPFRevendedor;
           if NomRevendedor <> ''
              then Q.ParamByName('nom_revendedor').AsString := NomRevendedor;
         end;
      Q.ParamByName('dta_compra').AsDateTime                := DtaCompra;
      if NumnotaFiscal > 0
         then Q.ParamByName('num_nota_fiscal').AsInteger := NumnotaFiscal;
      if NumPartidaLote <> ''
         then Q.ParamByName('num_partida_lote').AsString := NumPartidaLote;
      if DtaValidade <> 0
         then Q.ParamByName('dta_validade').AsDateTime := DtaValidade;
      Q.ParamByName('qtd_insumo').AsFloat                   := QtdInsumo;
      Q.ParamByName('cod_unidade_medida').AsInteger         := CodUnidadeMedida;
      if TxtObservacao <> ''
         then Q.ParamByName('txt_observacao').AsString := TxtObservacao;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodEntradaInsumo;
    Except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(893, Self.ClassName, NomMetodo, [E.Message]);
        Result := -893;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntEntradasInsumo.Alterar(CodEntradaInsumo, CodInsumo: Integer; DesInsumo,
      NomFabricanteInsumo: String; NumRegistroFabricante,
      CodPessoaSecundaria: Integer; NomRevendedor,
      NumCNPJCPFRevendedor: String; DtaCompra: TDateTime;
      NumnotaFiscal: Integer; NumPartidaLote: String;
      DtaValidade: TDateTime; QtdInsumo: Double; CodUnidadeMedida: Integer;
      TxtObservacao: String;Custo:Double): Integer;
var
  Q : THerdomQuery;
  IndSubtipo, IndAdmite: String;
  cnpjcpfaux:string;
  I, CodTipoInsumo:Integer;
  testaNump:boolean;
const
  NomMetodo : String ='Alterar';
  CodMetodo : Integer = 297;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;
  //----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  if Conexao.CodProdutorTrabalho = -1 then begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
     //-----------------------------------------
     // Verifica se a Entrada de Insumo é válida
     //-----------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ti.cod_tipo_insumo as CodTipoInsumo, ti.ind_sub_tipo_obrigatorio as IndSubTipoObrigatorio, ');
      Q.SQL.Add(' ti.ind_admite_partida_lote as IndAdmitePartidaLote ');
      Q.SQL.Add(' from tab_tipo_insumo as ti, tab_entrada_insumo as te ');
      Q.SQL.Add(' where  ti.cod_tipo_insumo = te.cod_tipo_insumo ');
      Q.SQL.Add(' and    te.cod_entrada_insumo = :cod_entrada_insumo ');
      Q.SQL.Add(' and    te.cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_entrada_insumo').AsInteger := CodEntradaInsumo;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(904, Self.ClassName, NomMetodo, []);
        Result := -904;
        Exit;
      end else
        IndSubTipo := Q.fieldbyname('IndSubTipoObrigatorio').asstring;
        CodTipoInsumo := Q.fieldbyname('CodTipoInsumo').asinteger;
        IndAdmite := Q.fieldbyname('IndAdmitePartidaLote').asstring;
      Q.Close;

     //--------------------------------------
     // Verifica se o CodInsumo foi informado
     //--------------------------------------
     if CodInsumo < 0 then
        if DesInsumo = '' then
           begin
             Mensagens.Adicionar(884, Self.ClassName, NomMetodo, []);
             Result := -884;
             Exit;
           end;
     if (CodInsumo > 0) then begin
         DesInsumo := '';
         NomFabricanteInsumo := '';
         NumRegistroFabricante := -1;
     end;
     //------------------------------
     // Verifica se o insumo é valido
     //------------------------------
      if CodInsumo > 0 then begin
         Q.SQL.Clear;
{$IFDEF MSSQL}
         Q.SQL.Add('select 1 from tab_insumo ');
         Q.SQL.Add(' where  cod_insumo = :cod_insumo');
         Q.SQL.Add('   and cod_tipo_insumo =:cod_tipo_insumo ');
         Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
         Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
         Q.ParamByName('cod_insumo').AsInteger := CodInsumo;
         Q.Open;
         if Q.IsEmpty then begin
            Mensagens.Adicionar(867, Self.ClassName, NomMetodo, []);
            Result := -867;
            Exit;
         end;
         Q.Close;
      end;

      //-------------------------------------------------------------
      // Trata DesInsumo, NomFabricanteInsumo e NumRegistroFabricante
      //-------------------------------------------------------------
      if DesInsumo <> '' then begin
        Result := VerificaString(DesInsumo, 'Descrição Insumo');
        if Result < 0 then begin
           Exit;
        end;

        Result := TrataString(DesInsumo, 20, 'Descrição do Insumo');
        if Result < 0 then begin
           Exit;
        end;
        if NomFabricanteInsumo <> '' then begin
           Result := VerificaString(NomFabricanteInsumo, 'Nome do Fabricante');
           if Result < 0 then begin
              Exit;
           end;

           Result := TrataString(NomFabricanteInsumo, 30, 'Nome do Fabricante');
           if Result < 0 then begin
              Exit;
           end;
        end;

        if NomFabricanteInsumo = '' then NumRegistroFabricante := -1;
      end;

     //------------------------------------------------
     // Verifica se o CodPessoaSecundaria foi informado
     //------------------------------------------------
     if (CodPessoaSecundaria > 0) then begin
         NomRevendedor := '';
         NumCNPJCPFRevendedor := '';
     end;

     if (CodPessoaSecundaria < 0) and (NomRevendedor = '') then
        NumnotaFiscal := -1;

     if (NumCNPJCPFRevendedor <> '') and (NomRevendedor = '') then begin
        Mensagens.Adicionar(885, Self.ClassName, NomMetodo, []);
        Result := -885;
        Exit;
     end;

     //-----------------------------------------------------------------
     // Verifica, caso seja informado, se o CodPessoaSecundaria é valido
     //-----------------------------------------------------------------
      if CodPessoaSecundaria > 0 then begin
         Q.SQL.Clear;
{$IFDEF MSSQL}
         Q.SQL.Add(' select 1  ');
         Q.SQL.Add(' from tab_pessoa_secundaria as tps, ');
         Q.SQL.Add('      tab_pessoa_papel_secundario as tpps ');
         Q.SQL.Add(' where tpps.cod_papel_secundario = 4 ');
         Q.SQL.Add(' and   tpps.cod_pessoa_secundaria = tps.cod_pessoa_secundaria ');
         Q.SQL.Add(' and   tpps.cod_pessoa_produtor = tps.cod_pessoa_produtor ');
         Q.SQL.Add(' and   tps.cod_pessoa_produtor =:cod_pessoa_produtor ');
         Q.SQL.Add(' and   tps.cod_pessoa_secundaria = :cod_pessoa_secundaria ');
{$ENDIF}
         Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
         Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
         Q.Open;
         if Q.IsEmpty then begin
            Mensagens.Adicionar(418, Self.ClassName, NomMetodo, []);
            Result := -418;
            Exit;
         end;
         Q.Close;
      end;

      //------------------------------------------
      // Trata NomRevendedor, NumCNPJCPFRevendedor
      //------------------------------------------
      if NomRevendedor <> '' then begin
        Result := VerificaString(NomRevendedor, 'Nome do Revendedor');
        if Result < 0 then begin
           Exit;
        end;

        Result := TrataString(NomRevendedor, 30, 'Nome do Revendedor');
        if Result < 0 then begin
           Exit;
        end;
        if NumCNPJCPFRevendedor <> '' then begin
           if length(NumCNPJCPFRevendedor) <= 11 then cnpjcpfaux := copy(NumCNPJCPFRevendedor,1,9);
           if length(NumCNPJCPFRevendedor) > 11 then cnpjcpfaux := copy(NumCNPJCPFRevendedor,1,12);
           if not VerificarCNPJCPF(cnpjcpfaux,NumCNPJCPFRevendedor,'N') then begin
              Mensagens.Adicionar(424, Self.ClassName, NomMetodo, []);
              Result := -424;
              Exit;
           end;
        end;
      end;

      //----------------
      // Trata DtaCompra
      //----------------
      if DtaCompra = 0 then begin
         Mensagens.Adicionar(887, Self.ClassName, NomMetodo, []);
         Result := -887;
         Exit;
      end;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add(' select te.dta_inicio as dtainicio  ');
      Q.SQL.Add(' from tab_evento as te, ');
      Q.SQL.Add('      tab_evento_sanitario as tes, tab_entrada_insumo as ti ');
      Q.SQL.Add(' where ti.cod_entrada_insumo = :cod_entrada_insumo ');
      Q.SQL.Add(' and   ti.cod_entrada_insumo = tes.cod_entrada_insumo ');
      Q.SQL.Add(' and   tes.cod_evento = te.cod_evento ');
{$ENDIF}
      Q.ParamByName('cod_entrada_insumo').AsInteger := CodEntradaInsumo;
      Q.Open;
      if not Q.IsEmpty then
         if Q.fieldbyname('dtainicio').asdatetime < DtaCompra then begin
            Mensagens.Adicionar(895, Self.ClassName, NomMetodo, []);
            Result := -895;
            Exit;
         end;
      Q.Close;

      //---------------------
      // Trata NumPartidaLote
      //---------------------
      if IndAdmite <> 'S'
         then NumPartidaLote := ''
         else begin
               testaNump := true;
               for I:= 1 to Length(NumPartidaLote) do
                    if not((NumPartidaLote[I] in ['A'..'Z']) or
                           (NumPartidaLote[I] in ['a'..'z']) or
                           (NumPartidaLote[I] in ['0'..'9']) or
                           (NumPartidaLote[I] = '-') or
                           (NumPartidaLote[I] = '/'))
                       then testaNump := false;
               if not testaNump then begin
                  Mensagens.Adicionar(888, Self.ClassName, NomMetodo, []);
                  Result := -888;
                  Exit;
               end;
         end;

      //---------------------
      // Trata DtaValidade
      //---------------------
      if DtaValidade <> 0 then
         if DtaValidade < DtaCompra then begin
            Mensagens.Adicionar(889, Self.ClassName, NomMetodo, []);
            Result := -889;
            Exit;
         end;

      //---------------------
      // Trata QtdInsumo
      //---------------------
      if (QtdInsumo <= 0) or (QtdInsumo > 9999999) then begin
         Mensagens.Adicionar(890, Self.ClassName, NomMetodo, []);
         Result := -890;
         Exit;
      end;

      //------------------------
      // Trata CodUnidadeMedida
      //------------------------
      if CodUnidadeMedida < 0 then begin
         Mensagens.Adicionar(891, Self.ClassName, NomMetodo, []);
         Result := -891;
         Exit;
      end else begin
         Q.SQL.Clear;
{$IFDEF MSSQL}
         Q.SQL.Add('select 1 ');
         Q.SQL.Add(' from tab_tipo_insumo_unidade_medida ');
         Q.SQL.Add(' where cod_unidade_medida = :cod_unidade_medida and ');
         Q.SQL.Add('       cod_tipo_insumo = :cod_tipo_insumo ');
{$ENDIF}
         Q.ParamByName('cod_unidade_medida').AsInteger := CodUnidadeMedida;
         Q.ParamByName('cod_tipo_insumo').AsInteger := CodTipoInsumo;
         Q.Open;
         if Q.IsEmpty then begin
            Mensagens.Adicionar(892, Self.ClassName, NomMetodo, []);
            Result := -892;
            Exit;
         end;
         Q.Close;
      end;
      //---------------
      // Abre transação
      //---------------
      beginTran;

      //-------------------------
      // Tenta Alterar Registro
      //-------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_entrada_insumo set ');
      if CodInsumo < 0 then begin
           Q.SQL.Add('  cod_insumo = null, ');
           Q.SQL.Add('  des_insumo =:des_insumo, ');
           if NomFabricanteInsumo <> ''
              then Q.SQL.Add('  nom_fabricante_insumo =:nom_fabricante_insumo, ')
              else Q.SQL.Add('  nom_fabricante_insumo = null, ');
           if NumRegistroFabricante > 0
              then Q.SQL.Add('  num_registro_fabricante =:num_registro_fabricante, ')
              else Q.SQL.Add('  num_registro_fabricante = null, ');
         end
         else begin
           Q.SQL.Add('  cod_insumo =:cod_insumo, ');
           Q.SQL.Add('  des_insumo = null, ');
           Q.SQL.Add('  nom_fabricante_insumo = null, ');
           Q.SQL.Add('  num_registro_fabricante = null, ');
         end;
      if CodPessoaSecundaria < 0 then begin
           if NumCNPJCPFRevendedor <> ''
              then Q.SQL.Add('  num_cnpj_cpf_revendedor =:num_cnpj_cpf_revendedor, ')
              else Q.SQL.Add('  num_cnpj_cpf_revendedor = null, ');
           if NomRevendedor <> ''
              then Q.SQL.Add('  nom_revendedor =:nom_revendedor, ')
              else Q.SQL.Add('  nom_revendedor = null, ');
           Q.SQL.Add('  cod_pessoa_secundaria = null, ');
       end  else begin
           Q.SQL.Add('  num_cnpj_cpf_revendedor = null, ');
           Q.SQL.Add('  nom_revendedor = null, ');
           Q.SQL.Add('  cod_pessoa_secundaria = :cod_pessoa_secundaria, ');
         end;
      Q.SQL.Add('  dta_compra =:dta_compra, ');
      if NumnotaFiscal < 0
         then Q.SQL.Add('  num_nota_fiscal = null, ')
         else Q.SQL.Add('  num_nota_fiscal =:num_nota_fiscal, ');
      if NumPartidaLote = ''
         then Q.SQL.Add('  num_partida_lote = null, ')
         else Q.SQL.Add('  num_partida_lote =:num_partida_lote, ');
      if DtaValidade = 0
         then Q.SQL.Add('  dta_validade = null, ')
         else Q.SQL.Add('  dta_validade =:dta_validade, ');
      Q.SQL.Add('  qtd_insumo =:qtd_insumo, ');
      //druzo
      Q.SQL.Add('  custo =:custo, ');
      Q.SQL.Add('  cod_unidade_medida =:cod_unidade_medida, ');
      if TxtObservacao = ''
         then Q.SQL.Add('  txt_observacao = null ')
         else Q.SQL.Add('  txt_observacao =:txt_observacao ');
      Q.SQL.Add('  where cod_entrada_insumo =:cod_entrada_insumo ');
{$ENDIF}
      if CodInsumo > 0
         then Q.ParamByName('cod_insumo').AsInteger := CodInsumo
         else begin
           Q.ParamByName('des_insumo').AsString := DesInsumo;
           if NomFabricanteInsumo <> ''
              then Q.ParamByName('nom_fabricante_insumo').AsString := NomFabricanteInsumo;
           if NumRegistroFabricante > 0
              then Q.ParamByName('num_registro_fabricante').AsInteger := NumregistroFabricante;
         end;
      if CodPessoaSecundaria > 0
         then Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria
         else begin
           if NumCNPJCPFRevendedor <> ''
              then Q.ParamByName('num_cnpj_cpf_revendedor').AsString := NumCNPJCPFRevendedor;
           if NomRevendedor <> ''
              then Q.ParamByName('nom_revendedor').AsString := NomRevendedor;
         end;
      Q.ParamByName('dta_compra').AsDateTime                := DtaCompra;
      if NumnotaFiscal > 0
         then Q.ParamByName('num_nota_fiscal').AsInteger := NumnotaFiscal;
      if NumPartidaLote <> ''
         then Q.ParamByName('num_partida_lote').AsString := NumPartidaLote;
      if DtaValidade <> 0
         then Q.ParamByName('dta_validade').AsDateTime := DtaValidade;
      Q.ParamByName('qtd_insumo').AsFloat                   := QtdInsumo;
      Q.ParamByName('cod_unidade_medida').AsInteger         := CodUnidadeMedida;
      if TxtObservacao <> ''
         then Q.ParamByName('txt_observacao').AsString := TxtObservacao;
      Q.ParamByName('cod_entrada_insumo').AsInteger         := CodEntradaInsumo;
      Q.ParamByName('custo').AsFloat                        :=  custo;

      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código de OK Alteração
      Result := 0;
    Except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(896, Self.ClassName, NomMetodo, [E.Message]);
        Result := -896;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntEntradasInsumo.Buscar(CodEntradaInsumo: Integer): Integer;
var
  Q : THerdomQuery;
const
  NomMetodo : String ='Buscar';
  CodMetodo : Integer = 299;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  // Verifica se produtor de trabalho foi definido
  if Conexao.CodProdutorTrabalho = -1 then begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------
      // Buscar Registro
      //-----------------
      Q.close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Clear;
      Q.SQL.Add('select * from ' +
                  '(select tei.cod_pessoa_produtor as CodPessoaProdutor, ' +
                  '       tei.cod_entrada_insumo as CodEntradaInsumo, ' +
                  '       tei.cod_fazenda as CodFazenda, ' +
                  '       tf.sgl_fazenda as SglFazenda, ' +
                  '       tf.nom_fazenda as NomFazenda, ' +
                  '       tei.cod_tipo_insumo as CodTipoInsumo, ' +
                  '       tti.sgl_tipo_insumo as SglTipoInsumo, ' +
                  '       tti.des_tipo_insumo as DesTipoInsumo, ' +
                  '       tti.ind_admite_partida_lote as IndAdmitePartidaLote, ' +
                  '       tei.cod_sub_tipo_insumo as CodSubTipoInsumo, ' +
                  '       tsti.sgl_sub_tipo_insumo as SglSubTipoInsumo, ' +
                  '       tsti.des_sub_tipo_insumo as DesSubTipoInsumo, ' +
                  '       ti.cod_insumo as CodInsumo, ' +
                  '       ti.des_insumo as DesInsumo, ' +
                  '       tfi.cod_fabricante_insumo as CodFabricanteInsumo, ' +
                  '       tfi.nom_fabricante_insumo as NomFabricanteInsumo, ' +
                  '       tfi.num_registro_fabricante as NumRegistroFabricante, ' +
                  '       tps.cod_pessoa_secundaria as CodPessoaSecundaria, ' +
                  '       case  ' +
                  '         when tei.cod_pessoa_secundaria is null then tei.nom_revendedor  ' +
                  '         else tps.nom_pessoa_secundaria end as NomRevendedor, ' +
                  '       case  ' +
                  '         when tei.cod_pessoa_secundaria is null then tei.num_cnpj_cpf_revendedor ' +
                  '         else tps.num_cnpj_cpf end as NumCNPJCPFRevendedor, '+
                  '       case  ' +
                  '       when tei.cod_pessoa_secundaria is null then ' +
                  '       case len(tei.num_cnpj_cpf_revendedor) ' +
                  '       when 11 then convert(varchar(18), ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 1, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 4, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 7, 3) + ''-'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 10, 2)) ' +
                  '       when 14 then convert(varchar(18), ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 1, 2) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 3, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 6, 3) + ''/'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 9, 4) + ''-'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 13, 2)) ' +
                  '       end ' +
                  '       else ' +
                  '       case len(tps.num_cnpj_cpf) ' +
                  '       when 11 then convert(varchar(18), ' +
                  '          substring(tps.num_cnpj_cpf, 1, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 4, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 7, 3) + ''-'' + ' +
                  '          substring(tps.num_cnpj_cpf, 10, 2)) ' +
                  '       when 14 then convert(varchar(18), ' +
                  '          substring(tps.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                  '          substring(tps.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                  '          substring(tps.num_cnpj_cpf, 13, 2)) ' +
                  '       end ' +
                  '       end as NumCNPJCPFRevendedorFormatado, ' +
                  '       tei.dta_compra as DtaCompra, ' +
                  '       tei.num_nota_fiscal as NumnotaFiscal, ' +
                  '       tei.num_partida_lote as NumPartidaLote, ' +
                  '       tei.dta_validade as DtaValidade, ' +
                  '       tei.qtd_insumo as QtdInsumo, ' +
                  '       tei.cod_unidade_medida as CodUnidadeMedida, ' +
                  '       tum.sgl_unidade_medida as SglUnidadeMedida, ' +
                  '       tei.txt_observacao as TxtObservacao, coalesce(tei.custo,0) custo ' +
                  '  from tab_entrada_insumo as tei left join tab_pessoa_secundaria tps on tei.cod_pessoa_produtor = tps.cod_pessoa_produtor and tei.cod_pessoa_secundaria = tps.cod_pessoa_secundaria ' +
                  '                                 left join tab_fazenda as tf on tei.cod_fazenda = tf.cod_fazenda and tei.cod_pessoa_produtor = tf.cod_pessoa_produtor ' +
                  '                                 left join tab_sub_tipo_insumo as tsti on tei.cod_sub_tipo_insumo = tsti.cod_sub_tipo_insumo, ' +
                  '       tab_tipo_insumo as tti, ' +
                  '       tab_insumo as ti, ' +
                  '       tab_fabricante_insumo as tfi, ' +
                  '       tab_unidade_medida as tum ' +
                  ' where tei.cod_tipo_insumo = tti.cod_tipo_insumo ' +
                  ' and   tei.cod_insumo = ti.cod_insumo ' +
                  ' and   ti.cod_fabricante_insumo = tfi.cod_fabricante_insumo ' +
                  ' and   tei.cod_unidade_medida = tum.cod_unidade_medida ' +
                  ' and   tei.des_insumo is null ');
    Q.SQL.Add(' union  ' +
                  'select tei.cod_pessoa_produtor as CodPessoaProdutor, ' +
                  '       tei.cod_entrada_insumo as CodEntradaInsumo, ' +
                  '       tei.cod_fazenda as CodFazenda, ' +
                  '       tf.sgl_fazenda as SglFazenda, ' +
                  '       tf.nom_fazenda as NomFazenda, ' +
                  '       tei.cod_tipo_insumo as CodTipoInsumo, ' +
                  '       tti.sgl_tipo_insumo as SglTipoInsumo, ' +
                  '       tti.des_tipo_insumo as DesTipoInsumo, ' +
                  '       tti.ind_admite_partida_lote as IndAdmitePartidaLote, ' +
                  '       tei.cod_sub_tipo_insumo as CodSubTipoInsumo, ' +
                  '       tsti.sgl_sub_tipo_insumo as SglSubTipoInsumo, ' +
                  '       tsti.des_sub_tipo_insumo as DesSubTipoInsumo, ' +
                  '       0 as cod_insumo, ' +
                  '       tei.des_insumo as DesInsumo, ' +
                  '       0 as CodFabricanteInsumo, ' +
                  '       tei.nom_fabricante_insumo as NomFabricanteInsumo, ' +
                  '       tei.num_registro_fabricante as NumRegistroFabricante, ' +
                  '       tps.cod_pessoa_secundaria as CodPessoaSecundaria, ' +
                  '       case  ' +
                  '         when tei.cod_pessoa_secundaria is null then tei.nom_revendedor  ' +
                  '         else tps.nom_pessoa_secundaria end as NomRevendedor, ' +
                  '       case  ' +
                  '         when tei.cod_pessoa_secundaria is null then tei.num_cnpj_cpf_revendedor ' +
                  '         else tps.num_cnpj_cpf end as NumCNPJCPFRevendedor, '+
                  '       case  ' +
                  '       when tei.cod_pessoa_secundaria is null then ' +
                  '       case len(tei.num_cnpj_cpf_revendedor) ' +
                  '       when 11 then convert(varchar(18), ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 1, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 4, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 7, 3) + ''-'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 10, 2)) ' +
                  '       when 14 then convert(varchar(18), ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 1, 2) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 3, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 6, 3) + ''/'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 9, 4) + ''-'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 13, 2)) ' +
                  '       end ' +
                  '       else ' +
                  '       case len(tps.num_cnpj_cpf) ' +
                  '       when 11 then convert(varchar(18), ' +
                  '          substring(tps.num_cnpj_cpf, 1, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 4, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 7, 3) + ''-'' + ' +
                  '          substring(tps.num_cnpj_cpf, 10, 2)) ' +
                  '       when 14 then convert(varchar(18), ' +
                  '          substring(tps.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                  '          substring(tps.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                  '          substring(tps.num_cnpj_cpf, 13, 2)) ' +
                  '       end ' +
                  '       end as NumCNPJCPFRevendedorFormatado, ' +
                  '       tei.dta_compra as DtaCompra, ' +
                  '       tei.num_nota_fiscal as NumnotaFiscal, ' +
                  '       tei.num_partida_lote as NumPartidaLote, ' +
                  '       tei.dta_validade as DtaValidade, ' +
                  '       tei.qtd_insumo as QtdInsumo, ' +
                  '       tei.cod_unidade_medida as CodUnidadeMedida, ' +
                  '       tum.sgl_unidade_medida as SglUnidadeMedida, ' +
                  '       tei.txt_observacao as TxtObservacao ,coalesce(tei.custo,0) custo' +
                  '  from tab_entrada_insumo as tei left join tab_pessoa_secundaria tps on tei.cod_pessoa_produtor = tps.cod_pessoa_produtor and tei.cod_pessoa_secundaria = tps.cod_pessoa_secundaria ' +
                  '                                 left join tab_fazenda as tf on tei.cod_fazenda = tf.cod_fazenda and tei.cod_pessoa_produtor = tf.cod_pessoa_produtor ' +
                  '                                 left join tab_sub_tipo_insumo as tsti on tei.cod_sub_tipo_insumo = tsti.cod_sub_tipo_insumo, ' +
                  '       tab_tipo_insumo as tti, ' +
                  '       tab_unidade_medida as tum ' +
                  ' where tei.cod_tipo_insumo = tti.cod_tipo_insumo ' +
                  ' and   tei.cod_unidade_medida = tum.cod_unidade_medida ');
  Q.SQL.Add('       and   tei.cod_insumo is null ) as resultado');
  Q.SQL.Add(' where CodEntradaInsumo =:CodEntradaInsumo');
  Q.SQL.Add(' and   CodPessoaProdutor =:CodPessoaProdutor');
{$ENDIF}
      Q.ParamByName('CodEntradaInsumo').AsInteger := CodEntradaInsumo;
      Q.ParamByName('CodPessoaProdutor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      //---------------------------------------
      // Verifica se existe registro para busca
      //---------------------------------------
      if Q.IsEmpty then begin
        Mensagens.Adicionar(904, Self.ClassName, NomMetodo, []);
        Result := -904;
        Exit;
      end;
      //-------------------------------
      // Obtem informações do registro
      //-------------------------------
      IntEntradaInsumo.CodEntradaInsumo               := Q.FieldByName('CodEntradaInsumo').AsInteger;
      IntEntradaInsumo.CodPessoaProdutor              := Q.FieldByName('CodPessoaProdutor').AsInteger;
      IntEntradaInsumo.CodFazenda                     := Q.FieldByName('CodFazenda').AsInteger;
      IntEntradaInsumo.SglFazenda                     := Q.FieldByName('SglFazenda').AsString;
      IntEntradaInsumo.NomFazenda                     := Q.FieldByName('NomFazenda').AsString;
      IntEntradaInsumo.CodTipoInsumo                  := Q.FieldByName('CodTipoInsumo').AsInteger;
      IntEntradaInsumo.SglTipoInsumo                  := Q.FieldByName('SglTipoInsumo').AsString;
      IntEntradaInsumo.DesTipoInsumo                  := Q.FieldByName('DesTipoInsumo').AsString;
      IntEntradaInsumo.IndAdmitePartidaLote           := Q.FieldByName('IndAdmitePartidaLote').AsString;
      IntEntradaInsumo.CodSubTipoInsumo               := Q.FieldByName('CodSubTipoInsumo').AsInteger;
      IntEntradaInsumo.SglSubTipoInsumo               := Q.FieldByName('SglSubTipoInsumo').AsString;
      IntEntradaInsumo.DesSubTipoInsumo               := Q.FieldByName('DesSubTipoInsumo').AsString;
      IntEntradaInsumo.CodInsumo                      := Q.FieldByName('CodInsumo').AsInteger;
      IntEntradaInsumo.DesInsumo                      := Q.FieldByName('DesInsumo').AsString;
      IntEntradaInsumo.CodFabricanteInsumo            := Q.FieldByName('CodFabricanteInsumo').AsInteger;
      IntEntradaInsumo.NomFabricanteInsumo            := Q.FieldByName('NomFabricanteInsumo').AsString;
      IntEntradaInsumo.NumRegistroFabricante          := Q.FieldByName('NumRegistroFabricante').AsInteger;
      IntEntradaInsumo.CodPessoaSecundaria            := Q.FieldByName('CodPessoaSecundaria').AsInteger;
      IntEntradaInsumo.NomRevendedor                  := Q.FieldByName('NomRevendedor').AsString;
      IntEntradaInsumo.NumCNPJCPFRevendedorFormatado  := Q.FieldByName('NumCNPJCPFRevendedorFormatado').AsString;
      IntEntradaInsumo.DtaCompra                      := StrToDate(FormatDateTime('dd/mm/yyyy',Q.FieldByName('DtaCompra').AsDateTime));
      IntEntradaInsumo.NumnotaFiscal                  := Q.FieldByName('NumnotaFiscal').AsInteger;
      IntEntradaInsumo.NumPartidaLote                 := Q.FieldByName('NumPartidaLote').AsString;
      IntEntradaInsumo.DtaValidade                    := StrToDate(FormatDateTime('dd/mm/yyyy',Q.FieldByName('DtaValidade').AsDateTime));
      IntEntradaInsumo.QtdInsumo                      := Q.FieldByName('QtdInsumo').AsFloat;
      IntEntradaInsumo.CodUnidadeMedida               := Q.FieldByName('CodUnidadeMedida').AsInteger;
      IntEntradaInsumo.SglUnidadeMedida               := Q.FieldByName('SglUnidadeMedida').AsString;
      IntEntradaInsumo.NumCNPJCPFRevendedor           := Q.FieldByName('NumCNPJCPFRevendedor').AsString;
      IntEntradaInsumo.TxtObservacao                  := Q.FieldByName('TxtObservacao').AsString;
      IntEntradaInsumo.Custo                          := Q.FieldByName('custo').AsFloat;

      Q.close;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(905, Self.ClassName, NomMetodo, [E.Message]);
        Result := -905;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntEntradasInsumo.Excluir(CodEntradaEvendo: Integer): Integer;
var
  Q : THerdomQuery;
const
  NomMetodo : String ='Excluir';
  CodMetodo : Integer = 298;
begin

  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  end;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  end;

  // Verifica se produtor de trabalho foi definido
  if Conexao.CodProdutorTrabalho = -1 then begin
    Mensagens.Adicionar(307, Self.ClassName, NomMetodo, []);
    Result := -307;
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //-----------------------------------
      // Verifica a existência do registro
      //-----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_entrada_insumo ');
      Q.SQL.Add(' where  cod_entrada_insumo = :cod_entrada_insumo ');
      Q.SQL.Add(' and    cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_entrada_insumo').AsInteger := CodEntradaEvendo;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(904, Self.ClassName, NomMetodo, []);
        Result := -904;
        Exit;
      end;
      Q.Close;

      //--------------------------------------------------------------
      // Verifica se a entrada está associada a algum evento sanitario
      //--------------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_evento_sanitario ');
      Q.SQL.Add(' where  cod_entrada_insumo = :cod_entrada_insumo ');
{$ENDIF}
      Q.ParamByName('cod_entrada_insumo').AsInteger := CodEntradaEvendo;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(908, Self.ClassName, NomMetodo, []);
        Result := -908;
        Exit;
      end;
      Q.Close;

      // Abre transação
      beginTran;

      //-------------------
      // Exclui o Registro
      //-------------------
      Q.Close;
      Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_entrada_insumo ');
        Q.SQL.Add(' where cod_entrada_insumo = :cod_entrada_insumo ');
        Q.SQL.Add(' and   cod_pessoa_produtor = :cod_pessoa_produtor ');
  {$ENDIF}
      Q.ParamByName('cod_entrada_insumo').AsInteger := CodEntradaEvendo;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do begin
        Rollback;
        Mensagens.Adicionar(909, Self.ClassName, NomMetodo, [E.Message]);
        Result := -909;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntEntradasInsumo.Pesquisar(CodEntradaInsumoInicio, CodEntradaInsumoFim,
      CodTipoInsumo, CodSubTipoInsumo: Integer; DesInsumo,
      NomFabricanteInsumo: WideString; NumRegistroFabricante: Integer;
      NomRevendedor, NumCNPJCPFRevendedor: String;
      DtaCompraInicio, DtaCompraFim, DtaValidade: TDateTime;
      CodOrdenacao, OrdenacaoCrescente: String; CodFazenda:Integer;
      IndEntradasemFazenda, IndSubEventoSanitario:string): Integer;
Const
  NomeMetodo: String = 'Pesquisar';
  CodMetodo : Integer = 300;
begin
  Result := -1;

  if not Inicializado then begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  // Verifica se usuário pode executar método
  if not Conexao.PodeExecutarMetodo(CodMetodo) then begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  end;

  // Verifica se produtor de trabalho foi definido
  if Conexao.CodProdutorTrabalho = -1 then begin
    Mensagens.Adicionar(307, Self.ClassName, NomeMetodo, []);
    Result := -307;
    Exit;
  end;

  //Neste caso a pesquisa vai considerar apenas as entradas sem fazenda (fazenda = null)
  if IndEntradaSemFazenda = 'S' then
     CodFazenda := -1;

  //Neste caso a pesquisa não vai restringir a fazenda.
  if IndEntradaSemFazenda = 'A' then
     CodFazenda := -1;

  Query.Close;
  Query.SQL.Clear;

{$IFDEF MSSQL}
    Query.SQL.Add('select * from ' +
                  '(select tei.cod_pessoa_produtor as CodPessoaProdutor, ' +
                  '       tei.cod_entrada_insumo as CodEntradaInsumo, ' +
                  '       tei.cod_fazenda as CodFazenda, ' +
                  '       tf.sgl_fazenda as SglFazenda, ' +
                  '       tf.nom_fazenda as NomFazenda, ' +
                  '       tei.cod_tipo_insumo as CodTipoInsumo, ' +
                  '       tti.sgl_tipo_insumo as SglTipoInsumo, ' +
                  '       tti.des_tipo_insumo as DesTipoInsumo, ' +
                  '       tei.cod_sub_tipo_insumo as CodSubTipoInsumo, ' +
                  '       tsti.sgl_sub_tipo_insumo as SglSubTipoInsumo, ' +
                  '       tsti.des_sub_tipo_insumo as DesSubTipoInsumo, ' +
                  '       ti.des_insumo as DesInsumo, ' +
                  '       tfi.nom_fabricante_insumo as NomFabricanteInsumo, ' +
                  '       tfi.num_registro_fabricante as NumRegistroFabricante, ' +
                  '       case tps.nom_pessoa_secundaria ' +
                  '       when null then tei.nom_revendedor  ' +
                  '                 else tps.nom_pessoa_secundaria end as NomRevendedor, ' +
                  '       case tps.nom_pessoa_secundaria ' +
                  '       when null then tei.num_cnpj_cpf_revendedor ' +
                  '                 else tps.num_cnpj_cpf end as NumCNPJCPFRevendedor, '+
                  '       case tps.nom_pessoa_secundaria ' +
                  '       when null then ' +
                  '       case len(tei.num_cnpj_cpf_revendedor) ' +
                  '       when 11 then convert(varchar(18), ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 1, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 4, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 7, 3) + ''-'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 10, 2)) ' +
                  '       when 14 then convert(varchar(18), ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 1, 2) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 3, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 6, 3) + ''/'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 9, 4) + ''-'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 13, 2)) ' +
                  '       end ' +
                  '       else ' +
                  '       case len(tps.num_cnpj_cpf) ' +
                  '       when 11 then convert(varchar(18), ' +
                  '          substring(tps.num_cnpj_cpf, 1, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 4, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 7, 3) + ''-'' + ' +
                  '          substring(tps.num_cnpj_cpf, 10, 2)) ' +
                  '       when 14 then convert(varchar(18), ' +
                  '          substring(tps.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                  '          substring(tps.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                  '          substring(tps.num_cnpj_cpf, 13, 2)) ' +
                  '       end ' +
                  '       end as NumCNPJCPFRevendedorFormatado, ' +
                  '       tei.dta_compra as DtaCompra, ' +
                  '       tei.num_nota_fiscal as NumnotaFiscal, ' +
                  '       tei.num_partida_lote as NumPartidaLote, ' +
                  '       tei.dta_validade as DtaValidade, ' +
                  '       tei.qtd_insumo as QtdInsumo, ' +
                  '       tei.cod_unidade_medida as CodUnidadeMedida, ' +
                  '       tum.sgl_unidade_medida as SglUnidadeMedida,coalesce(tei.custo,0) custo ' +
                  '  from tab_entrada_insumo as tei, ' +
                  '       tab_fazenda as tf, ' +
                  '       tab_tipo_insumo as tti, ' +
                  '       tab_sub_tipo_insumo as tsti, ' +
                  '       tab_insumo as ti, ' +
                  '       tab_fabricante_insumo as tfi, ' +
                  '       tab_pessoa_secundaria as tps, ' +
                  '       tab_unidade_medida as tum ');
    if IndEntradaSemFazenda = 'N' then begin
        Query.SQL.Add(' where tei.cod_fazenda = tf.cod_fazenda ' +
                      ' and   tei.cod_pessoa_produtor = tf.cod_pessoa_produtor ');
    end else begin
        Query.SQL.Add(' where tei.cod_fazenda *= tf.cod_fazenda ' +
                      ' and   tei.cod_pessoa_produtor *= tf.cod_pessoa_produtor ');
    end;
    if IndEntradasemFazenda = 'S' then
        Query.SQL.Add(' and tei.cod_fazenda is null ');
    if CodFazenda > 0 then
        Query.SQL.Add(' and tei.cod_fazenda = :cod_fazenda ');
    if uppercase(IndSubEventoSanitario) = 'S' then
        Query.SQL.Add(' and tti.cod_tipo_sub_evento_sanitario is not null ');
    if uppercase(IndSubEventoSanitario) = 'N' then
        Query.SQL.Add(' and tti.cod_tipo_sub_evento_sanitario is null ');
    Query.SQL.Add(' and   tei.cod_tipo_insumo = tti.cod_tipo_insumo ' +
                  ' and   tei.cod_sub_tipo_insumo *= tsti.cod_sub_tipo_insumo ' +
                  ' and   tei.cod_insumo = ti.cod_insumo ' +
                  ' and   ti.cod_fabricante_insumo = tfi.cod_fabricante_insumo ' +
                  ' and   tei.cod_pessoa_secundaria *= tps.cod_pessoa_secundaria ' +
                  ' and   tei.cod_pessoa_produtor *= tps.cod_pessoa_produtor ' +
                  ' and   tei.cod_unidade_medida = tum.cod_unidade_medida ' +
                  ' and   tei.des_insumo is null ');
    if CodTipoInsumo > 0 then
         Query.SQL.Add(' and   tti.cod_tipo_insumo =:cod_tipo_insumo ');
    if CodSubTipoInsumo > 0 then
         Query.SQL.Add(' and   tei.cod_sub_tipo_insumo =:cod_sub_tipo_insumo ');
    Query.SQL.Add(' union  ' +
                  'select tei.cod_pessoa_produtor as CodPessoaProdutor, ' +
                  '       tei.cod_entrada_insumo as CodEntradaInsumo, ' +
                  '       tei.cod_fazenda as CodFazenda, ' +
                  '       tf.sgl_fazenda as SglFazenda, ' +
                  '       tf.nom_fazenda as NomFazenda, ' +
                  '       tei.cod_tipo_insumo as CodTipoInsumo, ' +
                  '       tti.sgl_tipo_insumo as SglTipoInsumo, ' +
                  '       tti.des_tipo_insumo as DesTipoInsumo, ' +
                  '       tei.cod_sub_tipo_insumo as CodSubTipoInsumo, ' +
                  '       tsti.sgl_sub_tipo_insumo as SglSubTipoInsumo, ' +
                  '       tsti.des_sub_tipo_insumo as DesSubTipoInsumo, ' +
                  '       tei.des_insumo as DesInsumo, ' +
                  '       tei.nom_fabricante_insumo as NomFabricanteInsumo, ' +
                  '       tei.num_registro_fabricante as NumRegistroFabricante, ' +
                  '       case tps.nom_pessoa_secundaria ' +
                  '       when null then tei.nom_revendedor  ' +
                  '                 else tps.nom_pessoa_secundaria end as NomRevendedor, ' +
                  '       case tps.nom_pessoa_secundaria ' +
                  '       when null then tei.num_cnpj_cpf_revendedor ' +
                  '                 else tps.num_cnpj_cpf end as NumCNPJCPFRevendedor, '+
                  '       case tps.nom_pessoa_secundaria ' +
                  '       when null then ' +
                  '       case len(tei.num_cnpj_cpf_revendedor) ' +
                  '       when 11 then convert(varchar(18), ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 1, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 4, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 7, 3) + ''-'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 10, 2)) ' +
                  '       when 14 then convert(varchar(18), ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 1, 2) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 3, 3) + ''.'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 6, 3) + ''/'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 9, 4) + ''-'' + ' +
                  '          substring(tei.num_cnpj_cpf_revendedor, 13, 2)) ' +
                  '       end ' +
                  '       else ' +
                  '       case len(tps.num_cnpj_cpf) ' +
                  '       when 11 then convert(varchar(18), ' +
                  '          substring(tps.num_cnpj_cpf, 1, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 4, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 7, 3) + ''-'' + ' +
                  '          substring(tps.num_cnpj_cpf, 10, 2)) ' +
                  '       when 14 then convert(varchar(18), ' +
                  '          substring(tps.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                  '          substring(tps.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                  '          substring(tps.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                  '          substring(tps.num_cnpj_cpf, 13, 2)) ' +
                  '       end ' +
                  '       end as NumCNPJCPFRevendedorFormatado, ' +
                  '       tei.dta_compra as DtaCompra, ' +
                  '       tei.num_nota_fiscal as NumnotaFiscal, ' +
                  '       tei.num_partida_lote as NumPartidaLote, ' +
                  '       tei.dta_validade as DtaValidade, ' +
                  '       tei.qtd_insumo as QtdInsumo, ' +
                  '       tei.cod_unidade_medida as CodUnidadeMedida, ' +
                  '       tum.sgl_unidade_medida as SglUnidadeMedida,coalesce(tei.custo,0) custo' +
                  '  from tab_entrada_insumo as tei, ' +
                  '       tab_fazenda as tf, ' +
                  '       tab_tipo_insumo as tti, ' +
                  '       tab_sub_tipo_insumo as tsti, ' +
                  '       tab_pessoa_secundaria as tps, ' +
                  '       tab_unidade_medida as tum ');
    if IndEntradaSemFazenda = 'N' then begin
        Query.SQL.Add(' where tei.cod_fazenda = tf.cod_fazenda ' +
                      ' and   tei.cod_pessoa_produtor = tf.cod_pessoa_produtor ');
    end else begin
        Query.SQL.Add(' where tei.cod_fazenda *= tf.cod_fazenda ' +
                      ' and   tei.cod_pessoa_produtor *= tf.cod_pessoa_produtor ');
    end;
    if IndEntradasemFazenda = 'S' then
        Query.SQL.Add(' and tei.cod_fazenda is null ');
    if CodFazenda > 0 then
        Query.SQL.Add(' and tei.cod_fazenda = :cod_fazenda ');
    if uppercase(IndSubEventoSanitario) = 'S' then
        Query.SQL.Add(' and tti.cod_tipo_sub_evento_sanitario is not null ');
    if uppercase(IndSubEventoSanitario) = 'N' then
        Query.SQL.Add(' and tti.cod_tipo_sub_evento_sanitario is null ');
    Query.SQL.Add(' and   tei.cod_tipo_insumo = tti.cod_tipo_insumo ' +
                  ' and   tei.cod_sub_tipo_insumo *= tsti.cod_sub_tipo_insumo ' +
                  ' and   tei.cod_pessoa_secundaria *= tps.cod_pessoa_secundaria ' +
                  ' and   tei.cod_pessoa_produtor *= tps.cod_pessoa_produtor ' +
                  ' and   tei.cod_unidade_medida = tum.cod_unidade_medida ');
  if CodTipoInsumo > 0 then
     Query.SQL.Add(' and   tti.cod_tipo_insumo =:cod_tipo_insumo ');
  if CodSubTipoInsumo > 0 then
     Query.SQL.Add(' and   tei.cod_sub_tipo_insumo =:cod_sub_tipo_insumo ');
  Query.SQL.Add(' and   tei.cod_insumo is null ) as resultado');
  Query.SQL.Add('  where CodPessoaProdutor =:CodPessoaProdutor ');
  if (CodEntradaInsumoInicio > 0) and (CodEntradaInsumoFim > 0) then
     Query.SQL.Add(' and CodEntradaInsumo between :CodEntradaInsumoInicio and :CodEntradaInsumoFim ');
  if (DesInsumo <> '') then
     Query.SQL.Add(' and DesInsumo like :DesInsumo ');
  if (NomFabricanteInsumo <> '') then
     Query.SQL.Add(' and NomFabricanteInsumo like :NomFabricanteInsumo ');
  if (NumRegistroFabricante > 0) then
     Query.SQL.Add(' and NumRegistroFabricante = :NumRegistroFabricante ');
  if (NomRevendedor <> '') then
     Query.SQL.Add(' and NomRevendedor like :NomRevendedor ');
  if (NumCNPJCPFRevendedor <> '') then
     Query.SQL.Add(' and NumCNPJCPFRevendedor = :NumCNPJCPFRevendedor ');
  if (DtaCompraInicio > 0) and (DtaCompraFim > 0) then
     Query.SQL.Add(' and DtaCompra between :DtaCompraInicio and :DtaCompraFim ');
  if (DtaValidade > 0) then
     Query.SQL.Add(' and DtaValidade < :DtaValidade ');
  if CodOrdenacao = 'C' then
     Query.SQL.Add(' order by NomFazenda, CodEntradaInsumo ');
  if CodOrdenacao = 'T' then
     if OrdenacaoCrescente = 'S'
        then Query.SQL.Add(' order by NomFazenda, DesTipoInsumo, DesSubTipoInsumo, DtaCompra, DesInsumo ')
        else Query.SQL.Add(' order by NomFazenda, DesTipoInsumo, DesSubTipoInsumo, DtaCompra desc, DesInsumo ');
  if CodOrdenacao = 'I' then
     if OrdenacaoCrescente = 'S'
        then Query.SQL.Add(' order by NomFazenda, DesInsumo, DtaCompra ')
        else Query.SQL.Add(' order by NomFazenda, DesInsumo, DtaCompra desc ');
  if CodOrdenacao = 'R' then
     if OrdenacaoCrescente = 'S'
        then Query.SQL.Add(' order by NomFazenda, NomRevendedor, DtaCompra, DesInsumo ')
        else Query.SQL.Add(' order by NomFazenda, NomRevendedor, DtaCompra desc, DesInsumo ');
  if CodOrdenacao = 'D' then
     if OrdenacaoCrescente = 'S'
        then Query.SQL.Add(' order by NomFazenda, DtaCompra, DesInsumo ')
        else Query.SQL.Add(' order by NomFazenda, DtaCompra desc, DesInsumo ');
  if CodOrdenacao = 'V' then
     if OrdenacaoCrescente = 'S'
        then Query.SQL.Add(' order by NomFazenda, DtaValidade, DesInsumo ')
        else Query.SQL.Add(' order by NomFazenda, DtaValidade desc, DesInsumo ');

{$ENDIF}
  Query.ParamByName('CodPessoaProdutor').AsInteger              := Conexao.CodProdutorTrabalho;
  if (CodFazenda > 0) then
     Query.ParamByName('cod_fazenda').AsInteger    := CodFazenda;
  if (CodEntradaInsumoInicio > 0) and (CodEntradaInsumoFim > 0)
     then begin
      Query.ParamByName('CodEntradaInsumoInicio').AsInteger     := CodEntradaInsumoInicio;
      Query.ParamByName('CodEntradaInsumoFim').AsInteger        := CodEntradaInsumoFim;
     end;
  if CodTipoInsumo > 0 then
     Query.ParamByName('cod_tipo_insumo').AsInteger    := CodTipoInsumo;
  if CodSubTipoInsumo > 0 then
     Query.ParamByName('cod_sub_tipo_insumo').AsInteger    := CodSubTipoInsumo;
  if (DesInsumo <> '') then
     Query.ParamByName('DesInsumo').AsString    := DesInsumo + '%';
  if (NomFabricanteInsumo <> '') then
     Query.ParamByName('NomFabricanteInsumo').AsString    := NomFabricanteInsumo + '%';
  if (NumRegistroFabricante > 0) then
     Query.ParamByName('NumRegistroFabricante').AsInteger  := NumRegistroFabricante;
  if (NomRevendedor <> '') then
     Query.ParamByName('NomRevendedor').AsString    := NomRevendedor + '%';
  if (NumCNPJCPFRevendedor <> '') then
     Query.ParamByName('NumCNPJCPFRevendedor').AsString    := NumCNPJCPFRevendedor;
  if (DtaCompraInicio > 0) and (DtaCompraFim > 0) then begin
      Query.ParamByName('DtaCompraInicio').AsDateTime     := DtaCompraInicio;
      Query.ParamByName('DtaCompraFim').AsDateTime        := DtaCompraFim;
     end;
  if (DtaValidade > 0) then
     Query.ParamByName('DtaValidade').AsDateTime     := DtaValidade;
  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do begin
      Rollback;
      Mensagens.Adicionar(897, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -897;
      Exit;
    end;
  end;
end;

function TIntEntradasInsumo.PesquisarRelatorio(SglProdutor,NomPessoaProdutor : String; CodTipoInsumo,
          CodSubTipoInsumo: Integer; DesInsumo, NomFabricanteInsumo : String;
          NumRegistroFabricante: Integer; NomRevendedor, NumCnpjCpfRevendedor: String;
          DtaCompraInicio, DtaCompraFim: TDateTime; IndDataOrdemCrescente: String): Integer;
const
  NomMetodo: String = 'PesquisarRelatorio';
  CodRelatorio: Integer = 2;
var
  Retorno: Integer;
  sSql,sSqlOrder: String ;
  bPersonalizavel : Boolean;
  IntRelatorios: TIntRelatorios;
  Rel : TRelatorioPadrao;
begin
  IntRelatorios := TIntRelatorios.Create;

  try
    Result := IntRelatorios.Inicializar(Conexao, Mensagens);
    if Result < 0 then Exit;
    Result := IntRelatorios.Buscar(CodRelatorio);
    if Result < 0 then Exit;
    Result := IntRelatorios.Pesquisar(CodRelatorio);
    if Result < 0 then Exit;

    bPersonalizavel := (IntRelatorios.IntRelatorio.IndPersonalizavel = 'S');

  Query.Close;
  Query.SQL.Clear;
{$IFDEF MSSQL}
      // Cria temporária caso não exista
      Query.SQL.Add(
        #13#10'if object_id(''tempdb..#tmp_entrada_insumo_relatorio'') is null '+
        #13#10'  create table #tmp_entrada_insumo_relatorio '+
        #13#10'  ( '+
        #13#10'    NomPessoaProdutor  varchar (100) null'+
        #13#10'    , SglProdutor char(5) null'+
        #13#10'    , SglFazenda char(2) null'+
        #13#10'    , NomFazenda varchar(50)  null'+
        #13#10'    , SglTipoInsumo char(2) null '+
        #13#10'    , DesTipoInsumo varchar(30) null '+
        #13#10'    , SglSubTipoInsumo char(2) null '+
        #13#10'    , DesSubTipoInsumo varchar(60) null'+
        #13#10'    , DesInsumo varchar(20) null'+
        #13#10'    , NomFabricanteInsumo varchar(30) null '+
        #13#10'    , NumRegistroFabricante  int null '+
        #13#10'    , NomRevendedor  varchar(50) null '+
        #13#10'    , NumCNPJCPFRevendedor  varchar(14) null '+
        #13#10'    , NumCNPJCPFRevendedorFormatado  varchar(18) null '+
        #13#10'    , DtaDia smalldatetime  null '+
        #13#10'    , DtaMes varchar(7)  null '+
        #13#10'    , DtaAno varchar(4)  null '+
        #13#10'    , SglUnidadeMedida varchar(10) null '+
        #13#10'    , QtdInsumo decimal(9,2) null '+
        #13#10'  ) ');
      Query.ExecSQL;
      // Limpa a tabela
      Query.SQL.Clear;
      Query.SQL.Add(#13#10'truncate table #tmp_entrada_insumo_relatorio ');
      Query.ExecSQL;

      Query.close;
      Query.SQL.Clear;
      Query.SQL.Add(' insert into #tmp_entrada_insumo_relatorio (');
                 //os dois campos sao obrigatorios
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(15) = 1) then
                  Query.SQL.Add(' QtdInsumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(16) = 1) then
                  Query.SQL.Add(' , SglUnidadeMedida ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) then
                  Query.SQL.Add(' , NomPessoaProdutor ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(2) = 1) then
                  Query.SQL.Add(' , SglProdutor ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(3) = 1) then
                  Query.SQL.Add(' , DesTipoInsumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(4) = 1) then
                  Query.SQL.Add(' , SglTipoInsumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(5) = 1) then
                   Query.SQL.Add(' , DesSubTipoInsumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(6) = 1) then
                   Query.SQL.Add(' , SglSubTipoInsumo ');

                 Query.SQL.Add(' , DesInsumo ');
                 Query.SQL.Add(' , NomFabricanteInsumo ');
                 Query.SQL.Add(' , NumRegistroFabricante ');

                 Query.SQL.Add(' , NomRevendedor ');
                 Query.SQL.Add(' , NumCNPJCPFRevendedor, NumCNPJCPFRevendedorFormatado ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(12) = 1) then
                  Query.SQL.Add(' ,  DtaDia ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(13) = 1) then
                  Query.SQL.Add(' ,  DtaMes ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(14) = 1) then
                  Query.SQL.Add(' ,  DtaAno ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(17) = 1) then
                  Query.SQL.Add('  , SglFazenda ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(18) = 1) then
                  Query.SQL.Add(', NomFazenda ');

                Query.SQL.Add(')');

    Query.SQL.Add(' select * from ' +
                  ' (select ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(15) = 1) then
                  Query.SQL.Add(' tei.qtd_insumo as QtdInsumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(16) = 1) then
                  Query.SQL.Add(' , tum.sgl_unidade_medida as SglUnidadeMedida ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) then
                  Query.SQL.Add(' , tpp.nom_pessoa as NomPessoaProdutor ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(2) = 1) then
                  Query.SQL.Add(' , tpr.sgl_produtor as SglProdutor ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(3) = 1) then
                  Query.SQL.Add('  ,tti.des_tipo_insumo as DesTipoInsumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(4) = 1) then
                  Query.SQL.Add('  ,tti.sgl_tipo_insumo as SglTipoInsumo ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(5) = 1) then
                  Query.SQL.Add(' , tsti.des_sub_tipo_insumo as DesSubTipoInsumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(6) = 1) then
                  Query.SQL.Add(' , tsti.sgl_sub_tipo_insumo as SglSubTipoInsumo ');

                  Query.SQL.Add(' , ti.des_insumo as DesInsumo ' +
                                ' , tfi.nom_fabricante_insumo as NomFabricanteInsumo ' +
                                ', tfi.num_registro_fabricante as NumRegistroFabricante ' +
                                '     , case tps.nom_pessoa_secundaria ' +
                                '       when null then tei.nom_revendedor  ' +
                                '                 else tps.nom_pessoa_secundaria end as NomRevendedor ' +
                                ' , case tps.nom_pessoa_secundaria ' +
                                '     when null then tei.num_cnpj_cpf_revendedor ' +
                                '         else tps.num_cnpj_cpf end as NumCNPJCPFRevendedor ' +
                                '    , case tps.nom_pessoa_secundaria ' +
                                '       when null then ' +
                                '       case len(tei.num_cnpj_cpf_revendedor) ' +
                                '       when 11 then convert(varchar(18), ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 1, 3) + ''.'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 4, 3) + ''.'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 7, 3) + ''-'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 10, 2)) ' +
                                '       when 14 then convert(varchar(18), ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 1, 2) + ''.'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 3, 3) + ''.'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 6, 3) + ''/'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 9, 4) + ''-'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 13, 2)) ' +
                                '       end ' +
                                '       else ' +
                                '       case len(tps.num_cnpj_cpf) ' +
                                '       when 11 then convert(varchar(18), ' +
                                '          substring(tps.num_cnpj_cpf, 1, 3) + ''.'' + ' +
                                '          substring(tps.num_cnpj_cpf, 4, 3) + ''.'' + ' +
                                '          substring(tps.num_cnpj_cpf, 7, 3) + ''-'' + ' +
                                '          substring(tps.num_cnpj_cpf, 10, 2)) ' +
                                '       when 14 then convert(varchar(18), ' +
                                '          substring(tps.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                                '          substring(tps.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                                '          substring(tps.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                                '          substring(tps.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                                '          substring(tps.num_cnpj_cpf, 13, 2)) ' +
                                '       end ' +
                                '       end as NumCNPJCPFRevendedorFormatado ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(12) = 1) then
                  Query.SQL.Add(' ,  tei.dta_compra as DtaDia ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(13) = 1) then
                  Query.SQL.Add(' , right(''0'' + rtrim(convert(char(2),datepart(mm,tei.dta_compra))),2) + ''/'' +  convert(char(2),right(datepart(yy,tei.dta_compra),2)) as DtaMes ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(14) = 1) then
                  Query.SQL.Add(' ,  datepart(yyyy,tei.dta_compra) as DtaAno ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(17) = 1) then
                  Query.SQL.Add('  , tf.sgl_fazenda as SglFazenda ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(18) = 1) then
                   Query.SQL.Add(' , tf.nom_fazenda as NomFazenda ');

   Query.SQL.Add(' from tab_unidade_medida as tum ' +
                  '     , tab_entrada_insumo as tei ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) or (IntRelatorios.CampoAssociado(2) = 1) or (trim(NomPessoaProdutor) <> '') or (trim(SglProdutor) <> '') then begin
                  Query.SQL.Add(' , tab_pessoa as tpp ' +
                                ' , tab_produtor as tpr ');
                end;
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(17) = 1) or (IntRelatorios.CampoAssociado(18) = 1) then begin
                  Query.SQL.Add(' , tab_fazenda as tf ');
                end;
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(3) = 1) or (IntRelatorios.CampoAssociado(4) = 1) then begin
                  Query.SQL.Add(' , tab_tipo_insumo as tti ');
                end;
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(5) = 1) or (IntRelatorios.CampoAssociado(6) = 1) then begin
                  Query.SQL.Add(' , tab_sub_tipo_insumo as tsti ');
                end;
                Query.SQL.Add(' , tab_insumo as ti ' +
                              ' , tab_fabricante_insumo as tfi ' +
                              ' ,  tab_pessoa_secundaria as tps ');

  Query.SQL.Add('where  tei.des_insumo is null ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(16) = 1) then
                  Query.SQL.Add(' and tei.cod_unidade_medida = tum.cod_unidade_medida ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(3) = 1) or (IntRelatorios.CampoAssociado(4) = 1) then
                  Query.SQL.Add(' and   tei.cod_tipo_insumo = tti.cod_tipo_insumo ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(5) = 1) or (IntRelatorios.CampoAssociado(6) = 1) then
                  Query.SQL.Add( ' and   tei.cod_sub_tipo_insumo *= tsti.cod_sub_tipo_insumo ');

                  Query.SQL.Add(' and   tei.cod_insumo = ti.cod_insumo ' +
                                ' and   ti.cod_fabricante_insumo = tfi.cod_fabricante_insumo ' +
                                ' and   tei.cod_pessoa_secundaria *= tps.cod_pessoa_secundaria ' +
                                ' and   tei.cod_pessoa_produtor *= tps.cod_pessoa_produtor ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) or (IntRelatorios.CampoAssociado(2) = 1) or (trim(NomPessoaProdutor)<>'') or (trim(SglProdutor) <> '') then
                  Query.SQL.Add(' and   tpp.cod_pessoa = tei.cod_pessoa_produtor ' +
                  ' and   tpr.cod_pessoa_produtor = tpp.cod_pessoa ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(17) = 1) or (IntRelatorios.CampoAssociado(18) = 1) then
                  Query.SQL.Add('  and tf.cod_pessoa_produtor =* tei.cod_pessoa_produtor ' +
                     ' and  tf.cod_fazenda =* tei.cod_fazenda');

                Query.SQL.Add(' and ((tei.cod_tipo_insumo =:cod_tipo_insumo) or (:cod_tipo_insumo = -1)) ');
                Query.SQL.Add(' and ((tei.cod_sub_tipo_insumo =:cod_sub_tipo_insumo) or (:cod_sub_tipo_insumo = -1)) ');
                if (DtaCompraInicio > 0) and (DtaCompraFim > 0) then
                  Query.SQL.Add(' and tei.dta_compra between :DtaCompraInicio and :DtaCompraFim ');

                if (Conexao.CodPapelUsuario = 1) and (Conexao.CodTipoAcesso = 'C') then    // Associacao
                begin
                  Query.SQL.Add('   and tei.cod_pessoa_produtor in (select Cod_pessoa_produtor from tab_associacao_produtor where cod_pessoa_associacao = :cod_pessoa )');
                end
                else if (Conexao.CodPapelUsuario = 3) and (Conexao.CodTipoAcesso = 'C') then    // Tecnico
                begin
                  Query.SQL.Add('   and tei.cod_pessoa_produtor in (select Cod_pessoa_produtor from tab_tecnico_produtor where cod_pessoa_tecnico = :cod_pessoa and dta_fim_validade is null )');
                end
                else if (Conexao.CodPapelUsuario = 4) and (Conexao.CodTipoAcesso ='P') then    //Produtor
                begin
                  Query.SQL.Add('   and tei.cod_pessoa_produtor = :cod_pessoa');
                end
                else if (Conexao.CodPapelUsuario = 9) and (Conexao.CodTipoAcesso = 'C') then // Gestor
                begin
                  Query.SQL.Add('   and tei.cod_pessoa_produtor in (select ttp.cod_pessoa_produtor from tab_tecnico_produtor ttp, tab_tecnico tt ');
                  Query.SQL.Add('                                   where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico and ttp.dta_fim_validade is null and tt.dta_fim_validade is null and tt.cod_pessoa_gestor = :cod_pessoa) ');
                end
                else if Conexao.CodTipoAcesso = 'N' then    //Não tem acesso
                begin
                  Query.SQL.Add('   and tei.cod_pessoa_produtor = :cod_pessoa ');
                end;

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) or (trim(NomPessoaProdutor) <> '') then begin
                  Query.SQL.Add(' and tpp.nom_pessoa like :nom_pessoa_produtor ');
                end;
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(2) = 1) or (trim(SglProdutor) <> '') then begin
                  Query.SQL.Add(' and tpr.sgl_produtor like :sgl_produtor ');
                end;

    Query.SQL.Add(' union all ' +
                  ' select ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(15) = 1) then
                  Query.SQL.Add(' tei.qtd_insumo as QtdInsumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(16) = 1) then
                  Query.SQL.Add(' , tum.sgl_unidade_medida as SglUnidadeMedida ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) then
                  Query.SQL.Add(' , tpp.nom_pessoa as NomPessoaProdutor ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(2) = 1) then
                  Query.SQL.Add(' , tpr.sgl_produtor as SglProdutor ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(3) = 1) then
                  Query.SQL.Add('  ,tti.des_tipo_insumo as DesTipoInsumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(4) = 1) then
                  Query.SQL.Add('  ,tti.sgl_tipo_insumo as SglTipoInsumo ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(5) = 1) then
                  Query.SQL.Add(' , tsti.des_sub_tipo_insumo as DesSubTipoInsumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(6) = 1) then
                  Query.SQL.Add(' , tsti.sgl_sub_tipo_insumo as SglSubTipoInsumo ');

                  Query.SQL.Add(' , tei.des_insumo as DesInsumo ' +
                                ' , tei.nom_fabricante_insumo as NomFabricanteInsumo ' +
                                ', tei.num_registro_fabricante as NumRegistroFabricante ' +
                                '     , case tps.nom_pessoa_secundaria ' +
                                '       when null then tei.nom_revendedor  ' +
                                '                 else tps.nom_pessoa_secundaria end as NomRevendedor ' +
                                ' , case tps.nom_pessoa_secundaria ' +
                                '     when null then tei.num_cnpj_cpf_revendedor ' +
                                '         else tps.num_cnpj_cpf end as NumCNPJCPFRevendedor ' +
                                '    , case tps.nom_pessoa_secundaria ' +
                                '       when null then ' +
                                '       case len(tei.num_cnpj_cpf_revendedor) ' +
                                '       when 11 then convert(varchar(18), ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 1, 3) + ''.'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 4, 3) + ''.'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 7, 3) + ''-'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 10, 2)) ' +
                                '       when 14 then convert(varchar(18), ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 1, 2) + ''.'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 3, 3) + ''.'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 6, 3) + ''/'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 9, 4) + ''-'' + ' +
                                '          substring(tei.num_cnpj_cpf_revendedor, 13, 2)) ' +
                                '       end ' +
                                '       else ' +
                                '       case len(tps.num_cnpj_cpf) ' +
                                '       when 11 then convert(varchar(18), ' +
                                '          substring(tps.num_cnpj_cpf, 1, 3) + ''.'' + ' +
                                '          substring(tps.num_cnpj_cpf, 4, 3) + ''.'' + ' +
                                '          substring(tps.num_cnpj_cpf, 7, 3) + ''-'' + ' +
                                '          substring(tps.num_cnpj_cpf, 10, 2)) ' +
                                '       when 14 then convert(varchar(18), ' +
                                '          substring(tps.num_cnpj_cpf, 1, 2) + ''.'' + ' +
                                '          substring(tps.num_cnpj_cpf, 3, 3) + ''.'' + ' +
                                '          substring(tps.num_cnpj_cpf, 6, 3) + ''/'' + ' +
                                '          substring(tps.num_cnpj_cpf, 9, 4) + ''-'' + ' +
                                '          substring(tps.num_cnpj_cpf, 13, 2)) ' +
                                '       end ' +
                                '       end as NumCNPJCPFRevendedorFormatado ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(12) = 1) then
                  Query.SQL.Add(' ,  tei.dta_compra as DtaDia ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(13) = 1) then
                  Query.SQL.Add(' , right(''0'' + rtrim(convert(char(2),datepart(mm,tei.dta_compra))),2) + ''/'' +  convert(char(2),right(datepart(yy,tei.dta_compra),2)) as DtaMes ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(14) = 1) then
                  Query.SQL.Add(' ,  datepart(yyyy,tei.dta_compra) as DtaAno ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(17) = 1) then
                  Query.SQL.Add('  , tf.sgl_fazenda as SglFazenda ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(18) = 1) then
                   Query.SQL.Add(' , tf.nom_fazenda as NomFazenda ');
    Query.SQL.Add(' from tab_unidade_medida as tum ' +
                  '     , tab_entrada_insumo as tei ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) or (IntRelatorios.CampoAssociado(2) = 1) or (trim(NomPessoaProdutor) <> '') or (trim(SglProdutor) <> '') then begin
                  Query.SQL.Add(' , tab_pessoa as tpp ' +
                                ' , tab_produtor as tpr ');
                end;
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(17) = 1) or (IntRelatorios.CampoAssociado(18) = 1) then begin
                  Query.SQL.Add(' , tab_fazenda as tf ');
                end;
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(3) = 1) or (IntRelatorios.CampoAssociado(4) = 1) then begin
                  Query.SQL.Add(' , tab_tipo_insumo as tti ');
                end;
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(5) = 1) or (IntRelatorios.CampoAssociado(6) = 1) then begin
                  Query.SQL.Add(' , tab_sub_tipo_insumo as tsti ');
                end;
                 Query.SQL.Add(' ,  tab_pessoa_secundaria as tps ');
  Query.SQL.Add(' where  tei.cod_insumo is null ');

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(16) = 1) then
                  Query.SQL.Add(' and tei.cod_unidade_medida = tum.cod_unidade_medida ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(3) = 1) or (IntRelatorios.CampoAssociado(4) = 1) then
                  Query.SQL.Add(' and   tei.cod_tipo_insumo = tti.cod_tipo_insumo ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(5) = 1) or (IntRelatorios.CampoAssociado(6) = 1) then
                  Query.SQL.Add( ' and   tei.cod_sub_tipo_insumo *= tsti.cod_sub_tipo_insumo ');

                  Query.SQL.Add(' and   tei.cod_pessoa_secundaria *= tps.cod_pessoa_secundaria ' +
                  ' and   tei.cod_pessoa_produtor *= tps.cod_pessoa_produtor ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) or (IntRelatorios.CampoAssociado(2) = 1) or (trim(NomPessoaProdutor) <> '') or (trim(SglProdutor) <> '') then
                  Query.SQL.Add(' and   tpp.cod_pessoa = tei.cod_pessoa_produtor ' +
                  ' and   tpr.cod_pessoa_produtor = tpp.cod_pessoa ');
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(17) = 1) or (IntRelatorios.CampoAssociado(18) = 1) then
                  Query.SQL.Add('  and tf.cod_pessoa_produtor =* tei.cod_pessoa_produtor ' +
                     ' and  tf.cod_fazenda =* tei.cod_fazenda');

                //Parametros
                 Query.SQL.Add(' and ((tei.cod_tipo_insumo =:cod_tipo_insumo) or (:cod_tipo_insumo = -1 )) ');
                 Query.SQL.Add(' and ((tei.cod_sub_tipo_insumo =:cod_sub_tipo_insumo) or (:cod_sub_tipo_insumo = -1 )) ');
                if (DtaCompraInicio > 0) and (DtaCompraFim > 0) then
                  Query.SQL.Add(' and tei.dta_compra between :DtaCompraInicio and :DtaCompraFim ');

                if (Conexao.CodPapelUsuario = 1) and (Conexao.CodTipoAcesso = 'C') then    // Associacao
                begin
                  Query.SQL.Add('   and tei.cod_pessoa_produtor in (select Cod_pessoa_produtor from tab_associacao_produtor where cod_pessoa_associacao = :cod_pessoa )');
                end
                else if (Conexao.CodPapelUsuario = 3) and (Conexao.CodTipoAcesso = 'C') then    // Tecnico
                begin
                  Query.SQL.Add('   and tei.cod_pessoa_produtor in (select Cod_pessoa_produtor from tab_tecnico_produtor where cod_pessoa_tecnico = :cod_pessoa and dta_fim_validade is null )');
                end
                else if (Conexao.CodPapelUsuario = 4) and (Conexao.CodTipoAcesso ='P') then    //Produtor
                begin
                  Query.SQL.Add('   and tei.cod_pessoa_produtor = :cod_pessoa');
                end
                else if (Conexao.CodPapelUsuario = 9) and (Conexao.CodTipoAcesso = 'C') then // Gestor
                begin
                  Query.SQL.Add('   and tei.cod_pessoa_produtor in (select ttp.cod_pessoa_produtor from tab_tecnico_produtor ttp, tab_tecnico tt ');
                  Query.SQL.Add('                                   where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico and ttp.dta_fim_validade is null and tt.dta_fim_validade is null and tt.cod_pessoa_gestor = :cod_pessoa) ');
                end
                else if Conexao.CodTipoAcesso = 'N' then    //Não tem acesso
                begin
                  Query.SQL.Add('   and tei.cod_pessoa_produtor = :cod_pessoa ');
                end;

                if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) or (trim(NomPessoaProdutor) <> '') then begin
                  Query.SQL.Add(' and tpp.nom_pessoa like :nom_pessoa_produtor ');
                end;
                if not bPersonalizavel or (IntRelatorios.CampoAssociado(2) = 1) or (trim(SglProdutor) <> '') then begin
                  Query.SQL.Add(' and tpr.sgl_produtor like :sgl_produtor ');
                end;

                Query.SQL.Add(' ) as resultado where 0=0 ');

  //-------------------------
  //restricao do select geral
  //-------------------------
  if (DesInsumo <> '') then
     Query.SQL.Add(' and DesInsumo like :DesInsumo ');
  if (NomFabricanteInsumo <> '') then
     Query.SQL.Add(' and NomFabricanteInsumo like :NomFabricanteInsumo ');
  if (NumRegistroFabricante > 0) then
     Query.SQL.Add(' and NumRegistroFabricante = :NumRegistroFabricante ');
  if (NomRevendedor <> '') then
     Query.SQL.Add(' and NomRevendedor like :NomRevendedor ');
  if (NumCNPJCPFRevendedor <> '') then
     Query.SQL.Add(' and NumCNPJCPFRevendedor = :NumCNPJCPFRevendedor ');
{$ENDIF}
  if ((Conexao.CodPapelUsuario = 1) or
      (Conexao.CodPapelUsuario = 3) or // tecnico
      (Conexao.CodPapelUsuario = 4) or // produtor
      (Conexao.CodPapelUsuario = 9)) and // gestor
      (conexao.CodTipoAcesso <> 'N')  then
  begin
    Query.ParamByName('cod_pessoa').AsInteger := Conexao.CodPessoa;
  end
  else if conexao.CodTipoAcesso = 'N' then //Nao tem acesso aos produtores
    Query.ParamByName('cod_pessoa').AsInteger := -1;

  if not bPersonalizavel or (IntRelatorios.CampoAssociado(2) = 1) or (trim(SglProdutor) <> '') then begin
    Query.ParamByName('sgl_produtor').AsString := trim(SglProdutor) + '%';
  end;
  if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) or (trim(NomPessoaProdutor) <> '') then begin
     Query.ParamByName('nom_pessoa_produtor').AsString := trim(NomPessoaProdutor) + '%';
  end;
  Query.ParamByName('cod_tipo_insumo').AsInteger        := CodTipoInsumo;
  Query.ParamByName('cod_sub_tipo_insumo').AsInteger    := CodSubTipoInsumo;

  if (DesInsumo <> '') then
     Query.ParamByName('DesInsumo').AsString               :=  '%' + trim(DesInsumo) + '%';
  if (NomFabricanteInsumo <> '') then
     Query.ParamByName('NomFabricanteInsumo').AsString     :=  '%' + trim(NomFabricanteInsumo) + '%';
  if (NumRegistroFabricante > 0) then
     Query.ParamByName('NumRegistroFabricante').AsInteger  := NumRegistroFabricante;
  if (NomRevendedor <> '') then
     Query.ParamByName('NomRevendedor').AsString           :=  '%' + NomRevendedor + '%';
  if (NumCNPJCPFRevendedor <> '') then
     Query.ParamByName('NumCNPJCPFRevendedor').AsString    := NumCNPJCPFRevendedor;
  if (DtaCompraInicio > 0) and (DtaCompraFim > 0) then begin
      Query.ParamByName('DtaCompraInicio').AsDateTime      := DtaCompraInicio;
      Query.ParamByName('DtaCompraFim').AsDateTime         := DtaCompraFim;
  end;
//  Query.Sql.SaveToFile('C:\Entrada.txt');
  Query.ExecSQL;
  //---------------------------------------------------
  //Monta Group by conforme os parametros selecionados
  //---------------------------------------------------
    sSql := '';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(1) = 1) then
      sSql := sSql + ' , NomPessoaProdutor ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(2) = 1) then
      sSql := sSql + ' , SglProdutor ';

    if not bPersonalizavel or (IntRelatorios.CampoAssociado(3) = 1) then
      sSql := sSql + ', DesTipoInsumo ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(4) = 1) then
      sSql := sSql + ' , SglTipoInsumo ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(5) = 1) then
       sSql := sSql + ' , DesSubTipoInsumo ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(6) = 1) then
       sSql := sSql + ' , SglSubTipoInsumo ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(7) = 1) then
      sSql := sSql + ' , DesInsumo ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(8) = 1) then
      sSql := sSql + ' ,  NomFabricanteInsumo ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(9) = 1) then
      sSql := sSql + ' ,  NumRegistroFabricante ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(10) = 1) then
      sSql := sSql + ' , NomRevendedor ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(11) = 1) then
      sSql := sSql + ' , NumCNPJCPFRevendedorFormatado ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(17) = 1) then
      sSql := sSql + '  , SglFazenda ';
    if not bPersonalizavel or (IntRelatorios.CampoAssociado(18) = 1) then
      sSql := sSql + ', NomFazenda ';

    //------------------------------
    //Query apresentada no Relatorio
    //------------------------------
    Query.close;
    Query.sql.clear;
    sSql    := '';
    sSqlOrder := '';
    Query.SQL.Add('select ');

    Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);

    try
      Retorno := Rel.CarregarRelatorio(CodRelatorio);
      if Retorno < 0 then Exit;
      sSql := '';
      sSqlOrder :='';
      rel.Campos.IrAoPrimeiro;
      while not rel.campos.EOF do begin
        if not rel.Campos.BOF then begin
          if trim(sSql) <> '' then
            sSql:= sSql + ' , ';
          if (trim(sSqlOrder) <> '') and (rel.campos.campo.NomField <> 'QtdInsumo') then
            sSqlOrder := sSqlOrder + ',';
        end;

        if rel.campos.campo.NomField = 'QtdInsumo' then
          sSql := sSql + ' sum(' + rel.campos.campo.NomField + ') as QtdInsumo '
        else begin
          sSql:= sSql + rel.campos.campo.NomField;
          sSqlOrder := sSqlOrder + rel.campos.campo.NomField;
        end;

        rel.Campos.IrAoProximo;
      end;
      Query.SQL.Add(sSql);
      Query.SQL.Add('  from #tmp_entrada_insumo_relatorio  group by ');
      Query.SQL.Add(sSqlOrder);
      Query.SQL.Add(' order by ');
      sSql := '';
      rel.Campos.IrAoPrimeiro;
      while not rel.campos.EOF do begin
          if rel.Campos.BOF then begin
            if (rel.campos.campo.NomField = 'DtaDia') or (rel.campos.campo.NomField = 'DtaMes') or (rel.campos.campo.NomField = 'DtaAno') then begin
               if IndDataOrdemCrescente = 'N' then
                  sSql:= sSql + rel.campos.campo.NomField + ' desc '
               else
                  sSql:= sSql + rel.campos.campo.NomField;
            end
            else begin
              sSql:= sSql + rel.campos.campo.NomField;
            end;
          end
         else begin
            if (rel.campos.campo.NomField = 'DtaDia') or (rel.campos.campo.NomField = 'DtaMes') or (rel.campos.campo.NomField = 'DtaAno') then begin
               if IndDataOrdemCrescente = 'N' then
                  sSql:= sSql + ',' + rel.campos.campo.NomField + ' desc '
               else
                  sSql:= sSql + ',' +  rel.campos.campo.NomField;
            end
            else begin
              sSql := sSql + ' , ' + rel.campos.campo.NomField;
            end;
          end;
        rel.Campos.IrAoProximo;
      end;
      Query.SQL.Add(sSql);
    finally
      Rel.Free;
    end;

    Query.Open;
    Result := 0;
  Except
    On E: Exception do begin
      Rollback;
      Mensagens.Adicionar(1019, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1019;
      Exit;
    end;
  end;
end;

function TIntEntradasInsumo.RelatorioConsolidado(SglProdutor,NomPessoaProdutor : String;CodTipoInsumo,
          CodSubTipoInsumo: Integer; DesInsumo, NomFabricanteInsumo : String;
          NumRegistroFabricante: Integer; NomRevendedor, NumCnpjCpfRevendedor: String;
          DtaCompraInicio, DtaCompraFim: TDateTime; IndDataOrdemCrescente: String;Tipo,QtdQuebraRelatorio : Integer): String;
const
  Metodo: Integer = 327;
  NomeMetodo: String = 'RelatorioConsolidado';
  CodRelatorio: Integer = 2;
var
  Rel: TRelatorioPadrao;
  Retorno,AuxQuebra: Integer;
  Aux,MontaTitulo,sQuebraTitulo1,sQuebraTitulo2: String;
begin
  Result := '';

  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  if not Conexao.PodeExecutarMetodo(Metodo) then
  begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Exit;
  end;

  Retorno := PesquisarRelatorio(SglProdutor,
                                NomPessoaProdutor,
                                CodTipoInsumo,
                                CodSubTipoInsumo,
                                DesInsumo,
                                NomFabricanteInsumo,
                                NumRegistroFabricante,
                                NomRevendedor,
                                NumCnpjCpfRevendedor,
                                DtaCompraInicio,
                                DtaCompraFim,
                                IndDataOrdemCrescente);

  if Retorno < 0 then
  begin
    Exit;
  end;

  if Query.IsEmpty then
  begin
    Mensagens.Adicionar(1018, Self.ClassName, NomeMetodo, []);
    Exit;
  end;

  Rel := TRelatorioPadrao.Create(nil, Conexao, Mensagens);
  try
    Rel.TipoDoArquvio := Tipo;
    //-----------------------------------------------------------------
    //Define o relatório em questão e carrega os seus dados específicos
    //-----------------------------------------------------------------
    Retorno := Rel.CarregarRelatorio(CodRelatorio);
    if Retorno < 0 then Exit;
    //-------------------------------------------------------------
    //Desabilita a apresentação dos campos selecionados para quebra
    //-------------------------------------------------------------
    rel.Campos.IrAoPrimeiro;
    For auxQuebra := 1 to QtdQuebraRelatorio  do begin
      rel.Campos.DesabilitarCampo(rel.campos.campo.NomField);
      rel.Campos.IrAoProximo;
    end;
    //-------------------------------------------------------------
    //Inicializa o procedimento de geração do arquivo de relatório
    //-------------------------------------------------------------
    Retorno := Rel.InicializarRelatorio;
    if Retorno < 0 then Exit;

    Aux            := '';
    MontaTitulo    := '';
    sQuebraTitulo1 := '';
    sQuebraTitulo2 := '';

    Query.First;
    while not Query.EOF do begin
      if QtdQuebraRelatorio = 1 then begin
        rel.Campos.IrAoPrimeiro;
        if MontaTitulo <> rel.campos.campo.TxtTitulo + ': ' + Query.FieldByname(rel.campos.campo.NomField).asString then begin
          MontaTitulo := rel.campos.campo.TxtTitulo + ': ' + Query.FieldByname(rel.campos.campo.NomField).asString;
          if rel.LinhasRestantes = 1 then begin
            rel.ImprimirTexto(0,'');
            rel.ImprimirTexto(0,MontaTitulo);
          end else begin
              //1º titulo - sem espaço em branco
              if rel.LinhasPorPagina > rel.LinhasRestantes then begin
                rel.ImprimirTexto(0,'');
              end;
              rel.ImprimirTexto(0,MontaTitulo);
          end;
        end else begin
          if rel.LinhasRestantes = rel.LinhasPorPagina then begin
            rel.ImprimirTexto(0,MontaTitulo + '  ' + '(continuação)');
          end;
        end;
      end
      else if QtdQuebraRelatorio = 2 then begin
        rel.Campos.IrAoPrimeiro;
        if sQuebraTitulo1 <> rel.campos.campo.TxtTitulo + ': ' + Query.FieldByname(rel.campos.campo.NomField).asString + ' / ' then begin
            sQuebraTitulo1 := rel.campos.campo.TxtTitulo + ': ' + Query.FieldByname(rel.campos.campo.NomField).asString + ' / ';
            rel.Campos.IrAoProximo;
            sQuebraTitulo2 := rel.campos.campo.TxtTitulo + ': ' + Query.FieldByname(rel.campos.campo.NomField).asString;
            if rel.LinhasRestantes <= 2 then begin
              rel.NovaPagina;
              rel.ImprimirTexto(0,sQuebraTitulo1 + sQuebraTitulo2);
            end else begin
              if rel.LinhasPorPagina > rel.LinhasRestantes then begin
                rel.ImprimirTexto(0,'');
              end;
              rel.ImprimirTexto(0,sQuebraTitulo1 + sQuebraTitulo2);
            end;
        end else begin
          rel.Campos.IrAoProximo;
          if sQuebraTitulo2 <> rel.campos.campo.TxtTitulo + ': ' + Query.FieldByname(rel.campos.campo.NomField).asString then begin
            sQuebraTitulo2 := rel.campos.campo.TxtTitulo + ': ' + Query.FieldByname(rel.campos.campo.NomField).asString;
            if rel.LinhasRestantes <=2 then begin
              rel.NovaPagina;
              rel.ImprimirTexto(0,sQuebraTitulo1 + sQuebraTitulo2);
            end else begin
              rel.ImprimirTexto(0,'');
              rel.ImprimirTexto(0,sQuebraTitulo1 + sQuebraTitulo2);
            end;
          end else begin
            if rel.LinhasRestantes = rel.LinhasPorPagina then begin
              rel.ImprimirTexto(0,sQuebraTitulo1 + sQuebraTitulo2 + '  ' + '(continuação)');
            end;
          end;
        end;
      end;
      Rel.ImprimirColunasResultSet(Query);
      Query.Next;
    end;
    Retorno := Rel.FinalizarRelatorio;
    if Retorno = 0 then begin
      Result := Rel.NomeArquivo;
    end;
  finally
    Rel.Free;
  end;
end;
end.
