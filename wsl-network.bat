@echo off

netsh interface portproxy delete v4tov4 listenport=1081 listenaddress=172.30.144.1

netsh interface portproxy add v4tov4 listenaddress=172.30.144.1 listenport=1081 connectaddress=127.0.0.1 connectport=1081

netsh interface portproxy show v4tov4
