Подготовка образа ВМ для работы с FRR

1. Выполняем базовую установку Debian
2. Установка необходимых пакетов:
  
  `apt install sudo vim`
  
3. Заменить пакет настройки сети на ifupdown2
  
  `apt install ifupdown2`

4. Установить пакет для управления мостом
  
  `apt install bridge-utils`
  
5. Добавить параметры, разрешающие маршрутизацию пакетов. Скопировать файл 99frr_defaults.conf в каталог /etc/sysctl.d/ и выполнить команду:
   
   `sysctl -p /etc/sysctl.d/99frr_defaults.conf`

6. Установить FRR
  
  `apt instal frr frr-doc`
  
7.  При необходимости, в конфигурации FRR включить необходимые протоколы (BGP, OSPF)
  
  `sudo vi /etc/frr/daemons`
  ```
  [...]
  bgpd=yes
  ospfd=yes
  ```

8. Включить автостарт сервиса frr и перезагрузить сервис
   `systemctl enable frr.service`
   `systemctl restart frr.service`

9. Настраиваем права пользователя для управления FRR (login <frradmin> was created during OS setup)

   `usermod -a -G frr frradmin`
   `usermod -a -G frrvty frradmin`
   `usermod -s /usr/bin/vtysh frradmin`

10. Копируем на сервер и запускаем файл очистки debian-clear.sh
