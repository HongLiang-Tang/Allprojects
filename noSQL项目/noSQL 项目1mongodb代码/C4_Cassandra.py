import re
from cassandra.cluster import Cluster
from cassandra.query import SimpleStatement
from cassandra import ConsistencyLevel
import re

cluster = Cluster(['127.0.0.1'], port=9042)
session = cluster.connect()
session.execute("DROP KEYSPACE fit5137_masl")
session.execute("CREATE KEYSPACE fit5137_masl WITH replication ={'class':'SimpleStrategy', 'replication_factor':1}")
session.set_keyspace('fit5137_masl')
session.execute("Create Type sight(duration text,sighttext text,summary text);")
session.execute(
    "CREATE TABLE fit5137_masl.ufos (id text, city text,colour text,countyName text,day int,hour int,month int,shape text,sightingObs  list<frozen<sight>>,state text,weatherObs_conds text,weatherObs_dewpt float,weatherObs_fog  int,weatherObs_hail int,weatherObs_heatindex float,weatherObs_hum float, weatherObs_precip float,weatherObs_pressure float,weatherObs_rain int, weatherObs_snow int,weatherObs_temp  float,weatherObs_thunder int,weatherObs_tornado  int,weatherObs_vis float ,weatherObs_windCond_wdire text,weatherObs_windCond_wgust float,weatherObs_windCond_windchill float,weatherObs_windCond_wspd float,year int,primary key((month,state),day,hour,year,city,countyName,weatherObs_conds,weatherObs_dewpt,weatherObs_fog,weatherObs_hail,weatherObs_heatindex,weatherObs_hum,weatherObs_precip,weatherObs_pressure,weatherObs_rain,weatherObs_snow,weatherObs_temp,weatherObs_thunder,weatherObs_tornado,weatherObs_vis,weatherObs_windCond_wdire,weatherObs_windCond_wgust,weatherObs_windCond_windchill,weatherObs_windCond_wspd));")

insertin = session.prepare("""
        INSERT INTO ufos (id,city,colour,countyname,day,hour,month,shape,sightingobs,state,weatherObs_conds,weatherObs_dewpt,weatherObs_fog,weatherObs_hail,weatherObs_heatindex,weatherObs_hum,weatherObs_precip,weatherObs_pressure,weatherObs_rain,weatherObs_snow,weatherObs_temp,weatherObs_thunder,weatherObs_tornado,weatherObs_vis,weatherObs_windCond_wdire,weatherObs_windCond_wgust,weatherObs_windCond_windchill,weatherObs_windCond_wspd,year)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
        """)
