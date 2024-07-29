// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 28/08/2002
// *  Documentação       : Animais - Definição das Classes.doc
// *  Código Classe      : 45
// *  Descrição Resumida : Busca de Animais
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    23/08/2002    Criação
// *
// ********************************************************************
unit uIntAnimalResumido;

{$DEFINE MSSQL}
interface

uses SysUtils, dbTables, uIntClassesBasicas, uConexao, uIntMensagens;

type
  TIntAnimalResumido = class(TIntClasseBDBasica)
  private
    FCodPessoaProdutor: Integer;
    FNomPessoaProdutor: String;
    FCodAnimal: Integer;
    FCodFazendaManejo: Integer;
    FSglFazendaManejo: String;
    FCodAnimalManejo: String;
    FCodAnimalCertificadora: String;
    FCodPaisSisbov: Integer;
    FCodEstadoSisbov: Integer;
    FCodMicroRegiaoSisbov: Integer;
    FCodAnimalSisbov: Integer;
    FNumDVSisbov: Integer;
    FNomAnimal: String;
    FCodEspecie: Integer;
    FSglEspecie: String;
    FCodAptidao: Integer;
    FSglAptidao: String;
    FIndSexo: String;
    FCodTipoOrigem: Integer;
    FSglTipoOrigem: String;
    FDesAptidao: String;
    FDesEspecie: String;
    FDesTipoOrigem: String;
    FNomPessoaVendedor: String;
  public

    function CarregaPropriedadesResumidas(CodAnimal: Integer;
             CodAnimalSisbov: String; ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;

    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodAnimal: Integer read FCodAnimal write FCodAnimal;
    property CodFazendaManejo: Integer read FCodFazendaManejo write FCodFazendaManejo;
    property SglFazendaManejo: String read FSglFazendaManejo write FSglFazendaManejo;
    property CodAnimalManejo: String read FCodAnimalManejo write FCodAnimalManejo;
    property CodAnimalCertificadora: String read FCodAnimalCertificadora write FCodAnimalCertificadora;
    property CodPaisSisbov: Integer read FCodPaisSisbov write FCodPaisSisbov;
    property CodEstadoSisbov: Integer read FCodEstadoSisbov write FCodEstadoSisbov;
    property CodMicroRegiaoSisbov: Integer read FCodMicroRegiaoSisbov write FCodMicroRegiaoSisbov;
    property CodAnimalSisbov: Integer read FCodAnimalSisbov write FCodAnimalSisbov;
    property NumDVSisbov: Integer read FNumDVSisbov write FNumDVSisbov;
    property NomAnimal: String read FNomAnimal write FNomAnimal;
    property CodEspecie: Integer read FCodEspecie write FCodEspecie;
    property SglEspecie: String read FSglEspecie write FSglEspecie;
    property CodAptidao: Integer read FCodAptidao write FCodAptidao;
    property SglAptidao: String read FSglAptidao write FSglAptidao;
    property IndSexo: String read FIndSexo write FIndSexo;
    property CodTipoOrigem: Integer read FCodTipoOrigem write FCodTipoOrigem;
    property SglTipoOrigem: String read FSglTipoOrigem write FSglTipoOrigem;
    property DesAptidao: String read FDesAptidao write FDesAptidao;
    property DesEspecie: String read FDesEspecie write FDesEspecie;
    property DesTipoOrigem: String read FDesTipoOrigem write FDesTipoOrigem;
    property NomPessoaVendedor: String read FNomPessoaVendedor write FNomPessoaVendedor;
    property NomPessoaProdutor: String read FNomPessoaProdutor write FNomPessoaProdutor;
  end;

implementation

function TIntAnimalResumido.CarregaPropriedadesResumidas(CodAnimal: Integer;
  CodAnimalSisbov: String; ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
var
  Q : THerdomQuery;
  nCodPaisSisBov,nCodEstadosSisBov,nCodMicroRegiaoSisBov
   ,nCodAnimalSisBov,nDvSisBov : Integer;
begin
  nCodPaisSisBov := -1;
  nCodEstadosSisBov := -1;
  nCodMicroRegiaoSisBov := -1;
  nCodAnimalSisBov := -1;
  nDvSisBov :=-1;

  If Not Inicializado Then Begin
    Result := Inicializar(ConexaoBD, Mensagens);
    If Result < 0 Then Begin
      Exit;
    End;
  End;

  //---------------------------
  // Abstrai os dados do Sisbov
  //---------------------------
  if trim(CodAnimalSisBov) <> '' then begin
    nCodPaisSisBov := StrToInt(Copy(CodAnimalSisBov,1,3));
    nCodEstadosSisBov := StrToInt(Copy(CodAnimalSisBov,4,2));
    nCodMicroRegiaoSisBov := StrToInt(Copy(CodAnimalSisBov,6,2));
    nCodAnimalSisBov := StrToInt(Copy(CodAnimalSisBov,8,9));
    nDvSisBov := StrToInt(Copy(CodAnimalSisBov,17,1));
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //-----------------------
      // Tenta Buscar Registro
      //-----------------------
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ta.cod_pessoa_produtor ' +
      '     , tp.nom_pessoa as nom_pessoa_produtor ' +
      '     , ta.cod_animal          ' +
      '     , ta.cod_fazenda_manejo   ' +
      '     , tfm.sgl_fazenda as sgl_fazenda_manejo ' +
      '     , ta.cod_animal_manejo ' +
      '     , ta.cod_animal_certificadora ' +

      '     , ta.cod_pais_sisbov  ' +
      '     , ta.cod_estado_sisbov ' +
      '     , case ta.cod_micro_regiao_sisbov when -1 then null else ta.cod_micro_regiao_sisbov end as cod_micro_regiao_sisbov ' +
      '     , ta.cod_animal_sisbov ' +
      '     , ta.num_dv_sisbov ' +
      '     , ta.nom_animal ' +
      '     , ta.cod_especie ' +
      '     , te.sgl_especie ' +
      '     , te.des_especie ' +
      '     , ta.cod_aptidao ' +
      '     , tap.sgl_aptidao ' +
      '     , tap.des_aptidao ' +
      '     , ta.ind_sexo ' +
      '     , ta.cod_tipo_origem ' +
      '     , tto.sgl_tipo_origem ' +
      '     , tto.des_tipo_origem ' +
      '     , tpv.nom_pessoa as nom_pessoa_vendedor' + 
      '  from tab_animal ta ' +
      '     , tab_pessoa tp ' +
      '     , tab_fazenda tfm   ' +
      '     , tab_especie te ' +
      '     , tab_aptidao tap ' +
      '     , tab_tipo_origem tto ' +
      '     , tab_animal_vendido tav ' +
      '     , tab_pessoa tpv ' +
      ' where tfm.cod_pessoa_produtor =* ta.cod_pessoa_produtor ' +
      '   and tfm.cod_fazenda =* ta.cod_fazenda_manejo ' +
      '   and tp.cod_pessoa = ta.cod_pessoa_produtor ' +
      '   and te.cod_especie = ta.cod_especie ' +
      '   and tap.cod_aptidao = ta.cod_aptidao ' +
      '   and tto.cod_tipo_origem = ta.cod_tipo_origem ' +
      '   and tav.cod_pessoa_produtor =* ta.cod_pessoa_produtor ' +
      '   and tav.cod_animal =* ta.cod_animal ' +
      '   and tav.cod_produtor_evento_venda =* tpv.cod_pessoa ' + 
      '   and ta.cod_pessoa_produtor = :cod_pessoa_produtor ' +
      '   and ((ta.cod_animal = :cod_animal) or (:cod_animal = -1))');
      if trim(CodAnimalSisBov) <> '' then begin
        Q.SQL.Add('   and ta.cod_pais_sisbov   = :cod_pais_sisbov ' +
        '   and ta.cod_estado_sisbov  = :cod_estado_sisbov ' +
        '   and ta.cod_micro_regiao_sisbov = :cod_micro_regiao_sisbov ' +
        '   and ta.cod_animal_sisbov = :cod_animal_sisbov ' +
        '   and ta.num_dv_sisbov = :num_dv_sisbov ');
      end;
{$ENDIF}
    if trim(CodAnimalSisBov) <> '' then begin
      Q.ParamByName('cod_pais_sisbov').asInteger := nCodPaisSisBov;
      Q.ParamByName('cod_estado_sisbov').asInteger := nCodEstadosSisBov;
      Q.ParamByName('cod_micro_regiao_sisbov').asInteger := nCodMicroRegiaoSisBov;
      Q.ParamByName('cod_animal_sisbov').asInteger := nCodAnimalSisBov ;
      Q.ParamByName('num_dv_sisbov').asInteger := nDvSisBov;
    end;
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_animal').AsInteger           := codAnimal;
      Q.Open;
      //---------------------------------------
      // Verifica se existe registro para busca
      //---------------------------------------
      If Q.IsEmpty Then
        if CodAnimal > 0 then begin
           //verifica se é um RM
           Q.Close;
           Q.SQL.Clear;
           Q.SQL.Add('select trm.cod_pessoa_produtor ' +
                     '     , tp.nom_pessoa as nom_pessoa_produtor' +
                     '     , trm.cod_reprodutor_multiplo as cod_animal          ' +
                     '     , tf.cod_fazenda cod_fazenda_manejo   ' +
                     '     , tf.sgl_fazenda as sgl_fazenda_manejo ' +
                     '     , trm.cod_reprodutor_multiplo_manejo as cod_animal_manejo ' +
                     '     , null as cod_animal_certificadora ' +
                     '     , null as cod_pais_sisbov  ' +
                     '     , null as cod_estado_sisbov ' +
                     '     , null as cod_micro_regiao_sisbov ' +
                     '     , null as cod_animal_sisbov ' +
                     '     , null as num_dv_sisbov ' +
                     '     , null as nom_animal ' +
                     '     , te.cod_especie ' +
                     '     , te.sgl_especie ' +
                     '     , te.des_especie ' +
                     '     , null as cod_aptidao ' +
                     '     , null as sgl_aptidao ' +
                     '     , null as des_aptidao ' +
                     '     , null as ind_sexo ' +
                     '     , null as cod_tipo_origem ' +
                     '     , null as sgl_tipo_origem ' +
                     '     , null as des_tipo_origem ' +
                     '     , null as nom_pessoa_vendedor ' +
                     ' from   tab_especie te, '+
                     '        tab_fazenda tf, '+
                     '        tab_reprodutor_multiplo trm, '+
                     '        tab_pessoa tp ' +
                     ' where  trm.cod_especie = te.cod_especie '+
                     ' and    trm.cod_fazenda_manejo = tf.cod_fazenda '+
                     ' and    trm.cod_pessoa_produtor = tf.cod_pessoa_produtor '+
                     ' and    trm.cod_pessoa_produtor = tp.nom_pessoa ' +
                     ' and    trm.ind_ativo = ''S'' '+
                     ' and    trm.cod_reprodutor_multiplo =:cod_animal '+
                     ' and    trm.cod_pessoa_produtor = :cod_pessoa_produtor ');

           Q.ParamByName('cod_animal').asinteger := CodAnimal;
           Q.ParamByName('cod_pessoa_produtor').asinteger := Conexao.CodProdutorTrabalho;
           Q.Open;
        end;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(679, Self.ClassName, 'Buscar', []);
        Result := -679;
        Exit;
      End;
      //------------------------------
      // Obtem informações do registro
      //------------------------------
      Self.CodPessoaProdutor      := Q.FieldByName('cod_pessoa_produtor').AsInteger;
      Self.NomPessoaProdutor      := Q.FieldByName('nom_pessoa_produtor').AsString;
      Self.CodAnimal              := Q.FieldByName('cod_animal').AsInteger;
      Self.CodFazendaManejo       := Q.FieldByName('Cod_Fazenda_Manejo').AsInteger;
      Self.SglFazendaManejo       := Q.FieldByName('Sgl_Fazenda_Manejo').AsString;
      Self.CodAnimalManejo        := Q.FieldByName('Cod_Animal_Manejo').AsString;
      Self.CodAnimalCertificadora := Q.FieldByName('Cod_Animal_Certificadora').AsString;
      Self.CodPaisSisbov          := Q.FieldByName('Cod_Pais_Sisbov').AsInteger;
      Self.CodEstadoSisbov        := Q.FieldByName('Cod_Estado_Sisbov').AsInteger;
      Self.CodMicroRegiaoSisbov   := Q.FieldByName('Cod_Micro_Regiao_Sisbov').AsInteger;
      Self.CodAnimalSisbov        := Q.FieldByName('Cod_Animal_Sisbov').AsInteger;
      Self.NumDVSisbov            := Q.FieldByName('Num_DV_Sisbov').AsInteger;
      Self.NomAnimal              := Q.FieldByName('Nom_Animal').AsString;

      Self.CodEspecie             := Q.FieldByName('Cod_Especie').AsInteger;
      Self.SglEspecie             := Q.FieldByName('sgl_Especie').AsString;
      Self.DesEspecie             := Q.FieldByName('des_Especie').AsString;

      Self.CodAptidao             := Q.FieldByName('Cod_Aptidao').AsInteger;
      Self.SglAptidao             := Q.FieldByName('sgl_Aptidao').AsString;
      Self.DesAptidao             := Q.FieldByName('des_Aptidao').AsString;

      Self.IndSexo                := Q.FieldByName('Ind_Sexo').AsString;
      Self.CodTipoOrigem          := Q.FieldByName('Cod_Tipo_Origem').AsInteger;
      Self.SglTipoOrigem          := Q.FieldByName('sgl_Tipo_Origem').AsString;
      Self.DesTipoOrigem          := Q.FieldByName('des_Tipo_Origem').AsString;

      Self.NomPessoaVendedor      := Q.FieldByName('nom_pessoa_vendedor').AsString;

      Q.Close;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(446, Self.ClassName, 'CarregaPropriedadesResumidas', [E.Message]);
        Result := -446;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.
