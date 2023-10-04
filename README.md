# Домашнее задание к занятию "`GitLab`" - `Шадрин Игорь`


### Задание 1
Что нужно сделать:

    Разверните GitLab локально, используя Vagrantfile и инструкцию, описанные в этом репозитории.
    Создайте новый проект и пустой репозиторий в нём.
    Зарегистрируйте gitlab-runner для этого проекта и запустите его в режиме Docker. Раннер можно регистрировать и запускать на той же виртуальной машине, на которой запущен GitLab.

В качестве ответа в репозиторий шаблона с решением добавьте скриншоты с настройками раннера в проекте.


### Решение 1
![runner](img/Clipboard01.jpg)

### Задание 2


1.    Запушьте репозиторий на GitLab, изменив origin. Это изучалось на занятии по Git.
2.    Создайте .gitlab-ci.yml, описав в нём все необходимые, на ваш взгляд, этапы.

В качестве ответа в шаблон с решением добавьте:

`файл gitlab-ci.yml для своего проекта или вставьте код в соответствующее поле в шаблоне`
`скриншоты с успешно собранными сборками.`


### Решение 2

![builds](img/Clipboard02.jpg)

```yml
stages:
  - test
  - check
  - build

test:
  stage: test
  image: golang:1.17
  script: 
   - go test .

check:
 stage: test
 image:
  name: sonarsource/sonar-scanner-cli
  entrypoint: [""]
 variables:
 script:
  - sonar-scanner -Dsonar.projectKey=hw1 -Dsonar.sources=. -Dsonar.host.url=http://gitlab.localdomain:9000 -Dsonar.login=sqp_c3c65988b682b750445436ff82258fb57dd91842

build:
  stage: build
  image: docker:latest
  when: on_success
  script:
   - docker build .

```