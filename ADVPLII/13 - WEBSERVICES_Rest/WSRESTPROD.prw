#include "TOTVS.CH"
#include "RESTFUL.CH" //Include utilizada para constru��o de WebServices REST

//Inicio a cria��o do meu SERVI�O REST
WSRESTFUL WSRESTPROD DESCRIPTION "Servi�o REST para manipula��o de Produtos/SB1"

//Parametro utilizado para busca do produto e para exclus�o via m�todo delete
WSDATA CODPRODUTO AS STRING

//Inicio a cria��o dos m�todos que o meu WebService ter�
WSMETHOD GET buscarproduto;
DESCRIPTION "Retorna dados do Produto";
WSSYNTAX "/buscarproduto";
PATH "buscarproduto" PRODUCES APPLICATION_JSON

WSMETHOD POST inserirproduto    DESCRIPTION "Inserir dados Produto"   WSSYNTAX "/inserirproduto"      PATH "inserirproduto"   PRODUCES APPLICATION_JSON

WSMETHOD PUT atualizarproduto   DESCRIPTION "Alterar dados Produto"   WSSYNTAX "/atualizarproduto"    PATH "atualizarproduto" PRODUCES APPLICATION_JSON

WSMETHOD DELETE deletarproduto  DESCRIPTION "Deletar dados Produto"   WSSYNTAX "/deletarproduto"      PATH "deletarproduto"   PRODUCES APPLICATION_JSON

ENDWSRESTFUL


//Constru��o de M�todo para trazer dados da tabela SB1/PRODUTOS
WSMETHOD GET buscarproduto WSRECEIVE CODPRODUTO WSREST WSRESTPROD
Local lRet  := .T. //Vari�vel l�gica de retorno do m�todo

//Recuperamos o produto que est� sendo utilizado na URL/PARAMETRO 
Local cCodProd  := Self:CODPRODUTO //Self = Interno = Deste mesmo font = desta mesma estrutura
Local aArea     := GetArea()

Local oJson     := JsonObject():New() //Instanciando a classe JsonObject para transformar a vari�vel oJson na estruura JSon
Local cJson     := ""

Local oReturn   //Caso o produto n�o seja encontrado retorna uma mensagem de erro
Local cReturn   //Retorno de sucesso adicional

Local aProd     := {} //Array que receber� os dados de Produto e  ser� passado para Json

/*
O Objetivo � trazer do banco de dados os campos: 
C�digo de Produto / Descri��o / Unidade de Medida / Tipo / NCM / Grupo de Produto / Bloqueado ou N�o
*/
Local cStatus := "" //Bloqueado ou n�o
Local cGrupo  := "" //Bloqueado ou n�o


//Fa�o a busca de dados, via DbSelectArea()
DbSelectArea("SB1") //Seleciono a �rea da Tabela SB1
SB1->(DbSetOrder(1)) //Fa�o a ordena��o pelo �ndice 1 (FILIAL+C�DIGODEPRODUTO)
IF SB1->(DbSeek(xFilial("SB1")+cCodProd))
    cStatus := IIF(SB1->B1_MSBLQL == "1","Bloqueado","Desbloqueado")
    //Posiciono na SBM com o �ndice 1 e atrav�s do c�digo do grupo do produto eu busco a descri��o do grupo
    cGrupo  := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC") 

    aAdd(aProd,JsonObject():New()) //Passo o array para Json
    /*Como s� tenho 1 linha, pois s� podem existir 1 produto com o mesmo c�digo no sistema
    logo coloco 1 na posi��o do �ndice do array*/  
    aProd[1]['prodcod']     := AllTrim(SB1->B1_COD)
    aProd[1]['proddesc']    := AllTrim(SB1->B1_DESC)
    aProd[1]['produm']      := AllTrim(SB1->B1_UM)
    aProd[1]['prodtipo']    := AllTrim(SB1->B1_TIPO)
    aProd[1]['prodncm']     := AllTrim(SB1->B1_POSIPI)
    aProd[1]['prodgrupo']   := cGrupo
    aProd[1]['prodstatus']  := cStatus


    oReturn := JsonObject():New()
    oReturn['cRet']     := "200"
    oReturn['cmessage'] := "Produto encontrado com sucesso!"
    cReturn := FwJSonSerialize(oReturn) //Serializo esse retorno


    //Passo para o Json com Header Produtos e itens que s�o os campos que est�o acima com os dados da SB1
    oJson["produtos"] := aProd
    //Precisamos FAZER A SERIALIZA��O DO JSON /Trnasformo o retorno de itens em Json, atrav�s do FwJsonSerialize(oJson)
    cJson   := FwJSonSerialize(oJson)

    ::SetResponse(cJson)
    ::SetResponse(cReturn)
