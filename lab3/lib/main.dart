import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab3/routes/githubRepoPage.dart';
import 'package:lab3/githubRepoListItem.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 3',
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'FiraSans',
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
        ),
      ),
      home: MyHomePage(title: 'Lab 3'),
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = 'stars:>100 sort:stars';
  String _language = 'All';
  int nRepositories = 10;

  void changeQuery(String language) {
    setState(() {
      _language = language;
      _searchQuery = language != "All"
          ? 'stars:>100 sort:stars language:$language'
          : 'stars:>100 sort:stars';
    });
  }

  @override
  Widget build(BuildContext context) {
    final String readRepositories = r'''
      query SearchRepositories($nRepositories: Int!, $query: String!, $cursor: String) {
        search(last: $nRepositories, query: $query, type: REPOSITORY, after: $cursor) {
          repositoryCount
          pageInfo {
            endCursor
            hasNextPage
          }
          nodes {
            __typename
            ... on Repository {
              name
              nameWithOwner
              description
              updatedAt
              stargazers {
                totalCount
              }
              forks {
                totalCount
              }
              owner {
                avatarUrl(size: 70)
                login
              }
              primaryLanguage {
                name
                color
              }
            }
          }
        }
      }
    ''';

    final appBar = SliverAppBar(
      brightness: Brightness.dark,
      pinned: true,
      expandedHeight: MediaQuery.of(context).size.height * 0.3,
      toolbarHeight: MediaQuery.of(context).size.height * 0.05,
      backgroundColor: Color.fromRGBO(27, 27, 26, 1),
      elevation: 10.0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Center(
          child: Container(
            padding: EdgeInsets.only(top: 40.0),
            child: Text(
              "Most starred on Github",
              style: TextStyle(
                fontFamily: 'SansitaSwashed',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        background: Container(
          margin: EdgeInsets.only(top: 150.0),
          child: Column(
            children: <Widget>[
              Icon(
                FontAwesome.github_square,
                color: Colors.white,
                size: 50.0,
                semanticLabel: 'Github icon',
              ),
              Text(
                "Made using Github GraphQL API.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Language: '),
                  VerticalDivider(width: 10.0,),
                  DropdownButton<String>(
                    value: _language,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    iconSize: 24,
                    elevation: 1,
                    style: TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    dropdownColor: Colors.black,
                    onChanged: (String newValue) {
                      changeQuery(newValue);
                    },
                    items: <String>[
                      'All',
                      'JavaScript',
                      'Python',
                      'Java',
                      'TypeScript',
                      'C#',
                      'PHP',
                      'C++',
                      'C',
                      'Shell',
                      'Ruby'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      body: Container(
        color: Color.fromRGBO(27, 27, 26, 1),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Query(
          options: QueryOptions(
            documentNode: gql(readRepositories),
            variables: <String, dynamic>{
              'nRepositories': nRepositories,
              'query': _searchQuery,
              'cursor': null
            },
            pollInterval: 1000,
          ),
          // Just like in apollo refetch() could be used to manually trigger a refetch
          // while fetchMore() can be used for pagination purpose
          builder: (QueryResult result, {refetch, FetchMore fetchMore}) {
            FetchMoreOptions opts;

            Widget content = SliverToBoxAdapter(
              child: Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            );

            if (result.data == null && result.hasException) {
              content = SliverToBoxAdapter(
                child: Container(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                      child: Text(result.exception.toString()),
                    ),
                  ),
                ),
              );
            }

            if (result.data != null) {
              List reposInfo = result.data['search']['nodes'];
              final Map pageInfo = result.data['search']['pageInfo'];
              final String fetchMoreCursor = pageInfo['endCursor'];

              List<Widget> reposList = [];

              reposInfo.forEach((repo) {
                reposList.add(GithubRepoListItem(repoInfo: repo));
              });

              if (result.loading) {
                reposList.add(
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (pageInfo['hasNextPage'] == true) {
                reposList.add(Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: RaisedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Load More'),
                        ],
                      ),
                      onPressed: () {
                        fetchMore(opts);
                      },
                    ),
                  ),
                ));
              }

              opts = FetchMoreOptions(
                variables: {'cursor': fetchMoreCursor},
                updateQuery: (previousResultData, fetchMoreResultData) {
                  final List<dynamic> repos = [
                    ...previousResultData['search']['nodes'] as List<dynamic>,
                    ...fetchMoreResultData['search']['nodes'] as List<dynamic>
                  ];
                  fetchMoreResultData['search']['nodes'] = repos;

                  return fetchMoreResultData;
                },
              );

              content = SliverList(
                delegate: SliverChildListDelegate(
                  reposList,
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: refetch,
              child: CupertinoScrollbar(
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    appBar,
                    content,
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.business),
      //       label: 'Business',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.school),
      //       label: 'School',
      //     ),
      //   ],
      // ),
    );
  }
}
