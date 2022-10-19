FROM node:16-bullseye-slim

# Install necessary dependencies (python3, gcc, libc, libffi -> needed for twine)
RUN apt update && apt install -y python3 \
                        python3-pip \       
                        gcc \
                        libc-dev \ 
                        libffi-dev\ 
                        jq \
                        nodejs \
                        npm \
                        curl \
                        git \
                        ca-certificates

RUN pip3 install --upgrade pip && pip3 install twine

# Bring over our script to publish all the packages to the repository and run it on container startup
COPY ./scripts/upload.sh ./upload.sh
COPY ./scripts/build.sh ./build.sh

CMD ["./upload.sh"]
