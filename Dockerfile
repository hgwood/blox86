FROM debian

RUN apt-get update && apt-get install -y nasm genisoimage

ENTRYPOINT [ "sh" ]
