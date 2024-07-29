// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 14/11/2002
// *  Documentação       : Anúnicio de Banners - Definição das classes.doc
// *  Código Classe      : 72
// *  Descrição Resumida : Buscar dados do Animal Visita
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    14/11/2002    Criação
// *
// ********************************************************************
unit uIntAnimaisVisita;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens,uIntAnimalVisita;

type
  { TIntBannersVisita }
  TIntAnimaisVisita = class(TIntClasseBDLeituraBasica)
  private
    FQuery : THerdomQuery;
    FIntAnimalVisita : TIntAnimalVisita;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Buscar(CodAnimalSisbov : String): Integer;

    property IntAnimalVisita : TIntAnimalVisita read FIntAnimalVisita write FIntAnimalVisita;
  end;

implementation

{ TIntBanners }
constructor TIntAnimaisVisita.Create;
begin
  inherited;
  FQuery := THerdomQuery.Create(nil);
  FIntAnimalVisita := TIntAnimalVisita.Create;
end;

destructor TIntAnimaisVisita.Destroy;
begin
  FQuery.Free;
  FIntAnimalVisita.Free;
  inherited;
end;

function TIntAnimaisVisita.Buscar(CodAnimalSisbov : String): Integer;
var
  Q, Q1 : THerdomQuery;
  CodPessoaProdutor : Integer;
