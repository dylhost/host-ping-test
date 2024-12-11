Credits for original template code https://github.com/johnwmintz/pinglist

# How to run
>curl -sL https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/dev/pinglist.sh | bash -s

# Optionally specify a country
>curl -sL https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/dev/pinglist.sh | bash -s -- -c CODE

Currently available countries:
>curl -sL https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/dev/pinglist.sh | bash -s -- -c GBR

>curl -sL https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/dev/pinglist.sh | bash -s -- -c SGP

# Features
- Outputs total & Average (good for determining how well your server is peered internationally)
- Outputs min/max
- Added https://looking.house/ database of test IPs. If you would like test files, look for the provider on their site
