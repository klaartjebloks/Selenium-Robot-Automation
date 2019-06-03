*** Settings ***
# Import Library met Keywords waarmee websites getest kunnen worden.
Library  SeleniumLibrary
# Import Library met Keywords waarmee software op computer getest kan worden.
Library  SikuliLibrary
# In de Recourse file bevinden zich zelf samengestelde Keywords (functies).
Resource  ../Resources/Facebook_Resources.robot
# In deze Python file bevinden zich zelf verschillende Python functies.
Library  ../CreatedKeywords/Facebook_Excel.py

# NOTES:
# Gebruik voor de naam van menukeuzes een hoofdletter (bv Settlement)
# Als meerdere menukeuzes achtereenvolgens geselecteerd moeten worden, voeg hiertussen dan > als scheidingsteken in
# Gebruik voor de naam van een scherm dubbele aanhalingstekens ("")
# Gebruik voor de naam van een veld enkelvoudige aanhalingstekens (' ')
# Gebruik voor de naam van buttons haken (< >)
# Noem bij het beschrijven ook telkens óf het een menukeuze, scherm, veld of button betreft.

*** Variables ***
${URL}=  http://www.facebook.com
${Browser}=  Edge
${Email}=  klaartjebloks@gmail.com
${Wachtwoord}=  Eindhoven78

*** Test Cases ***
TC Vrienden updaten
    #[Documentation]  Vriend status aanpassen op Facebook.
    Set selenium speed  1sec

    ## LOG TO CONSOLE.
    log to console  Facebook openen en inloggen met eigen account gegevens.

    ## (FACEBOOK_RESOURCE) Roep functie <open browser en login> aan vanuit 'Keywords'.
    Open browser en login  ${URL}  ${Browser}  ${Email}  ${Wachtwoord}

    ## LOG TO CONSOLE.
    log to console  Inloggen is gelukt.

    ## Tel het aantal regels minus 1 (de koppen van de kolommen) = het aantal vrienden.
    ${Aantal_Rijen}=  CountRows
    #log to console  ${Aantal_Rijen}

    ## LOG TO CONSOLE.
    log to console  Bestaand Excel bestand openen...
    log to console  De volgende vrienden worden aangepast...

    : FOR  ${k}  IN RANGE  2  ${Aantal_Rijen}
        ## Haal de waarde (= URL) op uit Iedere regel van de Excel.
    \   ${URL_Vriend_Profiel_Pag}=  GetURL  ${k}
        ## Haal de waarde (= HUIDIGE VriendStatus) op uit Iedere regel van de Excel.
    \   ${HuidigeVriendStatusExcel}=  GetHuidigeVriendStatus  ${k}
        ## Haal de waarde (= NIEUWE VriendStatus) op uit Iedere regel van de Excel.
    \   ${NieuweVriendStatusExcel}=  GetNieuweVriendStatus  ${k}
        ## Haal de waarde (= NAAM) op uit Iedere regel van de Excel.
    \   ${VriendNaam}=  GetVriendNaam  ${k}
        ## Haal de waarde (= ONTVRIENDEN) op uit Iedere regel van de Excel.
    \   ${Ontvrienden}=  Ontvrienden  ${k}

        ## Open de vrienden pagina
    \   Go to  ${URL_Vriend_Profiel_Pag}

    \   ${HuidigeVriendStatusFB}=  SeleniumLibrary.Get text  xpath://a[@data-unref='bd_profile_button']//i/u

    \   run keyword if  '${NieuweVriendStatusExcel}' == 'None'  log to console  ${k}: Er is niks aangepast bij ${VriendNaam}, want er is geen nieuwe vriendstatus bekend.
    \   ...  ELSE IF  '${HuidigeVriendStatusFB}' == 'Kennis' and '${NieuweVriendStatusExcel}' == 'Vriend'  run keyword  WijzigVriendStatus_Kennis-Vriend  ${k}  ${VriendNaam}  ${Ontvrienden}
    \   ...  ELSE IF  '${HuidigeVriendStatusFB}' == 'Kennis' and '${NieuweVriendStatusExcel}' == 'Goede vriend'  run keyword  WijzigVriendStatus_Kennis-GoedeVriend  ${k}  ${VriendNaam}  ${Ontvrienden}
    \   ...  ELSE IF  '${HuidigeVriendStatusFB}' == 'Kennis' and '${NieuweVriendStatusExcel}' == 'Kennis'  run keyword  WijzigVriendStatus_Kennis-Kennis  ${k}  ${VriendNaam}  ${Ontvrienden}
    \   ...  ELSE IF  '${HuidigeVriendStatusFB}' == 'Goede vriend' and '${NieuweVriendStatusExcel}' == 'Vriend'  run keyword  WijzigVriendStatus_GoedeVriend-Vriend  ${k}  ${VriendNaam}  ${Ontvrienden}
    \   ...  ELSE IF  '${HuidigeVriendStatusFB}' == 'Goede vriend' and '${NieuweVriendStatusExcel}' == 'Kennis'  run keyword  WijzigVriendStatus_GoedeVriend-Kennis  ${k}  ${VriendNaam}  ${Ontvrienden}
    \   ...  ELSE IF  '${HuidigeVriendStatusFB}' == 'Goede vriend' and '${NieuweVriendStatusExcel}' == 'Goede vriend'  run keyword  WijzigVriendStatus_GoedeVriend-GoedeVriend  ${k}  ${VriendNaam}  ${Ontvrienden}
    \   ...  ELSE IF  '${HuidigeVriendStatusFB}' == 'Vriend' and '${NieuweVriendStatusExcel}' == 'Goede vriend'  run keyword  WijzigVriendStatus_Vriend-GoedeVriend  ${k}  ${VriendNaam}  ${Ontvrienden}
    \   ...  ELSE IF  '${HuidigeVriendStatusFB}' == 'Vriend' and '${NieuweVriendStatusExcel}' == 'Kennis'  run keyword  WijzigVriendStatus_Vriend-Kennis  ${k}  ${VriendNaam}  ${Ontvrienden}
    \   ...  ELSE IF  '${HuidigeVriendStatusFB}' == 'Vriend' and '${NieuweVriendStatusExcel}' == 'Vriend'  run keyword  WijzigVriendStatus_Vriend-Vriend  ${k}  ${VriendNaam}  ${Ontvrienden}
    \   ...  ELSE  run keyword  log to console  ${k}: Er is niks aangepast bij ${VriendNaam}, want er ging iets mis.

        ## Als de waarde in Excel op <Y> staat, zal deze vriend worden ontvriend.
    \   run keyword if  '${Ontvrienden}' == 'Y'  VerwijderenAlsVriend  ${k}  ${VriendNaam}

    ## LOG TO CONSOLE.
    log to console  Alle vrienden zijn succesvol doorlopen.

    ## (FACEBOOK_RESOURCE) Roep functie <Uitloggen> aan vanuit 'Keywords'.
    Uitloggen en browser sluiten

    ## LOG TO CONSOLE.
    log to console  Uiloggen en browser sluiten.

*** Keywords ***