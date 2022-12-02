#INCLUDE "PROTHEUS.CH"
#INCLUDE "RTMSR30.CH"

#DEFINE DIRCARREG  "DIRCARREG\"
    
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ RTMSR30  ณ Autor ณ Ramon Neves            ณ Data ณ17.06.2015ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Relat๓rio de Carregamento Grafico                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function RTMSR30()
Local oReport
Local aArea := GetArea()
Local aFilesBMP	:= {}
Local aFilesPNG	:= {}
Local nCont		:= 1
Local _cDiretorio	:= Alltrim(GetSrvProfString("RootPath","\"))+"\"+DIRCARREG

If FindFunction("TRepInUse") .And. TRepInUse()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInterface de impressao                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oReport := ReportDef()
	oReport:PrintDialog()

	aFilesBMP := Directory("\" +DIRCARREG+"*.bmp")
	aFilesPNG := Directory("\" +DIRCARREG+"*.png")
		
	//Apaga arquivos .bmp do diretorio
	If Len(aFilesBMP) > 0
		For nCont := 1 to Len(aFilesBMP)
			FErase(_cDiretorio+aFilesBMP[nCont][1])
		Next		
	Endif
	
	//Apaga arquivos .png do diretorio
	If Len(aFilesPNG) > 0
		For nCont := 1 to Len(aFilesPNG)
			FErase(_cDiretorio+aFilesPNG[nCont][1])
		Next		
	Endif		
	
Endif

RestArea(aArea)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณReportDef บAutor  ณRamon Prado    บ Data ณ  18/06/15		    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao que monta o layout de impressใo                     บฑฑ
ฑฑบ          ณ conforme os parametros informados                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
Local oReport
Local oCarreg
Local oCarreg2
Local oCarreg3
Local oCarreg4
Local oTotCarreg
Local oTotaliz
Local oTotQtdNf
Local oTotGeral
Local oTotValMer
Local oTotPeso
Local oValMer
Local oTotQtdVol
Local oTotObserv
Local cAliasDDK := GetNextAlias()
Local cAliasQry := GetNextAlias()
Local cAliasQry2 := GetNextAlias()
Local cAliasQry3 := GetNextAlias()
Local cAliasQry4 := GetNextAlias()
Local cAliasQry5 := GetNextAlias()
Local cAliasQry6 := GetNextAlias()
Local cAliasQry7 := GetNextAlias()
Local cAliasQry8 := GetNextAlias()

oReport := TReport():New("RTMSR30",STR0001,"RTMSR30", {|oReport| RTMSR30Imp(oReport,cAliasDDK,cAliasQry,cAliasQry2,cAliasQry3,cAliasQry4,cAliasQry5,cAliasQry6,cAliasQry7,cAliasQry8)},STR0002)

Pergunte("RTMSR30",.F.)
If (FunName() $ 'TMSA215')
	MV_PAR01 := DDK->DDK_FILCAR
	MV_PAR02 := DDK->DDK_FILCAR
	MV_PAR03 := DDK->DDK_CARREG
	MV_PAR04 := DDK->DDK_CARREG
	MV_PAR05 := DDK->DDK_VERSAO
	MV_PAR06 := DDK->DDK_VERSAO
	MV_PAR07 := Space(Len(DDK->DDK_CODVEI))
	MV_PAR08 := Replicate('Z',Len(DDK->DDK_CODVEI))
	MV_PAR09 := DDK->DDK_FILORI
	MV_PAR10 := DDK->DDK_FILORI
	MV_PAR11 := DDK->DDK_VIAGEM
	MV_PAR12 := DDK->DDK_VIAGEM
EndIf

//----------------------------------------------
// SEวรO CARREGAMENTO GRAFICO 
//----------------------------------------------
oCarreg := TRSection():New(oReport,STR0003,{"DDK","DDL"},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) 
oCarreg:SetPageBreak(.T.)		//Define se salta a pแgina na quebra de se็ใo
oCarreg:SetAutoSize(.T.)			//Ajusta alinhamento da c้lula por toda a extensao da linha
oReport:SetLandscape()			//-- paisagem

TRCell():New(oCarreg,"DDK_FILCAR"		,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| (cAliasDDK)->DDK_FILCARE+SPACE(13) }*/) //"Fil.Carregamento."
TRCell():New(oCarreg,"DDK_DATCAR"		,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| (cAliasDDK)->DDK_DATCAR+SPACE(13) }*/) //"Data Carregamento"
TRCell():New(oCarreg,"DDK_DATDSC"		,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| (cAliasDDK)->DDK_DATDSC+SPACE(13) }*/) //"Data Descarregamento"

oCarreg2 := TRSection():New(oReport,STR0003,{"DDK","DDL"},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oCarreg2:SetTotalInLine(.T.)
oCarreg2:SetAutoSize(.T.)			//Ajusta alinhamento da c้lula por toda a extensao da linha
TRCell():New(oCarreg2,"DDK_CARREG"		,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDDK)->DDK_CARREG }) //"Carregamento"
TRCell():New(oCarreg2,"DDK_HORCAR"		,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Hora Carregamento"
TRCell():New(oCarreg2,"DDK_HORDSC"		,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Hora de Descarregamento"

oCarreg3 := TRSection():New(oReport,STR0003,{"DDK","DDL","DAU"},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oCarreg3:SetTotalInLine(.T.)
oCarreg3:SetAutoSize(.T.)				//Ajusta alinhamento da c้lula por toda a extensao da linha
TRCell():New(oCarreg3,"DDK_VERSAO"	,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Versao"
TRCell():New(oCarreg3,"DDK_NOMRCA"	,"DDK",STR0008,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDDK)->NOMERESCAR }) //"Nome Responsavel Carregamento"
TRCell():New(oCarreg3,"DAU_NOMRDS"	,"DAU",STR0009,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasDDK)->NOMEDESCAR }) //"Nome Responsavel Descarregamento"

