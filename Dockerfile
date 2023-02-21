FROM python:3.6

WORKDIR /tmp
RUN apt-get update && apt-get install -y lsof
ENV PIP_ROOT_USER_ACTION=ignore
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir gunicorn
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
WORKDIR /app

CMD gunicorn -w 2 -b 0.0.0.0:3621 -k gevent server:app
