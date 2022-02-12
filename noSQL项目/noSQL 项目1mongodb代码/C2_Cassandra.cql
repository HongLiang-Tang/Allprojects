drop KEYSPACE FIT5137_MASL;
CREATE KEYSPACE FIT5137_MASL WITH replication={'class':'SimpleStrategy','replication_factor':'1'};
USE FIT5137_MASL;

/*Create table and UDT*/
Create Type FIT5137_MASL.sight(
    duration text,
    sighttext text,
    summary text
);
/*sightingObs as UDT*/
CREATE TABLE FIT5137_MASL.ufos (id text, city text,colour text,countyName text,day int,hour int,month int,shape text,sightingObs  list<frozen<sight>>,
    state text,weatherObs_conds text,
    weatherObs_dewpt float,
    weatherObs_fog  int,
    weatherObs_hail int,
    weatherObs_heatindex float,
    weatherObs_hum float,
    weatherObs_precip float,
    weatherObs_pressure float,
    weatherObs_rain int,
    weatherObs_snow int,
    weatherObs_temp  float,
    weatherObs_thunder int,
    weatherObs_tornado  int,
    weatherObs_vis float ,weatherObs_windCond_wdire text,
    weatherObs_windCond_wgust float,
    weatherObs_windCond_windchill float,
    weatherObs_windCond_wspd float,year int
    ,primary key((month,state),day,hour,year,city,countyName,weatherObs_conds,weatherObs_dewpt,weatherObs_fog,weatherObs_hail,weatherObs_heatindex,weatherObs_hum,weatherObs_precip,weatherObs_pressure,weatherObs_rain,weatherObs_snow,weatherObs_temp,weatherObs_thunder,weatherObs_tornado,weatherObs_vis,weatherObs_windCond_wdire,weatherObs_windCond_wgust,weatherObs_windCond_windchill,weatherObs_windCond_wspd));


/*-----Choose month state as partition key to do  group by
-----Choose day,hour,year,city,countyName,weatherObs_conds,weatherObs_dewpt,weatherObs_fog,weatherObs_hail,weatherObs_heatindex,weatherObs_hum,weatherObs_precip,weatherObs_pressure,weatherObs_rain,weatherObs_snow,weatherObs_temp,weatherObs_thunder,weatherObs_tornado,weatherObs_vis,weatherObs_windCond_wdire,weatherObs_windCond_wgust,weatherObs_windCond_windchill,weatherObs_windCond_wspd
-----as cluster keys to make sure we can add information give in C.2.4 into the database,and it when we import the csv file to Cassandra,
-----these cluster key can help us not lose many data.
-----Since Primary key cannot be null,I replace null with mean  for numeric data,'unknown' for categorical.
-----To make sure the number of observed sightingObs is correct.sightingObs is not set as part of cluster key ,so it can have null.
*/
/*import ufo.csv data into ufos table */
copy FIT5137_MASL.ufos(id,city,colour,countyname,day,hour,month,shape,sightingobs,state,weatherObs_conds,weatherObs_dewpt,weatherObs_fog,weatherObs_hail,weatherObs_heatindex,weatherObs_hum,weatherObs_precip,weatherObs_pressure,weatherObs_rain,weatherObs_snow,weatherObs_temp,weatherObs_thunder,weatherObs_tornado,weatherObs_vis,weatherObs_windCond_wdire,weatherObs_windCond_wgust,weatherObs_windCond_windchill,weatherObs_windCond_wspd,year) FROM  '/Users/yunxuanwang/Documents/FIT5137/new/ufo.csv' with delimiter=','  and HEADER = TRUE;

----C.2.3
----i
select count(sightingObs),month,state from ufos group by month,state allow filtering;


----ii
----create index on weatherObs_conds,so that we can use where condition on it.
create index on ufos(weatherObs_conds);
select count(sightingObs) from ufos  where weatherObs_conds='Overcast';


-----iii
----create index on year,so that we can use where condition on it.
create index on ufos(year);
select sum(weatherObs_temp)/count(weatherObs_temp) as Ave_Temp,sum(weatherObs_pressure)/count(weatherObs_pressure) as Ave_Pressure,sum(weatherObs_hum)/count(weatherObs_hum)  as Ave_Hum from ufos where year=2000;
/*use sum/count to get the average*/

------C.2.4
----The weather obvervation is the same as that observed during 11th October 1998 10PM
----Get the information of that time at first:
select * from ufos where day=11 and hour=22 and month=10 and year=1998 allow filtering;
----insert information to ufos table;
Insert into ufos(city,countyname,day,hour,month,sightingobs,state,weatherObs_conds,weatherObs_dewpt,weatherObs_fog,weatherObs_hail,weatherobs_heatindex,weatherObs_hum,weatherobs_precip,weatherObs_pressure,weatherObs_rain,weatherObs_snow,weatherObs_temp,weatherObs_thunder,weatherObs_tornado,weatherObs_vis,weatherObs_windCond_wdire,weatherobs_windcond_wgust,weatherobs_windcond_windchill,weatherObs_windCond_wspd,year) values ('HIGHLAND','LAKE',11,22,10,[{duration:'25 minutes',sighttext:'Awesome lights were seen in the sky',summary:'Awesome lights'}],'IN','Clear',-0.0909,0,0,  0.004765,0.0292,0.003782,-0.373,0,0,-0.2087,0,0,0.0643,'North',0.009488,0.023987,-0.9112,1998);