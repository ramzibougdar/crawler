#!/bin/bash

# Check if a parameter was provided
if [ -z "$1" ]; then
    echo "Error : Please provide a URL as a parameter."
    echo "Usage : $0 URL=https://www.example.com/sitemap.xml"
    exit 1
fi

# Extract URL from parameter
if [[ "$1" =~ ^URL=(.+)$ ]]; then
    SITEMAP_URL="${BASH_REMATCH[1]}"
else
    echo "Error: Parameter must be in the format URL=https://www.example.com/sitemap.xml"
    exit 1
fi

# Download sitemap content
echo "Downloading the sitemap..."
SITEMAP_CONTENT=$(curl -s "$SITEMAP_URL")

# Check if the download was successful
if [ -z "$SITEMAP_CONTENT" ]; then
    echo "Error: Unable to download sitemap."
    exit 1
fi

# Extract URLs from a sitemap
echo "Extracting URLs..."
URLS=$(echo "$SITEMAP_CONTENT" | sed -n -e 's|.*<loc><!\[CDATA\[\(.*\)\]\]></loc>.*|\1|p')

# Checking URLs
if [ -z "$URLS" ]; then
    echo "Error: No URL found in sitemap."
    exit 1
fi

# Crawl each URL and measure the time
echo "Start crawling URLs..."
for URL in $URLS; do
    echo "Crawling: $URL"

    # Perform query with time measurement
    START_TIME=$(date +%s.%N) # Timer starts
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
    END_TIME=$(date +%s.%N)   # End of timer

    # Calculation of time taken
    TIME_TAKEN=$(echo "$END_TIME - $START_TIME" | bc)

    if [ "$RESPONSE" -eq 200 ]; then
        echo "Success : $URL (Temps : ${TIME_TAKEN}s)"
    else
        echo "Error ($RESPONSE) : $URL (Temps : ${TIME_TAKEN}s)"
    fi
done

echo "Crawl completed."
