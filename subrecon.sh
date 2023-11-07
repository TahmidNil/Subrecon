#!/bin/bash

if [ -z $1 ]
then
        echo './subrecon.sh <list of domains>'
        exit 1
fi

echo 'FINDING SUBDOMAINS...'

while read line
do
        for var in $line
        do
                echo 'enumerating:' $var

                amass enum -passive -d $var > out1
                cat out1 >> subs1

                rm out1
        done
done < $1

sort -u subs1 > all_subs
rm subs1
echo 'saved subdomains to all_subs'

echo 'FINDING LIVE HOSTS...'

cat all_subs | httpx -silent > live_subs
echo 'saved live hosts to live_subs'

echo 'CHECKING FOR SUBDOMAIN TAKEOVER...'

subjack -w all_subs -a

echo 'DONE'

