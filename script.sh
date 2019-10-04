#!/bin/bash
function DirFil {
echo $1
if [ -f "$1" ]; then
	parseData $1
elif [ -d "$1" ]; then
	for file in $(ls $1)
	do
		DirFil $1/$file
	done
fi
}


function parseData {
file=$1
fileName=${1##*/}
EXT=${1##*.}
SIZE=$(stat -c%s "$file")
COEF=1024 
SIZEM=$(( $SIZE / $COEF )) 
DATE=$(date -r "$file")
TEMP=$fileName','$EXT','$DATE','$SIZEM' KB'
if [ "$EXT" == "mp4" ] || [ "$EXT" == "mp3" ] || [ "$EXT" == "mov" ] ; then
	TEMP=$TEMP','$(ffmpeg -i $file 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,//)
fi
TEXT="$TEMP"
echo $TEXT >> data.csv
}

IFS=$'\n'
TEXT="file,extention,creation date,size,length"
echo $TEXT >> data.csv
for file in $(ls -R)
do
	DirFil $file
done
