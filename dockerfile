FROM golang:alpine AS builder

RUN apk update && apk add --no-cache git make build-base curl

RUN mkdir -p $GOPATH/src/github.com/dgraph-io/

WORKDIR $GOPATH/src/github.com/dgraph-io/

#! If you wanna build always the latest commit, uncomment the next line. But this will take time to build.
#! Also remove the line 13 with the COPY command. And you you don't need to clone Dgraph repo again.
#RUN git clone -v --progress https://github.com/dgraph-io/dgraph.git

COPY . .

RUN cd dgraph && make install

FROM golang:alpine

COPY --from=builder /go/bin/dgraph /go/bin/dgraph

RUN mkdir /dgraph
WORKDIR /dgraph

EXPOSE 8080
EXPOSE 9080

CMD ["dgraph"]
