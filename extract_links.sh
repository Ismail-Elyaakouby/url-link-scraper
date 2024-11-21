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

if [ "$output_format" == "stdout" ]; then
  for url in "${urls[@]}"; do
    links=$(extract_links "$url")
    base_domain=$(echo "$url" | sed -E 's|https?://([^/]+).*|\1|') 

    for link in $links; do
      if [[ $link == http* ]]; then
        echo "$link"
      else
        echo "https://$base_domain$link"
      fi
    done
  done
elif [ "$output_format" == "json" ]; then
  json_output="{"
  for url in "${urls[@]}"; do
    links=$(extract_links "$url")
    base_domain=$(echo "$url" | sed -E 's|https?://([^/]+).*|\1|')

    for link in $links; do
      if [[ $link == http* ]]; then
        full_link="$link"
      else
        full_link="https://$base_domain$link"
      fi

      # Extract base URL and path
      base_url=$(echo "$full_link" | sed -E 's|^(https?://[^/]+).*|\1|')
      path=$(echo "$full_link" | sed -E 's|https?://[^/]+(.*)|\1|')

      # Convert path into JSON array format
      path_array=$(echo "$path" | tr "/" "\n" | sed '/^$/d' | awk '{print "\"" $0 "\""}' | paste -sd, -)

      # Append to JSON output
      if [[ "$json_output" == "{" ]]; then
        json_output+="\"$base_url\": [$path_array]"
      else
        json_output+=", \"$base_url\": [$path_array]"
      fi
    done
  done
  json_output+="}"
  
  echo "$json_output" | sed -E ':a;N;$!ba;s/\n//g' | sed 's/], "/]\n/g'
fi
