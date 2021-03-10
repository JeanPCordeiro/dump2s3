# dump2s3

A docker container to dump MySQL Database to AWS S3 Bucket

Usage with docker-compose :

version: '3.8'
services:
  DB:
    image: mariadb:latest
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 10
        window: 15s
    environment:
        MYSQL_DATABASE: *
        MYSQL_USER: *
        MYSQL_PASSWORD: *
        MYSQL_ROOT_PASSWORD: *
    volumes:
      - DB-data:/var/lib/mysql

  SaveS3:
    image: jpcordeiro/dump2s3:latest
    deploy:
      replicas: 0
      labels:
        - "swarm.cronjob.enable=true"
        - "swarm.cronjob.schedule=0 1 * * *"
        - "swarm.cronjob.skip-running=false"
      restart_policy:
        condition: none
    environment:
      AWS_ACCESS_KEY_ID: *
      AWS_SECRET_ACCESS_KEY: *
      AWS_PATH: *
      MYSQL_HOST: DB
      MYSQL_PORT: 3306
      MYSQL_USER: *
      MYSQL_PASSWORD: *
      MYSQL_DATABASE: *
    stdin_open: true
    depends_on:
      - DB
    tty: true

volumes:
    DB-data: {}
