class mynote {
  int? id;
  String ?title;
  String ?content;

  mynote({this.id, this.title, this.content});

  mynote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    return data;
  }
}