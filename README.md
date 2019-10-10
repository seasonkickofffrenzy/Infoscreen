# Preconditions:
 - directory todo exists
 - todo contains files of shows we want to show next kickoff (content does not matter, just the filename. Just empty files are fine for developmet.)
 - each filename ends with - number.extention (e.G. filename "good anime - 1234.mkv")
 - the number has to be the id of this anime in anilist.co
 - no file/folder named infobeamer-package or infobeamer-package.zip may exist

run load-data.py

# Postconditions:
 - infobeamer-package is a extracted infobeamer-package and can be run via
   ``` info-beamer infobeamer-package ```
 - infobeamer-package.zip is the same as ZIP-file for upload to infobeamer hosted
