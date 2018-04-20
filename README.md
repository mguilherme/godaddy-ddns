# Godaddy DNS
Simple script to update your GoDaddy DNS server to the IP address of your current internet connection.

### Usage

Add several entries to your __crontab__ (`crontab -e`) for each A record you wish to update:

```bash
*/30 * * * * /script/godaddy_ddns.sh personal example.com >> /script/godaddy_ddns.log
*/30 * * * * /script/godaddy_ddns.sh myftp    example.com >> /script/godaddy_ddns.log
```