#!/bin/bash

output_format="stdout"
urls=()

while getopts "u:o:" opt; do
  case $opt in
    u) urls+=("$OPTARG") ;;
    o) output_format="$OPTARG" ;; 
    *) 
      echo "Usage: $0 -u <URL> [-u <URL> ...] -o <stdout|json>" 
      exit 1 
      ;;
  esac
done

if [ "${#urls[@]}" -eq 0 ]; then
  echo "Error: At least one URL must be specified with the -u option."
  echo "Usage: $0 -u <URL> [-u <URL> ...] -o <stdout|json>"
  exit 1
fi
