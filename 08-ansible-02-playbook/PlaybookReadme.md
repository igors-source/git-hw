# VECTOR CLICKHOUSE ANSIBLE PLAYBOOK

Плейбук для установки Clickhouse, Vector на операционных системах типа Linux на базе rpm пакетов

# Системные требования

Плейбук разработан для запуска на дистрибутивах Linux с пакетным менеджером .rpm (fedora,redhat), архитектура x86_64
Необходимый набор пакетов для целевой машины соответствует требованиям Ansible для manage node:
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#managed-node-requirements

# Конфигурация

## Clichhouse

Файл конфигурации:
./group_vars/clickhouse/clickhouse.yml

Переменные:

clickhouse_version: - версия clickhouse
clickhouse_packages: - список пакетов для установки

## Vector

Файл конфигурации:
./group_vars/vector/vector.yml

Переменные:

vector_version: - версия vector
vector_architecture: - системная архитектура пакета vector

# Установка

Пример запуска плейбука:
``` ansible-playbook -i ./inventory/prod.yml site.yml -kK```bash
Ключи -kK используются для интерактивного запроса ввода пароля

# Tast Tags

clickhouse - установка clickhouse

vector - установка vector

# Templates:

Template файл:
./templates/vector.yaml.j2

Файл содержит базовый пример конфигурации Vector в формате yaml, устанавливается на целевой хост при запуске плейбука.
