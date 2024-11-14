# Домашнее задание к занятию «Конфигурация приложений» "Шадрин Игорь"


### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создать Deployment приложения, состоящего из контейнеров nginx и multitool.
2. Решить возникшую проблему с помощью ConfigMap.
3. Продемонстрировать, что pod стартовал и оба конейнера работают.
4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Решение 1

<details>

<summary> <h5>ConfigMap, Service, Volume</h5></summary>

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-multitool
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-multitool
  template:
    metadata:
      labels:
        app: nginx-multitool
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        volumeMounts:
        - name: simple-index
          mountPath: /usr/share/nginx/html/
        ports:
        - containerPort: 80
      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 8080
        env:
          - name: HTTP_PORT
            valueFrom:
              configMapKeyRef:
                name: problem-resolver
                key: HTTP_PORT
      volumes:
      - name: simple-index
        configMap:
          name: problem-resolver

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: problem-resolver
data:
  HTTP_PORT: '8080'
  index.html: |
    <html>
    <h1>Simple page</h1>
    </html>

---

apiVersion: v1
kind: Service
metadata:
  name: nginx-multitool-nodeport
  labels:
    app: nport
spec:
  ports:
  - name: nginx
    port: 80
    nodePort: 30080
    protocol: TCP
  - name: multitool
    port: 8080
    nodePort: 30081
    protocol: TCP
  selector:
    app: nginx-multitool
  type: NodePort

