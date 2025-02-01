# Домашнее задание к занятию «Подъём инфраструктуры в Yandex Cloud» - Оганесян Гор


### Задание 1 

**Выполните действия, приложите скриншот скриптов, скриншот выполненного проекта.**

От заказчика получено задание: при помощи Terraform и Ansible собрать виртуальную инфраструктуру и развернуть на ней веб-ресурс. 

В инфраструктуре нужна одна машина с ПО ОС Linux, двумя ядрами и двумя гигабайтами оперативной памяти. 

Требуется установить nginx, залить при помощи Ansible конфигурационные файлы nginx и веб-ресурса. 

Секретный токен от yandex cloud должен вводится в консоли при каждом запуске terraform.

Для выполнения этого задания нужно сгенирировать SSH-ключ командой ssh-keygen. Добавить в конфигурацию Terraform ключ в поле:


![Console](https://github.com/hovhannisyan-code/7-3-terraform/blob/master/img/screenshot_0.png)
![Yandex Cloud](https://github.com/hovhannisyan-code/7-3-terraform/blob/master/img/screenshot_1.png)
![Ansible Ping](https://github.com/hovhannisyan-code/7-3-terraform/blob/master/img/screenshot_2.png)

### Install nginx 
```bash
ansible-playbook -i hosts install-nginx.yml 
```
[Playbook](https://github.com/hovhannisyan-code/7-3-terraform/blob/master/install-nginx.yml)
![Ansible Nginx](https://github.com/hovhannisyan-code/7-3-terraform/blob/master/img/screenshot_3.png)