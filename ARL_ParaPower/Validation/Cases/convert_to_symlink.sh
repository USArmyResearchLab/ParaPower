#!/bin/sh
DOSDIR=Windows_Shortcuts_Converted_to_Symbolic_Links
echo $FILES
for FILE in `ls -1 *.lnk | sed -e"s/ /_S_/g" ` #| awk ' { print "\"" $0 "\"" } '`
do
  echo Process new file
  FILE=`echo $FILE | sed -e"s/_S_/ /g"`
  BASENAME=`echo $FILE | awk ' { print $1 } '`
  DOSPATH=`strings "$FILE" | grep $BASENAME` #  |grep -m1 '[A-Z]:\\.' | sed -e "s|\\|/|g" -e "s| |_|g" -e "s|[A-Z]:|/mnt|g"`
  DOSPATH=`echo $DOSPATH | sed -e"s/\\\\\/\//g" -e"s/ARL_ParaPower.Validation/|../" | cut -d"|" -f2 `
  #NEWNAME=`echo $FILE | sed -e"s/ /_/g" `
  if [ ! -d $DOSDIR ]; then
    mkdir $DOSDIR
  fi
  if [ -e $DOSPATH ]; then
    mv "$FILE" $DOSDIR
    ln -s $DOSPATH $BASENAME
    echo "Link created for $DOSPATH"
  else
    echo "Can't create link to $DOSPATH for $FILE"
  fi
done
