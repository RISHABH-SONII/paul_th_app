import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tharkyApp/Screens/Information.dart';
import 'package:tharkyApp/models/searchuser_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/utls.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<dynamic> _leaderboardData = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
  }

  Future<void> _fetchLeaderboardData() async {
    await fetchRanking().then((response) async {
      setState(() {
        _leaderboardData = response.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
        centerTitle: true,
      ),
      body:
          /* _leaderboardData.isEmpty
          ? Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : */
          ListView.builder(
        itemCount: _leaderboardData.length,
        itemBuilder: (context, index) {
          final player = _leaderboardData[index];
          final isTopThree = index < 3;

          return isTopThree
              ? FadeInDown(
                  delay: Duration(milliseconds: index * 200),
                  child: TopPlayerCard(
                    player: player,
                    rank: index + 1,
                  ),
                )
              : PlayerCard(
                  player: player,
                  rank: index + 1,
                );
        },
      ),
    );
  }
}

class TopPlayerCard extends StatelessWidget {
  final dynamic player;
  final int rank;

  const TopPlayerCard({required this.player, required this.rank});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showuser(player, context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: rank == 1
                ? [Colors.yellow, Colors.orange]
                : rank == 2
                    ? [Colors.grey, Colors.white70]
                    : [Colors.brown, Colors.orangeAccent],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              imageUrl(player['image']) ?? '',
            ),
            radius: 25,
          ),
          title: Text(
            player['fullName'] ?? 'Player',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            "Score: ${player['totalScore'] ?? 0}",
            style: TextStyle(color: Colors.white70),
          ),
          trailing: Text(
            "#$rank",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

void showuser(player, context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        var useryousee = SearchUser.fromJson(player);
        return Info(SearchUser.fromJson(player), Rks.currencUser, null,
            useryousee.isMatchedWithUser);
      });
}

class PlayerCard extends StatelessWidget {
  final dynamic player;
  final int rank;

  const PlayerCard({required this.player, required this.rank});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showuser(player, context);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl(player['image']) ?? ''),
            radius: 20,
          ),
          title: Text(
            player['fullName'] ?? 'Player',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text("Score: ${player['totalScore'] ?? 0}"),
          trailing: Text(
            "#$rank",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
