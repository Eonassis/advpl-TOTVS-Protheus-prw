#include 'Protheus.ch'
#include 'FWMVCDEF.ch' //Include principal do MVC



User Function MVCSZ9_M()
Local aArea := GetNextAlias() 
Local oBrowseSZ9 //Vari�vel Objeto que receber� o instanciamento da classe FwmBrose

oBrowseSZ9 := FwmBrowse():New()

//Passo como parametro a tabela que eu quero mostrar no Browse
oBrowseSZ9:SetAlias("SZ9") 

oBrowseSZ9:SetDescription("Meu primeiro Browse - Tela de Protheuzeiros SZ9")

//Faz com que somente estes campos apare�am no GRID;
oBrowseSZ9:SetOnlyFields({"Z9_CODIGO","Z9_NOME","Z9_SEXO","Z9_STATUS"})                
                    /*EXPRESSAO             / COR    / DESCRI��O*/
oBrowseSZ9:AddLegend("SZ9->Z9_STATUS == '1'","GREEN", "Protheuzeiro Ativo")
oBrowseSZ9:AddLegend("SZ9->Z9_STATUS == '2'","RED"  , "Protheuzeiro Inativo")

//oBrowseSZ9:SetFilterDefault("Z9_STATUS == '1'")

oBrowseSZ9:DisableDetails()

oBrowseSZ9:Activate()

RestArea(aArea)

Return 



Static Function MenuDef()
Local aRotina       := {}
Local aRotinaAut    := FwMvcMenu("MVCSZ9") //Recebe os menus automaticamente
Local aSubMnu := {}
Local  n

//Populo a vari�vel aRotina
ADD OPTION aRotina TITLE 'Legenda'      ACTION 'u_SZ9LEG'         OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE 'Sobre'        ACTION 'u_SZ9SOBRE'       OPERATION 6 ACCESS 0

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVCSZ9' OPERATION 2 ACCESS 0  //2 - Visualizar
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVCSZ9' OPERATION 3 ACCESS 0  //3 - Incluir
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVCSZ9' OPERATION 4 ACCESS 0  //4 - Alterar
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVCSZ9' OPERATION 5 ACCESS 0  //5 - Excluir
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVCSZ9' OPERATION 8 ACCESS 0  //8 - Imprimir
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVCSZ9' OPERATION 9 ACCESS 0  //7|9 - Copiar

    //Adiciona o arrya do submenu a op��o do menu
ADD OPTION aRotina TITLE 'SubMenu'    ACTION aSubMnu         OPERATION 9 ACCESS 0
    // adiciona op��es no submenu
ADD OPTION aSubMnu TITLE 'Sub Menu 01'    ACTION 'Alert("Sub menu 01")'  OPERATION 4 ACCESS 0
ADD OPTION aSubMnu TITLE 'Sub Menu 02'    ACTION 'Alert("Sub menu 02")'  OPERATION 4 ACCESS 0
//ADiciona dentro do array aRotina, o conte�do do array aRotinaAut
For n := 1 To Len(aRotinaAut)
    aAdd(aRotina,aRotinaAut[n])
Next n

Return aRotina




Static Function ModelDef()
Local oModel := Nil

//traz a estrutura da SZ9(tabela e caracter�stica dos campos), PARA O MODELO, por isso o parametro 1 no in�cio
Local oStructSZ9 := FwFormStruct(1,"SZ9") 

oModel := MPFormModel():New("MVCSZ9M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/)

//Atribuindo formulario para o modelo de dados.
oModel:AddFields("FORMSZ9",/*Owner*/,oStructSZ9)

//Definindo chave prim�ria para a aplica��o
oModel:SetPrimaryKey({"Z9_FILIAL","Z9_CODIGO"})

oModel:SetDescription("Modelo de Dados do Cadastro de Protheuzeiro(a)")

oModel:GetModel("FORMSZ9"):SetDescription("Formul�rio de Cadastro Protheuzeiro(a)")

oModel:GetModel( 'ZA1MASTER' ):SetDescription( 'Dados da Musica' )
oModel:GetModel( 'ZA2DETAIL' ):SetDescription( 'Dados do Autor Da Musica' )

Return oModel



Static Function ViewDef()
Local oView := Nil

//Funcao que retorna um objeto de model de determinado fonte.
Local oModel := FwLoadModel("MVCSZ9")

Local oStructSZ9 := FwFormStruct(2,"SZ9") //Traz a estrutura da SZ9 - (1 Model | 2 View)

//Construindo a parte de Vis�o dos Dados
oView := FwFormView():New()

//Passando o modelo de dados informado
oView:SetModel(oModel)

//Atribui��o da estrutura de dados � camada de VIS�O
oView:AddField("VIEWSZ9",oStructSZ9,"FORMSZ9")

//Criando um container com o identificador TELA
oView:CreateHorizontalBox("TELASZ9",100)

//Adicionando titulo ao formul�rio
oView:EnableTitleView("VIEWSZ9","Visualiza��o dos Protheuzeiros(as)")

//for�a o fechamento da janela, PASSANDO O PARAMETRO .T.
oView:SetCloseOnOk({|| .T.})

oView:SetOwnerView("VIEWSZ9","TELASZ9")

Return oView


User Function SZ9LEG()
Local aLegenda := {}

aAdd(aLegenda,{"BR_VERDE"   , "Ativo"})
aAdd(aLegenda,{"BR_VERMELHO", "Inativo"})

BrwLegenda("Protheuzeiros(as)","Ativos/Inativos",aLegenda)

Return aLegenda


User Function SZ9SOBRE()
Local cSobre 

cSobre := "-<b>Minha primeira tela em MVC Modelo 1<br> Este fonte foi desenvolvido por um(a) Protheuzeiro(a) da Sistematizei."

MsgInfo(cSobre)

Return 
