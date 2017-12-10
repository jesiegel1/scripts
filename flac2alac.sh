#!/bin/bash

function flac2alac_dir {
  if [[ -z "$outname" ]]; then
    for f in "$inpath"/*.flac; do
        ffmpeg -i "$f" -acodec alac "${f%.flac}.m4a"
    done
  else
    local dirname=$(basename "$inpath")
    local newpath="$outpath/$outname/$dirname"
    mkdir -p "$newpath"
    for f in "$inpath"/*.flac; do
        filename=$(basename "$f")

        ffmpeg -i "$f" -acodec alac "$newpath/${filename%.flac}.m4a"
    done
  fi
}

function flac2alac_file {
  if [[ -z "$outname" ]]; then
    ffmpeg -i "$inpath" -acodec alac "${inpath%.flac}.m4a"
  else
    ffmpeg -i "$inpath" -acodec alac "$outpath/${outname%.*}.m4a"
  fi
}

inpath=""
outpath=""
outname=""

while getopts ":i:o:" opt; do
  case $opt in
    i)
      inpath="$OPTARG"
      ;;
    o)
      outpath="$(dirname $OPTARG)"
      outname="$(basename $OPTARG)"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [[ -e "$inpath" ]]; then
  if [[ -d "$inpath" ]]; then
    flac2alac_dir
  elif [[ -f "$inpath" ]]; then
    flac2alac_file
  else
    echo "$inpath is neither a file nor a directory" >&2
    exit 1
  fi
else
  echo "Could not find input source $inpath" >&2
  exit 1
fi
