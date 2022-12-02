#include "Protheus.ch"
#include "FwMvcDef.ch"


User Function MVCVLD()
Local oBrowse := FwLoadBrw("MVCVLD") //Digo o fonte que eu estou buscando o BrowseDef

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

oBrowse:AddLegend("SZ2->Z2_STATUS == '1'","GREEN"   ,"Chamado Aberto")
oBrowse:AddLegend("SZ2->Z2_STATUS == '2'","RED"     ,"Chamado Finalizado")
oBrowse:AddLegend("SZ2->Z2_STATUS == '3'","YELLOW"  ,"Chamado em Andamento")

//Deve definir de onde virá o MenuDef devo chamar o meu menu
oBrowse:SetMenudef("MVCVLD") //Coloco o fonte de onde virá o meu menu

RestArea(aArea)

Return oBrowse 


Static Function MenuDef()
Local aMenu     := {}


//Trago através da FwMvcMenu, o menu para o array aMenuAut
Local aMenuAut      := FwMvcMenu("MVCVLD")   
Local n      := 1
/*Adiciono dentro da variável aMenu, o título Legenda e Sobre, junto com a ação
de chamar as UserFunctions de legenda e Sobre, essas operações são de código 6, e
eu passo o nível de usuário 0
*/
ADD OPTION aMenu TITLE 'Legenda'      ACTION 'u_zSZ2LEG'         OPERATION 6 ACCESS 0
ADD OPTION aMenu TITLE 'Sobre'        ACTION 'u_zSZ2SOBRE'       OPERATION 6 ACCESS 0

/*Utilizo um laço de repetição para adicionar à variável aMenu, 
o que eu criai automaticamente para a variável aMenuAut*/

For n:= 1 to Len(aMenuAut)
    aAdd(aMenu,aMenuAut[n])
Next n


Return aMenu



Static Function ModelDef()
//Declaro o meu modelo de dados sem passar blocos de validação pois usaremos a validação padrão do MVC
Local oModel := MPFormModel():New("MVCVLDM" /*IdDoModelo*/,;
                                                        /*|oModel| MPreVld(oModel)}*//*bPre*/,;
                                                        {|oModel| MPosVld(oModel)}/*bPos*/,;
                                                        {|oModel| MComVld(oModel)}/*bCommit*/,;
                                                        {|oModel| MCancVld(oModel)}/*bCancel*/)

//Crio as estruturas das tabelas PAI(SZ2) e FILHO(SZ3)
Local oStPaiZ2      := FwFormStruct(1,"SZ2")
Local oStFilhoZ3    := FwFormStruct(1,"SZ3")

//Após declarar a estrutura de dados, eu posso modificar o campo com SetProperty

oStFilhoZ3:SetProperty("Z3_CHAMADO",MODEL_FIELD_INIT,FwBuildFeature(STRUCT_FEATURE_INIPAD, "SZ2->Z2_COD"))

//Crio a minha trigger para trazer o nome do usuário automaticamente 

aTrigUser  := FwStruTrigger(;
"Z2_USUARIO",; //Campo que irá disparar o gatilho/trigger
"Z2_USERNAM",; //Campo que irá receber o conteúdo disparado
"USRRETNAME(M->Z2_USUARIO)",; //Conteúdo que irá para o campo Z7_TOTAL
.F.)

oStPaiZ2:AddTrigger(;
aTrigUser[1],;
aTrigUser[2],;
aTrigUser[3],;
aTrigUser[4])


//Crio Modelos de dados Cabeçalho e Item
oModel:AddFields("SZ2MASTER",,oStPaiZ2)
oModel:AddGrid("SZ3DETAIL","SZ2MASTER",oStFilhoZ3,,,,,)//ESSAS vírgulas em branco, são blocos de validação que não vamos usar


//Chamo o método SetVldActivate e passo como parametro o bloco de código com a minha Static Function 
oModel:SetVldActivate({|oModel| MActivVld(oModel)})

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
Local oModel    := FwLoadModel("MVCVLD")

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

