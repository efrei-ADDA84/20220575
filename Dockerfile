FROM ubuntu:latest

# RUN apk --no-cache add hadolint

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

COPY main.py .

RUN pip3 install --trusted-host pypi.python.org requests flask

EXPOSE 8081

CMD ["python3", "main.py"]