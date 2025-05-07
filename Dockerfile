FROM python:3.11

WORKDIR /app

COPY requirements.txt .
COPY unititled23.py .

RUN pip install -r requirements.txt

CMD ["python", "unititled23.py"]