//Passo a consulta padrão para o campo de usuario, onde retornará o código de usuário
oStPaiZ2:SetProperty("Z2_USUARIO",    MVC_VIEW_LOOKUP ,   "USR")

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
Esta função fará a validação de ABERTURA se o usuário estará apto à entrar dentro da rotina ou não.
Se ele não estiver dentro do parametro MV_XUSMVC, ele não poderá por exemplo... Incluir ou Alterar
    
    /*/
Static Function MActivVld(oModel)
Local lRet          := .T.

Local cUsersMVC     := SUPERGETMV("MV_XUSMVC") //Pego o conteúdo do parametro e passo para a cUsersMVC
Local cCodUser      := RetCodUsr()

//Se o conteúdo da variavel cCodUser NÃO estiver dentro de cUsersMVC ele BLOQUEIA
If !(cCodUser$cUsersMVC) 
//Já que o código de usuário corrente capturado não pertence ao parametro, a variável de controle será FALSE
    lRet    := .F. 

    //Se  você não colocar um HELP customizado, o MVC colocará um HELP padrao
    Help(NIL, NIL, "MActivVld", NIL, "Usuário não autorizado",;
    1,0, NIL, NIL, NIL, NIL, NIL,{"Este usuário não está autorizado à realizar esta operação, vide parametro MV_XUSMVC"})
ELSE
    IF cCodUser == "000000" //Se o código de usuário for igual ao código de usuário do Administrador ele liberará os campos
        //Vamos liberar os campos de Z2_DATA e Z2_USUARIO passando o parametro .T.       
        
        //MODELO ->      SUBMODELO -> ESTRUTURA -> PROPRIEDADE ->         BLOCO DE CÓDIGO ->                        X3_WHEN := .T.
        oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty("Z2_DATA",    MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,".T."))
        oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty("Z2_USUARIO", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,".T."))
    ELSE
        //MODELO ->      SUBMODELO -> ESTRUTURA -> PROPRIEDADE ->         BLOCO DE CÓDIGO ->                        X3_WHEN := .F.
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
    1,0, NIL, NIL, NIL, NIL, NIL,{"Data maior que a database do sistema, coloque uma data igual ou anterior à data do sistema"})
    lRet    := .F.
ENDIF
*/

Return lRet



/*/
No bloco de PÓS VALIDAÇÃO eu valido meu modelo, antes de ir para o COMMIT
   
    /*/
Static Function MPosVld(oModel)
Local lRet          := .T.
                    //MODELO  -->      SUBMODELO   -> CAMPO
Local cTitChamado   := oModel:GetValue("SZ2MASTER","Z2_TITCHAM") 
Local nLen          := Len(AllTrim(cTitChamado)) //Retiro os espaços em branco e conto quantos caracteres tem


IF nLen < 15
    lRet    := .F.
    Help(NIL, NIL, "MPosVld", NIL, "POSVALIDATION",;
    1,0, NIL, NIL, NIL, NIL, NIL,{"O título do Chamado deve ter no mínimo 15 caracteres - Campo Título de Chamado"})    
ENDIF

Return lRet


Static Function MComVld(oModel)
/*O parametro está ligado à informação de que O COMMIT FOI OU NÃO FOI FEITO, mas mesmo se 
eu não colocar o parametro, a gravação será feita, contudo aparecerá um HELP em branco*/

Local lRet    := .T.
Alert("Voce esta passando pela validacao COMIT")

FwFormCommit(oModel) //Faço o commit do modelo de dados que foi validado no PostValidation

Return lRet


Static Function MCancVld(oModel)
//Por padrão ele deve cancelar a tela de inserção/alteração, etc
Local lRet      :=  .T.   

Alert("Voce esta passando pela validacao CANCEL")

//Se ele clicar em NÃO
IF !(MSGYESNO("Deseja realmente fechar esta tela - Não será possível recuperar depois?"))
		Help(NIL, NIL, "MCancVld", NIL, "CANCEL",;
		1,0, NIL, NIL, NIL, NIL, NIL,{"Saída/Cancelamento abortado pelo usuário"})
    lRet    := .F.        
ENDIF

Return lRet
