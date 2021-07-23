#!/bin/sh
set -e

# Usage:
#  sh trialfonts.sh [path to source directory] [output path]


echo "Start Generate Trial Fonts"

timestamp=$(date +%y%m)

FONT_TRIAL_NAME=$1
SOURCE_DIRECTORY=$2
OUTPUT_SUBDIRECTORY_NAME='trial-exports'

if [ -z "$3" ]
then
	OUTPUT_DIRECTORY=$SOURCE_DIRECTORY/$OUTPUT_SUBDIRECTORY_NAME
else
	OUTPUT_DIRECTORY=$3	
fi

FAMILY_NAME_SUFFIX='Trial'

mkdir -p $OUTPUT_DIRECTORY

function subsetFonts {
	FORMAT=$1
	for FILE in $SOURCE_DIRECTORY/*.$FORMAT; do
		if test -f "$FILE"; then
			FONT=${FILE##*/}
			TYPE=${FONT##*.}
			NAME=${FONT%.*}
			pyftsubset $FILE --unicodes-file=subsetAllowedInTrial.txt --layout-features-='kern' --glyph-names --symbol-cmap --legacy-cmap --notdef-glyph --notdef-outline --recommended-glyphs --name-IDs='*' --name-legacy --name-languages='*' --recalc-bounds --output-file=$OUTPUT_DIRECTORY/$NAME.$TYPE
			echo Subset ${FONT}
		fi
	done
}

# function renameFonts {
# 	FORMAT=$1
# 	for MODFILE in $OUTPUT_DIRECTORY/*.$FORMAT; do
# 		if test -f "$MODFILE"; then
# 			FONT=${MODFILE##*/}
# 			TYPE=${FONT##*.}
# 			NAME=${FONT%.*}
# 			STYLE=${NAME##*-}
# 			FAMILY=${FONT%%-*}
# 			#Take file name and add spaces where uppercase
# 			sed 's/\([^[:blank:]]\)\([[:upper:]]\)/\1 \2/g' <<< "${FAMILY}" > "${MODFILE%.???}".txt
# 			sed ':a;N;$!ba;s/\n/ /g' ${MODFILE%.???}.txt > ${MODFILE%.???}-noline.txt
# 			#Turn spaced file name into variable
# 			FILECONTENTS=`cat ${MODFILE%.???}.txt`
# 			#Delete file that sed created
# 			rm ${MODFILE%.???}.txt ${MODFILE%.???}-noline.txt
# 			#Dump font name tables
# 			ttx -t name $MODFILE
# 			# #Use sed again to find and replace in name tables font name with font name + Trial
# 			sed -e "s:$FILECONTENTS:$FILECONTENTS $FAMILY_NAME_SUFFIX:g" ${MODFILE%.???}.ttx > ${MODFILE%.???}-$FAMILY_NAME_SUFFIX.ttx
# 			# #Use ttx to fuse new nametable
# 			ttx -m $MODFILE ${MODFILE%.???}-$FAMILY_NAME_SUFFIX.ttx
# 			#Remove original font file
# 			rm ${MODFILE%.???}.$FORMAT
# 			#Remove name table files
# 			rm -f ${MODFILE%.???}.ttx ${MODFILE%.???}-$FAMILY_NAME_SUFFIX.ttx
# 			echo ${FONT} Complete
# 		fi
# 	done
# }
# cd docs
# zip -r ${timestamp}_VeryCool_TrialFonts.zip VeryCool-TrialFonts


function renameFonts {
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

subsetFonts 'otf'
subsetFonts 'ttf'

renameFonts 'otf'
renameFonts 'ttf'

echo "Done"