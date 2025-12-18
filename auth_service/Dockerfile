FROM python:3.11 AS builder
COPY requirements.txt .

RUN pip install --user -r requirements.txt

FROM python:3.11
WORKDIR /app

COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local:$PATH
EXPOSE 50051

CMD ["python", "-u", "main.py"]