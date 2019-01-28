class StreamData {
  final String creationTime;
  final String fps;
  final String game;
  final String id;
  final String viewers;
  String name;

  StreamData({this.creationTime, this.fps, this.game, this.id, this.viewers});

  void setName(String name){
    this.name = name;
  }
  String getName(){
    return name;
  }
  factory StreamData.fromJson(Map<String, dynamic> json) {
    return StreamData(
      creationTime: json['creationTime'],
      fps: json['fps'],
      game: json['game'],
      id: json['id'],
      viewers: json['viewers']
    );
  }
}