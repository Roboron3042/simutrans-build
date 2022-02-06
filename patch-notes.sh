#!/bin/bash

PREV="";
CURRENT=HEAD;
WITH_FIXES=false;

while getopts 'p:c:f' opt; do
	case "$opt" in
		p)
			PREV="$OPTARG"
			;;
		c)
			CURRENT="$OPTARG"
			;;
		f)
			WITH_FIXES=true
			;;
		?|h)
			echo "Usage: $(basename $0) [-p previous revision] [-c current revision] [-f]"
			exit 1
	esac
done

if [ "$PREV" == "" ] 
then
	echo "Usage $(basename $0) [-p previous revision] [-c current revision] [-f]"
	exit 1
fi

echo -e "[b][size=14pt]Full changelog[/size][/b]\n" >> patch-notes.txt
echo -e "Here's the full list of changes since the last version." >> patch-notes.txt
echo -e "\n[b]Added[/b]" >> patch-notes.txt
svn log -r $CURRENT:$PREV | grep ADD | grep -v sqa | grep -v CODE | sed "s/.*ADD[^ ]\?/[*]/g" >> patch-notes.txt
echo -e "\n[b]Changed[/b]" >> patch-notes.txt
svn log -r $CURRENT:$PREV | grep CHG | grep -v sqa | grep -v CODE | sed "s/.*CHG[^ ]\?/[*]/g" >> patch-notes.txt


# too long to be displayed fully usually
if [ "$WITH_FIXES" = true ]
then
	echo -e "\n[b]Fixed[/b]" >> patch-notes.txt
	svn log -r $CURRENT:$PREV | grep FIX | grep -v sqa | grep -v CODE | sed "s/.*FIX[^ ]\?/[*]/g" >> patch-notes.txt
fi

# por si acaso
sed -i "s/.*: /[*] /g" patch-notes.txt
sed -i "s/ADD//g" patch-notes.txt
sed -i "s/CHG//g" patch-notes.txt
sed -i "s/FIX//g" patch-notes.txt
