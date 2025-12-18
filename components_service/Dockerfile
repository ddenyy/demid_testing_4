FROM python:3.11 AS builder
WORKDIR /app

COPY requirements.txt .
RUN pip install --user -r requirements.txt

FROM python:3.11
WORKDIR /app

COPY --from=builder /root/.local /root/.local
COPY . .

ENV PATH=/root/.local:$PATH
EXPOSE 50052

CMD ["python", "-u", "main.py"]
