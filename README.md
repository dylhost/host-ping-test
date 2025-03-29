Credits for original template code https://github.com/johnwmintz/pinglist

# How to run
```
curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/pinglist.sh  | bash -s
```

## Flags
```
curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/pinglist.sh  | bash -s -- -flags
```
| Flag | Description |
| ---- | ----------- |
| -c | Specify country to test |
| -s | Specify sort flag (options below) |
| -t | Ping timeout (default 1s) |
| -d | Use listtest instead of list.txt |

### Countries Flags:
[ISO 3166-1 alpha-3 format](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3)

### Sort flags:
Default: Sort by ping (desending) 
1. Sort by ping (assending)
2. Sort by IP
3. Sort by host name
4. Sort by City
5. Sort by Country code

### Examples
Test all SGP hosts
```
curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/pinglist.sh  | bash -s -- -c SGP
```

Test Hosthatch Hosts
```
curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/pinglist.sh | bash -s -- -c HostHatch
```

Sort by country code
```
curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/pinglist.sh | bash -s -- -s 5
```
