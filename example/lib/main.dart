import 'package:flutter/material.dart';
import 'package:train_api/Classes/Route.dart' as myRoute;
import 'package:train_api/Classes/Station.dart';
import 'package:train_api/train_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Station> listStations = [];

  Station first, second;

  TextEditingController controllerText = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomScrollView(
        slivers: [

          SliverList(delegate: SliverChildListDelegate([
            Text(
              ((first == null) ? ' . ' : first.name) 
              + ' --> ' + 
              ((second == null) ? ' . ' : second.name)
            ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controllerText,
                        decoration: InputDecoration(
                          hintText: 'Station name'
                        ),
                        onSubmitted: (string) async {
                          listStations = await TrainApi.getStations(string);
                          setState(() {});
                        },
                      ),
                    ),

                    IconButton(icon: Icon(Icons.search), onPressed: () async {
                      listStations = await TrainApi.getStations(controllerText.text);
                      setState(() {});
                    })
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(child: MaterialButton(
                      color: Colors.grey.shade300,
                      onPressed: () async => await TrainApi.getRoutes(first, second, DateTime.now()).then((listRoutes) => showDialog(
                        context: context,
                        child: Dialog(
                          child: ListView.builder(
                            itemCount: listRoutes.length,
                            itemBuilder: (context, n) => ListTile(
                              title: Text(listRoutes[n].startStation.name + ' -> ' + listRoutes[n].endStation.name),
                              trailing: Text(listRoutes[n].duration + ' min'),
                              subtitle: Text(listRoutes[n].trainList.length.toString() + ' cambi'),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: 
                                (context) => _DetailsScreen(route: listRoutes[n]))),
                            )
                          ),
                        )
                      )),
                      child: Text('Get routes now')
                    ),),
                    Expanded(child: MaterialButton(
                      color: Colors.grey.shade300,
                      onPressed: () => setState(() {
                        first = null;
                        second = null;
                      }),
                      child: Text('Clear selected stations')
                    )),
                  ],
                ),
              )
            ])
          ),

          SliverList(delegate: SliverChildBuilderDelegate(
            (context, n) => ListTile(
              title: Text(listStations[n].name),
              subtitle: Text(listStations[n].id),
              onTap: () => setState(() {
                if(first == null) {
                  first = listStations[n];
                } else if(second == null) {
                  second = listStations[n];
                }
              }),
            ),
            childCount: listStations.length,
          ))

        ],
      ),
    );
  }
}




class _DetailsScreen extends StatefulWidget {

  final myRoute.Route route;
  _DetailsScreen({@required this.route});

  @override
  __DetailsScreenState createState() => __DetailsScreenState();
}

class __DetailsScreenState extends State<_DetailsScreen> {

  @override
  void initState() { 
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Detail route screen')),
    body: CustomScrollView(
      slivers: <Widget>[
        SliverList(delegate: SliverChildListDelegate([
          Text(widget.route.startStation.name, textAlign: TextAlign.center),
          Text('|', textAlign: TextAlign.center),
          Text(widget.route.endStation.name, textAlign: TextAlign.center),

          Divider(),

          Text('Train changes (${widget.route.trainList.length})', textScaleFactor: 1.5, textAlign: TextAlign.center),
        ])),

        SliverList(delegate: SliverChildBuilderDelegate(
          (context, n) => ListTile(
            title: Text(widget.route.trainList[n].startStationName + ' -> ' + widget.route.trainList[n].endStationName),
            onTap: () async => await TrainApi.getTrainDetails(widget.route.trainList[n]),
          ),
          childCount: widget.route.trainList.length,
        ))
      ],
    ),
  );
}