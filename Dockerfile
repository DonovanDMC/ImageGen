FROM python:3.6

ENV TZ=America/Chicago
ENV NEW_RELIC_NO_CONFIG_FILE=true
ENV NEW_RELIC_DISTRIBUTED_TRACING_ENABLED=true
ENV NEW_RELIC_LOG=stdout
ENV NEW_RELIC_APP_NAME="Imgen"

WORKDIR /tmp
RUN apt-get update && apt-get install -y lsof
ENV PIP_ROOT_USER_ACTION=ignore
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir gunicorn
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update && apt-get install -y lsof fonts-symbola
RUN apt-get install -y software-properties-common && add-apt-repository contrib && add-apt-repository non-free && apt-get update  && apt-get install -y ttf-mscorefonts-installer
WORKDIR /app

# modify ImageMagick policy file so that Textclips work correctly.
RUN sed -i 's/none/read,write/g' /etc/ImageMagick-6/policy.xml

ENTRYPOINT ["newrelic-admin", "run-program"]
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:3621", "-k", "gevent", "server:app"]
