#include "Protheus.ch"
#include "FwMvcDef.ch"


User Function MVCVLD()
Local oBrowse := FwLoadBrw("MVCVLD") //Digo o fonte que eu estou buscando o BrowseDef

//Ativo o Browse
oBrowse:Activate()

Return 

/*/
Fun��o respons�vel por criar o Brose e retorn�-lo para o Menu que invoc�-lo
Quando eu tenho uma Static Function BrowseDef no meu fonte, significa
que eu posso emprest�-la para outros fontes, atrav�s do FwLoadBr

    /*/
Static Function BrowseDef()
Local aArea := GetArea()

Local oBrowse := FwMBrowse():New() 

oBrowse:SetAlias("SZ2")
oBrowse:SetDescription("Cadastro de Chamados")

oBrowse:AddLegend("SZ2->Z2_STATUS == '1'","GREEN"   ,"Chamado Aberto")
oBrowse:AddLegend("SZ2->Z2_STATUS == '2'","RED"     ,"Chamado Finalizado")
oBrowse:AddLegend("SZ2->Z2_STATUS == '3'","YELLOW"  ,"Chamado em Andamento")

//Deve definir de onde vir� o MenuDef devo chamar o meu menu
oBrowse:SetMenudef("MVCVLD") //Coloco o fonte de onde vir� o meu menu

RestArea(aArea)

Return oBrowse 


Static Function MenuDef()
Local aMenu     := {}


//Trago atrav�s da FwMvcMenu, o menu para o array aMenuAut
Local aMenuAut      := FwMvcMenu("MVCVLD")   
Local n      := 1
/*Adiciono dentro da vari�vel aMenu, o t�tulo Legenda e Sobre, junto com a a��o
de chamar as UserFunctions de legenda e Sobre, essas opera��es s�o de c�digo 6, e
eu passo o n�vel de usu�rio 0
*/
ADD OPTION aMenu TITLE 'Legenda'      ACTION 'u_zSZ2LEG'         OPERATION 6 ACCESS 0
ADD OPTION aMenu TITLE 'Sobre'        ACTION 'u_zSZ2SOBRE'       OPERATION 6 ACCESS 0

/*Utilizo um la�o de repeti��o para adicionar � vari�vel aMenu, 
o que eu criai automaticamente para a vari�vel aMenuAut*/

For n:= 1 to Len(aMenuAut)
    aAdd(aMenu,aMenuAut[n])
Next n


Return aMenu



Static Function ModelDef()
//Declaro o meu modelo de dados sem passar blocos de valida��o pois usaremos a valida��o padr�o do MVC
Local oModel := MPFormModel():New("MVCVLDM" /*IdDoModelo*/,;
                                                        /*|oModel| MPreVld(oModel)}*//*bPre*/,;
                                                        {|oModel| MPosVld(oModel)}/*bPos*/,;
                                                        {|oModel| MComVld(oModel)}/*bCommit*/,;
                                                        {|oModel| MCancVld(oModel)}/*bCancel*/)

//Crio as estruturas das tabelas PAI(SZ2) e FILHO(SZ3)
Local oStPaiZ2      := FwFormStruct(1,"SZ2")
Local oStFilhoZ3    := FwFormStruct(1,"SZ3")

//Ap�s declarar a estrutura de dados, eu posso modificar o campo com SetProperty

oStFilhoZ3:SetProperty("Z3_CHAMADO",MODEL_FIELD_INIT,FwBuildFeature(STRUCT_FEATURE_INIPAD, "SZ2->Z2_COD"))

//Crio a minha trigger para trazer o nome do usu�rio automaticamente 

aTrigUser  := FwStruTrigger(;
"Z2_USUARIO",; //Campo que ir� disparar o gatilho/trigger
"Z2_USERNAM",; //Campo que ir� receber o conte�do disparado
"USRRETNAME(M->Z2_USUARIO)",; //Conte�do que ir� para o campo Z7_TOTAL
.F.)

oStPaiZ2:AddTrigger(;
aTrigUser[1],;
aTrigUser[2],;
aTrigUser[3],;
aTrigUser[4])


//Crio Modelos de dados Cabe�alho e Item
oModel:AddFields("SZ2MASTER",,oStPaiZ2)
oModel:AddGrid("SZ3DETAIL","SZ2MASTER",oStFilhoZ3,,,,,)//ESSAS v�rgulas em branco, s�o blocos de valida��o que n�o vamos usar


//Chamo o m�todo SetVldActivate e passo como parametro o bloco de c�digo com a minha Static Function 
oModel:SetVldActivate({|oModel| MActivVld(oModel)})

