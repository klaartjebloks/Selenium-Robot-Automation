*** Settings ***
Library  SeleniumLibrary
Library  SikuliLibrary
Library  ../CreatedKeywords/Facebook_Keywords.py

*** Variables ***
#${email}=  klaartjebloks@gmail.com
#${wachtwoord}=  Eindhoven78
#${URL}=  http://www.facebook.com
#${Browser}=  Edge

*** Keywords ***
Open browser en login
    #[Documentation]  Facebook website openen en inloggen op Facebook.
    Set selenium speed  1sec

    # Open browser.
    [Arguments]  ${URL}  ${Browser}  ${email}  ${wachtwoord}
    Open Browser  ${URL}  ${Browser}
    # Maximaliseer browser window.
    Maximize Browser Window

    # Inloggen.
    # Veld <email adres> leeg maken.
    Clear Element Text  id:email
    # Waarde 'gebruikersnaam' invoeren in veld <email adres>.
    SeleniumLibrary.Input Text  id:email  ${email}
    # Waarde 'wachtwoord' invoeren in veld <wachtwoord>.
    SeleniumLibrary.Input Text  id:pass  ${wachtwoord}
    # Klik op de button <inloggen>.
    Click Button  xpath://input[@type='submit']

Inloggen
    #[Documentation]  Inloggen op Facebook.
    Set selenium speed  1sec

    [Arguments]  ${email}  ${wachtwoord}
    # Veld <email adres> leeg maken.
    Clear Element Text  id:email
    # Waarde 'gebruikersnaam' invoeren in veld <email adres>.
    SeleniumLibrary.Input Text  id:email  ${email}
    # Waarde 'wachtwoord' invoeren in veld <wachtwoord>.
    SeleniumLibrary.Input Text  id:pass  ${wachtwoord}
    # Klik op de button <inloggen>.
    Click Button  xpath://input[@type='submit']

Uitloggen en browser sluiten
    #[Documentation]  Uiloggen van Facebook en Facebook website sluiten.
    Set selenium speed  1sec

    # Klik op het meest reschtse item in de dondker blauwe menu balk boven in de pagina.
    click link  xpath://a[@id='pageLoginAnchor']
    # Kies voor het menu op het element <afmelden>.
    click link  xpath://a[@role='menuitem'][.='Afmelden']
    close browser

Evenementen Verjaardagen
    #[Documentation]  Ga naar de verjaardagskalender pagina.
    Set selenium speed  1sec

    # Klik naar de <info pagina> van de jarige job.
    click link  xpath://a[@data-tab-key='about']
    # Klik naar de <contact gegevens pagina> van de jarige job.
    click link  xpath://a[@data-testid='nav_contact_basic']
    # Klik naar honepage.
    click link  xpath://a[@title='Ga naar de Facebook-startpagina']
    # Klik naar <Evenementen>.
    click link  xpath://a[@data-testid='left_nav_item_Evenementen']
    # Klik naar <Verjaardagen>.
    click link  xpath://div[@data-key='birthdays']/a

FeliciteerJarigeJob
    #[Documentation]  Er is maar één vriend jarig vandaag om te feliciteren.

    ## Klik naar vriendschapspagina.
    click link  xpath://div[@id='birthdays_today_card']/following-sibling::div//a[@data-hovercard-prefer-more-content-show='1']
    ## Klik naar de profielpagina van JarigeJob.
    #click link  xpath://h2/a[contains(@href,'https://www.facebook.com/')]
    ## (FACEBOOK_RESOURCE) De waarden 'VriendType' en 'Leeftijd' worden bepaald.
     ## En hierna wordt in hetzelfde keyword het bijbehorende verjaardagsbericht geplaatst op de profielpagina van je jarige vriend.
    Bepaal VriendType en Leeftijd

    ## LOG TO CONSOLE.
    log to console  Vriend is gefeliciteerd.

    ## Melding plaatsen in RAPPORTAGE LOG.
    log  Vriend is gefeliciteerd.

