import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_decorated_text/flutter_decorated_text.dart';
import 'package:intl/intl.dart';
import 'package:twitter_style_feed/util/bottom_nav_bar.dart';
import 'package:faker/faker.dart';

import '../models/tweet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final faker = Faker();
  final _controller = ScrollController();

  // local variables
  List<Tweet> tweets = [];
  List<Tweet> matached = [];
  bool isLikesAsc = false;
  bool isRecentAsc = false;
  bool isViewsAsc = false;
  final List<bool> _selected =
      List.generate(3, (i) => false); // Fill it with false initially

  @override
  void initState() {
    for (var i = 0; i < 20; i++) {
      tweets.add(
        Tweet(
          username: faker.person.firstName(),
          name: faker.person.firstName(),
          time: faker.date.dateTime(),
          tweet: faker.lorem.sentence(),
          userimage: '',
          likes: Random().nextInt(250).toString(),
          reTweets: Random().nextInt(250).toString(),
          views: Random().nextInt(250).toString(),
          comments: Random().nextInt(250).toString(),
        ),
      );
    }

    setState(() {
      matached = tweets;
    });

    super.initState();

    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        loadMoreTweets();
      }
    });
  }

  // LeftSide navigation drawer
  void showDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void loadMoreTweets() async {
    List<Tweet> newTweets = [];
    for (var i = 0; i < 15; i++) {
      newTweets.add(
        Tweet(
          username: faker.person.firstName(),
          name: faker.person.firstName(),
          time: faker.date.dateTime(),
          tweet: faker.lorem.sentence(),
          userimage: '',
          likes: Random().nextInt(250).toString(),
          reTweets: Random().nextInt(250).toString(),
          views: Random().nextInt(250).toString(),
          comments: Random().nextInt(250).toString(),
        ),
      );
    }
    setState(() {
      tweets.addAll(newTweets);
    });
  }

  void filterTweets(String sortBy) {
    switch (sortBy) {
      case "likes":
        if (isLikesAsc) {
          setState(() {
            matached.sort((a, b) {
              final propertyA = int.parse(a.likes);
              final propertyB = int.parse(b.likes);
              if (propertyA < propertyB) {
                return -1;
              } else if (propertyA > propertyB) {
                return 1;
              } else {
                return 0;
              }
            });
          });
        } else {
          setState(() {
            matached.sort((b, a) {
              final propertyA = int.parse(a.likes);
              final propertyB = int.parse(b.likes);
              if (propertyA < propertyB) {
                return -1;
              } else if (propertyA > propertyB) {
                return 1;
              } else {
                return 0;
              }
            });
          });
        }
        break;
      case "recent":
        if (isRecentAsc) {
          setState(() {
            matached.sort((a, b) => a.time.compareTo(b.time));
          });
        } else {
          setState(() {
            matached.sort((b, a) => a.time.compareTo(b.time));
          });
        }

        break;
      case "views":
        if (isViewsAsc) {
          setState(() {
            matached.sort((a, b) {
              final propertyA = int.parse(a.views);
              final propertyB = int.parse(b.views);
              if (propertyA < propertyB) {
                return -1;
              } else if (propertyA > propertyB) {
                return 1;
              } else {
                return 0;
              }
            });
          });
        } else {
          setState(() {
            matached.sort((b, a) {
              final propertyA = int.parse(a.views);
              final propertyB = int.parse(b.views);
              if (propertyA < propertyB) {
                return -1;
              } else if (propertyA > propertyB) {
                return 1;
              } else {
                return 0;
              }
            });
          });
        }
        break;
      default:
    }
  }

  // Bottom Sheet
  void showCustomBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: 240,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 50,
                    color: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        title: const Text(
                          "Recents",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isRecentAsc = !isRecentAsc;
                            _selected[0] = !_selected[0];
                          });
                          filterTweets('recent');
                          Navigator.pop(context);
                        },
                        selected: _selected[0],
                        trailing: Icon(
                          isRecentAsc
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          "Likes",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isLikesAsc = !isLikesAsc;
                            _selected[1] = !_selected[1];
                          });
                          filterTweets('likes');
                          Navigator.pop(context);
                        },
                        selected: _selected[1],
                        trailing: Icon(
                          isLikesAsc
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          "Views",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isViewsAsc = !isViewsAsc;
                            _selected[2] = !_selected[2];
                          });
                          filterTweets('views');
                          Navigator.pop(context);
                        },
                        selected: _selected[2],
                        trailing: Icon(
                          isViewsAsc
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              (Theme.of(context).brightness != Brightness.light)
                  ? Brightness.light
                  : Brightness.dark,
          statusBarBrightness:
              (Theme.of(context).brightness == Brightness.light)
                  ? Brightness.light
                  : Brightness.dark,
        ),
        backgroundColor: Colors.white,
        leadingWidth: 40,
        elevation: 0,
        toolbarHeight: 65,
        title: const Text(
          "Twitter",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Builder(
            builder: (ctx) {
              return InkWell(
                onTap: () {
                  showDrawer(ctx);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    faker.image.image(
                      width: 20,
                      height: 20,
                      keywords: ["people"],
                    ),
                  ),
                  radius: 20,
                ),
              );
            },
          ),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: matached.length + 1,
        controller: _controller,
        itemBuilder: (context, index) {
          if (index < tweets.length) {
            return Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Wrap(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          backgroundImage: NetworkImage(
                            faker.image.image(
                              width: 20,
                              height: 20,
                              keywords: ["people"],
                              random: true,
                            ),
                          ),
                          radius: 23,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name, username, time etc.
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        // Name
                                        Text(
                                          tweets[index].name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        // Verified or not
                                        const Icon(
                                          Icons.verified,
                                          size: 17,
                                          color: Colors.blueAccent,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        // Username
                                        Text(
                                          tweets[index].username,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        const Text(
                                          ".",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        // Time
                                        // time is random integer value due to faker package.
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            DateFormat()
                                                .add_yMd()
                                                .add_jm()
                                                .format(tweets[index].time)
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Tweet Content
                                  // supports link, hashtag, mention highlighting
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: DecoratedText(
                                      text:
                                          faker.lorem.sentences(5).join(' \n '),
                                      rules: [
                                        DecoratorRule.startsWith(
                                          text: "@",
                                          onTap: (match) {
                                            // TODO
                                          },
                                          style: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        DecoratorRule.startsWith(
                                          text: "#",
                                          onTap: (match) {
                                            // TODO
                                          },
                                          style: const TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                        DecoratorRule.url(
                                          onTap: (url) {
                                            // TODO
                                          },
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Actions button
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _QuickActionButton(
                                          icon:
                                              Icons.chat_bubble_outline_rounded,
                                          count: tweets[index].comments,
                                        ),
                                        _QuickActionButton(
                                          icon: Icons.repeat,
                                          count: tweets[index].reTweets,
                                        ),
                                        _QuickActionButton(
                                          icon: Icons.thumb_up,
                                          count: tweets[index].likes,
                                        ),
                                        _QuickActionButton(
                                          icon: Icons.bar_chart,
                                          count: tweets[index].views,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: const Icon(Icons.more_vert),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemSelected: (int value) {},
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FloatingActionButton(
              onPressed: () {
                showCustomBottomSheet(context);
              },
              child: const Icon(Icons.filter_alt),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.count,
  });

  final IconData icon;
  final String count;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(count),
        ],
      ),
    );
  }
}
