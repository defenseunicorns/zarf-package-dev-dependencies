FROM debian:stable

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
                        bash \
                        ca-certificates

RUN pip3 install --upgrade pip && pip3 install twine

# TODO: REMOVE THIS.. This is for local testing, the /packages directory will normally be populated by the Zarf Injection
# ADD packages/ /packages/

# Simply declaring what environment variables are expected (for human sanity and documentation)
ENV GITEA_URL ""
ENV ZARF_USER ""
ENV ZARF_PASS ""

# Bring over our script to publish all the packages to the repository and run it on container startup
COPY ./upload.sh ./upload.sh
RUN chmod +x ./upload.sh
ENTRYPOINT ["./upload.sh"]