//1.3 
/*add new field dateTime by concatenating multiple field, then convert the concat result to ISOdate. 
Remove the old fields using $unset and $out output as name "ufoDates"*/
db.ufo.aggregate(
   [
      {
         $addFields: {
            dateTime: {
               $toDate: { $concat: [{ $toString: "$year" }, "-", { $toString: "$month" }, "-", { $toString: "$day" }, " ", { $toString: "$hour" }, ":00:00 +0000"] }
            },
            groupName: "FIT5137"
         }
      },
      { $unset: ["year", "month", "day", "hour"] },
      { $out: "ufoDates" }
   ]
)



//1.4 insert a new record
db.ufoDates.insertOne(
   {
      state: "MA",
      shape: "sphere",
      city: "BOSTON",
      countyName: "SUFFOLK",
      dateTime: new Date("1998-07-14T23:00:00.000+00:00"),
      groupName: "FIT5137",
      sightingObs: [{
         duration: "40 min",
         text: "I was going to my work on my night shift at the St Albin’s hospital and saw an unearthly ray of shooting lights which could be none other than a UFO!",
         summary: "Unearthly ray of shooting lights"
      }]
   }
)
//1.5 removes from an existing array all instance of a value that match the condition of  duration: "2 1/2 minutes"
db.ufoDates.update({},
   { $pull: { sightingObs: { duration: "2 1/2 minutes" } } },
   { multi: true }
)

//1.6
//i count the objects from the sightingObs array based on city, state and dateTime range.
db.ufoDates.aggregate([
   { $match: { city: "SAN FRANCISCO", state: "CA", dateTime: { $gte: new Date("1990-01-01"), $lt: new Date("2001-01-01") } } },
   { $unwind: "$sightingObs" },
   { $count: "total number of sightings observed" }
])
//ii filter the result that has fireball shape, and calculate the average of temperature,humidity,pressure and rainfall rounded to 3 decimal places
db.ufoDates.aggregate([
   { $match: { shape: "fireball" } },
   {
      $group:
      {
         _id: null,
         averageTemp: { $avg: "$weatherObs.temp" },
         averageHumid: { $avg: "$weatherObs.hum" },
         averagePressure: { $avg: "$weatherObs.pressure" },
         averageRainfall: { $avg: "$weatherObs.rain" }
      }
   },
   {
      $project: {
         averageTemp: { $round: ["$averageTemp", 3] },
         averageHumid: { $round: ["$averageHumid", 3] },
         averagePressure: { $round: ["$averagePressure", 3] },
         averageRainfall: { $round: ["$averageRainfall", 3] },
         _id: 0
      }
   }
])
//iii  
/*deconstruct ufoDates and output a document for each element in sightingObs. 
Then, find the number of sightings grouped by month and filter out the highest sightings. 
Lastly, format the output using month name to replace number*/
db.ufoDates.aggregate([
   { $unwind: "$sightingObs" },
   {
      $group: {
         _id: {
            month: { $month: "$dateTime" }
         }, "amount": { $sum: 1 }
      }
   },
   { $sort: { "amount": -1 } },
   { $limit: 1 },
   {
      $project:
      {
         "monthName":
         {
            $switch:
            {
               branches: [
                  { case: { $eq: ["$_id.month", 1] }, then: "January" },
                  { case: { $eq: ["$_id.month", 2] }, then: "February" },
                  { case: { $eq: ["$_id.month", 3] }, then: "March" },
                  { case: { $eq: ["$_id.month", 4] }, then: "April" },
                  { case: { $eq: ["$_id.month", 5] }, then: "May" },
                  { case: { $eq: ["$_id.month", 6] }, then: "June" },
                  { case: { $eq: ["$_id.month", 7] }, then: "July" },
                  { case: { $eq: ["$_id.month", 8] }, then: "August" },
                  { case: { $eq: ["$_id.month", 9] }, then: "September" },
                  { case: { $eq: ["$_id.month", 10] }, then: "October" },
                  { case: { $eq: ["$_id.month", 11] }, then: "November" },
                  { case: { $eq: ["$_id.month", 12] }, then: "December" },
               ],
               default: "unknown digit"
            }
         },
         "_id": 0,
         "highest number of UFO sightings": "$amount"
      }
   }
])
//iv
/*filter out null value and divide string in colour field base on space, 
unwind the split array so that we can group colours and calculate max and min temperature based on single colour*/
db.ufoDates.aggregate([
   { $match: { colour: { $ne: null } } },
   { $project: { colour: { $split: ["$colour", " "] }, weatherObs: 1 } },
   { $unwind: "$colour" },
   {
      $group: {
         "_id": { $toUpper: "$colour" },
         maxTemp: { $max: "$weatherObs.temp" },
         minTemp: { $min: "$weatherObs.temp" }
      }
   },
   {
      $project: {
         "_id": 1,
         maxTemp: { $round: ["$maxTemp", 3] },
         minTemp: { $round: ["$minTemp", 3] }
      }
   },
   { $sort: { "_id": 1 } }
]
)
//v 
/*find oval shape ufo, group documents by wind direction and count the number of instances. 
output the highest instances along with its wind direction*/
db.ufoDates.aggregate([
   { $match: { shape: "oval" } },
   {
      $group: {
         "_id": "$weatherObs.windCond.wdire",
         count: { $sum: 1 }
      }
   },
   { $sort: { count: -1 } },
   { $limit: 1 },
   {
      $project: {
         "wind direction": "$_id",
         count: 1,
         _id: 0
      }
   }
])
//vi 
/*text search using text index. search for light with no case sensitivity in text and summary field under signtingObs. 
count the number of observations that contain "light"*/
db.ufoDates.createIndex({
   "sightingObs.text": "text",
   "sightingObs.summary": "text"
})

