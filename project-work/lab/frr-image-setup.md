Подготовка образа ВМ для работы с FRR

1. Выполняем базовую установку Debian
2. Установка необходимых пакетов:
  
  `apt install sudo vim`
  
3. Заменить пакет настройки сети на ifupdown2
  
  `apt install ifupdown2`

4. Установить пакет для управления мостом
  
  `apt install bridge-utils`
  
5. Добавить параметр, разрешающий маршрутизацию пакетов
в файле /etc/sysctl.conf паскомментировать строку `net.ipv4.ip_forward=1`

6. Установить FRR
  
  `apt instal frr`
  
7. В конфигурации FRR включить протокол BGP
  
  `sudo vi /etc/frr/daemons`
  ```
  [...]
  bgpd=yes
```