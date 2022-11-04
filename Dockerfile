FROM centos:centos8

ENV LOG_STDOUT=true
ENV ANONYMOUS_ACCESS=false
ENV UPLOADED_FILES_WORLD_READABLE=false
ENV PASV_MIN_PORT 21000
ENV PASV_MAX_PORT 21110
ENV PASV_ADDRESS=10.111.92.31
ENV USERS="alex|PASSWORD1|/opt/ftp/shared/|1000 max|PASSWORD2|/opt/ftp/shared|1001"

RUN \
  yum clean all && \
  yum install -y vsftpd ncurses && \
  yum update && \
  yum clean all

COPY container-files /

EXPOSE 20-21 21100-21110

USER root
RUN bash -x bootstrap.sh

ENTRYPOINT ["/startup.sh"]