FeliciteerIedereen
    #[Documentation]  Loop door alle jarigen van vandaag heen.
    [Arguments]  ${CountVandaagJarig}

    ${Count_Vandaag_Jarig}=  CountVandaagJarig  ${CountVandaagJarig}
    ${Count_Vandaag_Jarig_plus1}=  CountVandaagJarig_plus1  ${CountVandaagJarig}

    ## LOOP door alle jarige vrienden heen, om ze allemaal -ombeurten- te feliciteren.
    : FOR  ${i}  IN RANGE  1  ${Count_Vandaag_Jarig_plus1}
        ## Klik naar vriendschapspagina.
    \   click link  xpath:(//div[@id='birthdays_today_card']/following-sibling::div//a[@data-hovercard-prefer-more-content-show='1'])[${i}]
        ## Klik naar de profielpagina van JarigeJob.
    #\   click link  xpath://h2/a[contains(@href,'https://www.facebook.com/')]
        ## (FACEBOOK_RESOURCE) De waarden 'VriendType' en 'Leeftijd' worden bepaald.
        ## En hierna wordt in hetzelfde keyword het bijbehorende verjaardagsbericht geplaatst op de profielpagina's van je jarige vrienden.
    \   Bepaal VriendType en Leeftijd

        ## LOG TO CONSOLE.
    \   log to console  Vriend ${i} van ${Count_Vandaag_Jarig} is gefeliciteerd.

        ## Melding plaatsen in RAPPORTAGE LOG.
    \   log Many  Vriend ${i} van ${Count_Vandaag_Jarig} is gefeliciteerd.

        ## Keer terug naar de verjaardagen overzichtspagina.
    \   Evenementen Verjaardagen

Bepaal VriendType en Leeftijd
    #[Documentation]  Bepalen wat jouw relatie is m.b.t. deze vriendschap (Kennis / Vriend / Goede Vriend) EN Bepalen of jouw jarige vriend een man (ABRAHAM) of vrouw (SARAHA) is.
    Set selenium speed  1sec

    ${TypeVriend}=  SeleniumLibrary.Get text  xpath://div[@id='fbProfileCover']//a[@role='button']//i/u

    # Klik naar de <info pagina> van de jarige job.
    click link  xpath://a[@data-tab-key='about']
    # Klik naar de <contact gegevens pagina> van de jarige job.
    click link  xpath://a[@data-testid='nav_contact_basic']

    ${Geslacht}=  SeleniumLibrary.Get text  xpath://*[@id="pagelet_basic"]/div/ul/li[2]/div/div[2]/div/div/span

    # Zet de geboortedatum in de variabele ${Datum}.
    ${Datum}=  SeleniumLibrary.Get text  xpath://li/div/div[2]/div/div/span[contains(text(),'1') or contains(text(),'2')]

    # (FACEBOOK PYTHON) Deze functie "SplitDatum", hakt de geboorte datum <dd maand jjjj> in drieën en zet het geboortejaar in de variabele ${GeboorteJaar}.
    ${GeboorteJaar}=  SplitDatum  ${Datum}

    # Vraag het huidige jaartal op van het systeem.
    ${SysteemJaar}=  Get Time  year  NOW

    # (FACEBOOK PYTHON) Deze functie berekent de leeftijd van de Jarige Job. Als de leeftijd gelijk is aan 50 jaar,
    # dan zal de jarige job een afbeelding van Abraham of Sara ontvangen.
    ${Leeftijd}=  LeeftijdBepalen  ${SysteemJaar}  ${GeboorteJaar}

    ${Naam}=  SeleniumLibrary.Get text  xpath://span[@data-testid='profile_name_in_profile_page']/a

    ## LOG TO CONSOLE.
    run keyword if  '${Geslacht}' == 'Man'   log to console  Vandaag is ${Naam} jarig! Hij is een '${TypeVriend}' van jou en wordt ${Leeftijd} jaar.
    run keyword if  '${Geslacht}' == 'Vrouw'   log to console  Vandaag is ${Naam} jarig! Zij is een '${TypeVriend}' van jou en wordt ${Leeftijd} jaar.

    # Bepaal aan de hand van het 'TypeVriend' vat voor een verjaardagswens deze krijgt op de profiepagina van de jarige job.
    run keyword if  '${Leeftijd}' == '50'  Abraham_Sarah afbeelding uploaden  ${Geslacht}
    ...  ELSE IF  '${TypeVriend}' == 'Kennis' and '${Leeftijd}' != '50'  run keyword  Standaard afbeelding uploaden
    ...  ELSE IF  '${TypeVriend}' == 'Vriend' and '${Leeftijd}' != '50'  run keyword  Algemeen bericht schrijven
    ...  ELSE IF  '${TypeVriend}' == 'Goede Vriend' and '${Leeftijd}' != '50'  run keyword  Persoonlijk bericht schrijven
    ...  ELSE  run keyword  log  Vriend feliciteren is mislukt.

NiemandJarig
    #[Documentation]  Vandaag is er niemand van jouw vrienden jarig.
    Set selenium speed  1sec

    ## LOG TO CONSIOLE
    log to console  Vandaag zijn er geen vrienden jarig om te feliciteren.

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  Er is niemand jarig vandaag.

Abraham_Sarah afbeelding uploaden
    #[Documentation]  Vriend wordt vandaag 50 jaar!
    [Arguments]  ${Geslacht}
    Set selenium speed  1sec

    # Klik naar de <Tijdlijn pagina> van de jarige job.
    click link  xpath://a[@data-tab-key='timeline']

    # Klik in het tekstveld <bericht schrijven>
    click element  xpath://div[@data-contents='true']

    run keyword if  '${Geslacht}' == 'Man'  log to console  Abraham afbeelding wordt geplaatst...
    run keyword if  '${Geslacht}' == 'Vrouw'  log to console  Sarah afbeelding wordt geplaatst...

    # Als de variabele ${AbrahamSarah} gelijk is aan "Abraham", dan wordt de Abraham-afbeelding geplaatst en
    # is deze variabele gelijk aan "Sarah", dan wordt de Sarah-afbeelding geplaatst.
    run keyword if  '${Geslacht}' == 'Man'  Choose file  //input[@name='composer_photo[]']  C://Users/Klaar/OneDrive/Bureaublad/Facebook_Scripts/FB_Abraham.jpg
    run keyword if  '${Geslacht}' == 'Vrouw'  Choose file  //input[@name='composer_photo[]']  C://Users/Klaar/OneDrive/Bureaublad/Facebook_Scripts/FB_Sarah.jpg

    # Wacht maximaal 30 seconden met uitvoeren van volgende Keyword (klik op button <plaatsen>).
    # Maar als button <plaatsen> eerder wordt gevonden, zal het Keyword direct worden uitgevoerd.
    set selenium implicit wait  30sec

    # Klik op de button <plaatsen> om het bericht te plaatsen.
    click button  xpath://button[.='Plaatsen']

    ## LOG TO CONSOLE.
    run keyword if  '${Geslacht}' == 'Man'  log to console  Afbeelding voor jarige Abraham is succesvol geplaatst.
    run keyword if  '${Geslacht}' == 'Vrouw'  log to console  Afbeelding voor jarige Sarah is succesvol geplaatst.

    ## Melding plaatsen in RAPPORTAGE LOG.
    run keyword if  '${Geslacht}' == 'Man'  log Many  Afbeelding voor jarige Abraham is succesvol geplaatst.
    run keyword if  '${Geslacht}' == 'Vrouw'  log Many  Afbeelding voor jarige Sarah is succesvol geplaatst.

Standaard afbeelding uploaden
    #[Documentation]  Een 'Kennis' feliciteren met zijn/haar verjaardag vandaag.
    Set selenium speed  1sec

    # Klik naar de <Tijdlijn pagina> van de jarige job.
    click link  xpath://a[@data-tab-key='timeline']

    # Klik in het tekstveld <bericht schrijven>
    click element  xpath://div[@data-contents='true']

    # Klik in het tekstveld <bericht schrijven> en plaats 'algemene' foto.
    Choose file  //input[@name='composer_photo[]']  C://Users/Klaar/OneDrive/Bureaublad/Facebook_Scripts/FB_Gefeliciteerd.jpg

    # Wacht maximaal 30 seconden met uitvoeren van volgende Keyword (klik op button <plaatsen>).
    # Maar als button <plaatsen> eerder wordt gevonden, zal het Keyword direct worden uitgevoerd.
    set selenium implicit wait  30sec

    # Klik op de button <plaatsen> om het bericht te plaatsen.
    click button  xpath://button[.='Plaatsen']

    ## LOG TO CONSOLE.
    log to console  Standaard afbeelding voor de jarige is succesvol geplaatst.

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  Standaard afbeelding voor de jarige is succesvol geplaatst.

Algemeen bericht schrijven
    #[Documentation]  Een 'Vriend' feliciteren met zijn/haar verjaardag vandaag.
    Set selenium speed  1sec

    # Klik naar de <Tijdlijn pagina> van de jarige job.
    click link  xpath://a[@data-tab-key='timeline']

    # Klik in het tekstveld <bericht schrijven>
    click element  xpath://div[@data-contents='true']
    # Schrijf bericht in tekstveld <bericht schrijven>.
    press keys  xpath://div[@role='textbox']  Van harte gefeliciteerd met je verjaardag!
    # Voeg spatie toe achter de tekst, zodat de emotiecon niet aan het woordje 'van' zit vastgeplakt.
    # Dit doe ik met de ASCII tekst: 32 (32 = spatie)
    press key  xpath://div[@role='textbox']  \\32
    # Klik op de link <alle emoticons>.
    click link  xpath://a[@data-tooltip-content='Voeg een emoji toe']
    # Klik op de image <feest-emoticon>.
    click image  xpath://img[@src='https://static.xx.fbcdn.net/images/emoji.php/v9/t4e/1/28/1f973.png']
    # Klik in het tekstveld <bericht schrijven> om de emoticons te sluiten en de knop <plaatsen> te activeren
    click element  xpath://div[@role='textbox']
    # Klik knop <achtergrondjes> om alle mogelijke achtergronden te openen.
    click element  xpath://i[@class='_3ov1 img sp_j-uVEp6OsLM sx_1894ca']

    # Vraag het aantal seconden op van het systeem.
    ${system_sec}=  Get Time  sec  NOW
    #log to console  ${system_sec}

    # Als het aantal seconden tussen de 01 t/m 09 is, dan worden deze omgezet naar 1 t/m 9.
    ${sec}=	 Set Variable If
    ...  '${system_sec}' == '01'  1
    ...	 '${system_sec}' == '02'  2
    ...	 '${system_sec}' == '03'  3
    ...	 '${system_sec}' == '04'  4
    ...	 '${system_sec}' == '05'  5
    ...	 '${system_sec}' == '06'  6
    ...	 '${system_sec}' == '07'  7
    ...	 '${system_sec}' == '08'  8
    ...	 '${system_sec}' == '09'  9

    # Klik achtergrond die hoort bij het getal dat gelijk is aan de huidige seconde tijd.
    : FOR  ${i}  IN RANGE  1  10
    \    Run Keyword If  '${i}' == '${sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[2]/td[3]/div/a/div

    : FOR  ${i}  IN RANGE  10  20
    \    Run Keyword If  '${i}' == '${system_sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[3]/td[2]/div/a/div

    : FOR  ${i}  IN RANGE  20  30
    \    Run Keyword If  '${i}' == '${system_sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[8]/td[4]/div/a/div

    : FOR  ${i}  IN RANGE  30  40
    \    Run Keyword If  '${i}' == '${system_sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[8]/td[5]/div/a/div

    : FOR  ${i}  IN RANGE  40  50
    \    Run Keyword If  '${i}' == '${system_sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[9]/td[1]/div/a/div

    : FOR  ${i}  IN RANGE  50  60
    \    Run Keyword If  '${i}' == '${system_sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[9]/td[2]/div/a/div

    # Klik in het tekstveld <bericht schrijven> om de emoticons te sluiten en de knop <plaatsen> te activeren
    click element  xpath://div[@role='textbox']

    # Klik op de button <plaatsen> om het bericht te plaatsen.
    click button  xpath://button[.='Plaatsen']

    ## LOG TO CONSOLE.
    log to console  Algemeen bericht voor de jarige is succesvol geplaatst.

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  Algemeen bericht voor de jarige is succesvol geplaatst.

Persoonlijk bericht schrijven
    [Documentation]  Een 'Goede Vriend' feliciteren met zijn/haar verjaardag vandaag.
    Set selenium speed  1sec

    # De naam van de jarige job is te vinden in de profielpagina titel.
    ${PaginaTitle}=  get title

    # (FACEBOOK_KEYWORDS) Pak de éérste naam (= voornaam) uit de titel. Dit gebeurd met Python functie 'SplitTitle'.
    # Daarna kan de voornaam gebruikt worden om het bericht aan de jarige job persoonlijker te maken.
    ${Voornaam}=  SplitTitle  ${PaginaTitle}

    # Klik naar de <Tijdlijn pagina> van de jarige job.
    click link  xpath://a[@data-tab-key='timeline']

    # Klik in het tekstveld <bericht schrijven>
    click element  xpath://div[@data-contents='true']
    # Schrijf bericht in tekstveld <bericht schrijven>.
    press keys  xpath://div[@role='textbox']  Heej ${Voornaam}! Ik wens je een hééééééle fijne verjaardag vandaag!
    # Voeg spatie toe achter de tekst, zodat de emotiecon niet aan het woordje 'van' zit vastgeplakt.
    press key  xpath://div[@role='textbox']  \\32
    # Klik op de link <alle emoticons>.
    click link  xpath://a[@data-tooltip-content='Voeg een emoji toe']
    # Klik op de image <feest-emoticon>.
    click image  xpath://img[@src='https://static.xx.fbcdn.net/images/emoji.php/v9/t4e/1/28/1f973.png']
    # Klik in het tekstveld <bericht schrijven> om de emoticons te sluiten en de knop <plaatsen> te activeren
    click element  xpath://div[@role='textbox']
    # Klik knop <achtergrondjes> om alle mogelijke achtergronden te openen.
    click element  //i[@class='_3ov1 img sp_E0oHonVlduq sx_990e59']

    # Vraag het aantal seconden op van het systeem.
    ${system_sec}=  Get Time  sec  NOW
    #log to console  ${system_sec}

    # Als het aantal seconden tussen de 01 t/m 09 is, dan worden deze omgezet naar 1 t/m 9.
    ${sec}=	 Set Variable If
    ...  '${system_sec}' == '01'  1
    ...	 '${system_sec}' == '02'  2
    ...	 '${system_sec}' == '03'  3
    ...	 '${system_sec}' == '04'  4
    ...	 '${system_sec}' == '05'  5
    ...	 '${system_sec}' == '06'  6
    ...	 '${system_sec}' == '07'  7
    ...	 '${system_sec}' == '08'  8
    ...	 '${system_sec}' == '09'  9

    # Klik achtergrond die hoort bij het getal dat gelijk is aan de huidige seconde tijd.
    : FOR  ${i}  IN RANGE  1  10
    \    Run Keyword If  '${i}' == '${sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[2]/td[3]/div/a/div

    : FOR  ${i}  IN RANGE  10  20
    \    Run Keyword If  '${i}' == '${system_sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[3]/td[2]/div/a/div

    : FOR  ${i}  IN RANGE  20  30
     \    Run Keyword If  '${i}' == '${system_sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[8]/td[4]/div/a/div

    : FOR  ${i}  IN RANGE  30  40
    \    Run Keyword If  '${i}' == '${system_sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[8]/td[5]/div/a/div

    : FOR  ${i}  IN RANGE  40  50
    \    Run Keyword If  '${i}' == '${system_sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[9]/td[1]/div/a/div

    : FOR  ${i}  IN RANGE  50  60
    \    Run Keyword If  '${i}' == '${system_sec}'  click element  //div/div[3]/div[3]/table/tbody/tr[9]/td[2]/div/a/div

    # Klik in het tekstveld <bericht schrijven> om de emoticons te sluiten en de knop <plaatsen> te activeren
    click element  xpath://div[@role='textbox']

    # Klik op de button <plaatsen> om het bericht te plaatsen.
    click button  xpath://button[.='Plaatsen']

    ## LOG TO CONSOLE.
    log to console  Gepersonalisserd bericht voor ${Voornaam} is succesvol geplaatst.

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  Gepersonalisserd bericht voor ${Voornaam} is succesvol geplaatst.

WijzigVriendStatus_Vriend-Kennis
    [Arguments]  ${k}  ${VriendNaam}  ${Ontvrienden}
    ## Van VRIEND naar KENNIS:
    ## Klik op knop <Vrienden> (vriendschapstatus aanpassen).
    click link  xpath://a[@data-unref='bd_profile_button']
    ## Klik op het item <Kennissen>.
    click link  xpath://a[.='Kennissen']
    ## Klik op element in pagina dat niks doet: zodat het menu <vrienden> sluit.
    click element  xpath://div[@id='fbTimelineHeadline']

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  ${k}: De vriendstatus van ${VriendNaam} is aangepast van 'Vriend' naar 'Kennis'.
    ## LOG TO CONSOLE
    log to console  ${k}: ${VriendNaam} is aangepast naar Kennis.

    ## Als de waarde in Excel op <Y> staat, zal deze vriend worden ontvriend.
    run keyword if  '${Ontvrienden}' == 'Y'  VerwijderenAlsVriend  ${k}  ${VriendNaam}

WijzigVriendStatus_Vriend-GoedeVriend
    [Arguments]  ${k}  ${VriendNaam}  ${Ontvrienden}
    ## Van VRIEND naar GOEDE VRIEND
    ## Klik op knop <Vrienden> (vriendschapstatus aanpassen).
    click link  xpath://a[@data-unref='bd_profile_button']
    ## Klik op het item <Kennissen>.
    click link  xpath://a[.='Beste vrienden']
    ## Klik op element in pagina dat niks doet: zodat het menu <vrienden> sluit.
    click element  xpath://div[@id='fbTimelineHeadline']

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  ${k}: De vriendstatus van ${VriendNaam} is aangepast van 'Vriend' naar 'Goede Vriend'.
    ## LOG TO CONSOLE
    log to console  ${k}: ${VriendNaam} is aangepast naar Goede Vriend.

    ## Als de waarde in Excel op <Y> staat, zal deze vriend worden ontvriend.
    run keyword if  '${Ontvrienden}' == 'Y'  VerwijderenAlsVriend  ${k}  ${VriendNaam}

WijzigVriendStatus_Kennis-Vriend
    [Arguments]  ${k}  ${VriendNaam}  ${Ontvrienden}
    ## Van KENNIS naar VRIEND:
    ## Klik op knop <Vrienden> (vriendschapstatus aanpassen).
    click link  xpath://a[@data-unref='bd_profile_button']
    ## Klik op het item <Kennissen>.
    click link  xpath://a[.='Kennissen']
    ## Klik op element in pagina dat niks doet: zodat het menu <vrienden> sluit.
    click element  xpath://div[@id='fbTimelineHeadline']

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  ${k}: De vriendstatus van ${VriendNaam} is aangepast van 'Kennis' naar 'Vriend'.
    ## LOG TO CONSOLE
    log to console  ${k}: ${VriendNaam} is aangepast naar Vriend.

    ## Als de waarde in Excel op <Y> staat, zal deze vriend worden ontvriend.
    run keyword if  '${Ontvrienden}' == 'Y'  VerwijderenAlsVriend  ${k}  ${VriendNaam}

WijzigVriendStatus_Kennis-GoedeVriend
    [Arguments]  ${k}  ${VriendNaam}  ${Ontvrienden}
    ## Van KENNIS naar GOEDE VRIEND:
    ## Klik op knop <Vrienden> (vriendschapstatus aanpassen).
    click link  xpath://a[@data-unref='bd_profile_button']
    ## Klik op het item <Kennissen>.
    click link  xpath://a[.='Beste vrienden']
    ## Klik op element in pagina dat niks doet: zodat het menu <vrienden> sluit.
    click element  xpath://div[@id='fbTimelineHeadline']

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  ${k}: De vriendstatus van ${VriendNaam} is aangepast van 'Kennis' naar 'Goede Vriend'.
    ## LOG TO CONSOLE
    log to console  ${k}: ${VriendNaam} is aangepast naar Goede Vriend.

    ## Als de waarde in Excel op <Y> staat, zal deze vriend worden ontvriend.
    run keyword if  '${Ontvrienden}' == 'Y'  VerwijderenAlsVriend  ${k}  ${VriendNaam}

WijzigVriendStatus_GoedeVriend-Kennis
    [Arguments]  ${k}  ${VriendNaam}  ${Ontvrienden}
    ## Van GOEDE VRIEND naar KENNIS:
    ## Klik op knop <Vrienden> (vriendschapstatus aanpassen).
    click link  xpath://a[@data-unref='bd_profile_button']
    ## Klik op het item <Kennissen>.
    click link  xpath://a[.='Kennissen']
    ## Klik op element in pagina dat niks doet: zodat het menu <vrienden> sluit.
    click element  xpath://div[@id='fbTimelineHeadline']

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  ${k}: De vriendstatus van ${VriendNaam} is aangepast van 'Goede Vriend' naar 'Kennis'.
    ## LOG TO CONSOLE
    log to console  ${k}: ${VriendNaam} is aangepast naar Kennis.

    ## Als de waarde in Excel op <Y> staat, zal deze vriend worden ontvriend.
    run keyword if  '${Ontvrienden}' == 'Y'  VerwijderenAlsVriend  ${k}  ${VriendNaam}

WijzigVriendStatus_GoedeVriend-Vriend
    [Arguments]  ${k}  ${VriendNaam}  ${Ontvrienden}
    ## Van GOEDE VRIEND naar VRIEND:
    ## Klik op knop <Vrienden> (vriendschapstatus aanpassen).
    click link  xpath://a[@data-unref='bd_profile_button']
    ## Klik op het item <Kennissen>.
    click link  xpath://a[.='Beste vrienden']
    ## Klik op element in pagina dat niks doet: zodat het menu <vrienden> sluit.
    click element  xpath://div[@id='fbTimelineHeadline']

    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  ${k}: De vriendstatus van ${VriendNaam} is aangepast van 'Goede Vriend' naar 'Vriend'.
    ## LOG TO CONSOLE
    log to console  ${k}: ${VriendNaam} is aangepast naar Vriend.

    ## Als de waarde in Excel op <Y> staat, zal deze vriend worden ontvriend.
    run keyword if  '${Ontvrienden}' == 'Y'  VerwijderenAlsVriend  ${k}  ${VriendNaam}

WijzigVriendStatus_Vriend-Vriend
    [Arguments]  ${k}  ${VriendNaam}  ${Ontvrienden}
    ## Van VRIEND naar VRIEND
    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  ${k}: ${VriendNaam} had al de status 'Vriend', dus er is niks aangepast.
    ## LOG TO CONSOLE
    log to console  ${k}: ${VriendNaam} behoudt zelfde status: Vriend.

    ## Als de waarde in Excel op <Y> staat, zal deze vriend worden ontvriend.
    run keyword if  '${Ontvrienden}' == 'Y'  VerwijderenAlsVriend  ${k}  ${VriendNaam}

WijzigVriendStatus_GoedeVriend-GoedeVriend
    [Arguments]  ${k}  ${VriendNaam}  ${Ontvrienden}
    ## Van GOEDE VRIEND naar GOEDE VRIEND
    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  ${k}: ${VriendNaam} had al de status 'Goede Vriend', dus er is niks aangepast.
    ## LOG TO CONSOLE
    log to console  ${k}: ${VriendNaam} behoudt zelfde status: Goede Vriend.

    ## Als de waarde in Excel op <Y> staat, zal deze vriend worden ontvriend.
    run keyword if  '${Ontvrienden}' == 'Y'  VerwijderenAlsVriend  ${k}  ${VriendNaam}

WijzigVriendStatus_Kennis-Kennis
    [Arguments]  ${k}  ${VriendNaam}  ${Ontvrienden}
    ## Van GOEDE VRIEND naar GOEDE VRIEND
    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  ${k}: ${VriendNaam} had al de status 'Kennis', dus er is niks aangepast.
    ## LOG TO CONSOLE
    log to console  ${k}: ${VriendNaam} behoudt zelfde status: Kennis.

    ## Als de waarde in Excel op <Y> staat, zal deze vriend worden ontvriend.
    run keyword if  '${Ontvrienden}' == 'Y'  VerwijderenAlsVriend  ${k}  ${VriendNaam}

VerwijderenAlsVriend
    [Arguments]  ${k}  ${VriendNaam}
    ## ONTVIENDEN
    ## Klik op knop <Vrienden> (vriendschapstatus aanpassen).
    click link  xpath://a[@data-unref='bd_profile_button']
    ## Klik op het item <Kennissen>.
    click link  xpath://a[.='Verwijderen als vriend']
    ## Melding plaatsen in RAPPORTAGE LOG.
    log Many  ${k}: ${VriendNaam} is verwijderd als Facebook vriend.
    ## LOG TO CONSOLE
    log to console  ${k}: ${VriendNaam} is ontvriend van je profiel.