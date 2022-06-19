FROM python:3.6

WORKDIR /tmp
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir gunicorn
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update && apt-get install -y lsof
WORKDIR /app

CMD gunicorn -w 24 -b 0.0.0.0:3621 -k gevent server:app
