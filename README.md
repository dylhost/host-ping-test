Credits for original template code https://github.com/johnwmintz/pinglist

# How to run
>curl -sL https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/dev/pinglist.sh |bash -s

Specifying a country (uses https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3 codes)
>curl -sL https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/dev/pinglist.sh |bash -s -- -c CODE

Currently available countries:
>curl -sL https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/dev/pinglist.sh |bash -s -- -c GBR
>curl -sL https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/dev/pinglist.sh |bash -s -- -c SGP

# Features
- Outputs total & Average (good for determining how well your server is peered internationally)
- Outputs min/max
- Added https://looking.house/ database of test IPs. If you would like test files, look for the provider on their site

# Future feature
Country based list(s) / options (slowly adding lists to /countries, 

Output is in CSV format so likely can be analysed further via CSV if you like.
