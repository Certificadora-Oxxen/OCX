unit uErroImportacao;

interface

uses
  ComObj, ActiveX, AspTlb, XHerdom_TLB, StdVcl, SysUtils, uIntErroImportacao, Dialogs;

const MAX_ERROS = 255;

type
  TErroImportacao = class(TASPMTSObject, IErroImportacao)
  private
    FInicializada: Boolean;
    FUltimoErro: Integer;
    FIntErroImportacao: TIntErroImportacao;
    FErros: array [0..MAX_ERROS] of String;
    FCodErro: Integer;
  protected
    function Get_CodErro: Integer; safecall;
    function Limpar: Integer; safecall;
    function ObterMensagem(CodErro: Integer): WideString; safecall;
    function ObterMensagemErro: WideString; safecall;
  public
    procedure Inicializar(IntErroImportacao: TIntErroImportacao);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property Inicializada: Boolean read FInicializada write FInicializada;
  end;

implementation

uses ComServ;

procedure TErroImportacao.AfterConstruction;
var
  X : Integer;
begin
  inherited;
  FInicializada := False;

  // Erros reservados da classe Erros
  FErros[0]   := 'Objeto ErroImportacao ainda não inicializado. É necessário inicializá-lo antes';
  FErros[1]   := 'Código de erro inválido';

  // Erros relativos às operações da ocx HerdImp
  FErros[2]   := 'Nome do arquivo de parâmetros deve ser informado';
  FErros[3]   := 'Arquivo de parâmetros ''%s'' não encontrado';
  FErros[4]   := 'Não foi possível abrir o arquivo ''%s''';
  FErros[5]   := 'Arquivo ''%s'' inconsistente';
  FErros[6]   := 'Erro na leitura do arquivo ''%s''. (Código do erro: %s)';
  FErros[7]   := 'Nome do arquivo de dados deve ser informado';
  FErros[8]   := 'Arquivo de dados ''%s'' não encontrado';
  FErros[9]   := 'O Arquivo de ''%s'' não pertence ao produtor informado ou não é um arquivo de dados válido';
  FErros[10]  := 'Natureza do produtor deve ser informada';
  FErros[11]  := 'CNPJ/CPF do produtor deve ser informado';
  FErros[12]  := 'Arquivo ''%s'' já inicializado';
  FErros[13]  := 'Erro ao inicializar arquivo de dados ''%s''';
  FErros[14]  := 'Erro ao finalizar arquivo de dados';
  FErros[15]  := 'Parâmetros devem ser carregados antes da realização desta operação';
  FErros[16]  := 'Arquivo de dados ainda não foi inicializado. É necessário inicializá-lo antes';
  FErros[17]  := 'Erro ao preparar dados para gravação de uma informação do tipo "%s"';
  FErros[18]  := 'Erro ao gravar informação do tipo "%s"';
  FErros[19]  := 'Tentativa de acessar tabela inexistente. (Metodo: %s, Tabela: %s)';
  FErros[20]  := 'Tentativa de acessar descrição em uma tabela que não possui descrição. (Metodo: %s, Tabela: %s)';
  FErros[21]  := '%s inexistente com o código ''%s''';
  FErros[22]  := 'Tentativa de acessar sigla em uma tabela que não possui sigla. (Metodo: %s, Tabela: %s)';
  FErros[23]  := 'O código da situação SISBOV deve ser informado';
  FErros[24]  := 'Coluna especificada (%s) é inválida. (Método: %s, Tabela: %s)';
  FErros[25]  := 'Data de nascimento do animal deve ser informada';
  FErros[26]  := 'O código SISBOV deve ser informado para animal identificado';
  FErros[27]  := 'Data de identificação do animal deve ser maior ou igual à data de nascimento do mesmo';
  FErros[28]  := 'O código da fazenda ou o NIRF/INCRA da propriedade de identificação devem ser informados para animal identificado';
  FErros[29]  := 'Código SISBOV não pode ser informado para animal NÃO identificado';
  FErros[30]  := 'Data de identificação do animal não pode ser informada para animal NÃO identificado';
  FErros[31]  := 'O código da fazenda ou o NIRF/INCRA da propriedade de identificação não podem ser informados para animal identificado';
  FErros[32]  := '%s ''%s'' é incompatível com %s ''%s''';
  FErros[33]  := 'O RM ''%s-%s'' já existe no arquivo ''%s''';
  FErros[34]  := 'Já existe um animal com código de manejo ''%s-%s'' no arquivo ''%s''';
  FErros[35]  := 'Já existe um animal com código de certificadora ''%s'' no arquivo ''%s''';
  FErros[36]  := 'Já existe um animal com código SISBOV ''%s'' no arquivo ''%s''';
  FErros[37]  := 'O animal ''%s-%s'' já foi associado ao RM ''%s-%s'' no arquivo ''%s''';
  FErros[38]  := 'Já existe um evento com código de identificação ''%s'' no arquivo ''%s''';
  FErros[39]  := 'Não foi encontrado um evento com código de identificação ''%s'' no arquivo ''%s''';
  FErros[40]  := 'O animal ''%s-%s'' já foi associado ao evento com código de identificação ''%s'' no arquivo ''%s''';
  FErros[41]  := 'O código da fazenda de manejo do RM deve ser informado';
  FErros[42]  := 'O código de manejo do RM deve ser informado';
  FErros[43]  := 'O código da espécie deve ser informada';
  FErros[44]  := 'O código da fazenda de manejo do animal deve ser informado';
  FErros[45]  := 'O código de manejo do animal deve ser informado';
  FErros[46]  := 'O nome do atributo a ser alterado deve ser informado';
  FErros[47]  := 'O código SISBOV informado é inválido.';
  FErros[48]  := 'O dígito verificador do código SISBOV informado é inválido';
  FErros[49]  := 'O código de identificação do evento deve ser informado';
  FErros[50]  := 'A data inicial do evento deve ser informada';
  FErros[51]  := 'A data final do evento deve ser informada';
  FErros[52]  := 'A data final do evento deve ser maior ou igual à data inicial';
  FErros[53]  := 'O código da aptidão deve ser informado';
  FErros[54]  := 'O código do regime alimentar de origem deve ser informado';
  FErros[55]  := 'O código do regime alimentar de destino deve ser informado';
  FErros[56]  := 'O código da categoria de origem deve ser informado';
  FErros[57]  := 'O código da categoria de destino deve ser informado';
  FErros[58]  := 'O código da fazenda de destino deve ser informado';
  FErros[59]  := 'O código do lote de destino deve ser informado';
  FErros[60]  := 'O código do local de destino deve ser informado';
  FErros[61]  := 'O código do regime alimentar de destino para animais mamando deve ser informado';
  FErros[62]  := 'O código do regime alimentar de destino para animais desmamados deve ser informado';
  FErros[63]  := 'O regime alimentar ''%s'' não é compatível com animais mamando';
  FErros[64]  := 'O regime alimentar ''%s'' não é compatível com animais desmamados';
  FErros[65]  := '''%s'' não é um CNPJ ou CPF válido. O mesmo deve conter 11 dígitos se for CPF ou 14 dígitos se for CNPJ';
  FErros[66]  := 'O dígito verificador do %s ''%s'' é inválido';
  FErros[67]  := '''%s'' não é um CNPJ ou CPF válido. O mesmo deve pode ser um número com todos os dígitos idênticos';
  FErros[68]  := 'O CNPJ do frigorífico deve ser informado';
  FErros[69]  := 'A data de emissão da GTA deve ser informada';
  FErros[70]  := 'Para informar a data de emissão da GTA o número do mesmo também deve ser informado';
  FErros[71]  := 'O código do tipo de morte deve ser informado';
  FErros[72]  := 'O código da causa da morte deve ser informado';
  FErros[73]  := 'O peso do animal deve ser informado para eventos de pesagem';
  FErros[74]  := 'Uma posição de identificador só pode ser informada se for informado também o identificador correspondente. A posição do identificador ''%s'' foi informada sem que o identificador da mesma tenha sido informado';
  FErros[75]  := 'Para cada identificador informado, deve também ser informada a posição do mesmo. O identificador ''%s'' foi informado sem que a posição do mesmo tenha sido informada';
  FErros[76]  := 'A posição informada para o identificador ''%s'' é inválida ou não é compatível com o identificador informado';
  FErros[77]  := 'Um dos identificadores informados é do tipo transponder, sendo assim, é obrigatório que seja também informado o número do transponder';
  FErros[78]  := 'O número do transponder só pode ser informado se um dos identificadores do animal for do tipo transponder';
  FErros[79]  := 'Somente um dos identificadores informados pode ser do tipo transponder';
  FErros[80]  := 'No máximo dois dos identificadores informados podem ser do tipo brinco';
  FErros[81]  := 'O código do tipo de origem deve ser informado';
  FErros[82]  := 'A data de compra só pode ser informada para animais comprados ou importados';
  FErros[83]  := 'A data de compra deve ser maior ou igual à data de nascimento';
  FErros[84]  := 'O código de manejo do animal deve ter no máximo 8 letras e/ou números';
  FErros[85]  := 'O código da fazenda de manejo deve ter no máximo 2 letras e/ou números';
  FErros[86]  := 'O código de manejo do RM deve ter no máximo 8 letras e/ou números';
  FErros[87]  := 'O código da fazenda deve ter no máximo 2 letras e/ou números';
  FErros[88]  := 'O código SISBOV não pode ser informado para animais importados';
  FErros[89]  := 'O código da fazenda de identificação deve ter no máximo 2 letras e/ou números';
  FErros[90]  := 'A propriedade de nascimento só pode ser informada para animais comprados';
  FErros[91]  := 'O código da fazenda de nascimento deve ter no máximo 2 letras e/ou números';
  FErros[92]  := 'O nome do animal deve ter no máximo 60 letras e/ou números';
  FErros[93]  := 'O apelido do animal deve ter no máximo 20 letras e/ou números';
  FErros[94]  := 'O RGD do animal deve ter no máximo 20 letras e/ou números';
  FErros[95]  := 'Os códigos da raça e da aptidão do animal devem ser informados';
  FErros[96]  := 'O código da pelagem do animal deve ser informado';
  FErros[97]  := 'O sexo do animal deve ser informado sendo ''M'' para macho e ''F'' para fêmea';
  FErros[98]  := 'Se a fazenda de manejo do animal pai for informada, é necessário que o código de manejo do mesmo também seja informado';
  FErros[99]  := 'O código da fazenda de manejo do animal pai deve ter no máximo 2 letras e/ou números';
  FErros[100] := 'Se a fazenda de manejo do animal mãe for informada, é necessário que o código de manejo do mesmo também seja informado';
  FErros[101] := 'O código da fazenda de manejo do animal mãe deve ter no máximo 2 letras e/ou números';
  FErros[102] := 'Se a fazenda de manejo do animal receptor for informada, é necessário que o código de manejo do mesmo também seja informado';
  FErros[103] := 'O código da fazenda de manejo do animal receptor deve ter no máximo 2 letras e/ou números';
  FErros[104] := 'Deve ser informado a condição de castração do animal sendo ''S'' para animal castrado e ''N'' para animal não castrado';
  FErros[105] := 'Ocorreu o seguinte erro na finalização ''%s''';
  FErros[106] := 'Informe somente o NIRF/INCRA de nascimento ou o código da fazenda de nascimento. Ambos não podem ser informados ao mesmo tempo';
  FErros[107] := 'O NIRF/INCRA de nascimento deve conter 8 ou 13 números';
  FErros[108] := 'A fazenda de nascimento não pode ser informada para animais comprados';
  FErros[109] := 'A fazenda de nascimento deve ser informada para animais nascidos';
  FErros[110] := 'O código da categoria do animal deve ser informado';
  FErros[111] := 'O código do regime alimentar do animal deve ser informado';
  FErros[112] := 'A idade informada para o animal é incompatível com a categoria ''%s''. Verifique a data de nascimento informada e também se a data atual do seu computador está correta';
  FErros[113] := 'O sexo informado para o animal é incompatível com a categoria ''%s''';
  FErros[114] := 'A condição de castração informada para o animal é incompatível com a categoria ''%s''';
  FErros[115] := 'Não foi efetuada nenhuma pesquisa';
  FErros[116] := 'Tentativa de efetuar pesquisa em tabela indisponível para essa operação. (Metodo: %s, Tabela: %s)';
  FErros[117] := 'A tabela pesquisada (%s) não contém informações';
  FErros[118] := 'A data informada para alteração do atributo ''%s'' é inválida';
  FErros[119] := 'O valor numérico inteiro informado para alteração do atributo ''%s'' é inválido';
  FErros[120] := 'Dados de GTA só pode ser informados para animais comprados ou importados';
  FErros[121] := 'O número da nota fiscal só pode ser informado para animais comprados ou importados';
  FErros[122] := 'O texto da observação deve ter no máximo 255 letras e/ou números';
  FErros[123] := 'O número da GTA deve ter no máximo 10 letras e/ou números';
  FErros[124] := 'O número da nota fiscal deve ter no máximo 9 dígitos';
  FErros[125] := 'O código da fazenda deve ser informado';
  FErros[126] := 'O código da raça do animal deve ser informado';
  FErros[127] := 'O fator de composição racial deve ser informado corretamente. Informe um número maior que zero e menor ou igual a um';
  FErros[128] := 'Já existe uma composição racial definida para o animal ''%s-%s'' com a raça ''%s'' no arquivo ''%s''';
  FErros[129] := 'Erro ao selecionar arquivo de parâmetros: "%s"';
  FErros[130] := 'Erro ao selecionar arquivo para gravação dos dados: "%s"';
  FErros[131] := 'A form de progresso já está ativa';
  FErros[132] := 'O valor máximo para a barra de progresso deve ser maior que o valor mínimo';
  FErros[133] := 'Erro ao criar form de progresso: "%s"';
  FErros[134] := 'A form de progresso ainda não foi ativada';
  FErros[135] := 'Tipo de informação inválido. Os tipos devem ser 1, 2 ou 3';
  FErros[136] := 'Valor inválido para a informação 3. Informe um valor entre %s e %s';
  FErros[137] := 'Valor inválido para a informação %s. Erro: "%s"';
  FErros[138] := 'Tipo de informação inválido. A form de progresso foi ativada sem barra de progresso';
  FErros[139] := 'O valor 1 não pode ser informado para atributos de manejo';
  FErros[140] := 'Ocorreu o seguinte erro na pesquisa de relacionamentos ''%s''';
  FErros[141] := 'A composição racial total do animal ''%s-%s'' ultrapassou o valor máximo que é 1 (um)';
  FErros[142] := 'O código da certificadora deve ter no máximo 20 letras e/ou números';
  FErros[143] := 'O código SISBOV informado é inválido';
  FErros[144] := 'O identificador informado na posição %s deve ser um identificador %s';
  FErros[145] := 'A categoria informada é inválida porque não é uma categoria para animal ativo';
  FErros[146] := 'Para o novo código de manejo deste animal informe código da fazenda de manejo e o código de manejo do animal';
  FErros[147] := 'Para o novo código de manejo deste animal não informe o código da fazenda de manejo, informe somente o código de manejo do animal';
  FErros[148] := 'Só podem ser usadas raças puras para definição de composição racial. A raça ''%s'' não é uma raça pura';
  FErros[149] := 'O código da estação de monta deve ser informado';
  FErros[150] := 'O código da estação de monta deve ter no máximo 4 letras e/ou números';
  FErros[151] := 'A descrição da estação de monta deve ser informada';
  FErros[152] := 'A descrição da estação de monta deve ter no máximo 20 caracteres';
  FErros[153] := 'O código da fazenda de manejo do animal ou RM deve ser informado';
  FErros[154] := 'O código da fazenda de manejo do animal ou RM deve ter no máximo 2 letras e/ou números';
  FErros[155] := 'O código de manejo do animal ou RM deve ser informado';
  FErros[156] := 'O código de manejo do animal ou RM deve ter no máximo 8 letras e/ou números';
  FErros[157] := 'O status de prenhez do animal deve ser informado';
  FErros[158] := 'O status de apto do animal deve ser informado';
  FErros[159] := 'O código da fazenda de manejo do touro deve ser informado';
  FErros[160] := 'O código da fazenda de manejo do touro deve ter no máximo 2 letras e/ou números';
  FErros[161] := 'O código de manejo do touro deve ser informado';
  FErros[162] := 'O código de manejo do touro deve ter no máximo 8 letras e/ou números';
  FErros[163] := 'O número da partida deve ter no máximo 8 caracteres';
  FErros[164] := 'O código da fazenda de manejo da fêmea deve ser informado';
  FErros[165] := 'O código da fazenda de manejo da fêmea deve ter no máximo 2 letras e/ou números';
  FErros[166] := 'O código de manejo da fêmea deve ser informado';
  FErros[167] := 'O código de manejo da fêmea deve ter no máximo 8 letras e/ou números';
  FErros[168] := 'O horário do evento deve ser informado';
  FErros[169] := 'A quantidade de doses utilizada deve ser informada';
  FErros[170] := 'A quantidade de doses informada é inválida. Uma quantidade válida varia entre 1 e 9';
  FErros[171] := 'O CPF ou CNPJ do criador deve ser informado';
  FErros[172] := 'O NIRF/INCRA deve conter 8 ou 13 números';
  FErros[173] := 'O NIRF/INCRA deve conter somente números';
  FErros[174] := 'A data de emissão do GTA deve ser menor ou igual a data de início do evento. A operação não será realizada.';
  FErros[175] := 'Para o tipo de lugar "PROPRIEDADE" não deve ser informada a "FAZENDA" nem o "CNPJ AGLOMERAÇÃO"';
  FErros[176] := 'O NIRF/INCRA de %s deve ser informado';
  FErros[177] := 'Para o tipo de lugar "AGLOMERAÇÃO" não deve ser informada a "FAZENDA" nem o "NIRF/INCRA"';
  FErros[178] := 'O CNPJ/CPF de %s deve ser informado';
  FErros[179] := 'Para o tipo de lugar "FAZENDA" não deve ser informado o "NIRF/INCRA" nem o "CNPJ AGLOMERAÇÃO"';
  FErros[180] := 'O código da fazenda de %s deve ser informado';
  FErros[181] := 'O tipo de lugar de %s informado é inválido';
  FErros[182] := 'Animais externos necessariamente devem possuir situação SISBOV igual a "Animal não controlado no SISBOV"';
  FErros[183] := 'A fazenda de manejo não deve ser informada para animais externos';
  FErros[184] := 'O código certificadora do animal não é necessário para animais externos';
  FErros[185] := 'O imóvel de nascimento não é necessário para animais externos';
  FErros[186] := 'A fazenda de nascimento não é necessária para animais externos';
  FErros[187] := 'A data da compra não é necessária para animais externos';
  FErros[188] := 'Não é necessário informar tipos de identificadores para animais externos';
  FErros[189] := 'Não é necessário informar posições de identificadores para animais externos';
  FErros[190] := 'Não é necessário informar o status de castrado do animal para animais externos';
  FErros[191] := 'Não é necessário informar o regime alimentar para animais externos';
  FErros[192] := 'Não é necessário informar a categoria do animal para animais externos';
  FErros[193] := 'Não é necessário informar o número do GTA para animais externos';
  FErros[194] := 'Não é necessário informar o data de emissão do GTA para animais externos';
  FErros[195] := 'Não é necessário informar o número da nota fiscal para animais externos';
  FErros[196] := 'O código da fazenda ou o NIRF/INCRA da propriedade de identificação devem ser informados para animais com identificação pendente';
  FErros[197] := 'Não é necessário informar a fazenda corrente para animais externos';
  FErros[198] := 'Não é necessário informar o local corrente para animais externos';
  FErros[199] := 'Não é necessário informar o lote corrente para animais externos';
  FErros[200] := 'Não é necessário informar o número de transponder para animais externos';
  FErros[201] := 'O campo Ind. Efetivar, deve conter (S/N)';  // Mensagem alterada para o novo campo
  FErros[202] := 'Sómente animais com a situação Sisbov pendente (P) podem ter o campo Ind. Efetivar igual a ''S''.'; // Mensagem alterada para o novo campo
  FErros[203] := 'Problemas na geração dos registros de animais. Evento com código de identificação ''%s'' no arquivo ''%s''';
  FErros[204] := 'O novo valor atributo deve ser informado';
  FErros[205] := 'O CNPJ/CPF ''%s'' do técnico é inválido.';
  FErros[206] := 'A data de identificação SISBOV ''%s'', não pode ser maior que a data atual.';
  FErros[207] := 'A data de nascimento ''%s'', não pode ser maior que a data atual.';
  FErros[208] := 'A data da compra ''%s'', não pode ser maior que a data atual.';
  FErros[209] := 'A data da emissão GTA ''%s'', não pode ser maior que a data atual.';
  FErros[210] := 'A data de emissão GTA ''%s'', deve ser maior que a data de nascimento do animal ''%s''.';      
  FErros[211] := 'Informado o NIRF/INCRA ou a fazenda de identificação, os dois não podem ser informados ao mesmo tempo.';
  FErros[212] := 'Não é permitido informar o NIRF/INCRA de identificação para animais nascidos.';
  FErros[213] := 'Informe o tipo de característica do evento de avaliação.';
  FErros[214] := 'O código SISBOV deverá ser informado.';
  FErros[215] := 'O identificador %s não foi informado. A operação não será realizada.';
  FErros[216] := 'A fazenda de identificação não foi informada.';
  FErros[217] := 'Informe o tipo de avaliação que o animal foi submetido.';
  FErros[218] := 'O valor da característica %s, da avaliação %s não foi informado.';
  FErros[219] := 'Os identificadores 1 e 2 informados devem ser diferentes.';  
  FErros[220] := 'O Inventário do animal ''%s'' na fazenda ''%s'' já existe no arquivo';
  FErros[221] := 'ATENÇÃO, os dados de inventário de animais devem ser inseridos em uma planilha exclusiva criada para esse fim.';

  // Verifica qual o último índice de erro da tabela
  // para teste de 'range' na obtenção e configuração de erros
  For X := 0 to MAX_ERROS do Begin
    FUltimoErro := X;
    If FErros[X] = '' Then Break;
  End;
  FErros[1] := FErros[1] + ' Informe um código entre 0 e ' + IntToStr(FUltimoErro) + '.';
