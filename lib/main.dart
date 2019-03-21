import 'package:http/http.dart' as http;
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
      _createHero = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeroDetails(),
        // Pass the arguments as part of the RouteSettings.
        settings: RouteSettings(
          arguments: ScreenArguments(
            new HeroItem(age: 0),
            _createHero,
          ),
        ),
      ),
    );
  }

  ListTile _createTile(HeroItem hero, IconData icon) => ListTile(
        onTap: () {
          setState(() {
            _createHero = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HeroDetails(),
              // Pass the arguments as part of the RouteSettings.
              settings: RouteSettings(
                arguments: ScreenArguments(
                  hero,
                  _createHero,
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
            print('Fetched Heroes!');
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Hero"),
      ),
      body: new Container(
        padding: new EdgeInsets.all(10.0),
        child: HeroDetailsForm(hero: args.hero, isCreate: args.isCreate),
      ),
    );
  }
}

class HeroDetailsForm extends StatefulWidget {
  HeroDetailsForm({Key key, this.hero, this.isCreate}) : super(key: key);

  final HeroItem hero;
  final bool isCreate;

  @override
  _HeroDetailsFormState createState() => _HeroDetailsFormState();
}

class _HeroDetailsFormState extends State<HeroDetailsForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<_HeroDetailsFormState>!
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final identityController = TextEditingController();
  final hometownController = TextEditingController();
  final ageController = TextEditingController();

  bool apiCallInProgress = false;

  @override
  void dispose() {
    // Clean up the controllers when the Widget is disposed
    nameController.dispose();
    identityController.dispose();
    hometownController.dispose();
    ageController.dispose();
    super.dispose();
  }

  HeroItem _newHero() {
    HeroItem newHero = new HeroItem();

    newHero.id = widget.hero.id;
    newHero.name = widget.hero.name;
    newHero.identity = widget.hero.identity;
    newHero.hometown = widget.hero.hometown;
    newHero.age = widget.hero.age;
    newHero.createdAt = widget.hero.createdAt;
    newHero.updatedAt = widget.hero.updatedAt;
    newHero.deletedAt = widget.hero.deletedAt;

    newHero.name = nameController.text;
    newHero.identity = identityController.text;
    newHero.hometown = hometownController.text;

    int age = int.tryParse(ageController.text);
    newHero.age = age;
    return newHero;
  }

  Widget _getProgressWidget() {
    if (apiCallInProgress)
      return new CircularProgressIndicator();
    else
      return null;
  }

  void _callApiMethod(ApiMethods method) async {
    setState(() {
      apiCallInProgress = true;
    });
    http.Response response;
    switch (method) {
      case ApiMethods.CREATE:
        response = await createHero(_newHero());
        break;

      case ApiMethods.UPDATE:
        response = await updateHero(widget.hero.id, _newHero());
        break;

      case ApiMethods.DELETE:
        response = await deleteHero(widget.hero.id);
        break;
    }

    if (response != null) {
      print(response);
    }

    setState(() {
      apiCallInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
            initialValue: widget.hero.name,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a name';
              }
            },
          ),
          TextFormField(
            controller: identityController,
            decoration: InputDecoration(labelText: 'Identity'),
            initialValue: widget.hero.identity,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter an identity';
              }
            },
          ),
          TextFormField(
            controller: hometownController,
            decoration: InputDecoration(labelText: 'Hometown'),
            initialValue: widget.hero.hometown,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a hometown';
              }
            },
          ),
          TextFormField(
            controller: ageController,
            decoration: InputDecoration(labelText: 'Age'),
            initialValue: widget.hero.age.toString(),
            validator: (value) {
              int intValue = int.tryParse(value);
              if (intValue == null || intValue < 1) {
                return 'Please enter an age';
              }
            },
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Visibility(
                        visible: !widget.isCreate,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text('Updating Hero...')));
                              }
                            },
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: const Text('Update'),
                          ),
                        )),
                    Visibility(
                        visible: !widget.isCreate,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text('Deleting Hero...')));
                              }
                            },
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            color: Colors.red,
                            textColor: Colors.white,
                            child: const Text('Delete'),
                          ),
                        )),
                    Visibility(
                        visible: widget.isCreate,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text('Creating Hero...')));
                                _callApiMethod(ApiMethods.CREATE);
                              }
                            },
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: const Text('Create'),
                          ),
                        )),
                  ]))),
          _getProgressWidget(),
        ],
      ),
    );
  }
}

enum ApiMethods { CREATE, UPDATE, DELETE }

class ScreenArguments {
  final HeroItem hero;
  final bool isCreate;

  ScreenArguments(this.hero, this.isCreate);
}
