FROM python:3.10.4-alpine3.16

LABEL org.opencontainers.image.source=https://github.com/apinanyogaratnam/python-websockets

WORKDIR /app

COPY requirements.txt .
COPY main.py .

CMD ["python3", "main.py"]