end;

procedure TErroImportacao.BeforeDestruction;
begin
  inherited;
end;

function TErroImportacao.Get_CodErro: Integer;
begin
  If FInicializada Then Begin
    FCodErro := FIntErroImportacao.CodErro;
  End Else Begin
    FCodErro := 0;
  End;
  Result := Trunc(Abs(FCodErro)) * -1;
end;

function TErroImportacao.Limpar: Integer;
begin
  FCodErro := 0;
end;

function TErroImportacao.ObterMensagem(CodErro: Integer): WideString;
begin
  CodErro := Trunc(Abs(CodErro));
  If CodErro > FUltimoErro Then Begin
    Result := FErros[1];
  End Else Begin
    Result := FErros[CodErro];
  End;
end;

procedure TErroImportacao.Inicializar(IntErroImportacao: TIntErroImportacao);
begin
  If IntErroImportacao <> nil Then Begin
    FIntErroImportacao := IntErroImportacao;
    FCodErro := 0;
    FInicializada := True;
  End;
end;

function TErroImportacao.ObterMensagemErro: WideString;
var
  Args : array of TVarRec;
  X : Integer;
  PArg : PChar;
begin
  FCodErro := Get_CodErro;
  If FCodErro = 0 Then Begin
    Result := '';
    Exit;
  End;
  If Trunc(Abs(FCodErro)) > FUltimoErro Then Begin
    Result := FErros[1];
  End Else Begin
    If FInicializada Then Begin
      If FIntErroImportacao.Count > 0 Then Begin
        SetLength(Args, FIntErroImportacao.Count);
        For X := 0 to FIntErroImportacao.Count - 1 do Begin
          PArg := PChar(FIntErroImportacao.Args[X]);
          Args[X].VType := vtPChar;
          Args[X].VPChar := PArg;
        End;
        Try
          Result := Format(FErros[Trunc(Abs(FCodErro))], Args);
        Except
          On E: Exception do Begin
            Result := 'Erro na obtenção da mensagem: "' + E.Message + '"';
          End;
        End;
      End Else Begin
        Result := FErros[Trunc(Abs(FCodErro))];
      End;
    End Else Begin
      Result := FErros[0];
    End;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TErroImportacao, Class_ErroImportacao,
    ciMultiInstance, tmApartment);
end.
