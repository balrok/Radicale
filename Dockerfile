FROM python:3-alpine

# Version of Radicale (e.g. 3.0.x)
ARG VERSION=master

# Install dependencies
RUN apk add --no-cache \
      python3 \
      python3-dev \
      build-base \
      libffi-dev \
      ca-certificates \
      openssl \
      git
# Install dependencies for Radicale<2.1.9
RUN pip3 install passlib[bcrypt] git+https://github.com/Unrud/RadicaleInfCloud vobject python-dateutil pytz

# Remove build dependencies
RUN apk del \
      python3-dev \
      build-base \
      libffi-dev

# Install Radicale
ADD . .
RUN python3 setup.py install

# Persistent storage for data (Mount it somewhere on the host!)
VOLUME /var/lib/radicale
# Configuration data (Put the "config" file here!)
VOLUME /etc/radicale
# TCP port of Radicale (Publish it on a host interface!)
EXPOSE 5232
# Run Radicale (Configure it here or provide a "config" file!)
CMD ["radicale", "--hosts", "0.0.0.0:5232"]
