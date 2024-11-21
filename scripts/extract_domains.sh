#!/bin/bash

extract_domains() {
  local urls="$1"
  
  echo "$urls" | grep -oP 'https?://([a-zA-Z0-9.-]+)' | cut -d'/' -f3 | tr '[:upper:]' '[:lower:]'
}

urls="http://tiktok.com
https://ads.faceBook.com.
https://sub.ads.faCebook.com
api.tiktok.com
Google.com.
aws.amazon.com"

extract_domains "$urls"
