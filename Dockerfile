FROM azul/zulu-openjdk-debian:17

LABEL maintainer="hello@unately.com"

RUN apt-get update && apt-get install -y curl bash dos2unix

WORKDIR /app

COPY ./serverpack .

RUN chmod +x install-only.sh && \
    # Because windows and vscode
    dos2unix install-only.sh && \
    sh install-only.sh


EXPOSE 25565

CMD ["bash", "run.sh"]