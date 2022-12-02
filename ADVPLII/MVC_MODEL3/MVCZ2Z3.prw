#include "Protheus.ch"
#include "FwMvcDef.ch"


User Function MVCZ2Z3()
Local oBrowse := FwLoadBrw("MVCZ2Z3") //Digo o fonte que eu estou buscando o BrowseDef

//Ativo o Browse
oBrowse:Activate()

Return 

/*/
Função responsável por criar o Brose e retorná-lo para o Menu que invocá-lo
Quando eu tenho uma Static Function BrowseDef no meu fonte, significa
que eu posso emprestá-la para outros fontes, através do FwLoadBr

    /*/
Static Function BrowseDef()
Local aArea := GetArea()

Local oBrowse := FwMBrowse():New() 

oBrowse:SetAlias("SZ2")
oBrowse:SetDescription("Cadastro de Chamados")

oBrowse:AddLegend("SZ2->Z2_STATUS == '1'","RED"   ,"Chamado Aberto")
oBrowse:AddLegend("SZ2->Z2_STATUS == '2'","GREEN"     ,"Chamado Finalizado")
oBrowse:AddLegend("SZ2->Z2_STATUS == '3'","YELLOW"  ,"Chamado em Andamento")


//Deve definir de onde virá o MenuDef devo chamar o meu menu
oBrowse:SetMenudef("MVCZ2Z3") //Coloco o fonte de onde virá o meu menu

RestArea(aArea)

Return oBrowse 


Static Function MenuDef()
Local aMenu     := {}


//Trago através da FwMvcMenu, o menu para o array aMenuAut
Local aMenuAut      := FwMvcMenu("MVCZ2Z3")
Local n             := 0  

/*Adiciono dentro da variável aMenu, o título Legenda e Sobre, junto com a ação
de chamar as UserFunctions de legenda e Sobre, essas operações são de código 6, e
eu passo o nível de usuário 0
*/
ADD OPTION aMenu TITLE 'Legenda'      ACTION 'u_SZ2LEG'         OPERATION 6 ACCESS 0
ADD OPTION aMenu TITLE 'Sobre'        ACTION 'u_SZ2SOBRE'       OPERATION 6 ACCESS 0

/*Utilizo um laço de repetição para adicionar à variável aMenu, 
o que eu criai automaticamente para a variável aMenuAut*/

For n:= 1 to Len(aMenuAut)
    aAdd(aMenu,aMenuAut[n])
Next n


Return aMenu




Static Function ModelDef()
//Declaro o meu modelo de dados sem passar blocos de validação pois usaremos a validação padrão do MVC
Local oModel := MPFormModel():New("MVCZ23M",/*bPre*/,  /*bPos*/,  /*bCommit*/,/*bCancel*/)

//Crio as estruturas das tabelas PAI(SZ2) e FILHO(SZ3)
Local oStPaiZ2      := FwFormStruct(1,"SZ2")
Local oStFilhoZ3    := FwFormStruct(1,"SZ3")

//Após declarar a estrutura de dados, eu posso modificar o campo com SetProperty

oStFilhoZ3:SetProperty("Z3_CHAMADO",MODEL_FIELD_INIT,FwBuildFeature(STRUCT_FEATURE_INIPAD, "SZ2->Z2_COD"))


//Crio Modelos de dados Cabeçalho e Item
oModel:AddFields("SZ2MASTER",,oStPaiZ2)
oModel:AddGrid("SZ3DETAIL","SZ2MASTER",oStFilhoZ3,,,,,)//ESSAS vírgulas em branco, são blocos de validação que não vamos usar

//O meu grid, irá se relacionar com o cabeçalho, através dos campos FILIAL e CODIGO DE CHAMADO
oModel:SetRelation("SZ3DETAIL",{{"Z3_FILIAL","xFilial('SZ2')"},{"Z3_CHAMADO","Z2_COD"}},SZ3->(IndexKey(1)))

