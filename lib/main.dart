import 'package:flutter/material.dart';
import 'package:heroes/models/hero_model.dart';
import 'package:heroes/services/hero_service.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heroes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Home'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _createHero = false;

  void _handleCreateHero() {
    setState(() {
      _createHero = !_createHero;
    });
  }

  ListTile _createTile(HeroItem hero, IconData icon) => ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HeroDetails(),
              // Pass the arguments as part of the RouteSettings. The
              // ExtractArgumentScreen reads the arguments from these
              // settings.
              settings: RouteSettings(
                arguments: ScreenArguments(
                  hero,
                  false,
                ),
              ),
            ),
          );
        },
        title: Text(hero.name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(hero.identity),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[500],
        ),
      );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the HomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new Container(
        child: new FutureBuilder<List<HeroItem>>(
          future: getHeroes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _createTile(snapshot.data[index], Icons.star),
                          new Divider()
                        ]);
                  });
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return new CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleCreateHero,
        tooltip: 'Create Hero',
        child: Icon(Icons.add),
      ),
    );
  }
}

class HeroDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast them as ScreenArguments.
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    print(args);

    return Scaffold(
      appBar: AppBar(
        title: Text("Hero"),
      ),
      body: new Container(
        padding: new EdgeInsets.all(10.0),
        child: HeroDetailsForm(),
      ),
    );
  }
}

class HeroDetailsForm extends StatefulWidget {
  @override
  HeroDetailsFormState createState() {
    return HeroDetailsFormState();
  }
}

class HeroDetailsFormState extends State<HeroDetailsForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast them as ScreenArguments.
    // final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a name';
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Identity'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter an identity';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenArguments {
  final HeroItem hero;
  final bool isCreate;

  ScreenArguments(this.hero, this.isCreate);
}
