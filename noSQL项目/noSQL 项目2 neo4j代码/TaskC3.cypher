// C.3. Database Modifications.
//1.

match (m:Month{month:8})<--(u:UfoInfo)-->(y:Year{year:1998}), 
(d:Day{day:14})<--(u)-->(h:Hour{hour:16}), (rain:Rain)<--(u)-->(hail:Hail), (thunder:Thunder)<--(u)-->(fog:Fog),
(tornado:Tornado)<--(u)-->(snow:Snow)
with u,rain,hail,thunder,fog,tornado,snow
create (n:UfoInfo{duration:'25 minutes', text:"Awesome lights were seen in the sky",summary:"Awesome lights", 
        pressure:u.pressure, temp:u.temp, heatindex:u.heatindex,windchill:u.windchill, 
        vis:u.vis, dewpt:u.dewpt, precip:u.precip, wspd:u.wspd, hum:u.hum,wgust:u.wgust
        })
with u,rain,hail,thunder,fog,tornado,snow,n
merge (y:Year{year:2021})
merge (m:Month{month:1})
merge (d:Day{day:14})
merge (h:Hour{hour:23})
merge (n)-[:YEAR_SPOTTED]->(y)
merge (n)-[:MONTH_SPOTTED]->(m) 
merge (n)-[:DAY_SPOTTED]->(d)
merge (n)-[:HOUR_SPOTTED]->(h)
merge (n)-[:HAS_HAIL]->(hail)
merge (n)-[:HAS_RAIN]->(rain)
merge (n)-[:HAS_THUNDER]->(thunder)
merge (n)-[:HAS_FOG]->(fog)
merge (n)-[:HAS_TORNADO]->(tornado)
merge (n)-[:HAS_SNOW]->(snow)
with n
match (c:City{cityName:'HIGHLAND'})-[:LOCATE_IN]->(co:County{countyName:'LAKE'})-[:LOCATE_AT]->(s:State{stateName:'IN'})
merge (n)-[:IS_WITNESSED]->(c)-[:LOCATE_IN]->(co)-[:LOCATE_AT]->(s);

//2.
match (y:Year)<--(u:UfoInfo)
where y.year in [2008,2011]
with u
match (u)-[r:WITH_SHAPE]->(s:Shape{shape:'UNKNOWN'})
delete r
with u
merge (newshape:Shape{shape:'FLYING SAUCER'})
merge (u)-[:WITH_SHAPE]->(newshape)
with u
match (u)-[r1:WITH_WEATHER]->(conds:WeatherCondition{weather:'CLEAR'})
delete r1
with u
merge (conds1:WeatherCondition{weather:'SUNNY/CLEAR'})
merge (u)-[:WITH_WEATHER]->(conds1);


//3.
match (c:City{cityName:'ARCADIA'}) --> (co:County)--> (s:State{stateName:'FL'})
detach delete c;