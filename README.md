# Zabbix.2

# Домашнее задание к занятию "Система мониторинга Zabbix. Часть 2" Кукушкина Марина


## Задание 1

![Шаблон Задание 1](screenshots/Задание%201.png)

## Задание 2 - 3
## Задание 4
## Задание 5
## Задание 6
### Код скрипта



```bash
#!/bin/bash

case $1 in
    1)
        echo "Кукушкина Марина Юрьевна"
        ;;
    2)
        date "+%Y-%m-%d %H:%M:%S"
        ;;
    *)
        echo "Использование: $0 {1|2}"
        echo "  1 - ФИО"
        echo "  2 - Текущая дата"
        exit 1
        ;;
esac

exit 0

```

## Задание 7

### Python-скрипт 

```python
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
```

## Задание 8

## Задание 9*

### Файлы в репозитории

- [Vagrantfile](Vagrantfile) — основной файл конфигурации Vagrant
- [scripts/zabbix-agent.sh](scripts/zabbix-agent.sh) — скрипт для установки и настройки Zabbix Agent
