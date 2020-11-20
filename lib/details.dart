import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  final String name, url, symbol, description, rank, website;
  final List links;
  final String numberOfMarkets,
      numberOfExchanges,
      volume,
      circulatingSupply,
      totalSupply,
      firstSeen,
      listedAt,
      approvedSupply;
  final List graph;
  Details(
      {this.name,
      this.url,
      this.graph,
      this.symbol,
      this.description,
      this.rank,
      this.website,
      this.numberOfMarkets,
      this.numberOfExchanges,
      this.volume,
      this.circulatingSupply,
      this.totalSupply,
      this.approvedSupply,
      this.firstSeen,
      this.listedAt,
      this.links});
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  List<double> _giveData() {
    List<double> data = List<double>();

    for (var x in widget.graph) {
      data.add(double.parse(x));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: Colors.indigoAccent,
          actions: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: SvgPicture.network(
                widget.url,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  height: height / 3,
                  child: Card(
                    elevation: 20,
                    shadowColor: Colors.deepPurple,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Sparkline(
                        pointsMode: PointsMode.all,
                        pointSize: 5,
                        sharpCorners: false,
                        data: _giveData(),
                        // lineColor: Colors.teal,
                        lineGradient: new LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.purple[800], Colors.purple[200]],
                        ),
                        pointColor: Colors.blue,
                      ),
                    ),
                  ),
                ),
                if (widget.rank != null)
                  ListTile(
                      title: Text(
                    "Rank : ${widget.rank}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                if (widget.symbol != null)
                  ListTile(
                      title: Text(
                    "Symbol : ${widget.symbol}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                if (widget.description != null)
                  ListTile(
                    title: Text(
                      "Description ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                if (widget.description != null)
                  ListTile(
                    title: Text(_parseHtmlString(widget.description)),
                  ),
                if (widget.website != null)
                  ListTile(
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            "Website : ",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          InkWell(
                              onTap: () async {
                                await launch(widget.website);
                              },
                              child: Text(
                                widget.website,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              )),
                        ],
                      ),
                    ),
                  ),
                if (widget.numberOfMarkets != null)
                  ListTile(
                      title: Text(
                    "Number of Markets : ${widget.numberOfMarkets}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                if (widget.numberOfExchanges != null)
                  ListTile(
                      title: Text(
                    "Number of Exchanges : ${widget.numberOfExchanges}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                if (widget.volume != null)
                  ListTile(
                      title: Text(
                    "Volume : ${widget.volume}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                if (widget.circulatingSupply != null)
                  ListTile(
                      title: Text(
                    "Circulating Supply : ${widget.circulatingSupply}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                if (widget.totalSupply != null)
                  ListTile(
                      title: Text(
                    "Total Supply : ${widget.totalSupply}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                if (widget.approvedSupply != null)
                  ListTile(
                      title: Text(
                    "Approved Supply : ${widget.approvedSupply}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                if (widget.firstSeen != null)
                  ListTile(
                      title: Text(
                    "First Seen : ${widget.firstSeen}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                if (widget.listedAt != null)
                  ListTile(
                      title: Text(
                    "Listed At : ${widget.listedAt}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              ],
            ),
          ),
        ));
  }
}
