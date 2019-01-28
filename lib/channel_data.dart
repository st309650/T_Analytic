class ChannelData{
  String creationTime;
  String displayName;
  String id;
  String language;
  String name;
  String status;
  String updatedTime;
  String url;

  ChannelData({this.creationTime, this.displayName, this.id,
      this.language, this.name, this.status, this.updatedTime,
      this.url});

  factory ChannelData.fromJson(Map<String, dynamic> json) {
    return ChannelData(
        creationTime: json['creationTime'],
        displayName: json['displayName'],
        id: json['id'],
        language: json['language'],
        name: json['name'],
        status: json['status'],
        updatedTime: json['updatedTime'],
        url: json['url']
    );
  }

}