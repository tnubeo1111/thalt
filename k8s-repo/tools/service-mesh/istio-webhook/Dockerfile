FROM python:3.8-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py .
COPY certs /certs
ENV PYTHONUNBUFFERED=1
CMD ["python", "main.py"]