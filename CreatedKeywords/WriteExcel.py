## Import Package "Openpyxl" (ÉÉRST VIA PIP DOWNLOADEN EN INSTALLEREN)
import openpyxl

## Creëeer file.
File = openpyxl.Workbook()

## Ga na actieve tabblad.
FileTab = File.active

## Hernoem de default titel van het active tabblad naar onderstaande titel.
FileTab.title="De titel van dit tabblad..."

# Schrijf onderstaande waarde in dit tabblad weg, in cel A2.
FileTab['A2'].value="Deze waarde wordt in cel A2 weg geschreven."

## Creëer 2e tabblad in dezelfde file.
File.create_sheet(title="Titel van het 2e tabblad...")
Tabblad1 = File['Titel van het 2e tabblad...']
Tabblad1['B1']="06-17398344"

## Verwijder tabblad.
#File.remove(File['De titel van dit tabblad...'])

## Sla het aangemaakte workbook op als deze file.
File.save("C:/Users/Klaar/OneDrive/Bureaublad/TestDataWrite.xlsx")