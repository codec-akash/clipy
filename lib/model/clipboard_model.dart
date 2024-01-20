class ClipBoardContent {
  late String id;
  late String createdAt;
  late String content;
  late String type;

  ClipBoardContent({
    required this.id,
    required this.createdAt,
    required this.content,
    required this.type,
  });

  ClipBoardContent.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    content = json['content'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['content'] = content;
    data['type'] = type;
    return data;
  }
}
