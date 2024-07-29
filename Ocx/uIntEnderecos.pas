// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 10/08/2004
// *  Documentação       : Ordens de Serviço - Definição das classes.doc
// *  Código Classe      : 106
// *  Descrição Resumida : Pesquisa por enderecos
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit uIntEnderecos;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,
     uIntEndereco, uFerramentas;

type
  { TIntEnderecos }
  TIntEnderecos = class(TIntClasseBDLeituraBasica)
  private
    FIntEndereco: TIntEndereco;
    function ObterCodEndereco(var CodEndereco: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Inserir(CodPessoa: Integer): Integer; overload;
    function Inserir(CodTipoEndereco: Integer; NomPessoaContato, NumTelefone, NumFax,
                TxtEmail, NomLogradouro, NomBairro, NumCEP, NomLocalidade: String;
                CodDistrito, CodMunicipio, CodEstado: Integer): Integer; overload;
    function Buscar(CodEndereco: Integer): Integer;
    function ObtemCodigoEstado(SglEstado: String): Integer;
    procedure ObtemCodigoMunicipioDistrito(NomeMunicipioDistrito: String;
      CodEstado: Integer; var CodMunicipio, CodDistrito: Integer);


    property IntEndereco: TIntEndereco read FIntEndereco write FIntEndereco;
  end;

implementation

{ TIntEnderecos }

constructor TIntEnderecos.Create;
begin
  inherited;
  FIntEndereco := TIntEndereco.Create;
end;

destructor TIntEnderecos.Destroy;
begin
  FIntEndereco.Free;
  inherited;
end;

function TIntEnderecos.ObterCodEndereco(
  var CodEndereco: Integer): Integer;
const
  NomeMetodo: String = 'ObterCodEndereco';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Abre transação
      BeginTran;
      // Executa um update que não afeta nenhuma linha para travar tabela
      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_endereco set cod_seq_endereco = cod_seq_endereco where cod_seq_endereco is null');
      {$ENDIF}
      Q.ExecSQL;
      // Pega próximo código
      Q.SQL.Clear;
      {$IFDEF MSSQL}
        Q.SQL.Add('select isnull(max(cod_seq_endereco), 0) + 1 as CodSeqEndereco from tab_seq_endereco ');
      {$ENDIF}
      Q.Open;
      CodEndereco := Q.FieldByName('CodSeqEndereco').AsInteger;
      Q.SQL.Clear;
      {$IFDEF MSSQL}
         Q.SQL.Add('update tab_seq_endereco set cod_seq_endereco = cod_seq_endereco + 1');
      {$ENDIF}
      Q.ExecSQL;
      Q.Close;
      // Fecha a transação
      Commit;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1825, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1825;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

//Adalberto
function TIntEnderecos.Buscar(CodEndereco: Integer): Integer;
var
  Query: THerdomQuery;
const
  CodMetodo: Integer = 565;
  NomeMetodo: String = 'Buscar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomeMetodo, []);
    Result := -188;
    Exit;
  End;
  Try
    Query := THerdomQuery.Create(Conexao, nil);
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Text :=
        'select '+
        '  cod_endereco as CodEndereco, '+
        '  cod_tipo_endereco as CodTipoEndereco, '+
        '  (select sgl_tipo_endereco from tab_tipo_endereco where cod_tipo_endereco = te.cod_tipo_endereco) as SglTipoEndereco, '+
        '  (select des_tipo_endereco from tab_tipo_endereco where cod_tipo_endereco = te.cod_tipo_endereco) as DesTipoEndereco, '+
        '  nom_pessoa_contato as NomPessoaContato, '+
        '  num_telefone as NumTelefone, '+
        '  num_fax as NumFax, '+
        '  txt_email as TxtEmail, '+
        '  nom_logradouro as NomLogradouro, '+
        '  nom_bairro as NomBairro, '+
        '  num_cep as NumCEP, '+
        '  cod_distrito as CodDistrito, '+
        '  (select nom_distrito from tab_distrito where cod_distrito = te.cod_distrito) as NomDistrito, '+
        '  cod_municipio as CodMunicipio, '+
        '  (select num_municipio_ibge from tab_municipio where cod_municipio = te.cod_municipio) as NumMunicipioIBGE, '+
        '  (select nom_municipio from tab_municipio where cod_municipio = te.cod_municipio) as NomMunicipio, '+
        '  cod_estado as CodEstado, '+
        '  (select sgl_estado from tab_estado where cod_estado = te.cod_estado) as SGLEstado, '+
        '  (select nom_estado from tab_estado where cod_estado = te.cod_estado) as NomEstado, '+
        '  cod_pais as CodPais, '+
        '  (select nom_pais from tab_pais where cod_pais = te.cod_pais) as NomPais '+
        'from '+
        '  tab_endereco as te '+
        'where cod_endereco = :cod_endereco ';
        Query.ParamByName('cod_endereco').AsInteger := CodEndereco;
        Query.Open;

        // Verifica se existe registro para busca
        If Query.IsEmpty Then Begin
          Mensagens.Adicionar(588, Self.ClassName, NomeMetodo, []);
          Result := -588;
          Exit;
        End;

        FIntEndereco.CodEndereco       := Query.FieldByName('CodEndereco').AsInteger;
        FIntEndereco.CodTipoEndereco   := Query.FieldByName('CodTipoEndereco').AsInteger;
        FIntEndereco.SglTipoEndereco   := Query.FieldByName('SglTipoEndereco').AsString;
        FIntEndereco.DesTipoEndereco   := Query.FieldByName('DesTipoEndereco').AsString;
        FIntEndereco.NomPessoaContato  := Query.FieldByName('NomPessoaContato').AsString;
        FIntEndereco.NumTelefone       := Query.FieldByName('NumTelefone').AsString;
        FIntEndereco.NumFax            := Query.FieldByName('NumFax').AsString;
        FIntEndereco.TxtEmail          := Query.FieldByName('TxtEmail').AsString;
        FIntEndereco.NomLogradouro     := Query.FieldByName('NomLogradouro').AsString;
        FIntEndereco.NomBairro         := Query.FieldByName('NomBairro').AsString;
        FIntEndereco.NumCEP            := Query.FieldByName('NumCEP').AsString;
        FIntEndereco.CodDistrito       := Query.FieldByName('CodDistrito').AsInteger;
        FIntEndereco.NomDistrito       := Query.FieldByName('NomDistrito').AsString;
        FIntEndereco.CodMunicipio      := Query.FieldByName('CodMunicipio').AsInteger;
        FIntEndereco.NumMunicipioIBGE  := Query.FieldByName('NumMunicipioIBGE').AsString;
        FIntEndereco.NomMunicipio      := Query.FieldByName('NomMunicipio').AsString;
        FIntEndereco.CodEstado         := Query.FieldByName('CodEstado').AsInteger;
        FIntEndereco.SglEstado         := Query.FieldByName('SglEstado').AsString;
        FIntEndereco.NomEstado         := Query.FieldByName('NomEstado').AsString;
        FIntEndereco.CodPais           := Query.FieldByName('CodPais').AsInteger;
        FIntEndereco.NomPais           := Query.FieldByName('NomPais').AsString;


      Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1827, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1827;
      Exit;
    End;
  End;
end;


function TIntEnderecos.Inserir(CodPessoa: Integer): Integer;
const
  NomeMetodo: String = 'Inserir';

  Consulta1: String = 'select top 1 '+
    '  (select txt_contato from tab_pessoa_contato where cod_pessoa = :cod_pessoa and cod_tipo_contato = 1 and ind_principal = ''S'') as NumTelefoneRES,'+
    '  (select txt_contato from tab_pessoa_contato where cod_pessoa = :cod_pessoa and cod_tipo_contato = 3 and ind_principal = ''S'') as NumTelefoneCEL,'+
    '  (select txt_contato from tab_pessoa_contato where cod_pessoa = :cod_pessoa and cod_tipo_contato = 2 and ind_principal = ''S'') as NumTelefoneCOM '+
    ' from tab_pessoa_contato '+
    ' where cod_pessoa = :cod_pessoa ';

  Consulta2: String = 'select top 1 '+
    '  (select txt_contato from tab_pessoa_contato where cod_pessoa = :cod_pessoa and cod_tipo_contato = 2 and ind_principal = ''S'') as NumTelefoneCOM,'+
    '  (select txt_contato from tab_pessoa_contato where cod_pessoa = :cod_pessoa and cod_tipo_contato = 3 and ind_principal = ''S'') as NumTelefoneCEL,'+
    '  (select txt_contato from tab_pessoa_contato where cod_pessoa = :cod_pessoa and cod_tipo_contato = 1 and ind_principal = ''S'') as NumTelefoneRES '+
    ' from tab_pessoa_contato '+
    ' where cod_pessoa = :cod_pessoa ';

  Consulta3: String = 'select top 1 '+
    '  (select txt_contato from tab_pessoa_contato where cod_pessoa = :cod_pessoa and cod_tipo_contato = 3 and ind_principal = ''S'') as NumTelefoneCEL,'+
    '  (select txt_contato from tab_pessoa_contato where cod_pessoa = :cod_pessoa and cod_tipo_contato = 1 and ind_principal = ''S'') as NumTelefoneRES,'+
    '  (select txt_contato from tab_pessoa_contato where cod_pessoa = :cod_pessoa and cod_tipo_contato = 2 and ind_principal = ''S'') as NumTelefoneCOM '+
    ' from tab_pessoa_contato '+
    ' where cod_pessoa = :cod_pessoa ';

var
  Q: THerdomQuery;
  MsgErro, NomPessoa, NomLogradouro, NomBairro, NumCep,  Telefone, Fax, Email: String;
  CodPais, CodEstado, CodMunicipio, CodDistrito, CodTipoEndereco, CodEnderecoNovo: Integer;
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  end;

  Try
  Q := THerdomQuery.Create(Conexao, nil);
    Try
      with Q do begin
  {$IFDEF MSSQL}
        SQL.Add('select ');
        SQL.Add('   tp.cod_tipo_endereco as CodTipoEndereco, ');
        SQL.Add('   tp.nom_pessoa as NomPessoa, ');
        SQL.Add('   tp.nom_logradouro as NomLogradouro, ');
        SQL.Add('   tp.nom_bairro as NomBairro, ');
        SQL.Add('   tp.num_cep as NumCep, ');
        SQL.Add('   tp.cod_pais as CodPais, ');
        SQL.Add('   tp.cod_estado as CodEstado, ');
        SQL.Add('   tp.cod_municipio as CodMunicipio, ');
        SQL.Add('   tp.cod_distrito as CodDistrito, ');
        SQL.Add('      (select top 1 txt_contato from tab_pessoa_contato where ');
        SQL.Add('         cod_pessoa = tp.cod_pessoa and cod_tipo_contato = 4 and ind_principal = ''S'') as NumFax, ');
        SQL.Add('      (select top 1 txt_contato from tab_pessoa_contato where ');
        SQL.Add('         cod_pessoa = tp.cod_pessoa and cod_tipo_contato = 5 and ind_principal = ''S'') as Txtemail ');
        SQL.Add('from ');
        SQL.Add('   tab_pessoa as tp left join tab_pessoa_contato as tpc on tp.cod_pessoa = tpc.cod_pessoa ');
        SQL.Add('where ');
        SQL.Add('   tp.cod_pessoa = :cod_pessoa ');
        SQL.Add('   and tp.dta_fim_validade is null ');
        SQL.Add('group by tp.cod_tipo_endereco, tp.nom_pessoa, tp.nom_logradouro, tp.nom_bairro, tp.cod_pessoa, ');
        SQL.Add('        tp.num_cep, tp.cod_pais, tp.cod_estado, tp.cod_municipio, tp.cod_distrito ');
  {$ENDIF}
        ParamByName('cod_pessoa').AsInteger := CodPessoa;
        Open;
      end;

    If Q.IsEmpty Then Begin
      Mensagens.Adicionar(1837, Self.ClassName, NomeMetodo, []);
      Result := -1837;
      Exit;
    end else begin

       if (Q.FieldByName('CodTipoEndereco').IsNull) or
          (Q.FieldByName('NomLogradouro').IsNull) or
          (Q.FieldByName('CodMunicipio').IsNull) or
          (Q.FieldByName('CodEstado').IsNull) or
          (Q.FieldByName('CodPais').IsNull) then begin
         Mensagens.Adicionar(1848, Self.ClassName, NomeMetodo, [Q.FieldByName('NomPessoa').AsString]);
         Result := -1848;
         Exit;
       end;

       //Obtem dados da pessoa
       CodTipoEndereco   := Q.FieldByName('CodTipoEndereco').AsInteger;
       NomPessoa         := Q.FieldByName('NomPessoa').AsString;
       NomLogradouro     := Q.FieldByName('NomLogradouro').AsString;
       NomBairro         := Q.FieldByName('NomBairro').AsString;
       NumCep            := Q.FieldByName('NumCep').AsString;
       CodPais           := Q.FieldByName('CodPais').AsInteger;
       CodEstado         := Q.FieldByName('CodEstado').AsInteger;
       CodMunicipio      := Q.FieldByName('CodMunicipio').AsInteger;
       CodDistrito       := Q.FieldByName('CodDistrito').AsInteger;
       Fax               := Q.FieldByName('NumFax').AsString;
       Email             := Q.FieldByName('Txtemail').AsString;

       Q.SQL.Clear;
       If CodTipoEndereco = 1 then begin
         Q.SQL.Add(Consulta1);
       end else if CodTipoEndereco = 2 then begin
         Q.SQL.Add(Consulta2);
       end else begin
         Q.SQL.Add(Consulta3);
       end;
       Q.ParamByName('cod_pessoa').AsInteger := CodPessoa;
       Q.Open;

       If CodTipoEndereco = 1 then begin
         If not Q.FieldByName('NumTelefoneRES').IsNull then
           Telefone := Q.FieldByName('NumTelefoneRES').AsString
         else if not Q.FieldByName('NumTelefoneCEL').IsNull then
           Telefone := Q.FieldByName('NumTelefoneCEL').AsString
         else if not Q.FieldByName('NumTelefoneCOM').IsNull then
           Telefone := Q.FieldByName('NumTelefoneCOM').AsString

       end else if CodTipoEndereco = 2 then begin
         If not Q.FieldByName('NumTelefoneCOM').IsNull then
           Telefone := Q.FieldByName('NumTelefoneCOM').AsString
         else if not Q.FieldByName('NumTelefoneCEL').IsNull then
           Telefone := Q.FieldByName('NumTelefoneCEL').AsString
         else if not Q.FieldByName('NumTelefoneRES').IsNull then
           Telefone := Q.FieldByName('NumTelefoneRES').AsString

       end else begin
         If not Q.FieldByName('NumTelefoneCEL').IsNull then
           Telefone := Q.FieldByName('NumTelefoneCEL').AsString
         else if not Q.FieldByName('NumTelefoneRES').IsNull then
           Telefone := Q.FieldByName('NumTelefoneRES').AsString
         else if not Q.FieldByName('NumTelefoneCOM').IsNull then
           Telefone := Q.FieldByName('NumTelefoneCOM').AsString
       end;

       //Obtem novo codigo de endereco
       Result := ObterCodEndereco(CodEnderecoNovo);
       If Result < 0 then Begin
         MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
         Result:= -1;
         Exit;
       end;

       Q.SQL.Clear;
       // Abre transação
       BeginTran;
       with Q do begin
        SQL.Add('insert into tab_endereco ( ');
        SQL.Add('cod_endereco, ');
        SQL.Add('cod_tipo_endereco, ');
        SQL.Add('nom_pessoa_contato, ');
        SQL.Add('num_telefone, ');
        SQL.Add('num_fax, ');
        SQL.Add('txt_email, ');
        SQL.Add('nom_logradouro, ');
        SQL.Add('nom_bairro, ');
        SQL.Add('num_cep, ');
        SQL.Add('cod_distrito, ');
        SQL.Add('cod_municipio, ');
        SQL.Add('cod_estado, ');
        SQL.Add('cod_pais) values (');
        SQL.Add(':cod_endereco, ');
        SQL.Add(':cod_tipo_endereco, ');
        SQL.Add(':nom_pessoa_contato, ');
        SQL.Add(':num_telefone, ');
        SQL.Add(':num_fax, ');
        SQL.Add(':txt_email, ');
        SQL.Add(':nom_logradouro, ');
        SQL.Add(':nom_bairro, ');
        SQL.Add(':num_cep, ');
        SQL.Add(':cod_distrito, ');
        SQL.Add(':cod_municipio, ');
        SQL.Add(':cod_estado, ');
        SQL.Add(':cod_pais )');

        ParamByName('cod_endereco').AsInteger := CodEnderecoNovo;
        AtribuiParametro(Q, CodTipoEndereco, 'cod_tipo_endereco', 0);
        ParamByName('nom_pessoa_contato').AsString := NomPessoa;
        ParamByName('num_telefone').AsString := Telefone;
        ParamByName('num_fax').AsString := Fax;
        ParamByName('txt_email').AsString := email;
        AtribuiParametro(Q, NomLogradouro, 'nom_logradouro', '');
        ParamByName('nom_bairro').AsString := NomBairro;
        ParamByName('num_cep').AsString := NumCep;
        AtribuiParametro(Q, CodDistrito, 'cod_distrito', 0);
        AtribuiParametro(Q, CodMunicipio, 'cod_municipio', 0);
        AtribuiParametro(Q, CodEstado, 'cod_estado', 0);
        AtribuiParametro(Q, CodPais, 'cod_pais', 0);
        ExecSQL;
       end;
       Commit;
       Result := CodEnderecoNovo;
    end;
   Finally
    Q.Free;
   end;
  except
    on E: Exception do
    begin
      Rollback;
      Mensagens.Adicionar(1828, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1828;
      Exit;
    end;
  end;
end;

function TIntEnderecos.Inserir(CodTipoEndereco: Integer; NomPessoaContato,
  NumTelefone, NumFax, TxtEmail, NomLogradouro, NomBairro, NumCEP, NomLocalidade: String;
  CodDistrito, CodMunicipio, CodEstado: Integer): Integer;
var
  Q : THerdomQueryNavegacao;
  CodEnderecoNovo, CodDis, CodMun, CodEst, CodPai: Integer;
  MsgErro: String;
const
  NomeMetodo :String = 'Inserir';
begin

  // Verifica se pelo menos um parâmetro foi informado
  If (NomLogradouro = '') and
     (NomBairro = '') and
     (NumCEP = '') and
     (NomLocalidade = '') and
     (CodEstado <= 0) and
     (CodMunicipio <= 0) and
     (CodDistrito <= 0) Then Begin
    Mensagens.Adicionar(1942, Self.ClassName, NomeMetodo, []);
    Result := -1942;
    Exit;
  End;

  if ( (NomLocalidade <> '') and ( (CodDistrito > 0) or (CodMunicipio > 0) ) )
  or ( (CodDistrito > 0) and ( (CodMunicipio > 0) or (NomLocalidade <> '') ) )
  or ( (CodMunicipio > 0) and ( (CodDistrito > 0) or (NomLocalidade <> '') ) )
  then begin
     Mensagens.Adicionar(1829, Self.ClassName, NomeMetodo, []);
     Result := -1829;
     Exit;
  end;

  If ((NomLocalidade = '') and ((CodMunicipio <= 0) and (CodDistrito <=0))) then Begin
    Mensagens.Adicionar(1842, Self.ClassName, NomeMetodo, []);
    Result  := -1842;
    Exit;
  End;

  If (CodEstado > 0) and (NomLocalidade = '') then begin
    Mensagens.Adicionar(1922, Self.ClassName, NomeMetodo, []);
    Result := -1922;
    Exit;
  end;

  Result := TrataString(NomLocalidade, 50, 'Nome da Localidade. ');
  if Result < 0 Then Begin
    Exit;
  end; 

  //Trata NomPessoaContato
  If NomPessoaContato <> '' Then Begin
    Result := TrataString(NomPessoaContato, 100, 'Nome Pessoa Contato do Endereço. ');
    if Result < 0 Then Begin
      Exit;
    end;
  end;

  //Trata NumTelefone
  If NumTelefone <> '' Then Begin
    Result := TrataString(NumTelefone, 50, 'Telefone do Endereço. ');
    if Result < 0 Then Begin
      Exit;
    end;
  end;

  //Trata NumFax
  If NumFax <> '' Then Begin
    Result := TrataString(NumFax, 50, 'Fax do Endereço. ');
    if Result < 0 Then Begin
      Exit;
    end;
  end;

  //Trata TxtEmail
  If TxtEmail <> '' Then Begin
    Result := TrataString(TxtEmail, 50, 'Email do Endereço. ');
    if Result < 0 Then Begin
      Exit;
    end;
  end;

  // Trata Logradouro
  If NomLogradouro <> '' Then Begin
    Result := TrataString(NomLogradouro, 100, 'Logradouro do Endereço. ');
    If Result < 0 Then Begin
      Exit;
    End;
  end else begin
    Mensagens.Adicionar(1847, Self.ClassName, NomeMetodo, []);
    Result := -1847;
    Exit;
  end;

  // Trata Bairro
  If NomBairro <> '' Then Begin
    Result := TrataString(NomBairro, 50, 'Bairro do Endereço. ');
    If Result < 0 Then Begin
      Exit;
    End;
  End;

  // Trata CEP
  If NumCEP <> '' Then Begin
    if not ehNumerico(NumCEP) then begin
      Mensagens.Adicionar(1845, Self.ClassName, NomeMetodo, []);
      Result := -1845;
      Exit;
    end;
    Result := TrataString(NumCEP, 8, 'CEP do endereço. ');
    If Result < 0 Then Begin
      Exit;
    End;
  End;

  Try
  Q := THerdomQueryNavegacao.Create(nil);
  Q.SQLConnection := Conexao.SQLConnection;

  //consiste se o cod_tipo_endereco é válido
  Q.SQL.Add('select 1 from tab_tipo_endereco ');
  Q.SQL.Add(' where cod_tipo_endereco = :cod_tipo_endereco ');
  Q.ParamByName('cod_tipo_endereco').AsInteger := CodTipoEndereco;
  Q.Open;
  If Q.IsEmpty then begin
    Mensagens.Adicionar(1846, Self.ClassName, NomeMetodo, []);
    Result := -1846;
    Exit;
  end;

  if NomLocalidade <> '' then begin
      if CodEstado < 0 then begin
        Mensagens.Adicionar(1830, Self.ClassName, NomeMetodo, []);
        Result := -1830;
        Exit;
      end;
      Q.SQL.Clear;
     {$IFDEF MSSQL}
      Q.SQL.Add('select td.cod_municipio, ');
      Q.SQL.Add('       td.cod_distrito, ');
      Q.SQL.Add('       tm.cod_estado, ');
      Q.SQL.Add('       te.cod_pais ');
      Q.SQL.Add('  from tab_distrito td, ');
      Q.SQL.Add('       tab_municipio tm, ');
      Q.SQL.Add('       tab_estado te ');
      Q.SQL.Add(' where tm.cod_municipio = td.cod_municipio ');
      Q.SQL.Add('   and te.cod_estado    = tm.cod_estado ');
      Q.SQL.Add('   and te.cod_estado    = :cod_estado ');
      Q.SQL.Add('   and td.nom_distrito  = :nom_distrito ');
      Q.SQL.Add('   and te.dta_fim_validade is null ');
      Q.SQL.Add('   and td.dta_fim_validade is null ');
     {$ENDIF}
      Q.ParamByName('nom_distrito').AsString := NomLocalidade;
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.Open;
      if Q.RecordCount > 1 then begin
        Mensagens.Adicionar(1903, Self.ClassName, NomeMetodo, [NomLocalidade]);
        Result := -1903;
        Exit;
      end;
      If not Q.IsEmpty then CodDistrito := Q.FieldByName('cod_distrito').AsInteger;  
    If Q.IsEmpty then begin
      Q.SQL.Clear;
    {$IFDEF MSSQL}
      Q.SQL.Add('select ');
      Q.SQL.Add('       tm.cod_municipio, ');
      Q.SQL.Add('       tm.cod_estado, ');
      Q.SQL.Add('       te.cod_pais ');
      Q.SQL.Add('  from tab_municipio tm, ');
      Q.SQL.Add('       tab_estado te ');
      Q.SQL.Add(' where tm.nom_municipio = :nom_municipio   ');
      Q.SQL.Add('   and te.cod_estado = tm.cod_estado ');
      Q.SQL.Add('   and te.cod_estado = :cod_estado ');
      Q.SQL.Add('   and tm.dta_fim_validade is null ');
      Q.SQL.Add('   and te.dta_fim_validade is null ');
    {$ENDIF}
      Q.ParamByName('nom_municipio').AsString := NomLocalidade;
      Q.ParamByName('cod_estado').AsInteger := CodEstado;
      Q.Open;
      if Q.RecordCount > 1 then begin
        Mensagens.Adicionar(1903, Self.ClassName, NomeMetodo, [NomLocalidade]);
        Result := -1903;
        Exit;
      end;
      CodDistrito := 0;
    end;

    If Q.IsEmpty then begin
      Mensagens.Adicionar(1831, Self.ClassName, NomeMetodo, []);
      Result := -1831;
      Exit;
    end;
  end else if CodDistrito > 0 then begin
    Q.SQL.Clear;
   {$IFDEF MSSQL}
    Q.SQL.Add('select td.cod_municipio, ');
    Q.SQL.Add('       td.cod_distrito , ');    
    Q.SQL.Add('       tm.cod_estado, ');
    Q.SQL.Add('       te.cod_pais ');
    Q.SQL.Add('  from tab_distrito td, ');
    Q.SQL.Add('       tab_municipio tm, ');
    Q.SQL.Add('       tab_estado te ');
    Q.SQL.Add(' where tm.cod_municipio = td.cod_municipio ');
    Q.SQL.Add('   and te.cod_estado    = tm.cod_estado ');
    Q.SQL.Add('   and td.cod_distrito  = :cod_distrito ');
    Q.SQL.Add('   and td.dta_fim_validade is null ');
   {$ENDIF}
    Q.ParamByName('cod_distrito').AsInteger := CodDistrito;
    Q.Open;
    If Q.IsEmpty then begin
      Mensagens.Adicionar(397, Self.ClassName, NomeMetodo, []);
      Result := -397;
      Exit;
    end;
    CodDistrito := Q.FieldByName('cod_distrito').AsInteger;
  end else if CodMunicipio > 0 then begin
    Q.SQL.Clear;
  {$IFDEF MSSQL}
    Q.SQL.Add('select tm.cod_municipio, ');
    Q.SQL.Add('       tm.cod_estado, ');
    Q.SQL.Add('       te.cod_pais ');
    Q.SQL.Add('  from tab_municipio tm, ');
    Q.SQL.Add('       tab_estado te ');
    Q.SQL.Add(' where tm.cod_municipio = :cod_municipio ');
    Q.SQL.Add('   and te.cod_estado = tm.cod_estado ');
    Q.SQL.Add('   and tm.dta_fim_validade is null ');
  {$ENDIF}
    Q.ParamByName('cod_municipio').AsInteger := CodMunicipio;
    Q.Open;
    CodDistrito := 0;
    If Q.IsEmpty then begin
      Mensagens.Adicionar(399, Self.ClassName, NomeMetodo, []);
      Result := -399;
      Exit;
    end;
  end;

  CodDis := CodDistrito;
  CodMun := Q.FieldByName('cod_municipio').AsInteger;
  CodEst := Q.FieldByName('cod_estado').AsInteger;
  CodPai := Q.FieldByName('cod_pais').AsInteger;

  Result := ObterCodEndereco(CodEnderecoNovo);
  If Result < 0 then Begin
    MsgErro := Mensagens.Items[Mensagens.Count - 1].Texto;
    Result:= -1;
    Exit;
  end;

  // Abre transação
  BeginTran;
  With Q do begin
    SQL.Add('insert into tab_endereco (');
    SQL.Add('cod_endereco, ');
    SQL.Add('cod_tipo_endereco, ');
    SQL.Add('nom_pessoa_contato, ');
    SQL.Add('num_telefone, ');
    SQL.Add('num_fax, ');
    SQL.Add('txt_email, ');
    SQL.Add('nom_logradouro, ');
    SQL.Add('nom_bairro, ');
    SQL.Add('num_cep, ');
    SQL.Add('cod_distrito, ');
    SQL.Add('cod_municipio, ');
    SQL.Add('cod_estado, ');
    SQL.Add('cod_pais) values (');
    SQL.Add(':cod_endereco, ');
    SQL.Add(':cod_tipo_endereco, ');
    SQL.Add(':nom_pessoa_contato, ');
    SQL.Add(':num_telefone, ');
    SQL.Add(':num_fax, ');
    SQL.Add(':txt_email, ');
    SQL.Add(':nom_logradouro, ');
    SQL.Add(':nom_bairro, ');
    SQL.Add(':num_cep, ');
    SQL.Add(':cod_distrito, ');
    SQL.Add(':cod_municipio, ');
    SQL.Add(':cod_estado, ');
    SQL.Add(':cod_pais )');

    ParamByName('cod_endereco').AsInteger             := CodEnderecoNovo;
    AtribuiParametro(Q, CodTipoEndereco, 'cod_tipo_endereco', 0);
    ParamByName('nom_pessoa_contato').AsString        := NomPessoaContato;
    ParamByName('num_telefone').AsString              := NumTelefone;
    ParamByName('num_fax').AsString                   := NumFax;
    ParamByName('txt_email').AsString                 := TxtEmail;
    AtribuiParametro(Q, NomLogradouro, 'nom_logradouro', '');
    ParamByName('nom_bairro').AsString                := NomBairro;
    ParamByName('num_cep').AsString                   := NumCep;
    AtribuiParametro(Q, CodDis, 'cod_distrito', 0);
    AtribuiParametro(Q, CodMun, 'cod_municipio', 0);
    AtribuiParametro(Q, CodEst, 'cod_estado', 0);
    AtribuiParametro(Q, CodPai, 'cod_pais', 0);

    ExecSQL;
  end;
  Commit;
  Result := CodEnderecoNovo;

   Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1828, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1828;
      Exit;
    End;
  End;
end;

{ Obtem o código do estado de acordo com a sigla.

Parametros:
  SglEstado: Sigla do estado a ser pesquisada

Retorno:
  Código do estado.

Exceptions:
  EHerdomException: se o estado não for encontrado ou ocorrer algum erro.}
function TIntEnderecos.ObtemCodigoEstado(SglEstado: String): Integer;
var
  QueryLocal: THerdomQuery;
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado('EfetivarCadastro');
    Exit;
  end;

  try
    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Busca o estado
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_estado');
        SQL.Add('  FROM tab_estado');
        SQL.Add(' WHERE sgl_estado = :sgl_estado');

        ParamByName('sgl_estado').AsString := UpperCase(Trim(SglEstado));
        Open;

        // Se o estado não for encontrado gera um erro.
        if IsEmpty then
        begin
          raise Exception.Create('Estado "' + SglEstado + '" não encontrado.');
        end;

        Result := FieldByName('cod_estado').AsInteger;
      end;
    finally
      QueryLocal.Free;
    end;
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(2079, Self.ClassName,
        'ObtemCodigoEstado', [E.Message], False);
    end;
  end;
end;

{ Obtem o código do municipio ou do distrito de acordo com o nome e o estado.

Parametros:
  NomeMunicipioDistrito: Nome do municipio/distrito a ser localizado
  CodEstado: Código do estado do municipio/distrito
  CodMunicipio: Parametro de retorno. Código do municipio se for encontrado.
  CodDistrito: Parametro de retorno. Código do distrito se for encontrado.

Retorno:
  Parametros CodMunicipio e CodDistrito como indicado acima.

Exceptions:
  EHerdomException: se ocorrer algum erro ou se o distrito/municipio não for
    encontrado.
}
procedure TIntEnderecos.ObtemCodigoMunicipioDistrito(
  NomeMunicipioDistrito: String; CodEstado: Integer; var CodMunicipio,
  CodDistrito: Integer);
var
  QueryLocal: THerdomQuery;
begin
  if not Inicializado then
  begin
    RaiseNaoInicializado('EfetivarCadastro');
    Exit;
  end;

  try
    CodMunicipio := -1;
    CodDistrito  := -1;

    QueryLocal := THerdomQuery.Create(Conexao, nil);
    try
      // Verifica se existe um municipio com este nome neste estado
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT cod_municipio');
        SQL.Add('  FROM tab_municipio');
        SQL.Add(' WHERE cod_estado = :cod_estado');
        SQL.Add('   AND nom_municipio = :nom_municipio');

        ParamByName('cod_estado').AsInteger := CodEstado;
        ParamByName('nom_municipio').AsString := NomeMunicipioDistrito;

        Open;
        if not IsEmpty then
        begin
          CodMunicipio := FieldByName('cod_municipio').AsInteger;
        end;
      end;

      // Verifica se existe um distrito com este nome neste estado
      with QueryLocal do
      begin
        SQL.Clear;
        SQL.Add('SELECT td.cod_distrito,');
        SQL.Add('       tm.cod_municipio');
        SQL.Add('  FROM tab_distrito td,');
        SQL.Add('       tab_municipio tm');
        SQL.Add(' WHERE tm.cod_estado = :cod_estado');
        SQL.Add('   AND td.nom_distrito = :nom_distrito');
        SQL.Add('   AND td.cod_municipio = tm.cod_municipio');

        ParamByName('cod_estado').AsInteger := CodEstado;
        ParamByName('nom_distrito').AsString := NomeMunicipioDistrito;

        Open;
        if not IsEmpty then
        begin
          CodMunicipio := FieldByName('cod_municipio').AsInteger;
          CodDistrito := FieldByName('cod_distrito').AsInteger;
        end;
      end;
    finally
      QueryLocal.Free;
    end;

    if (CodDistrito = -1) and (CodMunicipio = -1) then
    begin
      raise Exception.Create('O municipio/distrito "' + NomeMunicipioDistrito
        + '" não foi encontrado.');
    end;
  except
    on E: Exception do
    begin
      raise EHerdomException.Create(2079, Self.ClassName,
        'ObtemCodigoMunicipioDistrito', [E.Message], False);
    end;
  end;
end;

end.