oCarreg4 := TRSection():New(oReport,STR0003,{"DDK","DDL"},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oCarreg4:SetTotalInLine(.T.)
oCarreg4:SetAutoSize(.T.)			//Ajusta alinhamento da c้lula por toda a extensao da linha
TRCell():New(oCarreg4,"DDK_VIAGEM"		,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Viagem"
TRCell():New(oCarreg4,"DDK_CODVEI"		,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Veiculo de Carregamento"
TRCell():New(oCarreg4,"DDK_FILORI"		,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Filial de Origem"
TRCell():New(oCarreg4,"DDK_FILDES"		,"DDK",,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Filial de Destino"

//-- Secao - Rodape
oTotCarreg := TRSection():New(oReport,STR0004,{},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Informacoes da Viagem"
TRCell():New(oTotCarreg,"QTDCTRC"		,"",STR0010,"99999",03,/*lPixel*/,{|| (cAliasQry)->nQtdDoc }) //"CTRCs"

//-- Secao - Rodape
oTotQtdNf := TRSection():New(oTotCarreg,STR0004,{},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Informacoes da Viagem"
TRCell():New(oTotCarreg,"QTDNF"			,"",STR0011 ,"99999",03,/*lPixel*/,{|| (cAliasQry2)->nQtdNF }) //"Qtd. Notas Fiscais"

oValMer:=TRSection():New(oTotCarreg,STR0004,{"DDK","DDL"},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oTotCarreg,"VALMER"			,"",STR0012 ,"@E 99,999,999,999.99",03,/*lPixel*/,{|| (cAliasQry3)->ValMer }) //"Val.Mercadoria"

//-- Secao - Rodape
oTotPeso := TRSection():New(oTotCarreg,STR0004,{},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Informacoes da Viagem"
TRCell():New(oTotCarreg,"PESO"			,"",STR0013 ,"@E 999,999.9999",03,/*lPixel*/,{|| (cAliasQry4)->nPeso }) //"Val.Mercadoria"

//-- Secao - Rodape
oTotPesoM3 := TRSection():New(oTotCarreg,STR0004,{},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Informacoes da Viagem"
TRCell():New(oTotCarreg,"PESOM3"			,"",STR0014 ,"@E 999,999.9999",03,/*lPixel*/,{|| (cAliasQry5)->nPesoM3 }) //"Peso Cubado"

//-- Secao - Rodape
oTotValFre := TRSection():New(oTotCarreg,STR0004,{},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Informacoes da Viagem"
TRCell():New(oTotCarreg,"VALFRE"			,"",STR0015 ,"@E 999,999,999.99",03,/*lPixel*/,{|| (cAliasQry6)->ValFre }) //"Val.Frete"

//-- Secao - Rodape
oTotQtdVol := TRSection():New(oTotCarreg,STR0004,{},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Informacoes da Viagem"
TRCell():New(oTotCarreg,"QTDVOL"			,"",STR0016 ,"99999",03,/*lPixel*/,{|| (cAliasQry7)->QtdVol }) //"Volumes"

//-- Secao - Rodape - Observacoes
oTotObserv := TRSection():New(oReport,STR0004,{"DDK","DC1"},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Informacoes da Viagem"
TRCell():New(oTotObserv,"DDK_UNITIZ"			,"DDK"	,,"@!",/*Tamanho*/,/*lPixel*/,{|| (cAliasQry8)->DDK_UNITIZ }) //"Unitizador"
TRCell():New(oTotObserv,"DC1_DESUNI"			,"DC1"	,,"@!",/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao}*/)//"Descricao Unitizador"
TRCell():New(oTotObserv,"DDK_OBSERV"			,"DDK"	,,"@!",/*Tamanho*/,/*lPixel*/,{|| (cAliasQry8)->DDK_OBSERV }) //"Observacao"

TRPosition():New( oReport:Section(6),"DC1", 1, {|| xFilial( "DC1" ) + (cAliasQry8)->DDK_UNITIZ })

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRTMSR30Imp บAutor  ณRamon Prado    บ Data ณ  18/06/15		 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao que monta o layout de impressใo                     บฑฑ
ฑฑบ          ณ conforme os parametros informados                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RTMSR30Imp(oReport,cAliasDDK,cAliasQry,cAliasQry2,cAliasQry3,cAliasQry4,cAliasQry5,cAliasQry6,cAliasQry7,cAliasQry8)

Local oCarreg		:= oReport:Section(1)  
Local oCarreg2   	:= oReport:Section(2) 				
Local oCarreg3	:= oReport:Section(3)
Local oCarreg4	:= oReport:Section(4)
Local oTotCarreg	:= oReport:Section(5)
Local oTotQtdNf	:= oReport:Section(5):Section(1)
Local oTotValMer	:= oReport:Section(5):Section(2)
Local oTotPeso	:= oReport:Section(5):Section(3)
Local oTotPesoM3	:= oReport:Section(5):Section(4) 
Local oTotValFre	:= oReport:Section(5):Section(5)
Local oTotQtdVol	:= oReport:Section(5):Section(6)
Local oTotObserv	:= oReport:Section(6)
Local nLargura	:= oReport:PageWidth() - 60
Local nAltura		:= 900
Local _cDiretorio	:= GetTempPath() + DIRCARREG
Local nCont		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTransforma parametros Range em expressao SQL                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
MakeSqlExpr(oReport:uParam)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery do relatorio da secao Carregamento Grafico Por Unitizador         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oCarreg:BeginQuery()

BeginSql Alias cAliasDDK	
	
	SELECT DDK_FILIAL, DDK_FILORI,DDK_FILCAR,DDK_CARREG,			
		DDK_UNITIZ,DDK_VERSAO,DDK_VIAGEM,DDK_DATCAR,DDK_HORCAR,DDK_DTFCAR,DDK_CODVEI,
		DDK_HRFCAR,DDK_DATDSC,DDK_HORDSC,DDK_OBSERV,DDK_RESCAR,DDK_RESDSC,DAU1.DAU_NOME NOMERESCAR,DAU2.DAU_NOME NOMEDESCAR
	FROM %table:DDK% DDK 
	
	LEFT JOIN %table:DAU% DAU1 ON		
		DAU1.DAU_FILIAL		= DDK_FILIAL
		AND DAU1.DAU_COD		= DDK_RESCAR		
		AND DAU1.%NotDel%
		
	LEFT JOIN %table:DAU% DAU2 ON		
		DAU2.DAU_FILIAL		= DDK_FILIAL
		AND DAU2.DAU_COD		= DDK_RESDSC		
		AND DAU2.%NotDel%	 
		
	WHERE DDK_FILIAL = %xFilial:DDK%						
		AND DDK_FILCAR BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND DDK_CARREG BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND DDK_VERSAO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND DDK_CODVEI BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND DDK_FILORI BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
		AND DDK_VIAGEM BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND DDK.%NotDel%
			
	ORDER BY DDK_FILCAR,DDK_CARREG,DDK_VERSAO
EndSql

oCarreg:EndQuery()

oCarreg2:BeginQuery()

	BeginSql Alias cAliasDDK	
	
	SELECT DDK_FILIAL, DDK_FILORI,DDK_FILCAR,DDK_CODRB1,DDK_CODRB2,DDK_VEICAR,DDK_CARREG, 
			DDK_FILDES,DDK_UNITIZ,DDK_VERSAO,DDK_VIAGEM,DDK_DATCAR,DDK_HORCAR,DDK_DTFCAR,DDK_CODVEI,
			DDK_HRFCAR,DDK_DATDSC,DDK_HORDSC,DDK_OBSERV,DDK_RESCAR,DDK_RESDSC,DAU1.DAU_NOME NOMERESCAR,DAU2.DAU_NOME NOMEDESCAR
	FROM %table:DDK% DDK
	
	LEFT JOIN %table:DAU% DAU1 ON		
		DAU1.DAU_FILIAL		= DDK_FILIAL
		AND DAU1.DAU_COD		= DDK_RESCAR		
		AND DAU1.%NotDel%
		
	LEFT JOIN %table:DAU% DAU2 ON		
		DAU2.DAU_FILIAL		= DDK_FILIAL
		AND DAU2.DAU_COD		= DDK_RESDSC		
		AND DAU2.%NotDel%	 
	
	WHERE DDK_FILIAL = %xFilial:DDK%						
			AND DDK_FILCAR BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND DDK_CARREG BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND DDK_VERSAO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND DDK_CODVEI BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND DDK_FILORI BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
		AND DDK_VIAGEM BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
			AND DDK.%NotDel%
			
ORDER BY DDK_FILCAR,DDK_CARREG, DDK_VERSAO	
	EndSql

oCarreg2:EndQuery(/*Array com os parametros do tipo Range*/)

oCarreg3:BeginQuery()

	BeginSql Alias cAliasDDK	
	
	SELECT DDK_FILIAL, DDK_FILORI,DDK_FILCAR,DDK_CODRB1,DDK_CODRB2,DDK_VEICAR,DDK_CARREG, 
			DDK_FILDES,DDK_UNITIZ,DDK_VERSAO,DDK_VIAGEM,DDK_DATCAR,DDK_HORCAR,DDK_DTFCAR,DDK_CODVEI,
			DDK_HRFCAR,DDK_DATDSC,DDK_HORDSC,DDK_OBSERV,DDK_RESCAR,DDK_RESDSC,DAU1.DAU_NOME NOMERESCAR,DAU2.DAU_NOME NOMEDESCAR
	FROM %table:DDK% DDK
	
	LEFT JOIN %table:DAU% DAU1 ON		
		DAU1.DAU_FILIAL		= DDK_FILIAL
		AND DAU1.DAU_COD		= DDK_RESCAR		
		AND DAU1.%NotDel%
		
	LEFT JOIN %table:DAU% DAU2 ON		
		DAU2.DAU_FILIAL		= DDK_FILIAL
		AND DAU2.DAU_COD		= DDK_RESDSC		
		AND DAU2.%NotDel%		 			 
	
	WHERE DDK_FILIAL = %xFilial:DDK%						
		AND DDK_FILCAR BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND DDK_CARREG BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND DDK_VERSAO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND DDK_CODVEI BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND DDK_FILORI BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
		AND DDK_VIAGEM BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND DDK.%NotDel%
			
		ORDER BY DDK_FILCAR,DDK_CARREG, DDK_VERSAO	
	EndSql

oCarreg3:EndQuery(/*Array com os parametros do tipo Range*/)

TRPosition():New( oReport:Section(3),"DAU", 1, {|| xFilial( "DAU" ) + (cAliasDDK)->DDK_RESDSC })

oCarreg4:BeginQuery()

	BeginSql Alias cAliasDDK	
	
	SELECT DDK_FILIAL, DDK_FILORI,DDK_FILCAR,DDK_CODRB1,DDK_CODRB2,DDK_VEICAR,DDK_CARREG, 
			DDK_FILDES,DDK_UNITIZ,DDK_VERSAO,DDK_VIAGEM,DDK_DATCAR,DDK_HORCAR,DDK_DTFCAR,DDK_CODVEI,
			DDK_HRFCAR,DDK_DATDSC,DDK_HORDSC,DDK_OBSERV,DDK_RESCAR,DDK_RESDSC,DAU1.DAU_NOME NOMERESCAR,DAU2.DAU_NOME NOMEDESCAR
	FROM %table:DDK% DDK
	
	LEFT JOIN %table:DAU% DAU1 ON		
		DAU1.DAU_FILIAL		= DDK_FILIAL
		AND DAU1.DAU_COD		= DDK_RESCAR		
		AND DAU1.%NotDel%
		
	LEFT JOIN %table:DAU% DAU2 ON		
		DAU2.DAU_FILIAL		= DDK_FILIAL
		AND DAU2.DAU_COD		= DDK_RESDSC		
		AND DAU.%NotDel%	

	WHERE DDK_FILIAL = %xFilial:DDK%						
		AND DDK_FILCAR BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND DDK_CARREG BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND DDK_VERSAO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND DDK_CODVEI BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND DDK_FILORI BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
		AND DDK_VIAGEM BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
		AND DDK.%NotDel%
			
		ORDER BY DDK_FILCAR,DDK_CARREG, DDK_VERSAO	
	EndSql
	
oCarreg4:EndQuery(/*Array com os parametros do tipo Range*/)	

oCarreg:ExecSql()	
oCarreg2:ExecSql()
oCarreg3:ExecSql()
oCarreg4:ExecSql()

dbSelectArea(cAliasDDK)
While !oReport:Cancel() .And. !(cAliasDDK)->(Eof())
				
	oCarreg:Init()
	oCarreg:PrintLine()
	oCarreg:Finish()	
		
	oCarreg2:Init()
	oCarreg2:PrintLine()
	oCarreg2:Finish()
			
	oCarreg3:Init()
	oCarreg3:PrintLine()
	oCarreg3:Finish()
		
	oReport:ThinLine()
			
	oCarreg4:Init()
	oCarreg4:PrintLine()
	oCarreg4:Finish()
	
	oTotCarreg:BeginQuery()

		BeginSql Alias cAliasQry	
		
			SELECT COUNT(DT6_DOC) nQtdDoc	
			FROM %table:DDK% DDK        
			
			INNER JOIN %table:DUD% DUD ON
				
				DUD_FILIAL			= DDK_FILIAL
				AND DUD_VIAGEM	= DDK_VIAGEM
				AND DUD_FILORI	= DDK_FILORI		
				AND DUD.%NotDel%	
				
				INNER JOIN %table:DT6% DT6 ON
				DT6_FILIAL 		= DUD_FILIAL
				AND DT6_FILORI	= DUD_FILORI
				AND DT6_FILDOC	= DUD_FILDOC
				AND DT6_DOC		= DUD_DOC
				AND DT6_SERIE	= DUD_SERIE
				AND DT6.%NotDel%
						
			WHERE DDK_FILIAL		= %xFilial:DDK%
				AND DDK_FILCAR	= %Exp:(cAliasDDK)->DDK_FILCAR%
				AND DDK_CARREG	= %Exp:(cAliasDDK)->DDK_CARREG%	
				AND DDK_VERSAO	= %Exp:(cAliasDDK)->DDK_VERSAO%				
				AND DDK_CODVEI	= %Exp:(cAliasDDK)->DDK_CODVEI%
				AND DDK_FILORI	= %Exp:(cAliasDDK)->DDK_FILORI%
				AND DDK_VIAGEM	= %Exp:(cAliasDDK)->DDK_VIAGEM%
				AND DDK.%NotDel%
				
		EndSql

	oTotCarreg:EndQuery()

	oTotQtdNf:BeginQuery()
	
		BeginSql Alias cAliasQry2
	
		SELECT MAX(nQtdNF) AS nQtdNF FROM (
	
			SELECT COUNT(DTC_DOC) nQtdNF
			FROM %table:DDK% DDK
	
			JOIN %table:DUD% DUD ON
			DUD_FILIAL			= DDK_FILIAL
			AND DUD_VIAGEM		= DDK_VIAGEM
			AND DUD_FILORI		= DDK_FILORI
			AND DUD.%NotDel%
	
			JOIN %table:DTC% DTC ON
			DTC_FILIAL 			= DUD_FILIAL
			AND DTC_FILORI		= DUD_FILORI
			AND DTC_FILDOC		= DUD_FILDOC
			AND DTC_DOC			= DUD_DOC
			AND DTC_SERIE			= DUD_SERIE
			AND DTC.%NotDel%
	
			WHERE DDK_FILIAL			= %xFilial:DDK%
			AND DDK_FILCAR		= %Exp:(cAliasDDK)->DDK_FILCAR%
			AND DDK_CARREG 		= %Exp:(cAliasDDK)->DDK_CARREG%
			AND DDK_VERSAO	= %Exp:(cAliasDDK)->DDK_VERSAO%	
			AND DDK_CODVEI		= %Exp:(cAliasDDK)->DDK_CODVEI%	
			AND DDK_FILORI		= %Exp:(cAliasDDK)->DDK_FILORI%	
			AND DDK_VIAGEM		= %Exp:(cAliasDDK)->DDK_VIAGEM%	
			AND DDK.%NotDel%
			UNION
			SELECT COUNT(DY4_DOC) nQtdNF
			FROM %table:DDK% DDK
	
			JOIN %table:DUD% DUD ON
			DUD_FILIAL 			= DDK_FILIAL
			AND DUD_VIAGEM		= DDK_VIAGEM
			AND DUD_FILORI		= DDK_FILORI
			AND DUD.D_E_L_E_T_	= ''
	
		JOIN  %table:DY4% DY4 ON
			DY4_FILIAL				= DUD_FILIAL
			AND DY4_FILORI		= DUD_FILORI
			AND DY4_FILDOC		= DUD_FILDOC
			AND DY4_DOC			= DUD_DOC
			AND DY4_SERIE			= DUD_SERIE
			AND DY4.%NotDel%
	
			WHERE DDK_FILIAL			= %xFilial:DDK%
			AND DDK_FILCAR		= %Exp:(cAliasDDK)->DDK_FILCAR%
			AND DDK_CARREG		= %Exp:(cAliasDDK)->DDK_CARREG%
			AND DDK_VERSAO	= %Exp:(cAliasDDK)->DDK_VERSAO%	
			AND DDK_CODVEI		= %Exp:(cAliasDDK)->DDK_CODVEI%	
			AND DDK_FILORI		= %Exp:(cAliasDDK)->DDK_FILORI%	
			AND DDK_VIAGEM		= %Exp:(cAliasDDK)->DDK_VIAGEM%
		)cAliasTmp		
		
		EndSql

	oTotQtdNf:EndQuery()

	oTotValMer:BeginQuery()
		
		BeginSql Alias cAliasQry3
		
		SELECT SUM(DT6_VALMER) ValMer	
		FROM %table:DDK% DDK        
		
		INNER JOIN %table:DUD% DUD ON
			
			DUD_FILIAL			= DDK_FILIAL
			AND DUD_VIAGEM	= DDK_VIAGEM
			AND DUD_FILORI	= DDK_FILORI		
			AND DUD.%NotDel%	
			
		INNER JOIN %table:DT6% DT6 ON
			DT6_FILIAL 		= DUD_FILIAL
			AND DT6_FILORI	= DUD_FILORI
			AND DT6_FILDOC	= DUD_FILDOC
			AND DT6_DOC		= DUD_DOC
			AND DT6_SERIE		= DUD_SERIE
			AND DT6.%NotDel%
					
		WHERE DDK_FILIAL		= %xFilial:DDK%
			AND DDK_FILCAR	= %Exp:(cAliasDDK)->DDK_FILCAR%
			AND DDK_CARREG	= %Exp:(cAliasDDK)->DDK_CARREG%
			AND DDK_VERSAO	= %Exp:(cAliasDDK)->DDK_VERSAO%		
			AND DDK_CODVEI	= %Exp:(cAliasDDK)->DDK_CODVEI%
			AND DDK_FILORI	= %Exp:(cAliasDDK)->DDK_FILORI%
			AND DDK_VIAGEM	= %Exp:(cAliasDDK)->DDK_VIAGEM%
			AND DDK.%NotDel%
					
		EndSql
	
	oTotValMer:EndQuery()
	
	oTotPeso:BeginQuery()
		
		BeginSql Alias cAliasQry4
		
		SELECT SUM(DT6_PESO) nPeso	
		FROM %table:DDK% DDK        
		
		INNER JOIN %table:DUD% DUD ON
			
			DUD_FILIAL		= DDK_FILIAL
			AND DUD_VIAGEM	= DDK_VIAGEM
			AND DUD_FILORI	= DDK_FILORI		
			AND DUD.%NotDel%	
			
		INNER JOIN %table:DT6% DT6 ON
			DT6_FILIAL 		= DUD_FILIAL
			AND DT6_FILORI	= DUD_FILORI
			AND DT6_FILDOC	= DUD_FILDOC
			AND DT6_DOC		= DUD_DOC
			AND DT6_SERIE		= DUD_SERIE
			AND DT6.%NotDel%
					
		WHERE DDK_FILIAL	= %xFilial:DDK%
			AND DDK_FILCAR	= %Exp:(cAliasDDK)->DDK_FILCAR%
			AND DDK_CARREG	= %Exp:(cAliasDDK)->DDK_CARREG%
			AND DDK_VERSAO	= %Exp:(cAliasDDK)->DDK_VERSAO%		
			AND DDK_CODVEI	= %Exp:(cAliasDDK)->DDK_CODVEI%
			AND DDK_FILORI	= %Exp:(cAliasDDK)->DDK_FILORI%
			AND DDK_VIAGEM	= %Exp:(cAliasDDK)->DDK_VIAGEM%
			AND DDK.%NotDel%	
		
		EndSql
		
	oTotPeso:EndQuery()
	
	oTotPesoM3:BeginQuery()
		
		BeginSql Alias cAliasQry5
		
		SELECT SUM(DT6_PESOM3) nPesoM3	
		FROM %table:DDK% DDK        
		
		INNER JOIN %table:DUD% DUD ON
			
			DUD_FILIAL			= DDK_FILIAL
			AND DUD_VIAGEM	= DDK_VIAGEM
			AND DUD_FILORI	= DDK_FILORI		
			AND DUD.%NotDel%	
			
		INNER JOIN %table:DT6% DT6 ON
			DT6_FILIAL 		= DUD_FILIAL
			AND DT6_FILORI	= DUD_FILORI
			AND DT6_FILDOC	= DUD_FILDOC
			AND DT6_DOC		= DUD_DOC
			AND DT6_SERIE		= DUD_SERIE
			AND DT6.%NotDel%
					
		WHERE DDK_FILIAL		= %xFilial:DDK%
			AND DDK_FILCAR	= %Exp:(cAliasDDK)->DDK_FILCAR%
			AND DDK_CARREG	= %Exp:(cAliasDDK)->DDK_CARREG%
			AND DDK_VERSAO	= %Exp:(cAliasDDK)->DDK_VERSAO%		
			AND DDK_CODVEI	= %Exp:(cAliasDDK)->DDK_CODVEI%
			AND DDK_FILORI	= %Exp:(cAliasDDK)->DDK_FILORI%
			AND DDK_VIAGEM	= %Exp:(cAliasDDK)->DDK_VIAGEM%
			AND DDK.%NotDel%	
		
		EndSql
		
	oTotPesoM3:EndQuery()	
	
	oTotValFre:BeginQuery()
		
		BeginSql Alias cAliasQry6
		
		SELECT SUM(DT6_VALFRE) ValFre	
		FROM %table:DDK% DDK        
		
		INNER JOIN %table:DUD% DUD ON
			
			DUD_FILIAL			= DDK_FILIAL
			AND DUD_VIAGEM	= DDK_VIAGEM
			AND DUD_FILORI	= DDK_FILORI		
			AND DUD.%NotDel%	
			
		INNER JOIN %table:DT6% DT6 ON
			DT6_FILIAL 		= DUD_FILIAL
			AND DT6_FILORI	= DUD_FILORI
			AND DT6_FILDOC	= DUD_FILDOC
			AND DT6_DOC		= DUD_DOC
			AND DT6_SERIE		= DUD_SERIE
			AND DT6.%NotDel%
					
		WHERE DDK_FILIAL		= %xFilial:DDK%
			AND DDK_FILCAR	= %Exp:(cAliasDDK)->DDK_FILCAR%
			AND DDK_CARREG	= %Exp:(cAliasDDK)->DDK_CARREG%
			AND DDK_VERSAO	= %Exp:(cAliasDDK)->DDK_VERSAO%		
			AND DDK_CODVEI	= %Exp:(cAliasDDK)->DDK_CODVEI%
			AND DDK_FILORI	= %Exp:(cAliasDDK)->DDK_FILORI%
			AND DDK_VIAGEM	= %Exp:(cAliasDDK)->DDK_VIAGEM%
			AND DDK.%NotDel%	
		
		EndSql
		
	oTotValFre:EndQuery()
	
	oTotQtdVol:BeginQuery()
	
		BeginSql Alias cAliasQry7
		
		SELECT SUM(DT6_VOLORI) QtdVol	
		FROM %table:DDK% DDK        
		
		INNER JOIN %table:DUD% DUD ON
			
			DUD_FILIAL			= DDK_FILIAL
			AND DUD_VIAGEM	= DDK_VIAGEM
			AND DUD_FILORI	= DDK_FILORI		
			AND DUD.%NotDel%	
			
			INNER JOIN %table:DT6% DT6 ON
			DT6_FILIAL 		= DUD_FILIAL
			AND DT6_FILORI	= DUD_FILORI
			AND DT6_FILDOC	= DUD_FILDOC
			AND DT6_DOC		= DUD_DOC
			AND DT6_SERIE		= DUD_SERIE
			AND DT6.%NotDel%
					
		WHERE DDK_FILIAL		= %xFilial:DDK%
			AND DDK_FILCAR	= %Exp:(cAliasDDK)->DDK_FILCAR%
			AND DDK_CARREG	= %Exp:(cAliasDDK)->DDK_CARREG%
			AND DDK_VERSAO	= %Exp:(cAliasDDK)->DDK_VERSAO%		
			AND DDK_CODVEI	= %Exp:(cAliasDDK)->DDK_CODVEI%
			AND DDK_FILORI	= %Exp:(cAliasDDK)->DDK_FILORI%
			AND DDK_VIAGEM	= %Exp:(cAliasDDK)->DDK_VIAGEM%
			AND DDK.%NotDel%
					
		EndSql
	
	oTotQtdVol:EndQuery()	
	
	oTotObserv:BeginQuery()
	
		BeginSql Alias cAliasQry8
		
		SELECT DDK_FILIAL, DDK_FILORI,DDK_FILCAR,DDK_CODRB1,DDK_CODRB2,DDK_VEICAR,DDK_CARREG, 
				DDK_FILDES,DDK_UNITIZ,DDK_VERSAO,DDK_VIAGEM,DDK_DATCAR,DDK_HORCAR,DDK_DTFCAR,DDK_CODVEI,
				DDK_HRFCAR,DDK_DATDSC,DDK_HORDSC,DDK_OBSERV			
		FROM %table:DDK% DDK	
	
		WHERE DDK_FILIAL = %xFilial:DDK%						
			AND DDK_FILCAR BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
			AND DDK_CARREG BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
			AND DDK_VERSAO BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
			AND DDK_CODVEI BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
			AND DDK_FILORI BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%
			AND DDK_VIAGEM BETWEEN %Exp:mv_par11% AND %Exp:mv_par12%
			AND DDK.%NotDel%
				
			ORDER BY DDK_FILCAR,DDK_CARREG, DDK_VERSAO	
		EndSql
		
	oTotObserv:EndQuery(/*Array com os parametros do tipo Range*/)			
		
	oTotCarreg:ExecSql()	
	oTotQtdNf:ExecSql()	
	oTotValMer:ExecSql()
	oTotPeso:ExecSql()
	oTotPesoM3:ExecSql()
	oTotValFre:ExecSql()
	oTotQtdVol:ExecSql()
		
	oReport:SkipLine()
	oReport:ThinLine()
	oReport:SkipLine()
	oReport:PrintText(STR0005,oReport:Row(),oReport:Section(5):Cell("QTDCTRC"):ColPos()+5)
	oReport:SkipLine(2)
		 
	If !ExistDir(_cDiretorio)     
		MakeDir(_cDiretorio)		
	EndIf
			 
	Tmsa215Imp(_cDiretorio,(cAliasDDK)->DDK_FILCAR,(cAliasDDK)->DDK_CARREG,(cAliasDDK)->DDK_VERSAO)
		
	oReport:SayBitmap(oReport:Row()+2,oReport:Section(5):Cell("QTDCTRC"):ColPos()+20, _cDiretorio+"RTMSR30_"+(cAliasDDK)->DDK_FILCAR+(cAliasDDK)->DDK_CARREG+(cAliasDDK)->DDK_VERSAO+".bmp",nLargura,nAltura)
					
	oReport:SetPageFooter( 20 , {|| RTMSRDP30(oReport,oTotObserv) } )
							
	(cAliasDDK)->(DbSkip())
EndDo	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRTMSRDP30 บAutor  ณRamon Prado    บ  Data ณ  06/07/15		 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ  Imprime o Rodape						                    	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao de Impressao do relatorio                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RTMSRDP30(oReport,oTotObserv)

oReport:PrintText(STR0006,oReport:Row(),oReport:Section(5):Cell("QTDCTRC"):ColPos()+5)
oReport:SkipLine()	
oReport:ThinLine()
oReport:Section(5):Init()
oReport:Section(5):PrintLine()
oReport:Section(5):Finish()      
oReport:PrintText(STR0007,oReport:Row(),oReport:Section(5):Cell("QTDCTRC"):ColPos()+5)
oReport:SkipLine()
oReport:ThinLine()
oTotObserv:Init()
oTotObserv:PrintLine()
oTotObserv:Finish()

Return
