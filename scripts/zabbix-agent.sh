#!/bin/bash

USER=$1
USER_PASS=$2
UPGRADE=$3
AGENT_HOSTNAME=$4
AGENT_IP=$5
ZABBIX_SERVER_IP=$6

echo "=========================================="
echo "Настройка Zabbix Agent"
echo "Хост: $AGENT_HOSTNAME"
echo "IP агента: $AGENT_IP"
echo "Zabbix Server IP: $ZABBIX_SERVER_IP"
echo "=========================================="

apt update

echo "Создание пользователя $USER..."
useradd $USER -s /bin/bash -d /home/$USER
mkdir /home/$USER
chown -R $USER:$USER /home/$USER
echo "$USER    ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
usermod --password $(openssl passwd -6 $USER_PASS) root
usermod --password $(openssl passwd -6 $USER_PASS) $USER

if [ "$UPGRADE" == "true" ]; then 
    apt upgrade -y
fi

rm -Rf /etc/hosts
echo "127.0.0.1	localhost.localdomain	localhost" >> /etc/hosts
echo "$AGENT_IP	$AGENT_HOSTNAME.localdomain	$AGENT_HOSTNAME" >> /etc/hosts

echo "Установка Zabbix Agent..."
wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bdebian11_all.deb
dpkg -i zabbix-release_6.0-4+debian11_all.deb
apt update 
apt install zabbix-agent -y

sed -i "s/Server=127.0.0.1/Server=$ZABBIX_SERVER_IP/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=$ZABBIX_SERVER_IP/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=$AGENT_HOSTNAME/g" /etc/zabbix/zabbix_agentd.conf

echo 'UserParameter=custom.cpu.user.percent,top -bn1 | grep "Cpu(s)" | awk '\''{print 100 - $8}'\''' >> /etc/zabbix/zabbix_agentd.conf
echo 'UserParameter=custom.memory.pavailable,free | awk '\''NR==2{print $7*100/$2}'\''' >> /etc/zabbix/zabbix_agentd.conf
echo 'UserParameter=custom.python[*],python3 /etc/zabbix/custom_script.py $1 $2' >> /etc/zabbix/zabbix_agentd.conf
echo 'UserParameter=custom_echo[*],echo $1' >> /etc/zabbix/zabbix_agentd.d/test_user_parameter.conf

cat > /etc/zabbix/custom_script.py <<'EOF'
#!/usr/bin/env python3
import sys
import os
import re
import datetime

def main():
    if len(sys.argv) < 2:
        print("Usage: script.py <command> [argument]")
        return
    
    command = sys.argv[1]
    
    if command == "1":
        print("Кукушкина Марина Юрьевна")
    
    elif command == "2":
        now = datetime.datetime.now()
        print(now.strftime("%Y-%m-%d %H:%M:%S"))
    
    elif command == "-ping":
        if len(sys.argv) < 3:
            print("Error: need IP address or hostname")
            return
        result = os.popen("ping -c 1 " + sys.argv[2]).read()
        result_list = re.findall(r"time=(.*) ms", result)
        if result_list:
            print(result_list[0])
        else:
            print("0")
    
    elif command == "-simple_print":
        if len(sys.argv) < 3:
            print("Error: need text to print")
            return
        print(sys.argv[2])
    
    else:
        print(f"unknown input: {command}")

if __name__ == "__main__":
    main()
EOF

chmod +x /etc/zabbix/custom_script.py
systemctl restart zabbix-agent
systemctl enable zabbix-agent

echo "Настройка Zabbix Agent для $AGENT_HOSTNAME завершена!"
systemctl status zabbix-agent --no-pager
