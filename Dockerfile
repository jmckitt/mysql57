FROM ubuntu:bionic-20220531
RUN apt-get update
RUN apt-get install mysql-server -y

# Ensure mysqld logs go to stderr
RUN sed -i 's/^log-error=/#&/' /etc/mysql/mysql.conf.d/mysqld.cnf

COPY prepare-image.sh /
RUN /prepare-image.sh && rm -f /prepare-image.sh
COPY mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
ENV MYSQL_UNIX_PORT /var/run/mysqld/mysqld.sock


COPY docker-entrypoint.sh /entrypoint.sh
COPY healthcheck.sh /healthcheck.sh
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK CMD /healthcheck.sh
EXPOSE 3306 33060
CMD ["mysqld"]
