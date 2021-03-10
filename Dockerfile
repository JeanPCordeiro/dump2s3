FROM python:alpine

RUN apk add --update-cache ca-certificates tzdata
RUN pip install s3cmd
RUN apk add --update bash
RUN apk add --update mysql-client 

ENV MYSQLDUMP_OPTIONS --extended-insert --replace --compress

ADD backup.sh /backup.sh
ADD s3cfg /root/.s3cfg
RUN chmod +x /backup.sh

CMD /backup.sh
