FROM golang:1.23-alpine AS build

WORKDIR /src

COPY go.mod ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /app/hello-go .

FROM alpine:3.20

WORKDIR /app

COPY --from=build /app/hello-go /app/hello-go

EXPOSE 8080

CMD ["/app/hello-go"]