```

</details>


Запуск пода

![alt text](<img/pod start.jpg>)

Страница в браузере

![alt text](img/01.jpg)


### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.
2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
3. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.
4. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Решение 2


<details>

<summary> <h5>ConfigMap, Service, Volume, Secret</h5></summary>

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-cert
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-cert
  template:
    metadata:
      labels:
        app: nginx-cert
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        volumeMounts:
        - name: simple-index
          mountPath: /usr/share/nginx/html/
        ports:
        - containerPort: 80
      volumes:
      - name: simple-index
        configMap:
          name: index-page

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: index-page
data:
  index.html: |
    <html>
    <h1>Simple page part 2</h1>
    </html>


---

apiVersion: v1
kind: Service
metadata:
  name: s-front
spec:
  ports:
    - name: nginx
      protocol: TCP
      port: 80
      targetPort: 80
  selector:
    app: nginx-cert


---


apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: http-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: "nginx"
  tls:
  - hosts:
    - super.host
    secretName: nginx-secret
  rules:
  - host: super.host
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: s-front
            port:
              number: 80

---
    LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZB
    QVNDQktjd2dnU2pBZ0VBQW9JQkFRRHBzUEVMbDdoOWl2SHQKZmxCa1dvWFVBcTE4SS9JdWdOM2Zh
    SjFtdjZIRVp2WjBUcjFTM2R0WDAyeDVSUVpiZVFqa0FmNWlRd3U3V3NsOQpIa2J5NVBkd1doejJa
    djRMNmFaYTRVaTRhanZJTGU3WUlSKzV0RlFjZlhFN1NkWG9YOW9XRlcyRmdlcENEMDNhCmVhOXZH
    dldmNDFUMUx1c2VuZGNzMDJhVUt1UXNaVEU0L3c2ek1VaEcyOGJaSDV6bDQrUUJLM2twVUc1QUVn
    eHgKMkhCSWxZUFlWdFdZcFp0YVVSVi9pY0MyZDQzNkFEek00cW91R0Jza25DR2NlZ2swUGtPenR5
    YjM4bWNwbTR4egpyeXVXWHhXKzdGVjlTYlRMNVdhM0RlcVphdzhHOTVJQXBROUY3VlZNamhmWk1L
    UjNGNFY1c1l0ZUFKNVc1VC84CktFak5yOFQ1QWdNQkFBRUNnZ0VBQWIyay9ubkFqVFl4Wlkzc0Ur
    TGFhSVpzNmlKWm95L2cxendzaERiWHVzbXMKSGwrOGo1VlQ0MzFLWkdBWHJCMUVaUDR5UU9OcElx
    Z1JnTWlnWHl4dzk4S21UdmlWUlEyQTRYeTB2aXEzVDNTUwpsVzczU2l4dkJUQ0lYUW82V1RsUnll
    OG9panBkbXNpSjV0aGZKM3o1Z2RLWVpWWXJ4clJONlFKRWQ3WmQrSHZtClNpZEg2N2VrK0RIK3VT
    Q3dDYlFxaXNVeTk3TnFESXZRYVVmcUYrRzIvR2tnVkhJR2hCdGZtck9pcGN0UmwvY3IKYVZwb3po
    K2E0KzRTVTJpRGZNMXBkMEtNSENIQmRHNU5KVTlyQUsrZC8zY2k2VEEyRTllNUNRWGs3V0tEN3RW
    TgowdEhLNHFNa2QrNkgvZHFDd2JvN3p0blJTNDdQNktwYVlNeFV0NlVHd1FLQmdRRDdjQnpIcjVR
    V2QxRGgzRXVlCmtHbmtIQ2VRbFFwcVVDRFljc3dLc0YycEFCY1g1NmlPWkhieDhLaUM1WElWNXUy
    aVZIcTJuYnJQSFY1SEFmc0wKSzl1TmdqY2F1YzdHOUNtTE1YS2Z4Zzk2SEg2NzR0MWphanludC8v
    ZStIQ2ZSYWtsZDFMZWU0RW0vNUdQdnA1egpBNTFMSjdFRkpYS1lXcGpEMklsVjRodXM0UUtCZ1FE
    dDdtWDlRSVpNOGJDTUNtZ2xkUTBJVGExNnR5MThiME9KCjZuUzJkTXJBUVFYTlJNZVZmZ1FmMGFS
    VS84Q3NkeTNLUC91NnRhZzdpUjVuRDVOV2JlQit6MlBxZ0VDbmhtNEwKNUV1UFcyWUVKYUM0SDdL
    VG9SRi9PbGpQZEpUanVRWnFCa2dNRUFVR3R2aEtGVk4xQzA0d3VIdGJYQnpjcE4zVgpDMkFMVFYx
    REdRS0JnRUVxRUR0c2RNdlJ4b09TellKZDJTUEdiRGFiZWVTTnVjVi9Fd1NlS3RmMjd3VkNBN3hM
    CnEwd08zQTE0bTdXemNOa0dYZnRnSzU4cjlGZ2cya2hONkl2bk9KTFRueFNQQ1FsTEduTHdLT2l6
    NCtDYjdsYXEKbk9lMjF6aVpXTTdlaGZUdzFPaFdSK1dzakxRZGFnRlM2WHdsNEVuK0o1SDJ3T3JZ
    L3Ria1Q5bmhBb0dCQU5VeQpYU2tFZkZMTjdvaE5ldXkxYWF3YkRtdDdYOEswWUN4Z2JaeGdJcDBL
    cG93OEtTcUc5R01la3NXbk5acFVZQzl1CkRiNUxzQ2RJd25sT3Q1TW1lWmFuZHJ4Vmw1bUZGMjZJ
    Ymp4U2hhTUpwRzNYMlVmM2Q1b3RTZzc2UTcrWnQybWgKbjBWUHhYRXkybUJubzVTcFFMTGZXNG1O
    akQ4WmE3ek9xSXo0RWExaEFvR0FQTFA3djgrQk91Q0RtczNqREQ5bQp1dlpVNmphdlZVdzZ2WEo3
    YnB1OXpJbzI3MUhDTlpadmZvN05BRi9tS1pGQWtOM3dxUW43SGFvTVM0NUV5VnZ1CnZSUXVFRVBo
    eE56Zk9DVVdZVEU2RXdPOS9pN2NDTDdodDgzUnJ4a1JrZGFJSitaRUllZVVWa0Y2TVcvdGZEQlIK
    djU5Y1NWT0tzN1d4VmdxcXIzSG80MjA9Ci0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0K
```

</details>

Генерация сертификатов

```shell
penssl req -x509 -days 300 -nodes -newkey rsa:2048 -keyout ./hw.key -out hw.crt
```
Кодирование в base64

```shell
cat ./hw.key | base64
cat ./hw.crt | base64
```

Браузер ругается на самоподписаный сертификат

![alt text](img/crt.jpg)

Вывод результата

![alt text](<img/crt appl.jpg>)