FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY transaction_engine.py /app/

EXPOSE 8090

CMD ["python", "transaction_engine.py"]
