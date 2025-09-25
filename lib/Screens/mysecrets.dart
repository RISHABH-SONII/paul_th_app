import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/components/privatepubliclytotal.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/Screens/Tab.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/utls.dart';

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet>
    with SingleTickerProviderStateMixin {
  bool _isBlurred = true;
  late TabController _tabController;
  List<User> _leaderboardData = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _isBlurred = true;
    });
  }

  Future<void> _fetchLeaderboardData() async {
    await fetchSecring().then((response) async {
      Rks.logger.d(response.data);

      List<User> allusers = [];
      response.data.forEach((element) async {
        allusers.add(User.fromJson(element));
      });
      setState(() {
        _leaderboardData = allusers;
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Wallet"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          tabs: [
            Tab(
              icon: Icon(Icons.credit_card),
              text: "Credit",
            ),
            Tab(
              icon: Icon(Icons.account_balance),
              text: "Debit",
            ),
          ],
        ),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    Text("Tab1"),
                    Text("Tab2"),
                  ],
                )
              ],
            ),
    );
  }
}

class TopPlayerCard extends StatelessWidget {
  final User player;
  final int rank;

  const TopPlayerCard({required this.player, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => GridGalleryPublicTotal(
                showOverlays: false,
                theuser: player,
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                imageUrl(player.imageUrl![0]) ?? '',
              ),
              radius: 25,
            ),
            8.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${player.lastName ?? 'Player'} ${player.firstName}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                8.height,
                Text(
                  "${countVideos(player.privates!)} Videos\n${countImages(player.privates!)} Images",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  final dynamic player;
  final int rank;

  const PlayerCard({required this.player, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl(player['image']) ?? ''),
          radius: 20,
        ),
        title: Text(
          player['fullName'] ?? 'Player',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Score: ${player['score'] ?? 0}"),
        trailing: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "#$rank",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}
