import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:number_display/number_display.dart' as numberFormatter;

class GithubRepoPage extends StatelessWidget {
  GithubRepoPage({Key key, @required this.repoInfo}) : super(key: key);

  final Map repoInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(27, 27, 26, 1),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Feather.chevron_left,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    radius: (MediaQuery.of(context).size.width) * 0.05,
                    backgroundImage: NetworkImage(
                      repoInfo['owner']['avatarUrl'].toString(),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      repoInfo['owner']['login'] + "/",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.white54,
                      ),
                    ),
                    Text(
                      repoInfo['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 0.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  repoInfo['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: MoreRepoInfo(repoInfo: repoInfo),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoreRepoInfo extends StatefulWidget {
  MoreRepoInfo({Key key, @required this.repoInfo}) : super(key: key);

  final Map repoInfo;

  @override
  _MoreRepoInfoState createState() => _MoreRepoInfoState(repoInfo: repoInfo);
}

class _MoreRepoInfoState extends State<MoreRepoInfo> {
  _MoreRepoInfoState({this.repoInfo});

  final repoInfo;

  String formatBytes(int bytes) {
    if (bytes <= 0) return "0";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1000)).floor();
    return ((bytes / pow(1000, i)).toStringAsFixed(2)) + suffixes[i];
  }

  Color fromHexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final numberDisplay = numberFormatter.createDisplay(
      length: 4,
      decimal: 0,
      // separator: '\'',
    );
    final String repoName = repoInfo['name'];
    final String repoOwner = repoInfo['owner']['login'];
    final String getMoreRepositoryInfo = r'''
      query SearchRepositories($name: String!, $owner: String!) {
        repository(name: $name, owner: $owner) {
          diskUsage
          licenseInfo {
            name
          }
          primaryLanguage {
            name
            color
          }
          stargazers(last: 6) {
            totalCount
            nodes {
              avatarUrl(size: 70)
            }
          }
          forks(last: 6) {
            totalDiskUsage
            totalCount
            nodes {
              owner {
                avatarUrl
              }
            }
          }
          object(expression:"master") {
            ... on Commit {
              history {
                totalCount
              }
            }
          }
        }
      }
    ''';

    Widget getForksContent(Map forks) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.all(Radius.elliptical(7.0, 20.0)),
        ),
        margin: EdgeInsets.symmetric(vertical: 20.0),
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Octicons.repo_forked,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.07,
                  semanticLabel: 'Github fork icon',
                ),
                Text(
                  'FORKS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                VerticalDivider(width: 3.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 9.0,
                    vertical: 3.0,
                  ),
                  child: Center(
                    child: Text(
                      numberDisplay(forks['totalCount']),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                VerticalDivider(width: 10.0),
                Stack(
                  children: <Widget>[
                    for (int i = forks['nodes'].length - 1; i >= 0; --i)
                      Container(
                        margin: EdgeInsets.only(left: i * 15.0),
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.04,
                          backgroundImage: NetworkImage(
                            forks['nodes'][i]['owner']['avatarUrl'].toString(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Divider(height: 10.0),
            Row(
              children: <Widget>[
                VerticalDivider(width: 15.0),
                Container(
                  child: Icon(
                    Icons.storage,
                    size: 15.0,
                    semanticLabel: 'storage icon',
                    color: Colors.white70,
                  ),
                ),
                VerticalDivider(width: 10.0),
                Expanded(
                  child: Text(
                    'All forks of this repository combined are currently using ' +
                        formatBytes(forks['totalDiskUsage'] * 1000) +
                        ' of storage space.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget getStargazersContent(Map stargazers) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.amberAccent),
          borderRadius: BorderRadius.all(Radius.elliptical(7.0, 20.0)),
          // color: Colors.amberAccent,
        ),
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Octicons.star,
                  color: Colors.amberAccent,
                  size: MediaQuery.of(context).size.width * 0.07,
                  semanticLabel: 'Github star icon',
                ),
                Text(
                  'STARS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.amberAccent,
                  ),
                ),
                VerticalDivider(width: 3.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 9.0,
                    vertical: 3.0,
                  ),
                  child: Center(
                    child: Text(
                      numberDisplay(stargazers['totalCount']),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                VerticalDivider(width: 10.0),
                Stack(
                  children: <Widget>[
                    for (int i = stargazers['nodes'].length - 1; i >= 0; --i)
                      Container(
                        margin: EdgeInsets.only(left: i * 15.0),
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.04,
                          backgroundImage: NetworkImage(
                            stargazers['nodes'][i]['avatarUrl'].toString(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Query(
      options: QueryOptions(
        documentNode: gql(getMoreRepositoryInfo),
        variables: <String, dynamic>{
          'name': repoName,
          'owner': repoOwner,
        },
        pollInterval: 1000,
      ),
      builder: (QueryResult result, {refetch, FetchMore fetchMore}) {
        Widget content = Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
        );

        if (result.data == null && result.hasException) {
          content = Center(
            child: Text(result.exception.toString()),
          );
        }

        if (result.data != null) {
          final moreRepoInfo = result.data['repository'];
          final Map forks = result.data['repository']['forks'];
          final Map startgazers = result.data['repository']['stargazers'];

          content = Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Octicons.git_commit,
                                  size: 15.0,
                                  semanticLabel: 'commit icon',
                                  color: Colors.white70,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'This repository has ' +
                                      numberDisplay(forks['totalCount']) +
                                      ' commits.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 10.0,),
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.storage,
                                  size: 15.0,
                                  semanticLabel: 'storage icon',
                                  color: Colors.white70,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'This repository is currently using ' +
                                      formatBytes(
                                          moreRepoInfo['diskUsage'] * 1000) +
                                      ' of storage space.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                getForksContent(forks),
                getStargazersContent(startgazers),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (moreRepoInfo['primaryLanguage'] != null)
                          Chip(
                            backgroundColor: fromHexToColor(
                                moreRepoInfo['primaryLanguage']['color']
                                    as String),
                            avatar: Icon(
                              Icons.code,
                              size: 15.0,
                              semanticLabel: 'Code icon',
                            ),
                            label: Text(
                              moreRepoInfo['primaryLanguage']['name'],
                            ),
                          ),
                        if (moreRepoInfo['licenseInfo'] != null)
                          Text(
                            "Licence: " + moreRepoInfo['licenseInfo']['name'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return content;
      },
    );
  }
}
