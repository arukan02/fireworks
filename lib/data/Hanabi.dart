class Hanabi{

  final String Date;
  final String StartTime;
  final String Title;
  final String Place;
  final String Music;
  final String MusicURL;
  final String StoryURL;
  final DateTime timestamp;


  Hanabi(this.Date, this.Title, this.Place, this.Music, this.MusicURL, this.StoryURL, this.timestamp, this.StartTime );

  Hanabi.fromJson(Map<dynamic, dynamic> json)
      : timestamp = DateTime.parse(json['timestamp'] as String),
        StartTime = json['StartTime'] as String,
        Date = json['Date'] as String,
        Place = json['Place'] as String,
        Title = json['Title'] as String,
        Music = json['Music'] as String,
        MusicURL = json['MusicURL'] as String,
        StoryURL = json['StoryURL'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'timestamp': timestamp.toString(),
    'Date': Date,
    'Place': Place,
    'Title': Title,
    'Music': Music,
    'MusicURL': MusicURL,
    'StoryURL': StoryURL,
    'StartTime': StartTime
  };
}
