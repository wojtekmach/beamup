# pretend this is ubuntu-16.04. See https://github.com/nektos/act#runners for more information.
FROM node:12.21.0-buster
RUN apt-get update && apt-get install -y software-properties-common apt-transport-https ca-certificates && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0 && \
    apt-add-repository https://cli.github.com/packages && \
    apt-get update
RUN apt-get install -y gh jq
