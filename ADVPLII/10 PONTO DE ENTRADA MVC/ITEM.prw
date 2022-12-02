#include "Protheus.ch"


/*/{Protheus.doc} User Function Item
    Ponto de entrada utilizado para modificar o cadastro de produtos, quando este(MATA010)
    está em MVC
    @type  Function
    @author user
    @since 13/02/2021
    /*/
User Function Item()

/*Parametro obrigatório nos PEs em MVC, pois eles trazem consigo, informações importantes
sobre o estado e ponto de execução da rotina*/
Local aParam    := PARAMIXB

/* RETORNO DO ARRAY aParam
1   O     Objeto do formulário ou do modelo, conforme o caso
2   C     ID do local de execução do ponto de entrada
3   C     ID do formulário
*/

/*Esta variável pode retornar no final, tanto lógico quanto um array, por exemplo, por isso dixamos
a notação HÚNGARA indefinida com x e não com l */
Local xRet      := .T.

Local oObject   := aParam[1] //Objeto do formulário ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do local de execução do ponto de entrada(se é  pós validação, pré validação, commit, etc)
Local cIdModel  := aParam[3] //ID do formulário

//Captura a operação executada na aplicação
Local nOperation    := oObject:GetOperation()
/*
1- pesquisar
2- visualizar
3- incluir
4- alterar
5- excluir
6- outras funções
7- copiar
*/


//Se ele estiver diferente de nulo, quer dizer que alguma ação está sendo feita no modelo
IF aParam[2] <> Nil
    IF cIdPonto == "MODELPOS" //Se estiver na Pós Validação(Clicou em Confirma)
        //Verifica se o campo de código do produto possui no mínimo 10 caracteres
        IF Len(AllTrim(M->B1_COD)) < 10
            Help(NIL, NIL, "CODPRODUTO", NIL, "Código não permitido",;
            1,0, NIL, NIL, NIL, NIL, NIL,{"O Código <b> "+AllTrim(M->B1_COD) + "</b> deve ter no mínimo 10 caracteres <b>"})
            
            xRet    := .F.
        
        //Verifica se o campo de descrição do produto possui no mínimo 15 caracteres 
        ELSEIF  Len(AllTrim(M->B1_DESC)) < 15
            Help(NIL, NIL, "DESCPRODUTO", NIL, "Descrição do Produto inválida",;
            1,0, NIL, NIL, NIL, NIL, NIL,{"A descrição <b." + AllTrim(M->B1_DESC) +" </b> deve ter no mínimo 15 caracteres"})

            xRet    := .F.
        ENDIF            
    
    ELSEIF nOperation = 5 //Exclusão
		Help(NIL, NIL, "EXCLUIRPRODUTO", NIL, "Exclusão não permitida",;
		1,0, NIL, NIL, NIL, NIL, NIL,{"O Produto não pode ser excluído em hipótese alguma<br>"+;
		"Consulte o departamento de TI desta unidade"})
		xRet := .F.	        
    
    //Tarefa para você Protheuzeiro, faça uma outra validação para o Cancelamento, similar à que fizemos dentro do sistema de chamados
    
    Endif
Endif

Return xRet
