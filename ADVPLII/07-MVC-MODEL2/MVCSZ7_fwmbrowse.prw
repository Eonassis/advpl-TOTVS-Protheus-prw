#include 'Protheus.ch'
#include 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MVCSZ7
    Função principal para a construção da tela de Solicitação de  Compras da empresa
    Protheuzeiro Strong S/A, como base na proposta fictícia do treinamento da Sistematizei
    @type  Function
    @author Protheuzeiro Aluno
    @since 20/01/2021
    @version version 1.0
    /*/
User Function MVCSZ7()
Local aArea     := GetArea()

/*Fará o instanciamento da classe FwmBrowse, passando
 para o oBrowse a possibilidade de executar todos os métodos da classe
*/
Local oBrowse   := FwmBrowse():New() 

oBrowse:SetAlias("SZ7")
oBrowse:SetDescription("Solicitação de Compras")

//ATIVA O BROWSER
oBrowse:Activate()


//LIBERA A AREA
RestArea(aArea)

Return 
