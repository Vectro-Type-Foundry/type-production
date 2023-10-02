echo "Start Checking Fonts in ./src"

# sourcePath=$1
# outputPath=$2
sourcePath="./src/"
outputPath="./output/"

function runFontBakeryCheck {
  
  # echo $2
  for fileFullPath in $sourcePath*$1; do 
    if [ -e $fileFullPath ]
    then
      filename=`basename $fileFullPath`
      echo $filename
      # check-googlefonts
      fontbakery check-typenetwork $fileFullPath  --json "${outputPath}fontbakery-report-${filename}.json"
    fi
  done
}

runFontBakeryCheck .otf
runFontBakeryCheck .ttf

echo "Finished!"
