Credits for original template code https://github.com/johnwmintz/pinglist

# How to run
>curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/pinglist.sh  | bash -s

# Optionally specify a country
Note country codes are [ISO 3166-1 alpha-3 format](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3)
>curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/pinglist.sh | bash -s -- -c CODE

Examples:
>curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/pinglist.sh | bash -s -- -c GBR

>curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/pinglist.sh  | bash -s -- -c SGP

Any country code with servers in the list will work.

# Features
- Outputs total & Average (good for determining how well your server is peered internationally)
- Outputs min/max
- Added https://looking.house/ database of test IPs. If you would like test files, look for the provider on their site
- Option to select specific country to test (use ISO country codes, see examples above)
