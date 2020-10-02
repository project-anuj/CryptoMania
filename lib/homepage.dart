import 'dart:convert';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'details.dart';

class HomePage extends StatefulWidget {
  final bool darkThemeEnabled;
  HomePage(this.darkThemeEnabled);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = "https://api.coinranking.com/v1/public/coins";
  List coins;
  List graph;
  @override
  void initState() {
    super.initState();
    this.getCurrencies();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CryptoMania App"),
        actions: [
          Switch(value: widget.darkThemeEnabled, onChanged: bloc.changeTheme),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: _cryptoWidget(),
    );
  }

  Widget _cryptoWidget() {
    return Container(
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
        child: SvgPicture.network(
          coins[index]["iconUrl"],
          fit: BoxFit.cover,
        ),
      ),
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
              text: "Change = $_text2",
              style: TextStyle(
                  color:
                      coins[index]["change"] < 0 ? Colors.red : Colors.green)),
        ]),
      ),
    );
  }
}
