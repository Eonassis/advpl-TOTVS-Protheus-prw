#include "Protheus.ch"


/*/{Protheus.doc} User Function MVCSZ7M
    Ponto de entrada para a User Function MVCSZ7 que est� em MVC
    onde o ID do Modelo � MVCSZ7M, sendo assim este � o meu PE para esta fun��o
    Valida o item da grid, para n�o deixar quantidade >  10(maior que 10)
    @type  Function
    @author user
    @since 13/02/2021
    /*/
User Function MVCSZ7M()
Local aParam    := PARAMIXB
Local xRet      := .T.

Local oObject   := aParam[1] //Objeto do formul�rio ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execu��o do ponto de entrada(se �  p�s valida��o, pr� valida��o, commit, etc)
Local cIdModel  := aParam[3] //ID do formul�rio


IF aParam[2] <> Nil
    IF cIdPonto == "FORMLINEPOS"
        IF FWFldGet("Z7_QUANT") > 10 //Fun��o que busca o valor do campo na linha do GRID

            Help(NIL, NIL, "QUANT>10", NIL, "Quantidade n�o permitida",;
            1,0, NIL, NIL, NIL, NIL, NIL,{"<b>Aten��o</b> Neste per�odo de pandemia, limitamos a quantidade de compra em at� 10 unidades"})
            
            xRet    := .F. //Se retornar false, logo ele n�o deixa passar
        ENDIF
    ENDIF
ENDIF



Return xRet
