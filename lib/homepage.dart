import 'dart:convert';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cryptocurrency/news.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = "https://api.coinranking.com/v1/public/coins";
  String url1 = 'https://min-api.cryptocompare.com/data/v2/news/?lang=EN';
  List newsList = [];
  List coins;
  List graph;
  int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    this.getCurrencies();
    this.loadNews();
  }

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future<String> getCurrencies() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      var convertToJson = json.decode(response.body);
      coins = convertToJson["data"]["coins"];
      // print(coins);
    });
    return "SUCCESS";
  }

  Future<String> loadNews() async {
    var response = await http
        .get(Uri.encodeFull(url1), headers: {"Accept": "application/json"});
    setState(() {
      var convertToJson = json.decode(response.body);
      newsList = convertToJson['Data'];
      // print(newsList);
    });
    return "SUCCESS";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("CryptoMania App"),
          backgroundColor: Colors.indigoAccent,
        ),
        bottomNavigationBar: BubbleBottomBar(
          elevation: 5,
          opacity: 0.2,
          backgroundColor: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          currentIndex: currentIndex,
          hasInk: true,
          inkColor: Colors.black12,
          hasNotch: true,
          fabLocation: BubbleBottomBarFabLocation.end,
          onTap: changePage,
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
                backgroundColor: Colors.indigoAccent,
                icon: Icon(
                  Icons.dashboard,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.dashboard,
                  color: Colors.red,
                ),
                title: Text('All Coins')),
            BubbleBottomBarItem(
                backgroundColor: Colors.indigoAccent,
                icon: Icon(
                  Icons.tv,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.tv,
                  color: Colors.red,
                ),
                title: Text('News')),
          ],
        ),
        body: currentIndex == 0
            ? _cryptoWidget()
            : News(
                newsList: newsList,
              ));
  }

  Widget _cryptoWidget() {
    return coins == null
        ? SpinKitFadingCircle(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.red : Colors.green,
                ),
              );
            },
          )
        : Container(
            child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: coins == null ? 0 : coins.length,
                  itemBuilder: (context, index) {
                    return coins == null
                        ? CircularProgressIndicator()
                        : builderWidget(index);
                  },
                ),
              ),
            ],
          ));
  }

  ListTile builderWidget(int index) {
    String _text1 = coins[index]["price"];
    String _text2 = coins[index]["change"].toString();

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(
                name: coins[index]["name"],
                url: coins[index]["iconUrl"],
                graph: coins[index]["history"],
                symbol: coins[index]["symbol"],
                description: coins[index]["description"],
                rank: coins[index]["rank"].toString(),
                website: coins[index]["websiteUrl"].toString(),
                numberOfMarkets: coins[index]["numberOfMarkets"].toString(),
                numberOfExchanges: coins[index]["numberOfExchanges"].toString(),
                volume: coins[index]["volume"].toString(),
                circulatingSupply: coins[index]["circulatingSupply"].toString(),
                totalSupply: coins[index]["totalSupply"].toString(),
                approvedSupply: coins[index]["approvedSupply"].toString(),
                firstSeen: coins[index]["firstSeen"].toString(),
                listedAt: coins[index]["listedAt"].toString(),
                links: coins[index]["links"],
              ),
            ));
      },
      leading: CircleAvatar(
          backgroundColor: Colors.grey,
          child: SvgPicture.network(
            coins[index]["iconUrl"],
            fit: BoxFit.cover,
          )),
      title: Text(
        coins[index]["name"],
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      isThreeLine: true,
      subtitle: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: "Current Price = $_text1\$\n",
              style: TextStyle(color: Colors.black)),
          TextSpan(
              text:
                  "Change = ${coins[index]["change"] >= 0 ? '+' + _text2 : _text2}",
              style: TextStyle(
                  color:
                      coins[index]["change"] < 0 ? Colors.red : Colors.green)),
        ]),
      ),
    );
  }
}
