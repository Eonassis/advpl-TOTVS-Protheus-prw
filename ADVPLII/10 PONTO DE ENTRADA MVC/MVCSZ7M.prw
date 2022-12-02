#include "Protheus.ch"


/*/{Protheus.doc} User Function MVCSZ7M
    Ponto de entrada para a User Function MVCSZ7 que está em MVC
    onde o ID do Modelo é MVCSZ7M, sendo assim este é o meu PE para esta função
    Valida o item da grid, para não deixar quantidade >  10(maior que 10)
    @type  Function
    @author user
    @since 13/02/2021
    /*/
User Function MVCSZ7M()
Local aParam    := PARAMIXB
Local xRet      := .T.

Local oObject   := aParam[1] //Objeto do formulário ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execução do ponto de entrada(se é  pós validação, pré validação, commit, etc)
Local cIdModel  := aParam[3] //ID do formulário


IF aParam[2] <> Nil
    IF cIdPonto == "FORMLINEPOS"
        IF FWFldGet("Z7_QUANT") > 10 //Função que busca o valor do campo na linha do GRID

            Help(NIL, NIL, "QUANT>10", NIL, "Quantidade não permitida",;
            1,0, NIL, NIL, NIL, NIL, NIL,{"<b>Atenção</b> Neste período de pandemia, limitamos a quantidade de compra em até 10 unidades"})
            
            xRet    := .F. //Se retornar false, logo ele não deixa passar
        ENDIF
    ENDIF
ENDIF



Return xRet