with open('/Users/yunxuanwang/Documents/FIT5137/new/ufo.csv', 'r') as f:
    count = 0
    for line in f:
        if count != 0:
            list1 = []
            columns = line.split(",")
            id = columns[0]
            city = columns[1]
            colour = columns[2]
            countyname = columns[3]
            day = int(float(columns[4]))
            hour = int(columns[5])
            month = int(columns[6])
            shape = columns[7]
            if len(columns[8]) == 0:
                sightingobs = list(columns[8])
            else:
                sightingobs1 = ""
                str1 = columns[8:-20]
                for item in str1:
                    sightingobs1 += item
              
                duration = re.search("duration:'(.*)'sighttext", str(sightingobs1))
                duration1=re.search("duration':'(.*)''text'", str(sightingobs1))
                text = re.search("sighttext:'(.*)'summary", str(sightingobs1))
                text1=re.search("'text':'(.*)''summary", str(sightingobs1))
                summary = re.search("'summary:'(.*)'}]", str(sightingobs1))
                summary1 = re.search("'summary':'(.*)'}]", str(sightingobs1))
                if not duration and not duration1:
                    list1.append("")
                elif duration:
                    list1.append(duration.group(1))
                else:
                    list1.append(duration1.group(1))
                if not text and  not text1:
                    list1.append("")
                elif  text:
                    list1.append(text.group(1))
                else:
                    list1.append(text1.group(1))
                if not summary and  not summary1:
                    list1.append("")
                elif summary: 
                    list1.append(summary.group(1))
                else:
                    list1.append(summary1.group(1))

                sightingobs = list(list1)
            state = columns[-20]
            weatherObs_conds = columns[-19]
            weatherObs_dewpt = float(columns[-18])
            weatherObs_fog = int(columns[-17])
            weatherObs_hail = int(columns[-16])
            weatherObs_heatindex = float(columns[-15])
            weatherObs_hum = float(columns[-14])
            weatherObs_precip = float(columns[-13])
            weatherObs_pressure = float(columns[-12])
            weatherObs_rain = int(columns[-11])
            weatherObs_snow = int(columns[-10])
            weatherObs_temp = float(columns[-9])
            weatherObs_thunder = int(columns[-8])
            weatherObs_tornado = int(columns[-7])
            weatherObs_vis = float(columns[-6])
            weatherObs_windCond_wdire = columns[-5]
            weatherObs_windCond_wgust = float(columns[-4])
            weatherObs_windCond_windchill = float(columns[-3])
            weatherObs_windCond_wspd = float(columns[-2])
            year = int(columns[-1])
            try:
                if len(sightingobs) == 0:
                    # print(len(sightingobs))
                    session.execute(insertin, [id, city, colour, countyname, day, hour, month, shape, sightingobs, state,
                                               weatherObs_conds, weatherObs_dewpt, weatherObs_fog, weatherObs_hail,
                                               weatherObs_heatindex, weatherObs_hum, weatherObs_precip, weatherObs_pressure,
                                               weatherObs_rain, weatherObs_snow, weatherObs_temp, weatherObs_thunder,
                                               weatherObs_tornado, weatherObs_vis, weatherObs_windCond_wdire,
                                               weatherObs_windCond_wgust, weatherObs_windCond_windchill,
                                               weatherObs_windCond_wspd, year])
                else:
                    session.execute(insertin, [id, city, colour, countyname, day, hour, month, shape, {sightingobs[0],sightingobs[1],sightingobs[2]}, state,
                                               weatherObs_conds, weatherObs_dewpt, weatherObs_fog, weatherObs_hail,
                                               weatherObs_heatindex, weatherObs_hum, weatherObs_precip, weatherObs_pressure,
                                               weatherObs_rain, weatherObs_snow, weatherObs_temp, weatherObs_thunder,
                                               weatherObs_tornado, weatherObs_vis, weatherObs_windCond_wdire,
                                               weatherObs_windCond_wgust, weatherObs_windCond_windchill,
                                               weatherObs_windCond_wspd, year])
            except:
                sightingobs=["observe","observe","observe"]
                session.execute(insertin, [id, city, colour, countyname, day, hour, month, shape, {sightingobs[0],sightingobs[1],sightingobs[2]}, state,
                                               weatherObs_conds, weatherObs_dewpt, weatherObs_fog, weatherObs_hail,
                                               weatherObs_heatindex, weatherObs_hum, weatherObs_precip, weatherObs_pressure,
                                               weatherObs_rain, weatherObs_snow, weatherObs_temp, weatherObs_thunder,
                                               weatherObs_tornado, weatherObs_vis, weatherObs_windCond_wdire,
                                               weatherObs_windCond_wgust, weatherObs_windCond_windchill,
                                               weatherObs_windCond_wspd, year])
                
        
    
        count += 1
f.close()
print(session.execute("select count(sightingObs),month,state from ufos group by month,state allow filtering;").one())
session.execute("""create index on ufos(weatherObs_conds);""")
print(session.execute("select count(sightingObs) from ufos  where weatherObs_conds='Overcast';").one())
session.execute("create index on ufos(year);")
print(session.execute("select sum(weatherObs_temp)/count(weatherObs_temp) as Ave_Temp,sum(weatherObs_pressure)/count(weatherObs_pressure) as Ave_Pressure,sum(weatherObs_hum)/count(weatherObs_hum)  as Ave_Hum from ufos where year=2000;").one())

print(session.execute("select * from ufos where day=11 and hour=22 and month=10 and year=1998 allow filtering;").one())
session.execute("Insert into ufos(city,countyname,day,hour,month,sightingobs,state,weatherObs_conds,weatherObs_dewpt,weatherObs_fog,weatherObs_hail,weatherobs_heatindex,weatherObs_hum,weatherobs_precip,weatherObs_pressure,weatherObs_rain,weatherObs_snow,weatherObs_temp,weatherObs_thunder,weatherObs_tornado,weatherObs_vis,weatherObs_windCond_wdire,weatherobs_windcond_wgust,weatherobs_windcond_windchill,weatherObs_windCond_wspd,year) values ('HIGHLAND','LAKE',11,22,10,[{duration:'25 minutes',sighttext:'Awesome lights were seen in the sky',summary:'Awesome lights'}],'IN','Clear',-0.0909,0,0,  0.004765,0.0292,0.003782,-0.373,0,0,-0.2087,0,0,0.0643,'North',0.009488,0.023987,-0.9112,1998);")


