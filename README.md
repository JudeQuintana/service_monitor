# What is it? 
Service Monitor is a mini framework PoC that auto restarts processes that have died for whatever reason via the service command. It has only been tested on CentOS 6.8 running as root.

# Getting Started

Enter the service_monitor directory and install the gems.

```
bundle install
```

Edit the config/services_config.yaml file with the service_name and the subsequent commands for start, stop and status for the service. The beginning of each section must start with a dash (-) followed by a new line.

WARNING:
Please be careful what commands are entered. They will be executed on the server and Service Monitor doesn't filter malicious commands out of the box.

```yaml

-
   service_name: mysql
   start_cmd: service mysqld start
   stop_cmd: service mysqld stop
   status_cmd: service mysqld status
-
   service_name: apache
   start_cmd: service httpd start
   stop_cmd: service httpd stop
   status_cmd: service httpd status
```

You may now run the bin/main.rb script from the directory that it's in.

```
cd service_monitor/bin
ruby main.rb
```

Sample output for running services
```
[>] 2016-08-29 16:15:01 +0000

[+] Status for mysql service
[+] mysqld (pid  23543) is running...

------------------------------
[>] 2016-08-29 16:15:01 +0000

[+] Status for apache service
[+] httpd (pid  1605) is running...

------------------------------
```

Sample output for stopped services
```
[>] 2016-08-29 15:50:01 +0000

[+] Status for mysql service
[+] mysqld (pid  23543) is running...

------------------------------
[>] 2016-08-29 15:50:01 +0000

[+] Status for apache service
[+] httpd is stopped
[+] apache needs a RESTART
[+] Stopping apache service
[+] Starting apache service
httpd: Could not reliably determine the server's fully qualified domain name, using ::1 for ServerName

------------------------------
```

Sample output for dead services
```
[>] 2016-08-29 15:45:02 +0000

[+] Status for mysql service
[+] mysqld (pid  23543) is running...

------------------------------
[>] 2016-08-29 15:45:02 +0000

[+] Status for apache service
[+] httpd dead but subsys locked
[+] apache needs a RESTART
[+] Stopping apache service
[+] Starting apache service
httpd: Could not reliably determine the server's fully qualified domain name, using ::1 for ServerName

------------------------------
```

# Automating via crontab

Configure the bin/run_via_cron.sh script that will be run via crontab. Fill in the paths that include /path/to/.

```bash
#!/bin/bash
PATH=$PATH:/sbin
cd /path/to/service_monitor/bin
/path/to/ruby main.rb
```

Edit the config/service_monitor_crontab.txt and fill in the paths that include /path/to
```txt
#runs serivce monitor every 5 minutes
*/5 * * * * /path/to/service_monitor/bin/run_via_cron.sh  >> /path/to/service_monitor/log/service_monitor.log 2>&1
```

Then install the crontab with:
```
crontab service_monitor_crontab.txt
```

Now the Service Monitor will run every 5 minutes and the restart services that are down. There's also a mechanism to prevent service flapping. It will shut down the script in the event that the services fail to start or stop and notify to investigate the service further.

# Web Server
 
 There are two ways to start the web server (Sinatra app).
 
 The first:
 
 ```
 cd service_monitor
 rackup -p 5004
 ```
 
 or you can use foreman
 ```
 gem install foreman
 
 cd service_monitor
 
 foreman start
 ```
 
 Once started, the Sinatra app will load the service_monitor and you can check the current status of the services:
  
  ```
  curl localhost:5004
  
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="utf-8">
    <title>service monitor</title>
  </head>
  
  <body>
  <h1>Current Service Health</h1>
  <h4>[>] 2016-08-29 15:47:03 +0000</h4>
  
    <p>[+] mysql</p>
    <p>[+] mysqld (pid  23543) is running...
  </p>
    <p>------------------------------</p>
    <p>[+] apache</p>
    <p>[+] httpd is stopped
  </p>
    <p>------------------------------</p>
  </body>
  </html>
  ```
