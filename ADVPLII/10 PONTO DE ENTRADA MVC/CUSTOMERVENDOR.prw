#include "Protheus.ch"

/*/{Protheus.doc} User Function CustomerVendor
    CustomerVendor é o nome do ID do Model dentro do fonte padrão do cadastro de Fornecedor(MATA020)
    @type  Function
    @author user
    @since 13/02/2021
    /*/
User Function CustomerVendor()
Local aParam    := PARAMIXB
Local xRet      := .T.

Local oObject   := aParam[1] //Objeto do formulário ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execução do ponto de entrada(se é  pós validação, pré validação, commit, etc)
Local cIdModel  := aParam[3] //ID do formulário

Local cRazSoc   := AllTrim(M->A2_NOME)  //Razão Social

Local cFantasia := AllTrim(M->A2_NREDUZ) //Nome Reduzido

IF aParam[2] <> Nil //(Se ele clicar em Incluir/Alterar/Excluir/Visualizar)

    IF cIdPonto == "MODELPOS" //Se estiver na Pós Validação(Clicou em Confirma)
        IF Len(cRazSoc) < 20
			Help(NIL, NIL, "RAZSOC", NIL, "Razao social inválida",;
			1,0, NIL, NIL, NIL, NIL, NIL,{"A Razão social <b> "+cRazSoc + "</b> deve ter no mínimo <b>20</b> caracteres"})

            xRet    := .F.
        ELSEIF  Len(cFantasia) < 10
			Help(NIL, NIL, "NOMFAN", NIL, "Nome fantasia inválido",;
			1,0, NIL, NIL, NIL, NIL, NIL,{"O Nome Fantasia <b> "+cFantasia + "</b> deve ter no mínimo <b>10</b> caracteres"})

            xRet    := .F.
        ENDIF 
    ELSEIF cIdPonto == "BUTTONBAR"                   
        xRet    := {{"Produto x Fornecedor","Produto x Fornecedor",{|| MATA061()},"Chama a amarração Prod x Forn"}}
    Endif
Endif

Return xRet
