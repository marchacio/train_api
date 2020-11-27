import 'package:flutter/material.dart';
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
                          listStations = await TrainApi.returnStations(string);
                          setState(() {});
                        },
                      ),
                    ),

                    IconButton(icon: Icon(Icons.search), onPressed: () async {
                      listStations = await TrainApi.returnStations(controllerText.text);
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
                      onPressed: () async => await TrainApi.returnRoutes(first, second, DateTime.now()).then((listRoutes) => showDialog(
                        context: context,
                        child: Dialog(
                          child: ListView.builder(
                            itemCount: listRoutes.length,
                            itemBuilder: (context, n) => ListTile(
                              title: Text(listRoutes[n].trainList.toString()),
                              trailing: Text(listRoutes[n].duration),
                              subtitle: Text(listRoutes[n].toString())
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
