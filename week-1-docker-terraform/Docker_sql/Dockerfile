FROM python:3.9.1

RUN apt-get install wget
RUN pip install pandas pyarrow sqlalchemy psycopg2
#WORKDIR [The location in the image of the container]
WORKDIR /app
#COPY [Source from host] [Destination]
COPY IngestData.py IngestData.py


ENTRYPOINT [ "python", "IngestData.py" ]