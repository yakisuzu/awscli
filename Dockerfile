FROM python:latest

RUN set -x && apt-get -y update && apt-get -y upgrade && pip install pip --upgrade
RUN apt-get install -y groff
RUN pip install awscli

WORKDIR /root
ENTRYPOINT ["/bin/bash"]
CMD ["--login", "-i"]
