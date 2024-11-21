#!/bin/bash

# Default option for output format
output_format="stdout"
urls=()

# Parse command line arguments
while getopts "u:o:" opt; do
  case $opt in
    u) urls+=("$OPTARG") ;;  # Add URL to the urls array
    o) output_format="$OPTARG" ;;  # Set output format to either stdout or json
    *) 
      echo "Usage: $0 -u <URL> [-u <URL> ...] -o <stdout|json>" 
      exit 1 
      ;;
  esac
done

# Ensure at least one URL is provided
if [ "${#urls[@]}" -eq 0 ]; then
  echo "Error: At least one URL must be specified with the -u option."
  echo "Usage: $0 -u <URL> [-u <URL> ...] -o <stdout|json>"
  exit 1
fi

# Function to extract links from a URL
extract_links() {
  local url="$1"
  curl -s "$url" | grep -oP 'href="https?://[^"]+"' | sed 's/href="//g' | sed 's/"$//g' | sort -u
}
