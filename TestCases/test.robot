*** Settings ***
Library  SeleniumLibrary
#Library  SikuliLibrary
#Library  ../ExternalKeywords/Vriend_Status.py
Resource  ../Resources/Facebook_Resources.robot

*** Variables ***
${URL}=  http://www.facebook.com
${Browser}=  Edge

*** Test Cases ***
TC TEST SCRIPT
    # (RESOURCE) Open browser en maximaliseer window.
    Open browser  ${URL}  ${Browser}

    # (RESOURCE) Log in met onderstaande credentials.
    Inloggen  klaartjebloks@gmail.com  Eindhoven78

    log to console  Inloggen is gelukt.

    ## Open de vrienden pagina
    Go to  https://www.facebook.com/toetsen.bord.104

    #FeliciteerJarigeJob
    Bepaal VriendType en Leeftijd

    ## (FACEBOOK_RESOURCE) Roep functie <Uitloggen> aan vanuit 'Keywords'.
    Uitloggen en browser sluiten
    log to console  Uiloggen en browser sluiten.

*** Keywords ***
