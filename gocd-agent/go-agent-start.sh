#!/bin/bash

GO_SERVER=${GO_SERVER:-go-server}

COLOR_START="[01;34m"
COLOR_END="[00m"

echo -e "${COLOR_START}Starting Go Agent to connect to server $GOCD_SERVER_ADDR:$GOCD_SERVER_PORT ...${COLOR_END}"
sed -r -i "s/^(GO_SERVER)=(.*)/\1=\$GOCD_SERVER_ADDR/g" /etc/default/go-agent
sed -r -i "s/^(GO_SERVER_PORT)=(.*)/\1=\$GOCD_SERVER_PORT/g" /etc/default/go-agent
sed -i -e 's/DAEMON=Y/DAEMON=N/' /etc/default/go-agent /etc/default/go-agent

mkdir -p /var/lib/go-agent/config
/bin/rm -f /var/lib/go-agent/config/autoregister.properties

AGENT_KEY="${AGENT_KEY:-123456789abcdef}"
echo "agent.auto.register.key=$AGENT_KEY" >/var/lib/go-agent/config/autoregister.properties
if [ -n "$AGENT_RESOURCES" ]; then echo "agent.auto.register.resources=$AGENT_RESOURCES" >>/var/lib/go-agent/config/autoregister.properties; fi

/sbin/setuser go /etc/init.d/go-agent start
