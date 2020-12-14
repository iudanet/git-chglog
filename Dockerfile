FROM golang:1.15 as builder
ARG GOPROXY
WORKDIR /app
COPY go.*  ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /bin/git-chglog .


FROM alpine:latest  

WORKDIR /git
RUN apk --no-cache add ca-certificates tzdata git make
COPY --from=builder /bin/git-chglog /bin/git-chglog
# ENTRYPOINT [ "/bin/git-chglog" ]