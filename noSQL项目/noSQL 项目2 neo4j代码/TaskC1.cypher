//C.1. Database Design.
//import state.csv
load csv with headers from 'file:///states_a2.csv' as row
with row
merge (states:State{stateName:trim(toUpper(row.state))})  // state contain counties
merge (cities:City{cityName:trim(toUpper(row.city)),latitude:toFloat(row.lat),longitude:toFloat(row.lng)})-[:LOCATE_IN]->(counties:County{countyName:trim(toUpper(row.countyName))}) -[:LOCATE_AT]->(states);//county contain cities, same name county in different state is still different county


// duration, text and summary has empty value, so case when is needed otherwise will return error
//if line.xxx is used.
//assume 1 is true 0 is false
Load csv with headers from "file:///ufo_a2.csv" as line
with line 
create (ufo:UfoInfo)
set ufo.duration = trim(COALESCE(line.duration,'Not recorded')),
    ufo.text = trim(COALESCE(line.text,'Not recorded')),
    ufo.summary = trim(COALESCE(line.summary,'Not recorded')),
    ufo.pressure = (case trim(line.pressure) 
                    when 'NA' then null else toFloat(trim(line.pressure))END),
    ufo.temp = (case trim(line.temp) 
                    when 'NA' then null else toFloat(trim(line.temp))END),
    ufo.heatindex = (case trim(line.heatindex) 
                    when 'NA' then null else toFloat(trim(line.heatindex))END),
    ufo.windchill = (case trim(line.windchill) 
                    when 'NA' then null else toFloat(trim(line.windchill))END),
    ufo.vis = (case trim(line.vis) 
                    when 'NA' then null else toFloat(trim(line.vis))END),
    ufo.dewpt = (case trim(line.dewpt) 
                    when 'NA' then null else toFloat(trim(line.dewpt))END),
    ufo.precip = (case trim(line.precip) 
                    when 'NA' then null else toFloat(trim(line.precip))END),
    ufo.wspd = (case trim(line.wspd)
                    when 'NA' then null else toFloat(trim(line.wspd))END),
    ufo.hum = (case trim(line.hum) 
                    when 'NA' then null else toFloat(trim(line.hum))END),
    ufo.wgust = (case trim(line.wgust) 
                    when 'NA' then null else toFloat(trim(line.wgust))END)
//bool
create (hail:Hail)
set hail.status = (case trim(line.hail) when 1 then true else false end)
merge (ufo)-[:HAS_HAIL]->(hail)

create (rain:Rain)
set rain.status = (case trim(line.rain) when 1 then true else false end)
merge (ufo)-[:HAS_RAIN]->(rain)

create (thunder:Thunder)
set thunder.status = (case trim(line.thunder) when 1 then true else false end)
merge (ufo)-[:HAS_THUNDER]->(thunder)

create (fog:Fog)
set fog.status = (case trim(line.fog) when 1 then true else false end)
merge (ufo)-[:HAS_FOG]->(fog)

create (tornado:Tornado)
set tornado.status = (case trim(line.tornado) when 1 then true else false end)
merge (ufo)-[:HAS_TORNADO]->(tornado)

create (snow:Snow)
set snow.status = (case trim(line.snow) when 1 then true else false end)
merge (ufo)-[:HAS_SNOW]->(snow)

// year month day hour
merge (years:Year{year:toInteger(trim(line.year))})
merge (ufo)-[:YEAR_SPOTTED]->(years)
merge (months:Month{month:toInteger(trim(line.month))})
merge (ufo)-[:MONTH_SPOTTED]->(months)
merge (days:Day{day:toInteger(trim(line.day))})
merge (ufo)-[:DAY_SPOTTED]->(days)
merge (hours:Hour{hour:toInteger(trim(line.hour))})
merge (ufo)-[:HOUR_SPOTTED]->(hours)

//shape https://community.neo4j.com/t/load-csv-with-empty-cells/5091/4 handle null
//https://neo4j.com/developer/kb/conditional-cypher-execution/
foreach(ignoreMe in case when exists(line.shape) then [1] else [] END | 
merge(shapes:Shape{shape:toUpper(trim(line.shape))}) // changed toupper
merge(ufo)-[:WITH_SHAPE]->(shapes) 
)
//windir
merge(wdire:WindDirection{direction:line.wdire})
merge (ufo)-[:WITH_WINDDIRECTION]->(wdire)

//weather condition
//conds
foreach(ignoreMe in case when exists(line.conds) then [1] else [] END | 
merge(conds:WeatherCondition{weather:line.conds}) 
merge(ufo)-[:WITH_WEATHER]->(conds) 
)

//location
merge(address:Address {city:trim(toUpper(line.city)),state:trim(toUpper(line.state))})   
merge(ufo)-[:SPOTTED_ADDRESS]->(address);


//link ufo to Geo location

match(ufo:UfoInfo)-[s:SPOTTED_ADDRESS]->(address:Address)
match (ci:City) -[:LOCATE_IN]-> (co:County)-[:LOCATE_AT]->(st:State)
match (ci:City{cityName:address.city}) -[:LOCATE_IN]-> (co:County)-[:LOCATE_AT]->(st:State {stateName:address.state})
create (ufo) -[:IS_WITNESSED]-> (ci);