FROM golang:1.16-alpine

RUN mkdir -p /app
COPY ./app/http.go /app
WORKDIR /app
RUN go env -w GO111MODULE=off; go build -o http; chmod +x /app/http
ENV PORT 8000
CMD [ "/app/http" ]