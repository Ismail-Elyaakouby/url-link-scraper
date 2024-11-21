FROM alpine:latest

ENV USER=appuser
ENV HOME=/home/$USER

RUN apk update && \
    apk add --no-cache bash curl grep sed gawk && \
    adduser -D $USER && \
    mkdir -p $HOME/scripts && \
    chown -R $USER:$USER $HOME

COPY scripts/extract_links.sh $HOME/scripts/extract_links.sh

RUN chmod +x $HOME/scripts/extract_links.sh && \
    chown $USER:$USER $HOME/scripts/extract_links.sh

USER $USER

WORKDIR $HOME/scripts

ENTRYPOINT ["bash", "extract_links.sh"]

CMD ["-h"]