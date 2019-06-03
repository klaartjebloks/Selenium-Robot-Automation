import requests  ## installeren via PIP
import json  ## installeren via PIP
import jsonpath  ## installeren via PIP

#ArrayNaam = '{"K1":"value1","K2":"value2","K3":"value3"}'
#json_resultaat = json.loads(ArrayNaam)
#print(json_resultaat['K1'])

## Deze URL bevat de JSON string:
## {"page":2,"per_page":3,"total":12,"total_pages":4,"data":[{"id":4,"first_name":"Eve","last_name":"Holt","avatar":"https://s3.amazonaws.com/uifaces/faces/twitter/marcoramires/128.jpg"},
## {"id":5,"first_name":"Charles","last_name":"Morris","avatar":"https://s3.amazonaws.com/uifaces/faces/twitter/stephenmoon/128.jpg"},
## {"id":6,"first_name":"Tracey","last_name":"Ramos","avatar":"https://s3.amazonaws.com/uifaces/faces/twitter/bigmancho/128.jpg"}]}

## In een JSON editor ziet deze string er als volgt uit:
#{
#   "page":2,
#   "per_page":3,
#   "total":12,
#   "total_pages":4,
#   "data":[
#      {
#         "id":4,
#         "first_name":"Eve",
#         "last_name":"Holt",
#         "avatar":"https://s3.amazonaws.com/uifaces/faces/twitter/marcoramires/128.jpg"
#      },
#      {
#        "id":5,
#         "first_name":"Charles",
#         "last_name":"Morris",
#         "avatar":"https://s3.amazonaws.com/uifaces/faces/twitter/stephenmoon/128.jpg"
#      },
#      {
#         "id":6,
#         "first_name":"Tracey",
#        "last_name":"Ramos",
#        "avatar":"https://s3.amazonaws.com/uifaces/faces/twitter/bigmancho/128.jpg"
#      }
#   ]
#}

APIurl = "https://reqres.in/api/users?page=2"

## Do a request / Vraag op:
Antwoord1 = requests.get(APIurl)
#print(Antwoord1.text)

## Validate status code.
#assert Antwoord1.status_code==200

## Parse response into JSON format.
json_response=json.loads(Antwoord1.text)
#print(json_response)

## Apply JSON Path.
## Vraag waarde op van <total>.
x=jsonpath.jsonpath(json_response,'total')
print(x[0])
## Vraag de waarde op van <first_name> in de 2e lijn van de array.
y=jsonpath.jsonpath(json_response,'data[1].first_name')
print(y[0])

## Array uitlezen. Pak alle voornamen uit de array <data>.
for value in json_response['data']:
    print(value['first_name'])