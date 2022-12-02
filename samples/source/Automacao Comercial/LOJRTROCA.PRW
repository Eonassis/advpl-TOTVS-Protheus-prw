#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE TAG_NEGRITO_INI	 "<b>"		//Inicia Texto em Negrito
#DEFINE TAG_NEGRITO_FIM	"</b>"		//finaliza texto em negrito
#DEFINE TAG_CENTER_INI	"<ce>"		//centralizado
#DEFINE TAG_CENTER_FIM	"</ce>"		//centralizado
#DEFINE TAG_GUIL_INI	"<gui>"		//ativa guilhotina
#DEFINE TAG_GUIL_FIM	"</gui>"

//-------------------------------------------------------------------
/*/{Protheus.doc} LOJRTROCA
Faz a impressao do cupom de vale troca

@param	cNumCupom - Numero do cupom
		lNFiscal - Documento fiscal 
@author  JMM
@version V12.1.25
@since   12/2019
@return  

@obs     
/*/
//-------------------------------------------------------------------

User Function LOJRTROCA( cNumCupom,lNFiscal )
Local aArea       	:= GetArea()              	// Salva a area corrente
Local cCupomTroca	:= ""                     	// Codigo do cupom de troca
Local cSerie      	:= PadR(LjGetStation("SERIE"),TamSX3("L1_SERIE")[1])	// Serie da impressora
Local cSerieCVT   	:= ""                     	// Serie codificada que sera impressa no cupom de troca
Local nCount      	:= 1                      	// Contador
Local nX          	:= 0                      	// Contador
Local cCabecalho	:= ""						// Cabeçalho da impressão
Local cDadosOrc		:= ""						// Dados da venda
Local cItem			:= ""						// Item da troca
Local cRodape     	:= CHR(10) + TAG_CENTER_INI + " Apresente este cupom apara efetuar a troca " + TAG_CENTER_FIM	// Rodapé da impressão
Local cTexto      	:= ""
Local lPOS		  	:= STFIsPOS() 				// Pos?
Local nLarCup	  	:= 0						// Largura do cupom
Local cCodBarra   	:= ""						// Código de barras para impressora não fiscal
Local nHdlECF   	:= 0

Default lNfiscal  := .F.
Default cNumCupom := ""

nLarCup := IIF(lPOS,STFGetStation("LARGCOL"),LJGetStation("LARGCOL"))

cCabecalho :=  PadC( AllTrim(SM0->M0_NOMECOM), nLarCup) + CHR(10)
cCabecalho +=  PadC( "CNPJ: " + AllTrim(SM0->M0_CGC), nLarCup ) +CHR(10)
cCabecalho +=  PadC( AllTrim(SM0->M0_ENDCOB), nLarCup) + CHR(10)
cCabecalho +=  PadC( AllTrim(SM0->M0_CIDCOB) 	+ " - " +  AllTrim(SM0->M0_ESTCOB), nLarCup) + CHR(10)+CHR(10)
cCabecalho +=  PadC(TAG_CENTER_INI + "  C U P O M  D E  T R O C A " + TAG_CENTER_FIM, nLarCup) + CHR(10)+CHR(10)

cDadosOrc := CHR(10)
cDadosOrc += PadR(TAG_NEGRITO_INI + "Orçamento         : " + TAG_NEGRITO_FIM + SL1->L1_NUM, nLarCup) + CHR(10)
cDadosOrc += PadR(TAG_NEGRITO_INI + "Cliente           : " + TAG_NEGRITO_FIM + SL1->L1_CLIENTE + "/" + SL1->L1_LOJA, nLarCup) + CHR(10) 
cDadosOrc += PadR(TAG_NEGRITO_INI + "Nome do Cliente   : " + TAG_NEGRITO_FIM + Posicione("SA1",1,xFilial("SA1") + SL1->L1_CLIENTE + SL1->L1_LOJA,"SA1->A1_NOME"), nLarCup) + CHR(10)
cDadosOrc += PadR(TAG_NEGRITO_INI + "Vendedor          : " + TAG_NEGRITO_FIM + SL1->L1_VEND, nLarCup) + CHR(10)
cDadosOrc += PadR(TAG_NEGRITO_INI + "Nome do Vendedor  : " + TAG_NEGRITO_FIM + Posicione("SA3",1,xFilial("SA3") + SL1->L1_VEND,"A3_NOME"), nLarCup) + CHR(10)+CHR(10)

While nCount <= Len(cSerie)

	If IsDigit(SubStr(cSerie,nCount,1))
		cSerieCVT += "0" + SubStr(cSerie,nCount,1)
	ElseIf Empty(SubStr(cSerie,nCount,1))
		cSerieCVT += "99"
	Else
		cSerieCVT += AllTrim(Str(ASC(SubStr(cSerie,nCount,1))))
	EndIf

	nCount++
EndDo

cCupomTroca := Alltrim(cNumCupom) + cSerieCVT

DbSelectArea("SL2")
SL2->(DbSetOrder())

If DbSeek(xFilial("SL2") + SL1->L1_NUM)
	While xFilial("SL1") + SL1->L1_NUM == xFilial("SL2") + SL2->L2_NUM
		If SL2->L2_VLTROCA == "1"
			For nX := 1 To SL2->L2_QUANT
				cTexto := cCabecalho + cDadosOrc

				cItem := PadR(TAG_NEGRITO_INI + "Item   : " + TAG_NEGRITO_FIM + SL2->L2_ITEM	, nLarCup) + CHR(10)
				cItem += PadR(TAG_NEGRITO_INI + "Código : " + TAG_NEGRITO_FIM + SL2->L2_PRODUTO	, nLarCup) + CHR(10)
				cItem += PadR(TAG_NEGRITO_INI + "Produto: " + TAG_NEGRITO_FIM + SL2->L2_DESCRI	, nLarCup) + CHR(10)

				cTexto += CHR(10) + cItem

				If lNFiscal
					cTexto		:= cTexto + CHR(10)
					cCodBarra	:= Replicate("0",6) + cCupomTroca+SL2->L2_ITEM
					cTexto 		+= TAG_CENTER_INI + "<code128>	" + cCodBarra + "</code128> " + cCodBarra + TAG_CENTER_FIM
					cTexto		+= CHR(10) + cRodape + CHR(10) + CHR(10)

					INFTexto(cTexto)
					INFTexto(TAG_GUIL_INI+TAG_GUIL_FIM)
				Else
					IFCodBar( nHdlECF, cTexto, Replicate("0",6) + cCupomTroca+SL2->L2_ITEM, cRodape ,1)
				EndIf 

			Next nX
		EndIf
		SL2->(DbSkip())
	EndDo
EndIf

RestArea( aArea )

Return