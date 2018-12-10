#!/bin/bash
 
touch VisitedPages.txt
 
cat pages  | while read -s line; do
    case $line in
        http*)
        wget -q -O newurl.html $line ||  echo "$line FAILED"
        if ! grep -q "$line" VisitedPages.txt ; then
            echo "$line INIT"
            echo "$line $(md5sum newurl.html | awk '{print $1}')" >> VisitedPages.txt
        else
            cat VisitedPages.txt | while read -s nline; do
                page=$(echo "$nline" | awk '{print $1}')
                if [ "$page" == "$line" ] ; then
                    old=$(echo "$nline" | awk '{print $2}')
                    refreshed=$(echo "$(md5sum newurl.html | awk '{print $1}')")
                    if [ "$refreshed" != "$old" ] ; then
                        echo "$page"
                    fi
                fi
            done
    fi  
    esac
 
done