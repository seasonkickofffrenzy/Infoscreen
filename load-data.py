#!/usr/bin/python3
import requests
from os import listdir, mkdir, chdir
import json
from shutil import copyfile
import zipfile

def doAnilistRequest(animeId):
  query = '''
  query ($id: Int) {
    Media(id: $id) {
      id
      title {
        romaji
        english
        native
      }
      description
      coverImage {
        extraLarge
        color
      }
      isAdult
    }
  }
  '''
  # Define our query variables and values that will be used in the query request
  variables = {
      'id': animeId
  }
  url = 'https://graphql.anilist.co'
  # Make the HTTP Api request
  response = requests.post(url, json={'query': query, 'variables': variables})
  return response.json()

print("Making dir...")
mkdir("infobeamer-package")
mkdir("covers")
chdir("infobeamer-package")

print("Copying infobeamer-code and metadata...")
for i in listdir("../infobeamer-package-template"):
  print("  ",i)
  copyfile("../infobeamer-package-template/"+i, i)

print("Loading data...")
data = dict()
for i in listdir("../todo"):
  print("  ",i)
  animeId = i.split("-")[-1].split(".")[0].strip()
  result = doAnilistRequest(animeId)["data"]["Media"]
  data[animeId] = result

  try:
    imageUrl = result["coverImage"]["extraLarge"]
    filename = imageUrl.split("/")[-1]
    imageRequest = requests.get(imageUrl)
    with open(filename, 'wb') as f:
      f.write(imageRequest.content)
    with open("../covers/"+i+".png", 'wb') as f:
      f.write(imageRequest.content)
  except KeyError:
    print("no image found")

print("Writing JSON...")
with open('data.json','w') as file:
  json.dump(data, file, sort_keys=True, indent=4, ensure_ascii=False)


from os import listdir
import zipfile
print("Writing ZIP-File...")
zipf = zipfile.ZipFile('../infobeamer-package.zip', 'w', zipfile.ZIP_DEFLATED)
for i in listdir("."):
  print("  ",i)
  zipf.write(i)

zipf.close()
