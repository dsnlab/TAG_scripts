#!/bin/bash

source createJson_config.sh
echo "${subid}"

touch "${errorlog}"

cd $bidsdir

echo "YES" >> file

if [ "${converttask}" == "TRUE" ]; then
	echo -e "YAY" >> "yes.csv"
else
 	echo -e "NOOO" >> "no.csv"
fi
