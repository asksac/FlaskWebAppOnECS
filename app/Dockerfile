FROM python:3.9.4-alpine3.13

LABEL version="1.0"
LABEL description="Dockerfile to build a Python Flash webapp container"
LABEL maintainer="Sachin Hamirwasia <ssacha@amazon.com>"

WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt

ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
