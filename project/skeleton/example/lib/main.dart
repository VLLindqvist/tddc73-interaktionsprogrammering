import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:skeleton/skeleton.dart';
import 'package:flutter/services.dart';

Future main() async {
  await DotEnv().load('.env');

  final HttpLink httpLink = HttpLink(
    uri: 'https://api.github.com/graphql',
  );

  final githubToken = DotEnv().env['GITHUB_TOKEN'];
  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer $githubToken',
  );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );

  runApp(
    GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Skeleton examples'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final String githubQuery = r'''
      query SearchRepositories() {
        search(query: "flutter", type: REPOSITORY, first: 1) {
          nodes {
            ... on Repository {
              owner {
                avatarUrl(size: 70)
                login
              }
              openGraphImageUrl
            }
          }
        }
      }
    ''';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(46, 46, 46, 1.0),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Skeleton(
                loading: true,
                child: Container(),
              ),
              Divider(height: 20.0),
              Query(
                options: QueryOptions(
                  documentNode: gql(githubQuery),
                  // pollInterval: 1000,
                ),
                builder: (QueryResult result, {refetch, FetchMore fetchMore}) {
                  Widget content = Container();

                  if (result.data == null && result.hasException) {
                    content = Container(
                      child: Center(
                        child: Text(result.exception.toString()),
                      ),
                    );
                  }

                  if (result.data != null) {
                    content = LayoutBuilder(builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      return Container(
                        width: width,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 150,
                              margin: EdgeInsets.only(bottom: 15.0),
                              child: Image.network(
                                result.data['search']['nodes'][0]
                                    ['openGraphImageUrl'],
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                result.data['search']['nodes'][0]['owner']
                                    ['avatarUrl'],
                              ),
                            ),
                            Text(
                              result.data['search']['nodes'][0]['owner']
                                  ['login'],
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      );
                    });
                  }

                  return Skeleton(
                    loading: result.loading,
                    child: content,
                    placeholder: SkeletonPlaceholder(
                      child: Column(
                        children: <Widget>[
                          SkeletonBox(
                            width: 1.0,
                            height: 150,
                            style: SkeletonBoxStyle(
                              padding: EdgeInsets.only(bottom: 15.0),
                            ),
                          ),
                          SkeletonBox(
                            radius: 40,
                            center: true,
                          ),
                          SkeletonTitle(
                            center: true,
                            width: 0.2,
                            style: SkeletonTitleStyle(
                              height: 18.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              Divider(height: 20.0),
              Card(
                color: Color.fromRGBO(46, 46, 46, 1.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Skeleton(
                        theme: SkeletonTheme.Dark,
                        loading: _loading,
                        placeholder: SkeletonPlaceholder(
                          title: false,
                          avatar: true,
                        ),
                        child: LayoutBuilder(builder: (context, constraints) {
                          final width = constraints.maxWidth;

                          return Container(
                            width: width,
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: width * 0.15,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          'https://avatars0.githubusercontent.com/u/35808658?s=60&v=4',
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      width: width * 0.2,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    Divider(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Toggle loading:',
                          style: TextStyle(color: Colors.white),
                        ),
                        Switch(
                          activeColor: Colors.white,
                          value: _loading,
                          onChanged: (value) {
                            setState(() {
                              _loading = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 20.0),
              Card(
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Skeleton(
                    // animate: false,
                    theme: SkeletonTheme.Light,
                    loading: true,
                    placeholder: SkeletonPlaceholder(
                      title: false,
                      avatar: true,
                      child: LayoutBuilder(builder: (context, constraints) {
                        final width = constraints.maxWidth;

                        return Container(
                          width: width,
                          child: Column(
                            children: <Widget>[
                              SkeletonBox(
                                width: 1.0, // or 'width'
                                height: 100,
                                center: true,
                              ),
                              Divider(
                                height: 25.0,
                              ),
                              SkeletonTitle(
                                width: 0.5,
                                center: true,
                              ),
                              SkeletonParagraph(
                                rows: 2,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    child: Container(),
                  ),
                ),
              ),
              Divider(height: 20.0),
              LayoutBuilder(builder: (context, constraints) {
                final width = constraints.maxWidth;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    for (var i = 0; i < 2; ++i)
                      Container(
                        width: width * 0.45,
                        child: Skeleton(
                          theme: SkeletonTheme.Light,
                          loading: true,
                          placeholder: SkeletonPlaceholder(
                            avatar: true,
                            child: SkeletonBox(
                              center: true,
                              width: 1.0,
                            ),
                          ),
                          child: Container(child: Text("hej")),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
