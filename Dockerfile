FROM debian:stable-slim

# Install necessary dependencies (python3, gcc, libc, libffi -> needed for twine)
RUN apt update && apt install -y python3 \
                        python3-pip \
                        python3-dev \
                        jq \
                        curl \
                        git \
                        ca-certificates

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash

RUN apt update && apt -y install nodejs && apt clean

RUN pip3 install --upgrade pip && pip3 install twine

CMD ["bash"]
