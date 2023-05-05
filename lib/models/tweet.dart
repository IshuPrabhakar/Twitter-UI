class Tweet {
  String userimage;
  String username;
  String name;
  DateTime time;
  String tweet;
  String likes;
  String views;
  String reTweets;
  String comments;

  Tweet({
    required this.username,
    required this.name,
    required this.time,
    required this.tweet,
    required this.userimage,
    required this.likes,
    required this.reTweets,
    required this.views,
    required this.comments,
  });
}