ELSE
   SetRestFault(400,'C�digo do Produto n�o encontrado!') //Setando um erro
   lRet := .F.
   Return(lRet)
ENDIF

SB1->(dbCloseArea())

RestArea(aArea)

//Libero os objetos Json e Retorno
FreeObj(oJson)
FreeObj(oReturn)

RETURN(lRet)


//Constru��o do m�todo POST /inserirproduto
WSMETHOD POST inserirproduto WSRECEIVE WSREST WSRESTPROD
Local lRet      := .T.

Local aArea     := GetArea()

//Instancia da Classe JSonObject
Local oJson     := JsonObject():New()

Local oReturn   := JSonObject():New()

//Vai carregar os dados vindos da String/Body/Corpo da requis��o que estar� em Json
oJson:FromJson(Self:GetContent()) //GetContent pega o conte�do do Json

//VERIFICAMOS SE O CAMPO DE C�DIGO DO PRODUTO EST� EM BRANCO
IF Empty(oJson["produtos"]:GetJsonObject("prodcod"))
   SetRestFault(400,'CODIGO DO PRODUTO ESTA EM BRANCO!') //Setando um erro
   lRet := .F.
   Return(lRet)
ELSE //SE O C�DIGO DO PRODUTO N�O ESTIVER VAZIO NO JSON ELE FAZ A BUSCA
    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    //Verificar se o c�digo que est� sendo inserido j� existe
    IF SB1->(DbSeek(xFilial("SB1")+AllTrim(oJson["produtos"]:GetJsonObject("prodcod"))))
        SetRestFault(401,'CODIGO DO PRODUTO JA EXISTE!') //Setando um erro
        lRet := .F.
        Return(lRet)
    //VERIFICAMOS SE DEMAIS CAMPOS EST�O EM BRANCO
    ELSEIF Empty(oJson["produtos"]:GetJsonObject("proddesc"))
        SetRestFault(402,'DESCRICAO DO PRODUTO ESTA EM BRANCO!') //Setando um erro
        lRet := .F.
        Return(lRet)
    ELSEIF Empty(oJson["produtos"]:GetJsonObject("produm"))
        SetRestFault(403,'UNIDADE DE MEDIDA DO PRODUTO ESTA EM BRANCO!') //Setando um erro
        lRet := .F.
        Return(lRet)
    ELSEIF Empty(oJson["produtos"]:GetJsonObject("prodgrupo"))
        SetRestFault(404,'CODIGO DO GRUPO DO PRODUTO ESTA EM BRANCO!') //Setando um erro
        lRet := .F.
        Return(lRet)
    ELSEIF Empty(oJson["produtos"]:GetJsonObject("prodtipo"))
        SetRestFault(405,'O TIPO DO PRODUTO ESTA EM BRANCO!') //Setando um erro
        lRet := .F.
        Return(lRet) 
    //Se ele n�o encontrar o c�digo do grupo passado no JSON ele n�o deixa inserir e retorna erro de GRUPO INV�LIDO        
    ELSEIF !SBM->(DbSeek(xFilial("SBM")+AllTrim(oJson["produtos"]:GetJsonObject("prodgrupo"))))  
        SetRestFault(406,'CODIGO DO GRUPO INVALIDO | INSIRA UM CODIGO DE GRUPO EXISTENTE!') //Setando um erro
        lRet := .F.
        Return(lRet)     
    ELSE
        //SE O C�DIGO DO PRODUTO N�O EXISTIR NA TABELA E TODOS OS CAMPOS ESTIVEREM PREENCHIDOS, ELE INSERE NO BANCO
        RecLock("SB1",.T.) //True = Inclus�o / False = Altera��o
            SB1->B1_COD     :=  oJson["produtos"]:GetJsonObject("prodcod") //Esse c�digo � respons�vel por buscar dentro do Json o conte�do do campo prodcod
            SB1->B1_DESC    :=  oJson["produtos"]:GetJsonObject("proddesc")
            SB1->B1_TIPO    :=  oJson["produtos"]:GetJsonObject("prodtipo")
            SB1->B1_UM      :=  oJson["produtos"]:GetJsonObject("produm")
            SB1->B1_GRUPO   :=  oJson["produtos"]:GetJsonObject("prodgrupo")
            SB1->B1_MSBLQL  := "1" //O Produto j� entra ativo
        SB1->(MsUnlock())

        SB1->(dbCloseArea()) //Fecho a Area

        oReturn["prodcod"]  := oJson["produtos"]:GetJsonObject("prodcod")
        oReturn["proddesc"] := oJson["produtos"]:GetJsonObject("proddesc")
        oReturn["cRet"]     := "201 - Sucesso!"
        oReturn["cMessage"] := "Registro Inclu�do com Sucesso no Banco de dados, por favor insira o restante dos dados via Protheus"

        Self:SetStatus(201)
        Self:SetContentType(APPLICATION_JSON) //Tipo de conte�do retornado JSON
        Self:SetResponse(FwJSonSerialize(oReturn)) //Serializo o objeto oReturn para Json e retorno para o usu�rio
    ENDIF
