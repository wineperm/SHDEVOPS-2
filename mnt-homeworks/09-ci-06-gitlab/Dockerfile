FROM centos:7

RUN yum update -y && yum install -y python3 python3-pip
RUN pip3 install flask flask-jsonpify flask-restful

ADD python-api.py /python-api/
ENTRYPOINT [ "python3", "/python-api/python-api.py" ]
