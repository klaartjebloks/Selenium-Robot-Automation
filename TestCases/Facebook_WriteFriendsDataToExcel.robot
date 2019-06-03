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
${Scroll_y}=  100000000000
${Wait}=  2sec
${Scroll_Aantal}=  15

*** Test Cases ***
TC ListPage Vriend data scannen en opslaan
    [Documentation]  Vriend data van de 'Vrienden overzichtspagina' scrapen.
    Set selenium speed  1sec

    ## LOG TO CONSOLE.
    log to console  Facebook openen en onloggen met eigen account gegevens.

    ## (FACEBOOK_RESOURCE) Roep functie <open browser en login> aan vanuit 'Keywords'.
    Open browser en login  ${URL}  ${Browser}  ${Email}  ${Wachtwoord}

    ## LOG TO CONSOLE.
    log to console  Inloggen is gelukt.

    ## Open de vrienden pagina van Klaartje Bloks
    Go to  https://www.facebook.com/klaartje.bloks/friends?lst=756489715%3A756489715%3A1554969907&source_ref=pb_friends_tl

    ## LOG TO CONSOLE.
    log to console  Alle vrienden aan het scannen...

    ## Scroll helemaal naar beneden, zodat alle 200 vrienden geteld kunnen worden.
    ## Indien er meer dan 200 vrienden zijn: hoog dan variabele ${Aantal} op. Deze bepaald hoe vaak de FOR LOOP herhaald moet worden.
    : FOR  ${i}  IN RANGE  1  ${Scroll_Aantal}
        ## Scroll de pagina omlaag, zodat alle vrienden in de browser geladen worden.
    \   execute javascript  window.scrollTo(0,${Scroll_y})
        ## Geef de pagina tijd om de informatie in de browser te laden.
    \   sleep  ${Wait}
    ## Tel het aantal vrienden. Dit aantal moet overeenkomen met het aantal op de profielpagina.
    ${Count_Aantal_Vrienden}=  Get Element Count  xpath://a[@data-floc='friends_tab']
    ${Count_Aantal_Active_Vrienden}=  Get Element Count  //div[@data-testid='friend_list_item']/a[contains(@href,'https://www.facebook.com/')]

    ## LOG TO CONSOLE.
    log to console  Aantal gescande vrienden is: ${Count_Aantal_Vrienden}.
    log to console  Aantal active vrienden is: ${Count_Aantal_Active_Vrienden}.

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  Aantal gescande vrienden is: ${Count_Aantal_Vrienden}.
    log Many  Aantal active vrienden is: ${Count_Aantal_Active_Vrienden}.

    ## Creëer een Excel bestand met hierin alle vriendgegevens en het totaal aantal vrienden (zie tabblad-naam).
    CreateExcelFile  ${Count_Aantal_Vrienden}  ${Count_Aantal_Active_Vrienden}

    ## LOG TO CONSOLE.
    log to console  Nieuw Excel bestand aanmaken...
    log to console  De volgende vrienden opslaan in Excel bestand...

    : FOR  ${j}  IN RANGE  1  ${Count_Aantal_Active_Vrienden}
        ## Zet de vollediga naam in element <a> in variabele ${naam}.
    \   ${Naam}=  SeleniumLibrary.Get text  xpath:(//div[@class='uiProfileBlockContent']//a[contains(@href,'https://www.facebook.com/')][@data-hovercard-prefer-more-content-show='1'])[${j}]
        ## Zet de geboortedatum in attribute <href> in variabele ${Profiel_URL}.
    \   ${Profiel_URL}=  SeleniumLibrary.Get Element Attribute  xpath:(//div[@data-testid='friend_list_item']/a[contains(@href,'https://www.facebook.com/')])[${j}]  href
        ## Haal alles ná het "?" weg uit de URL string.
    \   ${URL_Vriend_Profiel_Pag}=  SplitProfielURL  ${Profiel_URL}
    \   ## Rij 1 is gevuld met kolomtitels, dus de vriend gegevens moeten vanaf rij 2 worden weg geschreven.
    \   ${Rij_Nr}=  RijRegelOphogen  ${j}
        ## Voeg vriend toe aan Excel.
    \   run keyword if  '${URL_Vriend_Profiel_Pag}' != 'https://www.facebook.com/profile.php'  AddFriend  ${URL_Vriend_Profiel_Pag}  ${Naam}  ${Rij_Nr}
    \   ...  ELSE  run keyword  AddFriend  ${Profiel_URL}  ${Naam}  ${Rij_Nr}
        ## LOG TO CONSOLE. Profiel URL´s, die succesvol zijn weggeschreven in Excel. Voeg <ENTER> toe achter de regel d.m.v. ASCII 13 (13 = enter).
    \   run keyword if  '${URL_Vriend_Profiel_Pag}' != 'https://www.facebook.com/profile.php'  log to console  ${j} - ${URL_Vriend_Profiel_Pag}.  \\13
    \   ...  ELSE  run keyword  log to console  ${j} - ${Profiel_URL}.  \\13
        ## Melding plaatsen in RAPPORTAGE LOG.
    \   run keyword if  '${URL_Vriend_Profiel_Pag}' != 'https://www.facebook.com/profile.php'  Log Many  ${j} - ${URL_Vriend_Profiel_Pag}.  \\13
    \   ...  ELSE  run keyword  Log Many  ${j} - ${Profiel_URL}.  \\13

    ## (FACEBOOK_RESOURCE) Roep functie <Uitloggen> aan vanuit 'Keywords'.
    Uitloggen en browser sluiten

    ## LOG TO CONSOLE.
    log to console  Uiloggen en browser sluiten.

TC DetailPage Vriend data scannen en opslaan
    [Documentation]  Vriend data van de 'Vriend profiel pagina' scrapen.
    Set selenium speed  2sec

    ## LOG TO CONSOLE.
    log to console  Facebook openen en onloggen met eigen account gegevens.

    ## (FACEBOOK_RESOURCE) Roep functie <open browser en login> aan vanuit 'Keywords'.
    Open browser en login  ${URL}  ${Browser}  ${Email}  ${Wachtwoord}

    ## LOG TO CONSOLE.
    log to console  Inloggen is gelukt.

    ## Tel het aantal regels minus 1 (de koppen van de kolommen) = het aantal vrienden.
    ${Aantal_Rijen}=  CountRows
    log to console  ${Aantal_Rijen}

    ## LOG TO CONSOLE.
    log to console  Bestaand Excel bestand openen...
    log to console  De volgende vriend data wordt aangevuld in het bestand...

    : FOR  ${k}  IN RANGE  2  ${Aantal_Rijen}
        ## Haal de waarde (= URL) op uit Iedere regel van de Excel.
    \   ${URL_Vriend_Profiel_Pag}=  GetURL  ${k}

        ## Open de vrienden pagina
    \   Go to  ${URL_Vriend_Profiel_Pag}

        ## Klik naar de <info pagina> van de jarige job.
    \   click link  xpath://ul[@data-referrer='timeline_light_nav_top']//a[@data-tab-key='about']
        ## Klik naar de <contact gegevens pagina> van de jarige job.
    \   click link  xpath://a[@data-testid='nav_contact_basic']

        ## Lees het TypeVriend uit via xpath.
    \   ${TypeVriend}=  SeleniumLibrary.Get text  xpath://a[@data-unref='bd_profile_button']//i/u

        ## Controleer of het <geslacht> op de profiel pagina geslacht getoond wordt.
    \   ${CountGeslacht}=  Get Element Count  xpath://*[@id="pagelet_basic"]/div/ul/li[2]/div/div[2]/div/div/span

        ## Als <geslacht> niet getoond wordt, zet dan de waarde op "[LEEG]" en anders haald de juiste waarde op.
    \   ${Geslacht}=  Run keyword if  '${CountGeslacht}' == '1'  SeleniumLibrary.Get text  xpath://*[@id="pagelet_basic"]/div/ul/li[2]/div/div[2]/div/div/span
    \   ...  ELSE  run keyword  Set variable  [LEEG]

        ## Controleer of de <geboortedatum> op de profiel pagina geslacht getoond wordt.
    \   ${CountGeboortedatum}=  Get Element Count  xpath://li/div/div[2]/div/div/span[contains(text(),'1') or contains(text(),'2')]

        ## Als <geboortedatum> niet getoond wordt, zet dan de waarde op "[LEEG]" en anders haald de juiste waarde op.
    \   ${Geboortedatum}=  Run keyword if  '${CountGeboortedatum}' == '1'  SeleniumLibrary.Get text  xpath://li/div/div[2]/div/div/span[contains(text(),'1') or contains(text(),'2')]
    \   ...  ELSE  run keyword  Set variable  [LEEG]

        ## Vul deze gegevens aan in Excel file in bestaande record.
    \   FillFriend  ${Geslacht}  ${Geboorte_Datum}  ${TypeVriend}  ${k}

        ## LOG TO CONSOLE. Voeg <ENTER> toe achter de regel d.m.v. ASCII 13 (13 = enter).
    \   log to console  ${k} - ${URL_Vriend_Profiel_Pag}.  \\13

        ## Melding plaatsen in RAPPORTAGE LOG. Voeg <ENTER> toe achter de regel d.m.v. ASCII 13 (13 = enter).
    \   log Many  ${k} - ${URL_Vriend_Profiel_Pag}.  \\13

    ## (FACEBOOK_RESOURCE) Roep functie <Uitloggen> aan vanuit 'Keywords'.
    Uitloggen en browser sluiten

    ## LOG TO CONSOLE.
    log to console  Uiloggen en browser sluiten.

*** Keywords ***