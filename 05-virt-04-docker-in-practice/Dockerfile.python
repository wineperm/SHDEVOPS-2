FROM python:3.9-slim
LABEL autor=05-virt-04-docker-in-practice-KLS
WORKDIR /usr/src/app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py .
CMD [ "python", "./main.py" ]