# Базовый image
FROM python:3.10-alpine

# Переменные, используемые для создания окружения, в котором запустится приложение
ARG USER=app 
ARG UID=1001
ARG GID=1001

# Установка фреймворка
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Создание пользователя операционной системы и его домашнего каталога
RUN addgroup -g ${GID} -S ${USER} \
   && adduser -u ${UID} -S ${USER} -G ${USER} \
   && mkdir -p /app \
   && chown -R ${USER}:${USER} /app
USER ${USER}

# Переход в каталог /app
WORKDIR /app

# Переменные окружения, необходимые для запуска web-приложения
ENV FLASK_APP=server.py \
   FLASK_RUN_HOST="0.0.0.0" \
   FLASK_RUN_PORT="9057" \
   PYTHONUNBUFFERED=1

# Копирование кода приложения в домашний каталог
COPY --chown=$USER:$USER server.py /app
ADD --chown=$USER:$USER templates /app/templates
COPY --chown=$USER:$USER static /app/static

# Публикация порта, который прослушивается приложением
EXPOSE 9057

# Команда запуска приложения
CMD ["flask", "run"]