ENDIF

RestArea(aArea)
FreeObj(oJson)
FreeObj(oReturn)
    
Return lRet



//Constru��o do m�todo PUT /alterarproduto
WSMETHOD PUT atualizarproduto WSRECEIVE WSREST WSRESTPROD
Local lRet      := .T.

Local aArea     := GetArea()

//Instancia da Classe JSonObject
Local oJson     := JsonObject():New()

Local oReturn   := JSonObject():New()

//Vai carregar os dados vindos da String/Body/Corpo da requis��o que estar� em Json
oJson:FromJson(Self:GetContent()) //GetContent pega o conte�do do Json

//VERIFICAMOS SE O CAMPO DE C�DIGO DO PRODUTO EST� EM BRANCO
IF Empty(oJson["produtos"]:GetJsonObject("prodcod"))
   SetRestFault(400,'CODIGO DO PRODUTO ESTA EM BRANCO!') //Setando um erro
   lRet := .F.
   Return(lRet)
ELSE //SE O C�DIGO DO PRODUTO N�O ESTIVER VAZIO NO JSON ELE FAZ A BUSCA
    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    //Verificar se o c�digo que est� sendo inserido j� existe porque sen�o existir n�o poder� ser atualizado
    IF !SB1->(DbSeek(xFilial("SB1")+AllTrim(oJson["produtos"]:GetJsonObject("prodcod"))))
        SetRestFault(401,'CODIGO DO PRODUTO NAO EXISTE! INSIRA UM CODIGO VALIDO') //Setando um erro
        lRet := .F.
        Return(lRet)
    //VERIFICAMOS SE DEMAIS CAMPOS EST�O EM BRANCO
    ELSEIF Empty(oJson["produtos"]:GetJsonObject("proddesc"))
        SetRestFault(403,'DESCRICAO DO PRODUTO ESTA EM BRANCO!') //Setando um erro
        lRet := .F.
        Return(lRet)
    ELSEIF Empty(oJson["produtos"]:GetJsonObject("produm"))
        SetRestFault(404,'UNIDADE DE MEDIDA DO PRODUTO ESTA EM BRANCO!') //Setando um erro
        lRet := .F.
        Return(lRet)
    ELSEIF Empty(oJson["produtos"]:GetJsonObject("prodgrupo"))
        SetRestFault(405,'CODIGO DO GRUPO DO PRODUTO ESTA EM BRANCO!') //Setando um erro
        lRet := .F.
        Return(lRet)
    ELSEIF Empty(oJson["produtos"]:GetJsonObject("prodtipo"))
        SetRestFault(406,'O TIPO DO PRODUTO ESTA EM BRANCO!') //Setando um erro
        lRet := .F.
        Return(lRet) 
    //Se ele n�o encontrar o c�digo do grupo passado no JSON ele n�o deixa inserir e retorna erro de GRUPO INV�LIDO        
    ELSEIF !SBM->(DbSeek(xFilial("SBM")+AllTrim(oJson["produtos"]:GetJsonObject("prodgrupo"))))  
        SetRestFault(407,'CODIGO DO GRUPO INVALIDO | INSIRA UM CODIGO DE GRUPO EXISTENTE!') //Setando um erro
        lRet := .F.
        Return(lRet)     
    ELSE
        //SE O C�DIGO DO PRODUTO N�O EXISTIR NA TABELA E TODOS OS CAMPOS ESTIVEREM PREENCHIDOS, ELE INSERE NO BANCO
        RecLock("SB1",.F.) //True = Inclus�o / False = Altera��o
            SB1->B1_DESC    :=  oJson["produtos"]:GetJsonObject("proddesc")
            SB1->B1_TIPO    :=  oJson["produtos"]:GetJsonObject("prodtipo")
            SB1->B1_UM      :=  oJson["produtos"]:GetJsonObject("produm")
            SB1->B1_GRUPO   :=  oJson["produtos"]:GetJsonObject("prodgrupo")
        SB1->(MsUnlock())

        SB1->(dbCloseArea()) //Fecho a Area

        oReturn["prodcod"]  := oJson["produtos"]:GetJsonObject("prodcod")
        oReturn["proddesc"] := oJson["produtos"]:GetJsonObject("proddesc")
        oReturn["cRet"]     := "201 - Sucesso!"
        oReturn["cMessage"] := "Registro ATUALIZADO com Sucesso no Banco de dados, por favor atualize o restante dos dados via Protheus"

        Self:SetStatus(201)
        Self:SetContentType(APPLICATION_JSON) //Tipo de conte�do retornado JSON
        Self:SetResponse(FwJSonSerialize(oReturn)) //Serializo o objeto oReturn para Json e retorno para o usu�rio
    ENDIF