const
  NomMetodo : String = 'Buscar';
  CodMetodo : Integer = 351;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  //-----------------------
  //Valida CodAnimalSisbov
  //-----------------------
  Result := VerificaString(CodAnimalSisbov,'Código SISBOV do Animal');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Q1 := THerdomQuery.Create(Conexao, nil);
    Try
      Try
        //-----------------------
        // Tenta Buscar Registro
        //-----------------------
        Q.Close;
        //---------------------------------
        // Prepara a proc spt_buscar_animal
        //---------------------------------
        Q.SQL.Clear;
        {$IFDEF MSSQL}
        Q.SQL.Add (' exec spt_buscar_animal_visita :CodAnimalSisBov ');
        {$ENDIF}
        Q.ParamByName('CodAnimalSisBov').asString := CodAnimalSisBov;
        Q.open;

        //---------------------------------------
        // Verifica se existe registro para busca
        //---------------------------------------
        If Q.IsEmpty Then Begin
          If Copy(CodAnimalSisBov,6,2) = '00' Then Begin
            CodAnimalSisBov := Copy(CodAnimalSisBov,1,5)+'99'+Copy(CodAnimalSisBov,8,10);
            //-----------------------
            // Tenta Buscar Registro para o cod. micro região 99
            //-----------------------
            Q.Close;
            //---------------------------------
            // Prepara a proc spt_buscar_animal
            //---------------------------------
            Q.SQL.Clear;
            {$IFDEF MSSQL}
            Q.SQL.Add (' exec spt_buscar_animal_visita :CodAnimalSisBov ');
            {$ENDIF}
            Q.ParamByName('CodAnimalSisBov').asString := CodAnimalSisBov;
            Q.open;


            If Q.IsEmpty Then Begin
              Mensagens.Adicionar(679, Self.ClassName, NomMetodo, []);
              Result := -679;
              Exit;
            End;
          End Else Begin
            Mensagens.Adicionar(679, Self.ClassName, NomMetodo, []);
            Result := -679;
            Exit;
          End;
        End;

        // Jerry
        //--------------------------------------------------------
        // Verifica se o produtor  Libera os animais para Público
        //--------------------------------------------------------

        CodPessoaProdutor := Q.FieldByName('cod_pessoa_produtor').AsInteger;

        Q1.SQL.Clear;
        {$IFDEF MSSQL}
        Q1.SQL.Add (' select ind_consulta_publica from tab_produtor ' +
                    ' where cod_pessoa_produtor = :cod_pessoa_produtor ');
        {$ENDIF}

        // Jerry
  //      Q.ParamByName('cod_pessoa_produtor').asInteger := Q.FieldByName('cod_pessoa_produtor').AsInteger;
        Q1.ParamByName('cod_pessoa_produtor').asInteger := CodPessoaProdutor;
        Q1.open;

        If not Q1.IsEmpty Then Begin
          // Jerry
  //        if Q.ParamByName('ind_consulta_public').asString <> 'S' then begin
          If Q1.FieldByName('ind_consulta_publica').asString <> 'S' then begin
            Mensagens.Adicionar(1136, Self.ClassName, NomMetodo, []);
            Result := -1136;
            Exit;
          End;
        End Else Begin
          Mensagens.Adicionar(1137, Self.ClassName, NomMetodo, []);
          Result := -1137;
          Exit;
        End;
        // Fim Jerry

        //------------------------------
        // Obtem informações do registro
        //------------------------------
        IntAnimalVisita.NomPessoaProdutor  := Q.FieldByName('nom_pessoa_produtor').AsString;
        IntAnimalVisita.NumCNPJCPFProdutorFormatado  := Q.FieldByName('num_CNPJCPF_produtor_formatado').AsString;
        IntAnimalVisita.CodPessoaNatureza  := Q.FieldByName('cod_natureza_pessoa').AsString;


        IntAnimalVisita.SglFazendaManejo  := Q.FieldByName('Sgl_Fazenda_Manejo').AsString;
        IntAnimalVisita.CodAnimalManejo   := Q.FieldByName('Cod_Animal_Manejo').AsString;
        IntAnimalVisita.NomArquivoImagemManejo   := Q.FieldByName('nom_arquivo_imagem_manejo').AsString;
        IntAnimalVisita.CodAnimalCertificadora := Q.FieldByName('Cod_Animal_Certificadora').AsString;

        IntAnimalVisita.CodPaisSisbov          := Q.FieldByName('Cod_Pais_Sisbov').AsInteger;
        IntAnimalVisita.CodEstadoSisbov  := Q.FieldByName('Cod_Estado_Sisbov').AsInteger;
        IntAnimalVisita.CodMicroRegiaoSisbov  := Q.FieldByName('Cod_Micro_Regiao_Sisbov').AsInteger;
        IntAnimalVisita.CodAnimalSisbov := Q.FieldByName('Cod_Animal_Sisbov').AsInteger;
        IntAnimalVisita.NumDVSisbov  := Q.FieldByName('Num_DV_Sisbov').AsInteger;

        IntAnimalVisita.DtaIdentificacaoSisbov := Q.FieldByName('Dta_Identificacao_Sisbov').AsDateTime;
        IntAnimalVisita.NumImovelIdentificacao := Q.FieldByName('Num_Imovel_Identificacao').AsString;
        IntAnimalVisita.NomPropriedadeIdentificacao  := Q.FieldByName('Nom_Propriedade_Identificacao').AsString;
        IntAnimalVisita.NomFazendaIdentificacao := Q.FieldByName('Nom_Fazenda_Identificacao').AsString;
        IntAnimalVisita.NomArquivoImagemIdentificacao  := Q.FieldByName('nom_arquivo_imagem_identif').AsString;
        IntAnimalVisita.NomMunicipioIdentificacao  := Q.FieldByName('nom_municipio_Identificacao').AsString;
        IntAnimalVisita.SglEstadoIdentificacao  := Q.FieldByName('sgl_estado_Identificacao').AsString;

        IntAnimalVisita.DtaNascimento := Q.FieldByName('Dta_Nascimento').AsDateTime;
        IntAnimalVisita.NumImovelNascimento := Q.FieldByName('Num_Imovel_Nascimento').AsString;
        IntAnimalVisita.NomPropriedadeNascimento  := Q.FieldByName('Nom_Propriedade_Nascimento').AsString;
        IntAnimalVisita.NomFazendaNascimento  := Q.FieldByName('Nom_Fazenda_Nascimento').AsString;
        IntAnimalVisita.NomArquivoImagemNascimento  := Q.FieldByName('nom_arquivo_imagem_nascimento').AsString;
        IntAnimalVisita.NomMunicipioNascimento  := Q.FieldByName('nom_municipio_nascimento').AsString;
        IntAnimalVisita.SglEstadoNascimento  := Q.FieldByName('sgl_estado_nascimento').AsString;

        IntAnimalVisita.NomAnimal  := Q.FieldByName('Nom_Animal').AsString;
        IntAnimalVisita.DesApelido := Q.FieldByName('Des_Apelido').AsString;
        IntAnimalVisita.DesEspecie := Q.FieldByName('Des_Especie').AsString;
        IntAnimalVisita.DesAptidao := Q.FieldByName('Des_Aptidao').AsString;
        IntAnimalVisita.DesRaca := Q.FieldByName('Des_Raca').AsString;
        IntAnimalVisita.DesPelagem := Q.FieldByName('Des_Pelagem').AsString;
        IntAnimalVisita.IndSexo := Q.FieldByName('Ind_Sexo').AsString;
        IntAnimalVisita.IndAnimalCastrado := Q.FieldByName('Ind_Animal_Castrado').AsString;
        IntAnimalVisita.SglAssociacaoRaca := Q.FieldByName('sgl_Associacao_Raca').AsString;
        IntAnimalVisita.SglGrauSangue := Q.FieldByName('sgl_grau_sangue').AsString;
        IntAnimalVisita.NumRGD := Q.FieldByName('Num_RGD').AsString;

        // Obtem os eventos do animal
        Try
          Query.Close;
          {$IFDEF MSSQL}
          Query.SQL.Clear;
          Query.SQL.Add('select te.cod_evento as CodEvento ' +
                        '     , tte.cod_tipo_evento as CodTipoEvento ' +
                        '     , tte.sgl_tipo_evento as SglTipoEvento ' +
                        '     , tte.Des_tipo_evento as DesTipoEvento ' +
                        '     , te.dta_inicio as DtaInicio ' +
                        '     , te.dta_fim as DtaFim ' +
                        '     , isnull(cast(te.txt_dados as varchar(800)),'''') + isnull(cast(tae.txt_dados as varchar(800)),'''') as TxtDados ' +
                        '     , te.cod_situacao_sisBov as CodSituacaoSisBov ' +
                        '     , tf.cod_fazenda as CodFazenda ' +
                        '     , tf.Sgl_fazenda as SglFazenda ' +
                        '     , tf.Nom_fazenda as NomFazenda ' +
                        '  from tab_animal as ta ' +
                        '     , tab_animal_evento as tae ' +
                        '     , tab_evento as te ' +
                        '     , tab_tipo_evento as tte ' +
                        '     , tab_fazenda as tf '+
                        ' where ta.dta_fim_validade is null ' +
                        '   and ta.cod_pais_sisbov = :CodPaisSisbov' +
                        '   and ta.cod_estado_sisbov = :CodEstadoSisbov' +
                        '   and ta.cod_micro_regiao_sisbov = :CodMicroRegiaoSisbov' +
                        '   and ta.cod_animal_sisbov = :CodAnimalSisbov' +
                        '   and ta.num_dv_sisbov = :NumDvSisbov ' +
                        '   and tae.cod_pessoa_produtor = ta.cod_pessoa_produtor' +
                        '   and tae.cod_animal = ta.cod_animal ' +
                        '   and te.cod_pessoa_produtor = tae.cod_pessoa_produtor' +
                        '   and te.cod_evento = tae.cod_evento ' +
                        '   and tte.cod_tipo_evento = te.cod_tipo_evento ' +
                        '   and tf.cod_fazenda =* te.cod_fazenda ' +
                        '   and tf.cod_pessoa_produtor =* te.cod_pessoa_produtor ' +
                        ' order by te.dta_inicio ' );
          {$ENDIF}
          Query.ParamByName('CodPaisSisbov').AsInteger := IntAnimalVisita.CodPaisSisbov;
          Query.ParamByName('CodEstadoSisbov').AsInteger := IntAnimalVisita.CodEstadoSisbov;
          Query.ParamByName('CodMicroRegiaoSisbov').AsInteger := IntAnimalVisita.CodMicroRegiaoSisbov;
          Query.ParamByName('CodAnimalSisbov').AsInteger := IntAnimalVisita.CodAnimalSisbov;
          Query.ParamByName('NumDvSisbov').AsInteger := IntAnimalVisita.NumDVSisbov;

          Query.Open;
        Except
          On E: Exception do Begin
            Rollback;
            Mensagens.Adicionar(1138, Self.ClassName, NomMetodo, [E.Message]);
            Result := -1138;
            Exit;
          End;
        End;

        // Retorna status "ok" do método
        Result := 0;
      Except
        On E: Exception do Begin
          Rollback;
          Mensagens.Adicionar(678, Self.ClassName, NomMetodo, [E.Message]);
          Result := -678;
          Exit;
        End;
      End;
    Finally
      Q1.Free;
    End;
  Finally
    Q.Free;
  End;
end;
end.
