//C.2. Queries.
// 1. How many UFO sightings were recorded in April?
match (ufo:UfoInfo) -[:MONTH_SPOTTED]-> (months:Month)
where months.month = 4
return count(ufo) as `number of ufo recorded in April`;
// 2. Show all unique weather conditions, for UFOs in ‘CIRCLE’ shape appeared in ‘AZ’
// state before 2014(exclusive). Display all weather conditions in lowercase letters.
match(shapes:Shape{shape:'CIRCLE'})<-[:WITH_SHAPE]-(ufo:UfoInfo)-[:WITH_WEATHER]->(weather:WeatherCondition), 
(years:Year)<-[:YEAR_SPOTTED]-(ufo)-[:IS_WITNESSED]->(ci:City)-[:LOCATE_IN]->(co:County)-[:LOCATE_AT]->(st:State{stateName:'AZ'})
where years.year<2014
return distinct weather as `weather condition`;
// 3. Show all unique UFO shapes that appeared in 2015 but not in 2000.
MATCH (shapes:Shape)<-[:WITH_SHAPE]-(ufo:UfoInfo)-[:YEAR_SPOTTED]->(years:Year)
WITH collect(years.year) as years, shapes
WHERE NOT 2000 in years AND 2015 in years
RETURN collect(distinct shapes.shape);
// 4. List all unique years in ascending order if it has ‘at high speeds’ in the text in each
// UFO sighting recording.
//call db.index.fulltext.createNodeIndex()

CREATE FULLTEXT INDEX textIndex FOR (n:UfoInfo) ON EACH [n.text];

CALL db.index.fulltext.queryNodes("textIndex", '"at high speeds"') YIELD node, score
match (node)-->(y:Year)
with distinct y.year as `years`
return years order by years ASC;

//match (u:UfoInfo) -[:YEAR_SPOTTED]-> (y:Year)


// 5. Count how many times each wind direction appeared across all years, sort the number
// of times of each direction in descending order.
match (years:Year)<-[:YEAR_SPOTTED]-(u:UfoInfo)-[:WITH_WINDDIRECTION]->(wdire:WindDirection)
with wdire, count(*) as `times of each direction`
order by `times of each direction` desc
return wdire.direction as wdire,`times of each direction`;

// 6. Display the nearest city information around ‘CORAL SPRINGS’ city in
// ‘BROWARD’ county of ‘FL’. The output should also display the distance calculated
// between ‘CORAL SPRINGS’ city and the nearest city you found.
create index city_location_index for (c:City) on (c.latitude,c.longitude);
match (city:City{cityName:'CORAL SPRINGS'}) -->(counties:County{countyName:'BROWARD'}) -->(states:State{stateName:'FL'})
with city, point({longitude:city.longitude,latitude:city.latitude}) as location1
match (citydup:City)
with location1,city,citydup,point({longitude:citydup.longitude,latitude:citydup.latitude}) as location2
where location1 <> location2
with city.cityName as place1, citydup.cityName as place2, distance(location1,location2) as distance
order by distance asc
limit 1
with place1, collect(place2) as pl2, distance
unwind pl2 as place
return place1 as `Target City`, place as `Nearest City`, distance, apoc.coll.indexOf(pl2,place) + 1 as RankByDistance;


// 7. Find the year with the least number of different kinds of UFO shapes. Display the
// year and the number of counting in the output.
match (y:Year) <--(u:UfoInfo)-->(s:Shape)
with y,count(distinct s.shape) as number
order by number asc
limit 1
return y.year as year, number as `number of shapes`;
// 8. What is the average temperature, pressure, and humidity of each UFO shape? (The
// output should also display the average values rounded to 3 decimal places)
match (u:UfoInfo) --> (s:Shape)
with s.shape as shape, round(avg(u.temp),3) as temperature, round(avg(u.pressure),3) as pressure, round(avg(u.hum),3) as humidity
return shape, temperature, pressure, humidity;


// 9. Display the top 3 counties with the most number of different cities.
match (c:County) <--(ci:City)
with c, count(ci.cityName) as number
order by number desc
limit 3 
return c.countyName as `County Name`, number as `Number of different cities`;

// 10. Rank the total number of UFO sighting recordings according to each state, display the
// state in descending order in the output.

match (u:UfoInfo)-->(ci:City)-->(co:County)-->(s:State)
with s, count(u) as number
order by number desc
return s.stateName as State, number as `Number of UFO sightings`;