ENDIF

RestArea(aArea)
FreeObj(oJson)
FreeObj(oReturn)
    
Return lRet


//Construindo m�todo DELETE  do meu WebService REST
WSMETHOD DELETE deletarproduto WSRECEIVE CODPRODUTO WSREST WSRESTPROD
Local lRet      := .T.

Local cCodProd  := Self:CODPRODUTO //Passo para a vari�vel cCodProd o conte�do do parametro
Local cDescProd := "" //Grava a descri��o do Produto caso ele seja encontrado

Local aArea     := GetArea()

Local oJson     := JsonObject():New()
Local oReturn   := JsonObject():New()

DbSelectArea("SB1")
SB1->(DbSetOrder(1))

IF !SB1->(DbSeek(xFilial("SB1")+cCodProd))
   SetRestFault(401,'O CODIGO DE PRODUTO informado nao existe ')
   lRet := .F.
   Return(lRet)
ELSE //Se ele achar, deleta

    cDescProd   := SB1->B1_DESC //Gravo a Descri��o do Produto, antes de deletar

    RecLock("SB1",.F.) //Sempre que � DELE��O usamos o parametro .F.
        DbDelete()
    SB1->(MsUnlock())

    oReturn["prodcod"]  := cCodProd
    oReturn["proddesc"] := cDescProd
    oReturn["cRet"]     := "201 - Sucesso!"
    oReturn["cMessage"] := "Registro EXCLUIDO com SUCESSO!"

    Self:SetStatus(201)
    Self:SetContentType(APPLICATION_JSON) //Tipo de conte�do retornado JSON
    Self:SetResponse(FwJSonSerialize(oReturn)) //Serializo o objeto oReturn para Json e retorno para o usu�rio    
ENDIF

SB1->(dbCloseArea())
RestArea(aArea)
FreeObj(oJson)
FreeObj(oReturn)

Return lRet

/* Modelo de Json
    {
    "produtos": 
        {
            "proddesc": "WHEY PROTEIN CARNIVOR 2KG",
            "prodcod": "WHEY.000066",
            "produm": "UN",
            "prodtipo": "PA",
            "prodgrupo": "0008"
        }
    }
*/
