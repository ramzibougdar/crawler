# crawler
Bash script to retrieve and parse an XML sitemap file, then measure the response time for each URL contained in the sitemap.
It uses curl to download the contents of the sitemap and make HTTP requests for each URL, measuring the time it takes to get a response.
The results are displayed with the status of each URL (success or error) and the response time in seconds.

# Execution
./crawler.sh URL=https://www.example.com/sitemap.xml

