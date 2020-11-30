# train_api

A package to obtain information about train travel in Italy

## Getting Started

With this package you can get information on Italian trains.

Just call `TrainApi` class in your code and access to all static method like:

* `TrainApi.getStations(String stationName)` to get a list of railway stations starting with the `stationName` String;
* `TrainApi.getRoutes(Station start, Station end, DateTime date)` to get a list of routes to go from `start` Station to `end` Station at `date`
* `TrainApi.getTrainDetails(Train train)` to get details about a `train` (obtained previously from `getRoutes`)

