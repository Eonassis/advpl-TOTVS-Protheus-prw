#include "Protheus.ch"

/*/{Protheus.doc} User Function CustomerVendor
    CustomerVendor � o nome do ID do Model dentro do fonte padr�o do cadastro de Fornecedor(MATA020)
    @type  Function
    @author user
    @since 13/02/2021
    /*/
User Function CustomerVendor()
Local aParam    := PARAMIXB
Local xRet      := .T.

Local oObject   := aParam[1] //Objeto do formul�rio ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execu��o do ponto de entrada(se �  p�s valida��o, pr� valida��o, commit, etc)
Local cIdModel  := aParam[3] //ID do formul�rio

Local cRazSoc   := AllTrim(M->A2_NOME)  //Raz�o Social

Local cFantasia := AllTrim(M->A2_NREDUZ) //Nome Reduzido

IF aParam[2] <> Nil //(Se ele clicar em Incluir/Alterar/Excluir/Visualizar)

    IF cIdPonto == "MODELPOS" //Se estiver na P�s Valida��o(Clicou em Confirma)
        IF Len(cRazSoc) < 20
			Help(NIL, NIL, "RAZSOC", NIL, "Razao social inv�lida",;
			1,0, NIL, NIL, NIL, NIL, NIL,{"A Raz�o social <b> "+cRazSoc + "</b> deve ter no m�nimo <b>20</b> caracteres"})

            xRet    := .F.
        ELSEIF  Len(cFantasia) < 10
			Help(NIL, NIL, "NOMFAN", NIL, "Nome fantasia inv�lido",;
			1,0, NIL, NIL, NIL, NIL, NIL,{"O Nome Fantasia <b> "+cFantasia + "</b> deve ter no m�nimo <b>10</b> caracteres"})

            xRet    := .F.
        ENDIF 
    ELSEIF cIdPonto == "BUTTONBAR"                   
        xRet    := {{"Produto x Fornecedor","Produto x Fornecedor",{|| MATA061()},"Chama a amarra��o Prod x Forn"}}
    Endif
Endif

Return xRet