//O meu grid, ir� se relacionar com o cabe�alho, atrav�s dos campos FILIAL e CODIGO DE CHAMADO
oModel:SetRelation("SZ3DETAIL",{{"Z3_FILIAL","xFilial('SZ2')"},{"Z3_CHAMADO","Z2_COD"}},SZ3->(IndexKey(1)))

//Setamos a chave prim�ria, prevalece o que est� na SX2(X2_UNICO), se na X2 estiver preenchido
//N�o podemos ter dentro de uma chamado, dois coment�rios com o mesmo c�digo
oModel:SetPrimaryKey({"Z3_FILIAL","Z3_CHAMADO","Z3_CODIGO"})

//Combina��o de campos que n�o podem se repetir, ficarem iguais
oModel:GetModel("SZ3DETAIL"):SetUniqueLine({"Z3_CHAMADO","Z3_CODIGO"})

oModel:SetDescription("Modelo 3 - Sistema de Chamados")
oModel:GetModel("SZ2MASTER"):SetDescription("CABE�ALHO DO CHAMADO")
oModel:GetModel("SZ3DETAIL"):SetDescription("COMENT�RIOS DO CHAMADO")

/*
Como n�o vamos manipular aCols nem aHeader, n�o vou usar o SetOldGrid
*/

Return oModel



Static Function ViewDef()
Local oView     := Nil

//Invoco o Model da fun��o que quero
Local oModel    := FwLoadModel("MVCVLD")

/*
A grande diferen�a das estruturas de dados do modelo 2 para o modelo 3, � que no modelo 2
a estrutura de dados do cabe�alho � tempor�ria/imagin�ria/fict�cia, j�aaaaaaaa no modelo 3/x
todas as estruturas de dados, tendem � ser REAIS, ou seja, importamos via FwFormStruct, a(s) tabela(s)
propriamente ditas
*/
Local oStPaiZ2      := FwFormStruct(2,"SZ2")
Local oStFilhoZ3    := FwFormStruct(2,"SZ3")

//Removo o campo para n�o aparecer, j� que ele estar� sendo preenchido automaticamente pelo c�digo do chamado do cabe�alho
oStFilhoZ3:RemoveField("Z3_CHAMADO")

//Travo o campo de Codigo para n�o ser editado, ou seja, o campo CODIGO DE COMENTARIO do chamado, ser� autom�tico e n�o poder� ser modificado
oStFilhoZ3:SetProperty("Z3_CODIGO",    MVC_VIEW_CANCHANGE, .F.)

//Passo a consulta padr�o para o campo de usuario, onde retornar� o c�digo de usu�rio
oStPaiZ2:SetProperty("Z2_USUARIO",    MVC_VIEW_LOOKUP ,   "USR")

//Fa�o a instancia da fun��o FwFormView para a vari�vel oView
oView   := FwFormView():New()

//Carrego o model importado para a View
oView:SetModel(oModel)

//Crio as views de cabe�alho e item, com as estruturas de dados criadas acima
oView:AddField("VIEWSZ2",oStPaiZ2,"SZ2MASTER")
oView:AddGrid("VIEWSZ3",oStFilhoZ3,"SZ3DETAIL")

//Fa�o o campo de Item ficar incremental
oView:AddIncrementField("SZ3DETAIL","Z3_CODIGO") //Soma 1 ao campo de Item

//Criamos os BOX horizontais para CABE�ALHO E ITENS
oView:CreateHorizontalBox("CABEC",60)
oView:CreateHorizontalBox("GRID",40)

//Amarro as views criadas aos BOX criados
oView:SetOwnerView("VIEWSZ2","CABEC")
oView:SetOwnerView("VIEWSZ3","GRID")

//Darei t�tulos personalizados ao cabe�alho e coment�rios do chamado
oView:EnableTitleView("VIEWSZ2","Detalhes do Chamado/Cabe�alho")
oView:EnableTitleView("VIEWSZ3","Coment�rios do do chamado/Itens")

Return oView

User Function zSZ2LEG()
Local aLegenda := {}

aAdd(aLegenda,{"BR_VERDE","Chamado Aberto"})
aAdd(aLegenda,{"BR_AMARELO" , 	"Chamado em Andamento"})
aAdd(aLegenda,{"BR_VERMELHO", 	"Chamado Finalizado"})

BrwLegenda("Status dos Chamados",,aLegenda)

return aLegenda


User Function zSZ2SOBRE()
Local cSobre

cSobre := "-<b>Minha primeira tela em MVC Modelo 3<br>"+;
"Este Sistema de Chamados foi desenvolvido por um(a) Protheuzeiro(a) da Sistematizei."

MsgInfo(cSobre,"Sobre o Programador...")

