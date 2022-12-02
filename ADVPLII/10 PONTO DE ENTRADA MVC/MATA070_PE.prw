#include "Protheus.ch"

/*/{Protheus.doc} User Function MATA070
    Ponto de entrada para Bancos(MATA070), neste caso
    em especial o IDDAMODEL tem o mesmo nome da FUNCTION, fonte padrão
    para isto, eu criei o fonte como MATA070_pe.prw
    @type  Function
    @author user
    @since 13/02/2021
    /*/
User Function MATA070()
Local aParam    := PARAMIXB
Local xRet      := .T.

Local oObject   := aParam[1] //Objeto do formulário ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execução do ponto de entrada(se é  pós validação, pré validação, commit, etc)
Local cIdModel  := aParam[3] //ID do formulário


IF aParam[2] <> Nil
    IF cIdPonto == "MODELPOS"
        IF Empty(M->A6_DVAGE) .OR. Empty(M->A6_DVCTA)
            Help(NIL, NIL, "MATA070", NIL, "DV de Agencia ou Conta em branco",;
            1,0, NIL, NIL, NIL, NIL, NIL,{"O dígito verificador da <b>Agencia</b> e da <b>Conta</b> devem ser preenchidos"})

            xRet    := .F. //Se retornar false, logo ele não deixa passar
        ENDIF
    ENDIF
ENDIF

Return xRet