db.ufoDates.aggregate([
   {
      $match: {
         $text: { $search: "light", $caseSensitive: false }
      }
   },
   {
      $count: "Number of UFO sighting observations contain the word ‘light’"
   }
])

//1.7
/*lookup to join two collection based on mulitple fields, need to use let so that we can access field from ufoDates inside the pipeline,
the use of $expr allow us to aggregation expression inside $match
after join, we don want to have duplicate information in coordinate, so I used project to filter output*/

db.ufoDates.aggregate([
   {
      $lookup: {
         from: "states",
         let: { ufoState: "$state", ufoStateCity: "$city" ,ufoStateCountyName: "$countyName"},
         pipeline: [
            {
               $match:
               {
                  $expr:
                  {
                     $and:
                        [
                           { $eq: ["$countyName", "$$ufoStateCountyName"] },
                           { $eq: ["$city", "$$ufoStateCity"] },
                           { $eq: ["$state", "$$ufoState"] }
                        ]
                  }
               }
            },
            {
               $project: {
                  city: 0,
                  countyName: 0,
                  _id: 0,
                  state: 0
               }
            }
         ],
         as: "geoCoordinate"

      }
   },
   {
      $out: { db: "FIT5137MASL", coll: "ufoStates" }
   }
])

//1.8 
/*two method. map is easier. get lng and lat data from geoCoordinate field and make it GeoJSON Objects and store it in a new field called location. 
avoid show geoCoordinate as we already have location GeoJSON Objects.
output to new collection called ufoStatesGeojson. Used cond to assign null to empty location(but it is not neccessary)*/
db.ufoStates.aggregate([
   {
      $addFields:
      {
         "location":
         {
            $let: {
               vars: {
                  location: { $arrayElemAt: ["$geoCoordinate", 0] }
               },
               in: {
                  $cond: {
                     if: "$$location", then: { type: "Point", coordinates: ["$$location.lng", "$$location.lat"] }, else: null
                  }
               }
            }
         }
      }
   },
   {
      $project: {
         "geoCoordinate": 0
      }
   },
   { $out: "ufoStatesGeojson" }
])
//but I cannot use this in 1.9, since it generates array which is a problem when we need to create index for 2dsphere on location in 1.9.
//we can only use $let for 1.9
db.ufoStates.aggregate([
   {
      $addFields:
      {
         "location":
         {
            $map: {
               input: "$geoCoordinate",
               as: "location",
               in: {
                  $cond: {
                     if: "$$location", then: { type: "Point", coordinates: ["$$location.lng", "$$location.lat"] }, else: null
                  }
               }
            }
         }
      }
   },
   {
      $project: {
         "geoCoordinate": 0
      }
   },
   { $out: "ufoStatesGeojson" }
])


//1.9
//to use $near or $geonear we need to have  a geospatial index and we are specifying GeoJSON point so we need to use 2dsphere
db.ufoStatesGeojson.createIndex({ "location": "2dsphere" })

//find the highest sightings location
db.ufoStatesGeojson.aggregate([
   {
      $match: {
         location:{$exists:true, $ne:null}
      }
   },
   {
      $unwind:"$sightingObs"
   },
   {
      $group: {
         "_id": {
            "state": "$state",
            "city": "$city",
            "countyName": "$countyName"
         },
         "sightings":{$sum:1},
         "location":{$first:"$location"}
      }
   },
   {$sort:{"sightings":-1}},
   {$limit:1}
])
//[-112.0891,33.5722]
// get all near city and group by city, city name ranked in ascending order
db.ufoStatesGeojson.aggregate([
   {
      "$geoNear":
            {
               near:{type:"Point", coordinates:[-112.0891,33.5722]},
               distanceField:"dist.calculated",
               maxDistance:100000,
               minDistance:10000,
               includeLocs:"dist.location",
               key:"location",
               spherical: true
            }
   },
   {
      $group:{
         "_id":{
            "city":"$city"
         }
      }
   },
   {$sort:{"_id.city":1}}

])