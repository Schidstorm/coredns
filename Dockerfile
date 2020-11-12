FROM golang:1.14 AS coredns


RUN mkdir /code
WORKDIR /code

RUN git clone https://github.com/coredns/coredns
WORKDIR /code/coredns
RUN git checkout v1.7.1
COPY plugin.cfg plugin-append.cfg
RUN echo "" >> plugin.cfg
RUN cat plugin-append.cfg | tee -a plugin.cfg
RUN go generate
RUN make


FROM alpine

RUN adduser -D coredns
USER coredns
WORKDIR /home/coredns
RUN mkdir bin conf

COPY --chown=coredns:coredns --from=coredns /code/coredns/coredns bin


ENTRYPOINT [ "/home/coredns/coredns" ]