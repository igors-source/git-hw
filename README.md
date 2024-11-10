# Домашнее задание к занятию «Хранение в K8s. Часть 1» "Шадрин Игорь"

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

### Решение 1

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment
  labels:
    app: nginx-busybox
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-busybox
  template:
    metadata:
      labels:
        app: nginx-busybox
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool:latest
        volumeMounts:
        - name: homework
          mountPath: /tmp

      - name: busybox
        image: busybox:1.28
        command: [ 'sh', '-c', 'while true; do echo "volume_homework_1" >> /tmp/hw; sleep 2;done' ]
        volumeMounts:
        - name: homework
          mountPath: /tmp
      volumes:
        - name: homework
          emptyDir: {}
```

![alt text](img/01.jpg)

### Задание 2


**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

### Решение 2
```yml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemonset-multitool
  labels:
    app: multitool
spec:
  selector:
    matchLabels:
      app: multitool
  template:
    metadata:
      labels:
        app: multitool
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        volumeMounts:
        - name: homework2
          mountPath: /tmp
      volumes:
        - name: homework2
          hostPath:
            path: /var/log
```

![alt text](img/02.jpg)