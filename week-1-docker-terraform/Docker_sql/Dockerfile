FROM python:3.9

RUN pip install pandas pyarrow 
#WORKDIR [The location in the image of the container]
WORKDIR /app
#COPY [Source from host] [Destination]
COPY pipeline.py pipeline.py


ENTRYPOINT [ "python", "pipeline.py" ]