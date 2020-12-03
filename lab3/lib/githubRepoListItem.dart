import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab3/routes/githubRepoPage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:number_display/number_display.dart' as numberFormatter;

class GithubRepoListItem extends StatelessWidget {
  GithubRepoListItem({Key key, @required this.repoInfo}) : super(key: key);

  final repoInfo;

  @override
  Widget build(BuildContext context) {
    final numberDisplay = numberFormatter.createDisplay(
      length: 4,
      decimal: 0,
      // separator: '\'',
    );

    final forks = Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.all(Radius.elliptical(7.0, 20.0)),
      ),
      padding: EdgeInsets.all(3.0),
      child: Row(
        children: <Widget>[
          Icon(
            Octicons.repo_forked,
            color: Colors.white,
            size: 11.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          VerticalDivider(width: 3.0),
          Text(
            numberDisplay(repoInfo['forks']['totalCount']),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    final stars = Container(
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.all(Radius.elliptical(7.0, 20.0)),
        color: Colors.amberAccent,
      ),
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.only(left: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Octicons.star,
            color: Colors.black,
            size: 11.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          VerticalDivider(width: 3.0),
          Text(
            numberDisplay(repoInfo['stargazers']['totalCount']),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      margin: EdgeInsets.all(7.0),
      child: Card(
        margin: EdgeInsets.all(0.0),
        color: Color.fromRGBO(47, 47, 46, 1),
        elevation: 3.0,
        child: FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GithubRepoPage(repoInfo: repoInfo))
            );
          },
          onLongPress: () {},
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    repoInfo['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.04,
                    backgroundImage: NetworkImage(
                      repoInfo['owner']['avatarUrl'].toString(),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(
                  repoInfo['nameWithOwner'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white54,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  repoInfo['description'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    forks,
                    stars,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