//Setamos a chave primária, prevalece o que está na SX2(X2_UNICO), se na X2 estiver preenchido
//Não podemos ter dentro de uma chamado, dois comentários com o mesmo código
oModel:SetPrimaryKey({"Z3_FILIAL","Z3_CHAMADO","Z3_CODIGO"})

//Combinação de campos que não podem se repetir, ficarem iguais
oModel:GetModel("SZ3DETAIL"):SetUniqueLine({"Z3_CHAMADO","Z3_CODIGO"})

oModel:SetDescription("Modelo 3 - Sistema de Chamados")
oModel:GetModel("SZ2MASTER"):SetDescription("CABEÇALHO DO CHAMADO")
oModel:GetModel("SZ3DETAIL"):SetDescription("COMENTÁRIOS DO CHAMADO")

/*
Como não vamos manipular aCols nem aHeader, não vou usar o SetOldGrid
*/

Return oModel


Static Function ViewDef()
Local oView     := Nil

//Invoco o Model da função que quero
Local oModel    := FwLoadModel("MVCZ2Z3")

/*
A grande diferença das estruturas de dados do modelo 2 para o modelo 3, é que no modelo 2
a estrutura de dados do cabeçalho é temporária/imaginária/fictícia, jáaaaaaaaa no modelo 3/x
todas as estruturas de dados, tendem à ser REAIS, ou seja, importamos via FwFormStruct, a(s) tabela(s)
propriamente ditas
*/
Local oStPaiZ2      := FwFormStruct(2,"SZ2")
Local oStFilhoZ3    := FwFormStruct(2,"SZ3")

//Removo o campo para não aparecer, já que ele estará sendo preenchido automaticamente pelo código do chamado do cabeçalho
oStFilhoZ3:RemoveField("Z3_CHAMADO")

//Travo o campo de Codigo para não ser editado, ou seja, o campo CODIGO DE COMENTARIO do chamado, será automático e não poderá ser modificado
oStFilhoZ3:SetProperty("Z3_CODIGO",    MVC_VIEW_CANCHANGE, .F.)



//Faço a instancia da função FwFormView para a variável oView
oView   := FwFormView():New()

//Carrego o model importado para a View
oView:SetModel(oModel)

//Crio as views de cabeçalho e item, com as estruturas de dados criadas acima
oView:AddField("VIEWSZ2",oStPaiZ2,"SZ2MASTER")
oView:AddGrid("VIEWSZ3",oStFilhoZ3,"SZ3DETAIL")

//Faço o campo de Item ficar incremental
oView:AddIncrementField("SZ3DETAIL","Z3_CODIGO") //Soma 1 ao campo de Item

//Criamos os BOX horizontais para CABEÇALHO E ITENS
oView:CreateHorizontalBox("CABEC",60)
oView:CreateHorizontalBox("GRID",40)

//Amarro as views criadas aos BOX criados
oView:SetOwnerView("VIEWSZ2","CABEC")
oView:SetOwnerView("VIEWSZ3","GRID")

//Darei títulos personalizados ao cabeçalho e comentários do chamado
oView:EnableTitleView("VIEWSZ2","Detalhes do Chamado/Cabeçalho")
oView:EnableTitleView("VIEWSZ3","Comentários do do chamado/Itens")

Return oView



User Function SZ2LEG()
Local aLegenda := {}

aAdd(aLegenda,{"BR_VERMELHO","Chamado Aberto"})
aAdd(aLegenda,{"BR_AMARELO" , 	"Chamado em Andamento"})
aAdd(aLegenda,{"BR_VERDE", 	"Chamado Finalizado"})

BrwLegenda("Status dos Chamados",,aLegenda)

return aLegenda


User Function SZ2SOBRE()
Local cSobre

cSobre := "-<b>Minha primeira tela em MVC Modelo 3<br>"+;
"Este Sistema de Chamados foi desenvolvido por um(a) Protheuzeiro(a) da Sistematizei."

MsgInfo(cSobre,"Sobre o Programador...")

return