return


/*/
Esta fun��o far� a valida��o de ABERTURA se o usu�rio estar� apto � entrar dentro da rotina ou n�o.
Se ele n�o estiver dentro do parametro MV_XUSMVC, ele n�o poder� por exemplo... Incluir ou Alterar
    
    /*/
Static Function MActivVld(oModel)
Local lRet          := .T.

Local cUsersMVC     := SUPERGETMV("MV_XUSMVC") //Pego o conte�do do parametro e passo para a cUsersMVC
Local cCodUser      := RetCodUsr()

//Se o conte�do da variavel cCodUser N�O estiver dentro de cUsersMVC ele BLOQUEIA
If !(cCodUser$cUsersMVC) 
//J� que o c�digo de usu�rio corrente capturado n�o pertence ao parametro, a vari�vel de controle ser� FALSE
    lRet    := .F. 

    //Se  voc� n�o colocar um HELP customizado, o MVC colocar� um HELP padrao
    Help(NIL, NIL, "MActivVld", NIL, "Usu�rio n�o autorizado",;
    1,0, NIL, NIL, NIL, NIL, NIL,{"Este usu�rio n�o est� autorizado � realizar esta opera��o, vide parametro MV_XUSMVC"})
ELSE
    IF cCodUser == "000000" //Se o c�digo de usu�rio for igual ao c�digo de usu�rio do Administrador ele liberar� os campos
        //Vamos liberar os campos de Z2_DATA e Z2_USUARIO passando o parametro .T.       
        
        //MODELO ->      SUBMODELO -> ESTRUTURA -> PROPRIEDADE ->         BLOCO DE C�DIGO ->                        X3_WHEN := .T.
        oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty("Z2_DATA",    MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,".T."))
        oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty("Z2_USUARIO", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,".T."))
    ELSE
        //MODELO ->      SUBMODELO -> ESTRUTURA -> PROPRIEDADE ->         BLOCO DE C�DIGO ->                        X3_WHEN := .F.
        oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty("Z2_DATA",    MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,".F."))
        oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty("Z2_USUARIO", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,".F."))
    ENDIF
Endif

//Ele retorna True, validado, e false bloqueado
Return lRet




Static Function MPreVld(oModel)
Local lRet      :=      .T.


Alert("Voce esta passando pela Pre Validacao")

/*
IF oModel:GetValue("SZ2MASTER","Z2_DATA") > dDatabase
    Help(NIL, NIL, "MPreVld", NIL, "PREVALIDACAO",;
    1,0, NIL, NIL, NIL, NIL, NIL,{"Data maior que a database do sistema, coloque uma data igual ou anterior � data do sistema"})
    lRet    := .F.
ENDIF
*/

Return lRet



/*/
No bloco de P�S VALIDA��O eu valido meu modelo, antes de ir para o COMMIT
   
    /*/
Static Function MPosVld(oModel)
Local lRet          := .T.
                    //MODELO  -->      SUBMODELO   -> CAMPO
Local cTitChamado   := oModel:GetValue("SZ2MASTER","Z2_TITCHAM") 
Local nLen          := Len(AllTrim(cTitChamado)) //Retiro os espa�os em branco e conto quantos caracteres tem


IF nLen < 15
    lRet    := .F.
    Help(NIL, NIL, "MPosVld", NIL, "POSVALIDATION",;
    1,0, NIL, NIL, NIL, NIL, NIL,{"O t�tulo do Chamado deve ter no m�nimo 15 caracteres - Campo T�tulo de Chamado"})    
ENDIF

Return lRet


Static Function MComVld(oModel)
/*O parametro est� ligado � informa��o de que O COMMIT FOI OU N�O FOI FEITO, mas mesmo se 
eu n�o colocar o parametro, a grava��o ser� feita, contudo aparecer� um HELP em branco*/

Local lRet    := .T.
Alert("Voce esta passando pela validacao COMIT")

FwFormCommit(oModel) //Fa�o o commit do modelo de dados que foi validado no PostValidation

Return lRet


Static Function MCancVld(oModel)
//Por padr�o ele deve cancelar a tela de inser��o/altera��o, etc
Local lRet      :=  .T.   

Alert("Voce esta passando pela validacao CANCEL")

//Se ele clicar em N�O
IF !(MSGYESNO("Deseja realmente fechar esta tela - N�o ser� poss�vel recuperar depois?"))
		Help(NIL, NIL, "MCancVld", NIL, "CANCEL",;
		1,0, NIL, NIL, NIL, NIL, NIL,{"Sa�da/Cancelamento abortado pelo usu�rio"})
    lRet    := .F.        
ENDIF

Return lRet
