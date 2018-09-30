#Load data from Raw
airports_raw = load '/data/raw/airports/' using PigStorge(',') AS (iata:string,airport:string,city:string,state:string,country:string,lat:string,long:string);
carriers_raw = load '/data/raw/carriers/' using PigStorge(',') AS (Code:string,Description:string);
planedata_raw = load '/data/raw/plane_data/' using PigStorge(',') AS (tailnum:string,type:string,manufacturer:string,issue_date:string,model:string,status:string,aircraft_type:string,engine_type:string,year:string);
OTP_raw = load '/data/raw/OTP/' using PigStorge(',') AS (Year:string,Month:string,DayofMonth:string,DayOfWeek:string,DepTime:string,CRSDepTime:string,ArrTime:string,CRSArrTime:string,UniqueCarrier:string,FlightNum:string,TailNum:string,ActualElapsedTime:string,CRSElapsedTime:string,AirTime:string,ArrDelay:string,DepDelay:string,Origin:string,Dest:string,Distance:string,TaxiIn:string,TaxiOut:string,Cancelled:string,CancellationCode:string,Diverted:string,CarrierDelay:string,WeatherDelay:string,NASDelay:string,SecurityDelay:string,LateAircraftDelay:string);

#Append new columns to raw data
airports_decomp = FOREACH airports_raw GENERATE *, UniqueID() as UUID, CurrentTime() as timestamp;
carriers_decomp = FOREACH carriers_raw GENERATE *, UniqueID() as UUID, CurrentTime() as timestamp;
planedata_decomp = FOREACH planedata_raw GENERATE *, UniqueID() as UUID, CurrentTime() as timestamp;
OTP_decomp = FOREACH OTP_raw GENERATE *, UniqueID() as UUID, CurrentTime() as timestamp;

#Write output in parquet format
STORE airports_decomp into '/data/decomposed/airports' USING AvroStorage();
STORE carriers_decomp into '/data/decomposed/carriers' USING AvroStorage();
STORE planedata_decomp into '/data/decomposed/planedata' USING AvroStorage();
STORE OTP_decomp into '/data/decomposed/OTP' USING AvroStorage();
