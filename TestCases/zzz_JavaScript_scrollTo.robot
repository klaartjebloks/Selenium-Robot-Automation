*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${Browser}  edge
${URL}  https://www.funda.nl/

*** Test Cases ***
TC open page and scroll down
    Open Browser  ${URL}  ${Browser}
    Maximize Browser Window
    execute javascript  window.scrollTo(0,10000)
    sleep  5sec

*** Keywords ***