class TodoModel {
  final int? id;
  final String? title;
  final String? description;

  TodoModel({
    this.id,
    this.title,
    this.description
  });

  TodoModel.fromMap(Map<String, dynamic> res): id = res['id'], title = res['title'], description = res['description'];

  Map<String, Object?> toMap(){
    return  {
      'id': id,
      'title': title,
      'description': description
    };
  }
}