FROM ubuntu:jammy

# Install necessary dependencies (python3, gcc, libc, libffi -> needed for twine)
RUN apt update && apt install -y python3 \
                        python3-pip \
                        python3-dev \
                        jq \
                        curl \
                        git \
                        bash \
                        ca-certificates \
                        && apt clean

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash

RUN apt update && apt -y install nodejs && apt -y upgrade && apt clean

RUN pip3 install --upgrade pip && pip3 install twine && pip3 cache purge

CMD ["bash"]
