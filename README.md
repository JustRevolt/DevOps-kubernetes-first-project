# Kubernetes project

## 1. Создание веб-сервера

В качестве веб-сервера используется веб-приложение на Flask.

1. `server/server.py` - файл веб-приложение
2. `server/static/css/style.css` - файл css со стилями
3. `server/templates` - каталог с html страницами веб-приложения
4. Для тестирования приложения была создана клиентская часть: `client/client.py`

## 2. Docker

1. Создал Dockerfile для сервера
2. Создал Dockerfile для клиента
3. Создал `docker-compose.yml`

### Docker image

1. Для сбора Docker image **сервера** можно использовать команду:
    ```
    docker build -t sergeytabunschik/server:1.0.0 --network host -t sergeytabunschik/server:latest server
    ```

2. Для сбора Docker image **клиента** можно использовать команду:
    ```
    docker build -t sergeytabunschik/client:1.0.0 --network host -t sergeytabunschik/client:latest client
    ```

3. Для сбора Docker image **сервера** и **клиента** можно использовать команду:
    ```
    docker compose build
    ```

### Docker container

1. Для запуска Docker container **сервера** можно использовать команду:
    ```
    docker run -ti --rm -p 9057:9057 --name server --network host sergeytabunschik/server:1.0.0
    ```

2. Для запуска Docker container **сервера** и **клиента** можно использовать команду:
    ```
    docker compose up
    ```

### Docker hub

Выложил Docker image сервера на Docker hub.

Ссылка: https://hub.docker.com/r/sergeytabunschik/server/

## 3. Kubernetes

1. Создал Kubernetes Deployment manifest `deployment-app.yaml`, в котором используются Probes:
    
    1. startupProbe
    2. livenessProbe
    3. readinessProbe

2. Для деплоя приложения с помощью Kubernetes создан `Makefile`.

    1. `make deploy`:
        
        1. запускает minikube
        2. устанавливает Deployment manifest в кластер Kubernetes
        3. проверяет статус установки Deployment

    2. `make deployment-info` - выводит результат команды:

    ```
    $ kubectl describe deployment web

    Name:                   web
    Namespace:              default
    CreationTimestamp:      Wed, 17 May 2023 22:04:23 +0300
    Labels:                 app=web-server
    Annotations:            deployment.kubernetes.io/revision: 1
    Selector:               app=web-server
    Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
    StrategyType:           RollingUpdate
    MinReadySeconds:        0
    RollingUpdateStrategy:  1 max unavailable, 1 max surge
    Pod Template:
    Labels:  app=web-server
    Containers:
    web-server:
        Image:        sergeytabunschik/server:1.0.0
        Port:         9057/TCP
        Host Port:    0/TCP
        Liveness:     http-get http://:serverport/ delay=15s timeout=1s period=20s #success=1 #failure=3
        Readiness:    http-get http://:serverport/ delay=0s timeout=1s period=10s #success=1 #failure=5
        Startup:      http-get http://:serverport/ delay=0s timeout=1s period=10s #success=1 #failure=15
        Environment:  <none>
        Mounts:       <none>
    Volumes:        <none>
    Conditions:
    Type           Status  Reason
    ----           ------  ------
    Available      True    MinimumReplicasAvailable
    Progressing    True    NewReplicaSetAvailable
    OldReplicaSets:  <none>
    NewReplicaSet:   web-7dd7849774 (2/2 replicas created)
    Events:
    Type    Reason             Age   From                   Message
    ----    ------             ----  ----                   -------
    Normal  ScalingReplicaSet  47s   deployment-controller  Scaled up replica set web-7dd7849774 to 2

    ```

    3. `make port-forward` - обеспечивает доступ к web-приложению внутри кластера по порту 8080

    ![Personal Website by 8080 port](/img/Personal%20Website.png "Personal Website")