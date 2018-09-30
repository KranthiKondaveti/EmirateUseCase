CREATE DATABASE MODELLED IF NOT EXISTS;

CREATE EXTERNAL TABLE MODELLED.AIRPORTS(
iata string,
airport string,
city string,
state string,
country string,
lat string,
long string,
uuid string,
timestamp string
)
LOCATION '/data/modelled/airports'
STORED AS PARQUET
ROW FORMAT SERDE 'parquet.hive.serde.ParquetHiveSerDe';

CREATE EXTERNAL TABLE MODELLED.AIRPORTS(
Code string,
Description string,
uuid string,
timestamp string
)
LOCATION '/data/modelled/airports'
STORED AS PARQUET
ROW FORMAT SERDE 'parquet.hive.serde.ParquetHiveSerDe';

CREATE EXTERNAL TABLE MODELLED.PLANDATA(
tailnum string,
type string,
manufacturer string,
issue_date string,
model string,
status string,
aircraft_type string,
engine_type string,
year string, 
uuid string, 
timestamp string
)
LOCATION '/data/modelled/planedata'
STORED AS PARQUET
ROW FORMAT SERDE 'parquet.hive.serde.ParquetHiveSerDe';

CREATE EXTERNAL TABLE MODELLED.OTP(
Year string, 
Month string, 
DayofMonth string, 
DayOfWeek string, 
DepTime string,
CRSDepTime string,
ArrTime string,
CRSArrTime string,
UniqueCarrier string,
FlightNum string,
TailNum string,
ActualElapsedTime string,
CRSElapsedTime string,
AirTime string,
ArrDelay string,
DepDelay string,
Origin string,
Dest string,
Distance string,
TaxiIn string,
TaxiOut string,
Cancelled string,
CancellationCode string,
Diverted string,
CarrierDelay string,
WeatherDelay string,
NASDelay string,
SecurityDelay string,
LateAircraftDelay string
uuid string,
timestamp string
)
LOCATION '/data/modelled/otp'
STORED AS PARQUET
ROW FORMAT SERDE 'parquet.hive.serde.ParquetHiveSerDe';