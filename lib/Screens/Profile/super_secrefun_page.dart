import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/utils/common.dart';

class SuperSecretFunPage extends StatelessWidget {
  final List<Map<String, String>> itemsList = [
    {
      'text': 'I Duped Myself For Him',
      'emoji': '🕵️‍♂️',
      "url":
          "https://www.redbubble.com/people/this-is-a-copy/shop?artistUserName=this-is-a-copy&collections=861187&iaCode=u-tees&sortOrder=top%20selling"
    },
    {
      'text': 'I Duped Myself For Her',
      'emoji': '🕵️‍♀️',
      "url":
          "https://www.redbubble.com/people/this-is-a-copy/shop?artistUserName=this-is-a-copy&asc=u&collections=861187&iaCode=w-dresses"
    },
    {
      'text': 'Expensive Stuff For Him',
      'emoji': '⌚',
      "url":
      "https://www.redbubble.com/people/this-is-genuine/shop?artistUserName=this-is-genuine&asc=u&collections=860814&iaCode=u-tees"
    },
    {
      'text': 'Expensive Stuff For Her',
      'emoji': '💎',
      "url":
          "https://www.redbubble.com/people/this-is-genuine/shop?artistUserName=this-is-genuine&asc=u&collections=860814&iaCode=w-dresses&sortOrder=top%20selling"
    },
    {
      'text': 'Lilibet\'s Wardrobe',
      'emoji': '👗',
      "url":
      "https://www.redbubble.com/people/this-is-genuine/shop?artistUserName=this-is-genuine&asc=u&collections=2743558&iaCode=w-dresses"
    },
    {
      'text': 'ROAR Merch',
      'emoji': '🦁',
      "url":
          "https://www.redbubble.com/people/this-is-a-copy/shop?artistUserName=this-is-a-copy&iaCode=u-tees&sortOrder=top%20selling"
    },
    {
      'text': 'Hand Roasted Coffee (COMING SOON)',
      'emoji': '☕',
      "url": "https://www.youtube.com/watch?v=T1Evnfgw-zY"
    },
    {
      'text': 'Makeup store',
      'emoji': '☕',
      "url":
          "https://thenastycollectorsnastycollection.com/your-makeup-is-terrible/"
    },
    {
      'text': 'Our #1 St-Walkers R For Sale Here',
      'emoji': '👠',
      "url": "https://luxedb.com/top-20-trends-of-the-day-dec-28/"
    },
    {
      'text': 'Backstage Pop Gossip',
      'emoji': '🎤',
      "url": "https://thenastycollectorsnastycollection.com/the-dressing-room/"
    },
    {
      'text': 'Tales Of The Sh*tty',
      'emoji': '📚',
      "url": "https://www.youtube.com/@talesoftheshitty"
    },
    {
      'text': 'Tales Of The Sh*tty Merch',
      'emoji': '🛍️',
      "url":
          "https://www.redbubble.com/people/this-is-a-copy/shop?artistUserName=this-is-a-copy&asc=u&collections=3435183&iaCode=u-decor"
    },
    {
      'text': 'ROAR Dance Podcasts',
      'emoji': '🎧',
      "url": "https://soundcloud.com/nextgendates"
    },
    {
      'text': 'PiccyBot will be your judge',
      'emoji': '🤖',
      "url": "https://youtu.be/KfF1dZuSziw?si=eq-aKHcynJKvuVTj"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Super Secret Fun Page",
            style: TextStyle(fontWeight: FontWeight.bold, color: white)),
        backgroundColor: black,
        iconTheme: IconThemeData(color: white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/supersecret.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: itemsList.map((item) => _buildGridItem(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildGridItem(Map item) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: transparentColor,
      child: InkWell(
        onTap: () => commonLaunchUrl(item["url"]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${item["emoji"]}",
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item["text"],
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
