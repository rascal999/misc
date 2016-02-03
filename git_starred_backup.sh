#!/bin/bash
user="rascal999"
pages=$(curl -I https://api.github.com/users/$user/starred | sed -nr 's/^Link:.*page=([0-9]+).*/\1/p')
 
for page in $(seq 0 $pages); do
curl "https://api.github.com/users/$user/starred?page=$page&per_page=100" | awk '/^ {4}"html_url"/&&$0=$4' FS='"' |
while read rp; do
#rp1=`echo $rp | sed 's#https://#https://rascal999:ohshitisthismypasswordno@#g'`
git -C /home/user/git clone $rp1
done
done 
