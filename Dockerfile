FROM alpine:latest
RUN apk update && \
  apk add bash jq

COPY extract_ticket_id.sh /extract_ticket_id.sh

ENTRYPOINT ["/extract_ticket_id.sh"]