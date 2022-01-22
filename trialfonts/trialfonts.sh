#!/bin/sh
set -e

# Usage:
#  sh trialfonts.sh [font name] [path to source directory] [output path]


echo "Start Generate Trial Fonts"

timestamp=$(date +%y%m)

FONT_TRIAL_NAME=$1
SOURCE_DIRECTORY=$2
OUTPUT_SUBDIRECTORY_NAME='trial-exports'

echo $FONT_TRIAL_NAME
# echo $SOURCE_DIRECTORY


if [ -z "$3" ]
then
	OUTPUT_DIRECTORY=$SOURCE_DIRECTORY/$OUTPUT_SUBDIRECTORY_NAME
else
	OUTPUT_DIRECTORY=$3	
fi

# echo $OUTPUT_DIRECTORY

FAMILY_NAME_SUFFIX='Trial'

mkdir -p $OUTPUT_DIRECTORY

function subsetFonts {
	echo "Subset Fonts"
	FORMAT=$1
	
	for FILE in $SOURCE_DIRECTORY/*.$FORMAT; do
		
		if test -f "$FILE"; then
		echo $FILE
			FONT=${FILE##*/}
			TYPE=${FONT##*.}
			NAME=${FONT%.*}
			pyftsubset $FILE --unicodes-file=subsetAllowedInTrial.txt --layout-features-='kern' --glyph-names --symbol-cmap --legacy-cmap --notdef-glyph --notdef-outline --recommended-glyphs --name-IDs='*' --name-legacy --name-languages='*' --recalc-bounds --ignore-missing-glyphs --output-file=$OUTPUT_DIRECTORY/$NAME.$TYPE
			echo Subset ${FONT}
		fi
	done
}
function renameFonts {
	echo "Rename Fonts"
	FORMAT=$1
	for FILE in $OUTPUT_DIRECTORY/*.$FORMAT; do
		if test -f "$FILE"; then
			FONT=${FILE##*/}
			python3 ../rename-font/rename-font.py "$FONT_TRIAL_NAME" $FILE
			mv $FILE "${FILE/.$FORMAT/-Trial.$FORMAT}"
			echo Rename $FONT
		fi
	done
}

function copyFonts {
	echo "Copy and Move Fonts"
	FORMAT=$1
	
	for FILE in $SOURCE_DIRECTORY/*.$FORMAT; do
		
		if test -f "$FILE"; then
		echo $FILE
		FILENAME="$(basename $FILE)"
			cp $FILE $OUTPUT_DIRECTORY/$FILENAME
		fi
	done
}

# subsetFonts 'otf'
# subsetFonts 'ttf'

copyFonts 'otf'
copyFonts 'ttf'

renameFonts 'otf'
renameFonts 'ttf'

echo "Done"