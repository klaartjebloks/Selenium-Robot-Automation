*** Settings ***
# Import Library met Keywords waarmee websites getest kunnen worden.
Library  SeleniumLibrary
# Import Library met Keywords waarmee software op computer getest kan worden.
Library  SikuliLibrary
# In de Recourse file bevinden zich zelf samengestelde Keywords (functies).
Resource  ../Resources/Facebook_Resources.robot

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
${email}=  klaartjebloks@gmail.com
${wachtwoord}=  Eindhoven78

*** Test Cases ***
TC Jarigen feliciteren
    #[Documentation]  Al mijn vrienden feliciteren die vandaag jarig zijn.
    Set selenium speed  1sec

    ## LOG TO CONSOLE.
    log to console  Facebook openen en inloggen met eigen account gegevens.

    ## (FACEBOOK_RESOURCE) Roep functie <open browser en login> aan vanuit 'Keywords'.
    Open browser en login  ${URL}  ${Browser}  ${Email}  ${Wachtwoord}

    ## LOG TO CONSOLE.
    log to console  Inloggen is gelukt.

    ## Klik naar in linker menu naar: Evenementen > Verjaardagen.
    go to  https://www.facebook.com/events/birthdays/

    ## LOG TO CONSOLE.
    log to console  Controleren of er vrienden jarig zijn vandaag...

    ## Controleer hoeveel mensen er vandaag jarig zijn.
    ${CountVandaagJarig}=  Get Element Count  xpath://div[@id='birthdays_today_card']/following-sibling::div//a[@data-hovercard-prefer-more-content-show='1']

    ## LOG TO CONSOLE.
    log to console  Aantal jarige vrienden vandaag: ${CountVandaagJarig}

    ## ALS ${CountVandaagJarig} = 0 DAN zijn er geen vrienden jarig vandaag.
    ## ALS ${CountVandaagJarig} = 1 DAN is er ÉÉN vriend jarig vandaag.
    ## ALS ${CountVandaagJarig} > 1 DAN zijn er meerdere vrienden jarig vandaag.
    Run keyword if  '${CountVandaagJarig}' == '1'  FeliciteerJarigeJob
    ...  ELSE IF  '${CountVandaagJarig}' > '1'  FeliciteerIedereen  ${CountVandaagJarig}
    ...  ELSE  run keyword  NiemandJarig

    ## (FACEBOOK_RESOURCE) Roep functie <Uitloggen> aan vanuit 'Keywords'.
    Uitloggen en browser sluiten

    ## LOG TO CONSOLE.
    log to console  Uiloggen en browser sluiten.

*** Keywords ***