#!/bin/bash

if [[ $# != 2 ]]; then
   echo "$0 <file> <searchTerm>"
   exit 1
fi

oIFS=$IFS
IFS=$'\n'

find $1 -name '*.docx' | while read -r i; do
   COUNT=`java -jar /work/scripts/tika-app-1.11.jar -t "$i" 2>/dev/null | grep --color -Ei "$2" | wc -l`
   if [[ $COUNT -ne 0 ]]; then
      echo "$COUNT instances found in $i"
   fi
done

IFS=$oIFS

exit 0
