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
  FErros[0]   := 'Objeto ErroImportacao ainda n�o inicializado. � necess�rio inicializ�-lo antes';
  FErros[1]   := 'C�digo de erro inv�lido';

  // Erros relativos �s opera��es da ocx HerdImp
  FErros[2]   := 'Nome do arquivo de par�metros deve ser informado';
  FErros[3]   := 'Arquivo de par�metros ''%s'' n�o encontrado';
  FErros[4]   := 'N�o foi poss�vel abrir o arquivo ''%s''';
  FErros[5]   := 'Arquivo ''%s'' inconsistente';
  FErros[6]   := 'Erro na leitura do arquivo ''%s''. (C�digo do erro: %s)';
  FErros[7]   := 'Nome do arquivo de dados deve ser informado';
  FErros[8]   := 'Arquivo de dados ''%s'' n�o encontrado';
  FErros[9]   := 'O Arquivo de ''%s'' n�o pertence ao produtor informado ou n�o � um arquivo de dados v�lido';
  FErros[10]  := 'Natureza do produtor deve ser informada';
  FErros[11]  := 'CNPJ/CPF do produtor deve ser informado';
  FErros[12]  := 'Arquivo ''%s'' j� inicializado';
  FErros[13]  := 'Erro ao inicializar arquivo de dados ''%s''';
  FErros[14]  := 'Erro ao finalizar arquivo de dados';
  FErros[15]  := 'Par�metros devem ser carregados antes da realiza��o desta opera��o';
  FErros[16]  := 'Arquivo de dados ainda n�o foi inicializado. � necess�rio inicializ�-lo antes';
  FErros[17]  := 'Erro ao preparar dados para grava��o de uma informa��o do tipo "%s"';
  FErros[18]  := 'Erro ao gravar informa��o do tipo "%s"';
  FErros[19]  := 'Tentativa de acessar tabela inexistente. (Metodo: %s, Tabela: %s)';
  FErros[20]  := 'Tentativa de acessar descri��o em uma tabela que n�o possui descri��o. (Metodo: %s, Tabela: %s)';
  FErros[21]  := '%s inexistente com o c�digo ''%s''';
  FErros[22]  := 'Tentativa de acessar sigla em uma tabela que n�o possui sigla. (Metodo: %s, Tabela: %s)';
  FErros[23]  := 'O c�digo da situa��o SISBOV deve ser informado';
  FErros[24]  := 'Coluna especificada (%s) � inv�lida. (M�todo: %s, Tabela: %s)';
  FErros[25]  := 'Data de nascimento do animal deve ser informada';
  FErros[26]  := 'O c�digo SISBOV deve ser informado para animal identificado';
  FErros[27]  := 'Data de identifica��o do animal deve ser maior ou igual � data de nascimento do mesmo';
  FErros[28]  := 'O c�digo da fazenda ou o NIRF/INCRA da propriedade de identifica��o devem ser informados para animal identificado';
  FErros[29]  := 'C�digo SISBOV n�o pode ser informado para animal N�O identificado';
  FErros[30]  := 'Data de identifica��o do animal n�o pode ser informada para animal N�O identificado';
  FErros[31]  := 'O c�digo da fazenda ou o NIRF/INCRA da propriedade de identifica��o n�o podem ser informados para animal identificado';
  FErros[32]  := '%s ''%s'' � incompat�vel com %s ''%s''';
  FErros[33]  := 'O RM ''%s-%s'' j� existe no arquivo ''%s''';
  FErros[34]  := 'J� existe um animal com c�digo de manejo ''%s-%s'' no arquivo ''%s''';
  FErros[35]  := 'J� existe um animal com c�digo de certificadora ''%s'' no arquivo ''%s''';
  FErros[36]  := 'J� existe um animal com c�digo SISBOV ''%s'' no arquivo ''%s''';
  FErros[37]  := 'O animal ''%s-%s'' j� foi associado ao RM ''%s-%s'' no arquivo ''%s''';
  FErros[38]  := 'J� existe um evento com c�digo de identifica��o ''%s'' no arquivo ''%s''';
  FErros[39]  := 'N�o foi encontrado um evento com c�digo de identifica��o ''%s'' no arquivo ''%s''';
  FErros[40]  := 'O animal ''%s-%s'' j� foi associado ao evento com c�digo de identifica��o ''%s'' no arquivo ''%s''';
  FErros[41]  := 'O c�digo da fazenda de manejo do RM deve ser informado';
  FErros[42]  := 'O c�digo de manejo do RM deve ser informado';
  FErros[43]  := 'O c�digo da esp�cie deve ser informada';
  FErros[44]  := 'O c�digo da fazenda de manejo do animal deve ser informado';
  FErros[45]  := 'O c�digo de manejo do animal deve ser informado';
  FErros[46]  := 'O nome do atributo a ser alterado deve ser informado';
  FErros[47]  := 'O c�digo SISBOV informado � inv�lido.';
  FErros[48]  := 'O d�gito verificador do c�digo SISBOV informado � inv�lido';
  FErros[49]  := 'O c�digo de identifica��o do evento deve ser informado';
  FErros[50]  := 'A data inicial do evento deve ser informada';
  FErros[51]  := 'A data final do evento deve ser informada';
  FErros[52]  := 'A data final do evento deve ser maior ou igual � data inicial';
  FErros[53]  := 'O c�digo da aptid�o deve ser informado';
  FErros[54]  := 'O c�digo do regime alimentar de origem deve ser informado';
  FErros[55]  := 'O c�digo do regime alimentar de destino deve ser informado';
  FErros[56]  := 'O c�digo da categoria de origem deve ser informado';
  FErros[57]  := 'O c�digo da categoria de destino deve ser informado';
  FErros[58]  := 'O c�digo da fazenda de destino deve ser informado';
  FErros[59]  := 'O c�digo do lote de destino deve ser informado';
  FErros[60]  := 'O c�digo do local de destino deve ser informado';
  FErros[61]  := 'O c�digo do regime alimentar de destino para animais mamando deve ser informado';
  FErros[62]  := 'O c�digo do regime alimentar de destino para animais desmamados deve ser informado';
  FErros[63]  := 'O regime alimentar ''%s'' n�o � compat�vel com animais mamando';
  FErros[64]  := 'O regime alimentar ''%s'' n�o � compat�vel com animais desmamados';
  FErros[65]  := '''%s'' n�o � um CNPJ ou CPF v�lido. O mesmo deve conter 11 d�gitos se for CPF ou 14 d�gitos se for CNPJ';
  FErros[66]  := 'O d�gito verificador do %s ''%s'' � inv�lido';
  FErros[67]  := '''%s'' n�o � um CNPJ ou CPF v�lido. O mesmo deve pode ser um n�mero com todos os d�gitos id�nticos';
  FErros[68]  := 'O CNPJ do frigor�fico deve ser informado';
  FErros[69]  := 'A data de emiss�o da GTA deve ser informada';
  FErros[70]  := 'Para informar a data de emiss�o da GTA o n�mero do mesmo tamb�m deve ser informado';
  FErros[71]  := 'O c�digo do tipo de morte deve ser informado';
  FErros[72]  := 'O c�digo da causa da morte deve ser informado';
  FErros[73]  := 'O peso do animal deve ser informado para eventos de pesagem';
  FErros[74]  := 'Uma posi��o de identificador s� pode ser informada se for informado tamb�m o identificador correspondente. A posi��o do identificador ''%s'' foi informada sem que o identificador da mesma tenha sido informado';
  FErros[75]  := 'Para cada identificador informado, deve tamb�m ser informada a posi��o do mesmo. O identificador ''%s'' foi informado sem que a posi��o do mesmo tenha sido informada';
  FErros[76]  := 'A posi��o informada para o identificador ''%s'' � inv�lida ou n�o � compat�vel com o identificador informado';
  FErros[77]  := 'Um dos identificadores informados � do tipo transponder, sendo assim, � obrigat�rio que seja tamb�m informado o n�mero do transponder';
  FErros[78]  := 'O n�mero do transponder s� pode ser informado se um dos identificadores do animal for do tipo transponder';
  FErros[79]  := 'Somente um dos identificadores informados pode ser do tipo transponder';
  FErros[80]  := 'No m�ximo dois dos identificadores informados podem ser do tipo brinco';
  FErros[81]  := 'O c�digo do tipo de origem deve ser informado';
  FErros[82]  := 'A data de compra s� pode ser informada para animais comprados ou importados';
  FErros[83]  := 'A data de compra deve ser maior ou igual � data de nascimento';
  FErros[84]  := 'O c�digo de manejo do animal deve ter no m�ximo 8 letras e/ou n�meros';
  FErros[85]  := 'O c�digo da fazenda de manejo deve ter no m�ximo 2 letras e/ou n�meros';
  FErros[86]  := 'O c�digo de manejo do RM deve ter no m�ximo 8 letras e/ou n�meros';
  FErros[87]  := 'O c�digo da fazenda deve ter no m�ximo 2 letras e/ou n�meros';
  FErros[88]  := 'O c�digo SISBOV n�o pode ser informado para animais importados';
  FErros[89]  := 'O c�digo da fazenda de identifica��o deve ter no m�ximo 2 letras e/ou n�meros';
  FErros[90]  := 'A propriedade de nascimento s� pode ser informada para animais comprados';
  FErros[91]  := 'O c�digo da fazenda de nascimento deve ter no m�ximo 2 letras e/ou n�meros';
  FErros[92]  := 'O nome do animal deve ter no m�ximo 60 letras e/ou n�meros';
  FErros[93]  := 'O apelido do animal deve ter no m�ximo 20 letras e/ou n�meros';
  FErros[94]  := 'O RGD do animal deve ter no m�ximo 20 letras e/ou n�meros';
  FErros[95]  := 'Os c�digos da ra�a e da aptid�o do animal devem ser informados';
  FErros[96]  := 'O c�digo da pelagem do animal deve ser informado';
  FErros[97]  := 'O sexo do animal deve ser informado sendo ''M'' para macho e ''F'' para f�mea';
  FErros[98]  := 'Se a fazenda de manejo do animal pai for informada, � necess�rio que o c�digo de manejo do mesmo tamb�m seja informado';
  FErros[99]  := 'O c�digo da fazenda de manejo do animal pai deve ter no m�ximo 2 letras e/ou n�meros';
  FErros[100] := 'Se a fazenda de manejo do animal m�e for informada, � necess�rio que o c�digo de manejo do mesmo tamb�m seja informado';
  FErros[101] := 'O c�digo da fazenda de manejo do animal m�e deve ter no m�ximo 2 letras e/ou n�meros';
  FErros[102] := 'Se a fazenda de manejo do animal receptor for informada, � necess�rio que o c�digo de manejo do mesmo tamb�m seja informado';
  FErros[103] := 'O c�digo da fazenda de manejo do animal receptor deve ter no m�ximo 2 letras e/ou n�meros';
  FErros[104] := 'Deve ser informado a condi��o de castra��o do animal sendo ''S'' para animal castrado e ''N'' para animal n�o castrado';
  FErros[105] := 'Ocorreu o seguinte erro na finaliza��o ''%s''';
  FErros[106] := 'Informe somente o NIRF/INCRA de nascimento ou o c�digo da fazenda de nascimento. Ambos n�o podem ser informados ao mesmo tempo';
  FErros[107] := 'O NIRF/INCRA de nascimento deve conter 8 ou 13 n�meros';
  FErros[108] := 'A fazenda de nascimento n�o pode ser informada para animais comprados';
  FErros[109] := 'A fazenda de nascimento deve ser informada para animais nascidos';
  FErros[110] := 'O c�digo da categoria do animal deve ser informado';
  FErros[111] := 'O c�digo do regime alimentar do animal deve ser informado';
  FErros[112] := 'A idade informada para o animal � incompat�vel com a categoria ''%s''. Verifique a data de nascimento informada e tamb�m se a data atual do seu computador est� correta';
  FErros[113] := 'O sexo informado para o animal � incompat�vel com a categoria ''%s''';
  FErros[114] := 'A condi��o de castra��o informada para o animal � incompat�vel com a categoria ''%s''';
  FErros[115] := 'N�o foi efetuada nenhuma pesquisa';
  FErros[116] := 'Tentativa de efetuar pesquisa em tabela indispon�vel para essa opera��o. (Metodo: %s, Tabela: %s)';
  FErros[117] := 'A tabela pesquisada (%s) n�o cont�m informa��es';
  FErros[118] := 'A data informada para altera��o do atributo ''%s'' � inv�lida';
  FErros[119] := 'O valor num�rico inteiro informado para altera��o do atributo ''%s'' � inv�lido';
  FErros[120] := 'Dados de GTA s� pode ser informados para animais comprados ou importados';
  FErros[121] := 'O n�mero da nota fiscal s� pode ser informado para animais comprados ou importados';
  FErros[122] := 'O texto da observa��o deve ter no m�ximo 255 letras e/ou n�meros';
  FErros[123] := 'O n�mero da GTA deve ter no m�ximo 10 letras e/ou n�meros';
  FErros[124] := 'O n�mero da nota fiscal deve ter no m�ximo 9 d�gitos';
  FErros[125] := 'O c�digo da fazenda deve ser informado';
  FErros[126] := 'O c�digo da ra�a do animal deve ser informado';
  FErros[127] := 'O fator de composi��o racial deve ser informado corretamente. Informe um n�mero maior que zero e menor ou igual a um';
  FErros[128] := 'J� existe uma composi��o racial definida para o animal ''%s-%s'' com a ra�a ''%s'' no arquivo ''%s''';
  FErros[129] := 'Erro ao selecionar arquivo de par�metros: "%s"';
  FErros[130] := 'Erro ao selecionar arquivo para grava��o dos dados: "%s"';
  FErros[131] := 'A form de progresso j� est� ativa';
  FErros[132] := 'O valor m�ximo para a barra de progresso deve ser maior que o valor m�nimo';
  FErros[133] := 'Erro ao criar form de progresso: "%s"';
  FErros[134] := 'A form de progresso ainda n�o foi ativada';
  FErros[135] := 'Tipo de informa��o inv�lido. Os tipos devem ser 1, 2 ou 3';
  FErros[136] := 'Valor inv�lido para a informa��o 3. Informe um valor entre %s e %s';
  FErros[137] := 'Valor inv�lido para a informa��o %s. Erro: "%s"';
  FErros[138] := 'Tipo de informa��o inv�lido. A form de progresso foi ativada sem barra de progresso';
  FErros[139] := 'O valor 1 n�o pode ser informado para atributos de manejo';
  FErros[140] := 'Ocorreu o seguinte erro na pesquisa de relacionamentos ''%s''';
  FErros[141] := 'A composi��o racial total do animal ''%s-%s'' ultrapassou o valor m�ximo que � 1 (um)';
  FErros[142] := 'O c�digo da certificadora deve ter no m�ximo 20 letras e/ou n�meros';
  FErros[143] := 'O c�digo SISBOV informado � inv�lido';
  FErros[144] := 'O identificador informado na posi��o %s deve ser um identificador %s';
  FErros[145] := 'A categoria informada � inv�lida porque n�o � uma categoria para animal ativo';
  FErros[146] := 'Para o novo c�digo de manejo deste animal informe c�digo da fazenda de manejo e o c�digo de manejo do animal';
  FErros[147] := 'Para o novo c�digo de manejo deste animal n�o informe o c�digo da fazenda de manejo, informe somente o c�digo de manejo do animal';
  FErros[148] := 'S� podem ser usadas ra�as puras para defini��o de composi��o racial. A ra�a ''%s'' n�o � uma ra�a pura';
  FErros[149] := 'O c�digo da esta��o de monta deve ser informado';
  FErros[150] := 'O c�digo da esta��o de monta deve ter no m�ximo 4 letras e/ou n�meros';
  FErros[151] := 'A descri��o da esta��o de monta deve ser informada';
  FErros[152] := 'A descri��o da esta��o de monta deve ter no m�ximo 20 caracteres';
  FErros[153] := 'O c�digo da fazenda de manejo do animal ou RM deve ser informado';
  FErros[154] := 'O c�digo da fazenda de manejo do animal ou RM deve ter no m�ximo 2 letras e/ou n�meros';
  FErros[155] := 'O c�digo de manejo do animal ou RM deve ser informado';
  FErros[156] := 'O c�digo de manejo do animal ou RM deve ter no m�ximo 8 letras e/ou n�meros';
  FErros[157] := 'O status de prenhez do animal deve ser informado';
  FErros[158] := 'O status de apto do animal deve ser informado';
  FErros[159] := 'O c�digo da fazenda de manejo do touro deve ser informado';
  FErros[160] := 'O c�digo da fazenda de manejo do touro deve ter no m�ximo 2 letras e/ou n�meros';
  FErros[161] := 'O c�digo de manejo do touro deve ser informado';
  FErros[162] := 'O c�digo de manejo do touro deve ter no m�ximo 8 letras e/ou n�meros';
  FErros[163] := 'O n�mero da partida deve ter no m�ximo 8 caracteres';
  FErros[164] := 'O c�digo da fazenda de manejo da f�mea deve ser informado';
  FErros[165] := 'O c�digo da fazenda de manejo da f�mea deve ter no m�ximo 2 letras e/ou n�meros';
  FErros[166] := 'O c�digo de manejo da f�mea deve ser informado';
  FErros[167] := 'O c�digo de manejo da f�mea deve ter no m�ximo 8 letras e/ou n�meros';
  FErros[168] := 'O hor�rio do evento deve ser informado';
  FErros[169] := 'A quantidade de doses utilizada deve ser informada';
  FErros[170] := 'A quantidade de doses informada � inv�lida. Uma quantidade v�lida varia entre 1 e 9';
  FErros[171] := 'O CPF ou CNPJ do criador deve ser informado';
  FErros[172] := 'O NIRF/INCRA deve conter 8 ou 13 n�meros';
  FErros[173] := 'O NIRF/INCRA deve conter somente n�meros';
  FErros[174] := 'A data de emiss�o do GTA deve ser menor ou igual a data de in�cio do evento. A opera��o n�o ser� realizada.';
  FErros[175] := 'Para o tipo de lugar "PROPRIEDADE" n�o deve ser informada a "FAZENDA" nem o "CNPJ AGLOMERA��O"';
  FErros[176] := 'O NIRF/INCRA de %s deve ser informado';
  FErros[177] := 'Para o tipo de lugar "AGLOMERA��O" n�o deve ser informada a "FAZENDA" nem o "NIRF/INCRA"';
  FErros[178] := 'O CNPJ/CPF de %s deve ser informado';
  FErros[179] := 'Para o tipo de lugar "FAZENDA" n�o deve ser informado o "NIRF/INCRA" nem o "CNPJ AGLOMERA��O"';
  FErros[180] := 'O c�digo da fazenda de %s deve ser informado';
  FErros[181] := 'O tipo de lugar de %s informado � inv�lido';
  FErros[182] := 'Animais externos necessariamente devem possuir situa��o SISBOV igual a "Animal n�o controlado no SISBOV"';
  FErros[183] := 'A fazenda de manejo n�o deve ser informada para animais externos';
  FErros[184] := 'O c�digo certificadora do animal n�o � necess�rio para animais externos';
  FErros[185] := 'O im�vel de nascimento n�o � necess�rio para animais externos';
  FErros[186] := 'A fazenda de nascimento n�o � necess�ria para animais externos';
  FErros[187] := 'A data da compra n�o � necess�ria para animais externos';
  FErros[188] := 'N�o � necess�rio informar tipos de identificadores para animais externos';
  FErros[189] := 'N�o � necess�rio informar posi��es de identificadores para animais externos';
  FErros[190] := 'N�o � necess�rio informar o status de castrado do animal para animais externos';
  FErros[191] := 'N�o � necess�rio informar o regime alimentar para animais externos';
  FErros[192] := 'N�o � necess�rio informar a categoria do animal para animais externos';
  FErros[193] := 'N�o � necess�rio informar o n�mero do GTA para animais externos';
  FErros[194] := 'N�o � necess�rio informar o data de emiss�o do GTA para animais externos';
  FErros[195] := 'N�o � necess�rio informar o n�mero da nota fiscal para animais externos';
  FErros[196] := 'O c�digo da fazenda ou o NIRF/INCRA da propriedade de identifica��o devem ser informados para animais com identifica��o pendente';
  FErros[197] := 'N�o � necess�rio informar a fazenda corrente para animais externos';
  FErros[198] := 'N�o � necess�rio informar o local corrente para animais externos';
  FErros[199] := 'N�o � necess�rio informar o lote corrente para animais externos';
  FErros[200] := 'N�o � necess�rio informar o n�mero de transponder para animais externos';
  FErros[201] := 'O campo Ind. Efetivar, deve conter (S/N)';  // Mensagem alterada para o novo campo
  FErros[202] := 'S�mente animais com a situa��o Sisbov pendente (P) podem ter o campo Ind. Efetivar igual a ''S''.'; // Mensagem alterada para o novo campo
  FErros[203] := 'Problemas na gera��o dos registros de animais. Evento com c�digo de identifica��o ''%s'' no arquivo ''%s''';
  FErros[204] := 'O novo valor atributo deve ser informado';
  FErros[205] := 'O CNPJ/CPF ''%s'' do t�cnico � inv�lido.';
  FErros[206] := 'A data de identifica��o SISBOV ''%s'', n�o pode ser maior que a data atual.';
  FErros[207] := 'A data de nascimento ''%s'', n�o pode ser maior que a data atual.';
  FErros[208] := 'A data da compra ''%s'', n�o pode ser maior que a data atual.';
  FErros[209] := 'A data da emiss�o GTA ''%s'', n�o pode ser maior que a data atual.';
  FErros[210] := 'A data de emiss�o GTA ''%s'', deve ser maior que a data de nascimento do animal ''%s''.';      
  FErros[211] := 'Informado o NIRF/INCRA ou a fazenda de identifica��o, os dois n�o podem ser informados ao mesmo tempo.';
  FErros[212] := 'N�o � permitido informar o NIRF/INCRA de identifica��o para animais nascidos.';
  FErros[213] := 'Informe o tipo de caracter�stica do evento de avalia��o.';
  FErros[214] := 'O c�digo SISBOV dever� ser informado.';
  FErros[215] := 'O identificador %s n�o foi informado. A opera��o n�o ser� realizada.';
  FErros[216] := 'A fazenda de identifica��o n�o foi informada.';
  FErros[217] := 'Informe o tipo de avalia��o que o animal foi submetido.';
  FErros[218] := 'O valor da caracter�stica %s, da avalia��o %s n�o foi informado.';
  FErros[219] := 'Os identificadores 1 e 2 informados devem ser diferentes.';  
  FErros[220] := 'O Invent�rio do animal ''%s'' na fazenda ''%s'' j� existe no arquivo';
  FErros[221] := 'ATEN��O, os dados de invent�rio de animais devem ser inseridos em uma planilha exclusiva criada para esse fim.';

  // Verifica qual o �ltimo �ndice de erro da tabela
  // para teste de 'range' na obten��o e configura��o de erros
  For X := 0 to MAX_ERROS do Begin
    FUltimoErro := X;
    If FErros[X] = '' Then Break;
  End;
  FErros[1] := FErros[1] + ' Informe um c�digo entre 0 e ' + IntToStr(FUltimoErro) + '.';
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
            Result := 'Erro na obten��o da mensagem: "' + E.Message + '"';
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
