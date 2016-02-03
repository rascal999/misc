#!/bin/bash

HOST=`hostname`
CURRENT_YEAR=`date +%Y`

if [[ "$HOST" == "laptop" ]]; then
   JOBS_DIR="/work/jobs"
else
   JOBS_DIR="/root/work/jobs"
fi

LAST_FIVE_MODIFIED_DIRS=`ls -ht ${JOBS_DIR}/${CURRENT_YEAR}/ | head -5`

TOOLS="zenity
gimp
scrot
"

for i in $TOOLS
do
   echo -n "Checking for $i .. "
   which $i 1>/dev/null
   if [[ $? != 0 ]]; then
      echo "not found"
      exit 1
   fi
   echo "done"
done

#if [[ "$HOST" != "kali" ]]; then
#   echo "Run from Kali box"
#   exit 1
#fi

for i in $LAST_FIVE_MODIFIED_DIRS
do
   JOB_SCREENSHOT_DIR=`readlink -f ${JOBS_DIR}/${CURRENT_YEAR}/$i`
   JOB_PIPE_CODE=`echo $JOB_SCREENSHOT_DIR | gawk -F '/' '{ print $NF }' | gawk -F '-' '{ print $1 }'`
   LAST_FIVE_MODIFIED_DIRS_ABSOLUTE="${LAST_FIVE_MODIFIED_DIRS_ABSOLUTE}
${JOB_SCREENSHOT_DIR}/${JOB_PIPE_CODE}-screenshots"
done

LAST_FIVE_MODIFIED_DIRS_ABSOLUTE="${LAST_FIVE_MODIFIED_DIRS_ABSOLUTE}
Other..."

echo "Debug"
echo "$LAST_FIVE_MODIFIED_DIRS_ABSOLUTE"

JOB_CURRENT_DIR=""
JOB_CURRENT_DIR=`zenity --list --height 270 --width 400 --text "Last five job directories (by mod time):" \
  --title="Rascal999 Screenshot Tool v0.1" \
  --column="Directory" \
   ${LAST_FIVE_MODIFIED_DIRS_ABSOLUTE}`

if [[ "${JOB_CURRENT_DIR}" == "Other..." ]]; then
   JOB_CURRENT_DIR=`zenity --file-selection --directory`
fi

if [[ "${JOB_CURRENT_DIR}" == "" ]]; then
   zenity --info --text "No job directory specified"
   exit 1
fi

# Wait for the zenity box to disappear
sleep 2

IMAGE_SCROT=`scrot '%Y-%m-%d-%s_$wx$h.png' -e 'echo \$f'`
mv ${IMAGE_SCROT} ${JOB_CURRENT_DIR}

# Launch gimp with image?
zenity --question --text "Launch GIMP with image?"

if [[ $? == 0 ]]; then
   gimp "${JOB_CURRENT_DIR}/${IMAGE_SCROT}"
fi
