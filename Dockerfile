FROM debian
ENV DEBIAN_FRONTEND="noninteractive"
WORKDIR /opt
RUN apt-get update -yq && apt-get install -yq wget libxtst6 default-jre libgl1-mesa-glx libgl1-mesa-dri libgconf-2-4 procps
COPY ./install.sh /opt/install.sh
