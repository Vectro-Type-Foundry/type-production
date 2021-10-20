echo "Start Generate Webfonts"

sourcePath=$1
outputPath=$2


function generateWebfontsInDirectory {
  # echo $1
  # echo $2
  for fileFullPath in $1/*$2; do 
    filename=`basename $fileFullPath`
    echo $filename
    fonttools ttLib.woff2 compress -o $3/${filename/$2/.woff2} $fileFullPath
  done
}

generateWebfontsInDirectory $sourcePath .otf $outputPath
# generateWebfontsInDirectory $sourcePath .ttf $outputPath

echo "Finished!"
