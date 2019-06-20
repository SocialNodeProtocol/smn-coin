#!/bin/sh
set -e

ROOTDIR=dist
BUNDLE=${ROOTDIR}/SocialNode-Qt.app
CODESIGN=codesign
TSMNDIR=sign.temp
TSMNLIST=${TSMNDIR}/signatures.txt
OUT=signature.tar.gz

if [ ! -n "$1" ]; then
  echo "usage: $0 <codesign args>"
  echo "example: $0 -s MyIdentity"
  exit 1
fi

rm -rf ${TSMNDIR} ${TSMNLIST}
mkdir -p ${TSMNDIR}

${CODESIGN} -f --file-list ${TSMNLIST} "$@" "${BUNDLE}"

for i in `grep -v CodeResources ${TSMNLIST}`; do
  TARGETFILE="${BUNDLE}/`echo ${i} | sed "s|.*${BUNDLE}/||"`"
  SIZE=`pagestuff $i -p | tail -2 | grep size | sed 's/[^0-9]*//g'`
  OFFSET=`pagestuff $i -p | tail -2 | grep offset | sed 's/[^0-9]*//g'`
  SIGNFILE="${TSMNDIR}/${TARGETFILE}.sign"
  DIRNAME="`dirname ${SIGNFILE}`"
  mkdir -p "${DIRNAME}"
  echo "Adding detached signature for: ${TARGETFILE}. Size: ${SIZE}. Offset: ${OFFSET}"
  dd if=$i of=${SIGNFILE} bs=1 skip=${OFFSET} count=${SIZE} 2>/dev/null
done

for i in `grep CodeResources ${TSMNLIST}`; do
  TARGETFILE="${BUNDLE}/`echo ${i} | sed "s|.*${BUNDLE}/||"`"
  RESOURCE="${TSMNDIR}/${TARGETFILE}"
  DIRNAME="`dirname "${RESOURCE}"`"
  mkdir -p "${DIRNAME}"
  echo "Adding resource for: "${TARGETFILE}""
  cp "${i}" "${RESOURCE}"
done

rm ${TSMNLIST}

tar -C ${TSMNDIR} -czf ${OUT} .
rm -rf ${TSMNDIR}
echo "Created ${OUT}"
