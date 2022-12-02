#include "TOTVS.CH"
#include "RESTFUL.CH"


WSRESTFUL WSRESTCLI DESCRIPTION "Serviço REST para INTEGRAÇÃO DE CLIENTES|SA1"

//Dados de recebimento/parametro Cliente de / Cliente Até
WSDATA CODCLIENTEDE     AS STRING //Também utilizado para Atualizar o Cliente
WSDATA CODCLIENTEATE    AS STRING

//Declarar os nossos métodos

WSMETHOD GET buscarcliente;
    DESCRIPTION "Retorna dados do Cliente";
        WSSYNTAX "/buscarcliente";
            PATH "buscarcliente";
                PRODUCES APPLICATION_JSON

WSMETHOD POST incluircliente;
    DESCRIPTION "Insere dados do Cliente";
        WSSYNTAX "/incluircliente";
            PATH "incluircliente";
                PRODUCES APPLICATION_JSON                

WSMETHOD PUT atualizarcliente;
    DESCRIPTION "Atualiza dados do Cliente";
        WSSYNTAX "/atualizarcliente";
            PATH "atualizarcliente";
                PRODUCES APPLICATION_JSON  

WSMETHOD DELETE deletarcliente;
    DESCRIPTION "Deleta o cliente através do parametro";
        WSSYNTAX "/deletarcliente";
            PATH "deletarcliente";
                PRODUCES APPLICATION_JSON 


ENDWSRESTFUL


//Criando método GET buscarcliente
//     [VERBO]  [DESCRICAO/ID]       [    PARAMETROS           ]             [WEBSERVICE A QUAL O MÉDOTO PERTENCE]
WSMETHOD GET    buscarcliente       WSRECEIVE CODCLIENTEDE, CODCLIENTEATE        WSREST WSRESTCLI

Local lRet          := .T.

Local nCount        := 1  // Contador do laço de repetição WHILE que será utilizado como índice do array com Json

Local nRegistros    := 0  //Conta o número de registros vindos no SELECT feito em SQL

//Variáveis que recebem os parametros | convertemos em caractere justamente porque elas serão concatenadas com texto, e elas são número
Local cCodDe        :=  cValtoChar(Self:CODCLIENTEDE)
Local cCodAte       :=  cValToChar(Self:CODCLIENTEATE)

Local aListClientes := {}  //Array que receberá os dados dos clientes que virão do banco de dados

//Objeto e string Json para recebimento do array com Json Serializado e depois como texto
Local oJson         := JsonObject():New()
Local cJson         := ""
 
/*Pega um nome de Alias automaticamente para armazenamento dos dados do SELECT 
evitando que fique travado caso várias pessoas acessem o mesmo aAlias*/
Local cAlias        := GetNextAlias()

//Armazenará o filtro do SELECT
Local cWhere        := "" 

//Imagine que o usuário para testar a aplicação coloque um códigoDe maior que um CódigoAté
IF Self:CODCLIENTEDE > Self:CODCLIENTEATE
    cCodDe        :=  cValToChar(Self:CODCLIENTEATE) 
    cCodAte       :=  cValtoChar(Self:CODCLIENTEDE)
ENDIF

                                //Por isso o motivo de convertermos as variávies de parametro para caracter
cWhere              := " AND SA1.A1_COD BETWEEN '"+cCodDe+"' AND '"+cCodAte+"' AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' "

        //Dica para transformar o cWhere em filtro / Tratamento para retirar as aspas que ficam automaticamente
cWhere              := "%"+cWhere+"%"

/*Buscaremos os seguintes campos:
CODIGO, LOJA, NOME, NOMEREDUZIDO, ENDEREÇO, ESTADO, BAIRRO, CIDADE, CGC
*/
BEGINSQL Alias cAlias
    SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SA1.A1_END, SA1.A1_EST, SA1.A1_BAIRRO, SA1.A1_MUN, SA1.A1_CGC
        FROM %table:SA1% SA1
    WHERE SA1.%notDel% 
    %exp:cWhere%
ENDSQL

//Conto quantos registros vieram e armazeno na variável nRegistros
Count to nRegistros

//Posiciono no primeiro registro
(cAlias)->(DbGoTop())

//Enquanto não chegar ao final do arquivo End Of Files(EOF)
WHILE (cAlias)->(!EOF())
    aAdd(aListClientes,JsonObject():New())
        aListClientes[nCount]["clicodigo"]      := (cAlias)->A1_COD
        aListClientes[nCount]["cliloja"]        := (cAlias)->A1_LOJA
        aListClientes[nCount]["clinome"]        := AllTrim(EncodeUTF8((cAlias)->A1_NOME))
        aListClientes[nCount]["clinomereduz"]   := AllTrim(EncodeUTF8((cAlias)->A1_NREDUZ))
        aListClientes[nCount]["cliendereco"]    := (cAlias)->A1_END
        aListClientes[nCount]["cliestado"]      := (cAlias)->A1_EST
        aListClientes[nCount]["clicidade"]      := (cAlias)->A1_MUN
        aListClientes[nCount]["clibairro"]      := (cAlias)->A1_BAIRRO
        aListClientes[nCount]["clicgc"]         := (cAlias)->A1_CGC
    nCount++ //Incremento a variável para pegar o próximo índice do array correspondente ao próximo registro

    (cAlias)->(DbSkip()) //Passo para o próximo registro
ENDDO

//Fecho a área/alias aberto
(cAlias)->(DbCloseArea())

IF nRegistros > 0
    oJson["clientes"]   := aListClientes //Atribuo ao objeto oJson o array com dados dos clientes

    cJson := FwJsonSerialize(oJson) //Serializo o Json e passo para a variável texto

    ::SetResponse(cJson) //Retorno o Json para o usuário
ELSE //Se não tiver registros ele retorna um erro
    SetRestFault(400,EncodeUTF8("Não existem registros/CLIENTES para os filtros informados! Por favor VERIFIQUE e tente novamente."))
    lRet    := .F.
    Return(lRet)
ENDIF

//Libero o Objeto de Json
FreeObj(oJson)

Return lRet
