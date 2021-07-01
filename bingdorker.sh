#!/bin/bash
# Name     : Bing Dorker 2018
# Type     : -
# Vendor   : http://zerobyte.id/
# Version  : 2018.01
#
# Installation :
#   wget -O bingdorker.sh https://pastebin.com/raw/inDnkVhx;sed -i -e 's/\r$//' bingdorker.sh;chmod +x bingdorker.sh;
# Run :
#   ./bingdorker.sh

### YOU CAN CUSTOM HERE ###
JOBS=("weather", "maps", "about", "contact", "calendar", "movies", "entertainment", "animal", "sports", "news", "flights", "prince", "discover", "thesaurus", "bitcoin", "america", "venezuela", "indonesia", "machine", "technology", "soft", "software", "warehouse", "health", "healthy", "professor", "doctor", "university", "college", "website", "blog", "faculty", "machine", "world", "article", "asian", "europe", "asia", "australia", "science");
MAXDUP="5"; # Min 5
###########################

echo "                    ::     ";
echo " www.zerobyte.id  ,::'\    ";
echo "       __       ,::' ' \   ";
echo "     /'  '\'~~'~' \ /'\.)  ";
echo "  ,:(      )    /  |       ";
echo " ,:' \    /-.,,(   )       ";
echo "      ) /       ) /        ";
echo "      ||        ||    BING ";
echo "      (_\       (_\ DORKER ";
echo "-------- V 2018.01 --------";

if [[ -f "BINGJOB.FILE" ]];then
	rm BINGJOB.FILE
	touch BINGJOB.FILE
fi

function doBing() {
	DORK=$(echo ${1} | sed 's/=/%3D/g' | sed 's/?/%3F/g' | sed 's/\//%2F/g' | sed 's/ /+/g' | sed 's/"/%22/g' | sed 's/&/%26/g' | sed 's/:/%3A/g');
	WORD="${2}";
	TMPRES="${3}";
	MAXCPN="${4}";
	MAXARR="${5}";
	i=1;
	c=0;
	f=0;
	while true;
	do
		if [[ ${6} == "y" ]];then
			CURL=$(timeout 5 curl -s "https://www.bing.com/search?q=${DORK}+%22${WORD}%22&first=${i}" | grep -Po '<li class="b_algo"><h2><a href="\K.*?(?=")' | sed 's/:\/\//[]/g' | sed 's/\// /g' | sed 's/\[\]/:\/\//g' | awk '{print $1"/"}')
		else
			CURL=$(timeout 5 curl -s "https://www.bing.com/search?q=${DORK}+%22${WORD}%22&first=${i}" | grep -Po '<li class="b_algo"><h2><a href="\K.*?(?=")')
		fi
		for SITE in ${CURL};
		do
			if [[ -z $(cat ${TMPRES} | grep "${SITE}") ]];then
				((c++));
				echo "${SITE}" >> ${TMPRES}
				echo "INFO: *${SITE}";
			else
				((f++));
				echo -ne "";
			fi
			if [[ ${f} -eq ${MAXCPN} ]];then
				echo "D" >> BINGJOB.FILE;
				echo "INFO: [$(cat BINGJOB.FILE | wc -l)/${MAXARR}] Jobs Remaining";
				return 0;
			fi
		done
		let "i=i+10";
	done
}

TMPRES="BINGRESULTS.TMP";

if [[ -f "${TMPRES}" ]];then
	rm ${TMPRES}
	touch ${TMPRES};
fi

echo -ne "\n + Insert dork     : ";
read DORK;
echo -ne " + Save to file    : ";
read FILE;
echo -ne " + Domain-only [y] : ";
read DMNONLY;
echo "";

for WORD in "${JOBS[@]}";
do
	doBing "${DORK}" "${WORD}" "${TMPRES}" "${MAXDUP}" "${#JOBS[@]}" "${DMNONLY}"
done

if [[ -z ${FILE} ]];then
	FILE="bing-default.lst";
fi

cat ${TMPRES} | sort | uniq >> ${FILE}
echo "[DONE] Domains at ${FILE} with total $(cat ${FILE} | wc -l) lines.";
