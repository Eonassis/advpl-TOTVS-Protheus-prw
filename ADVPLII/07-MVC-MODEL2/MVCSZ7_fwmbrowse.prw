#include 'Protheus.ch'
#include 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MVCSZ7
    Fun��o principal para a constru��o da tela de Solicita��o de  Compras da empresa
    Protheuzeiro Strong S/A, como base na proposta fict�cia do treinamento da Sistematizei
    @type  Function
    @author Protheuzeiro Aluno
    @since 20/01/2021
    @version version 1.0
    /*/
User Function MVCSZ7()
Local aArea     := GetArea()

/*Far� o instanciamento da classe FwmBrowse, passando
 para o oBrowse a possibilidade de executar todos os m�todos da classe
*/
Local oBrowse   := FwmBrowse():New() 

oBrowse:SetAlias("SZ7")
oBrowse:SetDescription("Solicita��o de Compras")

//ATIVA O BROWSER
oBrowse:Activate()


//LIBERA A AREA
RestArea(aArea)

Return 
