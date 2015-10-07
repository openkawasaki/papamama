#!/bin/bash

# このスクリプトは、Google Docs上のデータをCSVでダウンロードし、
# 結合、csv2geojsonでgeojsonに変換します。
# 動作にはnode.jsおよびcsv2geojsonのインストールが必要です。
# csv2geojsonのインストールは
# https://github.com/openkawasaki/papamama/wiki/GeoJSON%E3%81%B8%E3%81%AE%E5%A4%89%E6%8F%9B%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6
# をご覧ください

# csv2geojsonのパス（環境に合わせて修正してください）
CMD="/Users/daijiro/Sites/csv2geojson/csv2geojson";


# 以下は変更しないでください
ID="1wcKzZPd8gFnORUynqZUF5WXzZilLE3wqbDF9MBJMMA4";
BASE="https://docs.google.com/spreadsheets/d/${ID}/export?format=csv&id=${ID}&gid=";
GEOJSON="../data/nurseryFacilities.geojson";

DIR=./csv/
ALL=${DIR}all.csv
TEMP=${DIR}temp.csv
HEADER=header
LOG=${DIR}cmd.log

GIDS=(
	"2096853833"
	"1898655938"
	"2884537"
	"973798039"
	"1334772284"
	"1500086315"
	"1513626499"
	"1109938430"
	"1357964101"
	"1863141824"
);
NAMES=(
	"kawasaki.csv"
	"saiwai.csv"
	"nakahara.csv"
	"takatsu.csv"
	"miyamae.csv"
	"tama.csv"
	"aso.csv"
	"onakama.csv"
	"nintei.csv"
	"chiiki.csv"
);


rm -fr ${DIR}
mkdir -p ${DIR}

for (( I = 0; I < ${#GIDS[@]}; ++I ))
do
	wget ${BASE}${GIDS[$I]} -O ${DIR}${NAMES[$I]}
done

for (( I = 0; I < ${#NAMES[@]}; ++I ))
do
	tail -n `wc -l ${DIR}${NAMES[$I]} | awk '{ print $1 }'` ${DIR}${NAMES[$I]} >> ${TEMP}
	echo >> ${TEMP}
done

HID=1
cp ${HEADER} ${ALL}
cat ${TEMP} | while read line
do
	echo ${HID}${line} >> ${ALL}
	HID=`expr $HID + 1`
done


${CMD} --lat Y --lon X  ${ALL} > ${GEOJSON} 2> ${LOG}
if [ -s ${LOG} ];then
	echo "error occurred. see ${LOG} file."
fi
