
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

python3 IngestData.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5431 \
  --db=ny_taxi \
  --table=yellow_taxi_trips \
  --url=${URL}


#At this point, setup everything on a Docker container
docker build -t taxidata_ingest:v001 .

docker run -it --network pg-network taxidata_ingest:v001 \
  --password=root \
  --host=127.0.0.1\
  --port=5431 \
  --db=ny_taxi \
  --table=yellow_taxi_trips \
  --url=${URL} \
#5432 is the port of Postgres container (See `Setup.sh`, where 'postgre:13' is located)