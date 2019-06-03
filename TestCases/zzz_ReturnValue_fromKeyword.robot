*** Settings ***
Library  SeleniumLibrary

*** Variables ***


*** Test Cases ***
TC get value from keyword
    ${ReturnTitle}=  Afbeelding plaatsen  https://www.funda.nl/  edge
    Log to console  ${ReturnTitle}
    input text  xpath://locator  ${RetrunTitle}

*** Keywords ***
Open browser en maximaliseer
    [Arguments]  ${URL}  ${Browser}
    Open Browser  ${URL}  ${Browser}
    sleep  2sec
    Maximize Browser Window
    sleep  2sec
    # Get title of page
    ${Title}=  get title
    # Command to set page title ready to return -> hiermee kun je de waarde van variabele ${Title} gaan gebruiken in je testcase.
    [return]  ${Title}