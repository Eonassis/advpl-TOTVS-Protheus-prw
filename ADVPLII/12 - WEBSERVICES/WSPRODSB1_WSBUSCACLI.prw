#Include 'Protheus.ch'
#Include 'APWEBSRV.CH'
#Include 'TOPCONN.CH'


//C�DIGO, DESCRI��O, UNIDADE DE MEDIDA, TIPO, NCM E GRUPO;
//Estrutura de dados do Produto
WSSTRUCT StProduto
    WSDATA  produtoB1COD        AS STRING OPTIONAL
    WSDATA  produtoB1DESC       AS STRING OPTIONAL
    WSDATA  produtoB1UM         AS STRING OPTIONAL
    WSDATA  produtoB1TIPO       AS STRING OPTIONAL
    WSDATA  produtoB1POSIPI     AS STRING OPTIONAL
    WSDATA  produtoB1GRUPO      AS STRING OPTIONAL //Buscar da SBMa trav�s de posicione
ENDWSSTRUCT

//Estrutura de dados da Quantidade e valor total de vendas
WSSTRUCT StProdVenda
    WSDATA produtoQTDTOTAL          AS INTEGER   OPTIONAL  /*D2_QUANT*/
    WSDATA produtoVALORTOTAL        AS FLOAT     OPTIONAL  /*D2_TOTAL*/
ENDWSSTRUCT


//Estrutura de Dados para retorno de mensagem
WSSTRUCT StRetMsgProd
    WSDATA cRet         AS STRING OPTIONAL
    WSDATA cMessage     AS STRING OPTIONAL
ENDWSSTRUCT

//Classe de dados para retorno geral, aqui ser� uma ponte para as duas classes/estrutuas acima
WSSTRUCT STRetGeralProd
    WSDATA WsBuscaProd      AS StProduto  
    WSDATA WsRetMsg         AS StRetMsgProd  
    WSDATA WsProdVenda      AS StProdVenda
ENDWSSTRUCT


WSSERVICE WSPRODSB1   DESCRIPTION "Servi�o para retornar os dados de um PRODUTO espec�fico da Protheuzeiro Strong"
//Parametro de entrada
WSDATA _cCodProduto     AS STRING

//Parametro de retorno Atrav�s deste dado, ele acessar� a classe de dados STRetGeralProd, e atrav�s dela, acessar� o StProduto e o StREtMsgProd
WSDATA WsRetornoGeral   AS STRetGeralProd

//M�todo
WSMETHOD BuscaProduto   DESCRIPTION  "Lista dados do PRODUTO atrav�s do C�digo"

WSMETHOD BuscaProdVend  DESCRIPTION  "Busca quantidade de produtos vendidos e total de venda"
 
ENDWSSERVICE


WSMETHOD BuscaProduto WSRECEIVE _cCodProduto WSSEND WsRetornoGeral WSSERVICE WSPRODSB1

Local cCodProduto   := ::_cCodProduto

DbSelectArea("SB1")
SB1->(DbSetOrder(1))

//Se encontrar vai retornar SUCESSO no WebService
IF SB1->(DbSeek(xFilial("SB1")+cCodProduto))
        ::WSRetornoGeral:WsRetMsg:cRet                      := "[T]"
        ::WsRetornoGeral:WsRetMsg:cMessage                  := "Sucesso! O produto foi encontrado"

        ::WsRetornoGeral:WsBuscaProd:produtoB1COD           :=  SB1->B1_COD
        ::WsRetornoGeral:WsBuscaProd:produtoB1DESC          :=  SB1->B1_DESC
        ::WsRetornoGeral:WsBuscaProd:produtoB1UM            :=  SB1->B1_UM
        ::WsRetornoGeral:WsBuscaProd:produtoB1TIPO          :=  SB1->B1_TIPO
        ::WsRetornoGeral:WsBuscaProd:produtoB1POSIPI        :=  SB1->B1_POSIPI
        ::WsRetornoGeral:WsBuscaProd:produtoB1GRUPO         :=  Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC")

//Sen�o, ele vai retornar falso
ELSE
        ::WSRetornoGeral:WsRetMsg:cRet                      := "[F]"
        ::WsRetornoGeral:WsRetMsg:cMessage                  := "Falha! O produto foi encontrado para o c�digo especificado"
ENDIF

SB1->(DbCloseArea())

RETURN .T.





WSMETHOD BuscaProdVend WSRECEIVE _cCodProduto WSSEND WsRetornoGeral WSSERVICE WSPRODSB1
Local cCodProduto   := ::_cCodProduto

//Vari�veis que receber�o os totais de quantidade e valor de venda dos produtos
Local nQtdVend      := 0
Local nTotalVend    := 0

//Selecionar tabela
DbSelectArea("SD2")

//Ordenar por �ndice 1
SD2->(DbSetOrder(1))

//Fa�o uma busca para ver se o produto existe dentro da SD2
SD2->(DbSeek(xFilial("SD2")+cCodProduto))

//EOF END OF FILE  OU FINAL DO ARQUIVO
While SD2->(!EOF()) .AND. SD2->D2_COD = cCodProduto

    //Vai incrementar os totais dentro dessas vari�veis
    nQtdVend    +=      SD2->D2_QUANT
    nTotalVend  +=      SD2->D2_TOTAL

//Passar para o pr�ximo Registro
SD2->(DbSkip())
ENDDO

//Fecho a �rea aberta
SD2->(DbCloseArea())

//Se ele achar o produto dentro da SD2, se tiver tido alguma venda, eu mostro no webService
IF nQtdVend > 0 
    ::WSRetornoGeral:WsRetMsg:cRet                      := "[T]"
    ::WsRetornoGeral:WsRetMsg:cMessage                  := "Sucesso! O produto foi encontrado"

    ::WsRetornoGeral:WsProdVenda:produtoQTDTOTAL        := nQtdVend
    ::WsRetornoGeral:WsProdVenda:produtoVALORTOTAL      := nTotalVend
ELSE
    ::WSRetornoGeral:WsRetMsg:cRet                      := "[F]"
    ::WsRetornoGeral:WsRetMsg:cMessage                  := "Falha! O produto N�O foi encontrado para o c�digo especificado"
ENDIF


RETURN .T.
