class UserModel {
  final int? id;
  final String? email;
  final String? name;
  final String? authToken;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.authToken
  });

  UserModel.fromMap(Map<String, dynamic> res): id = res['id'], email = res['email'], name = res['name'], authToken = res['auth_token'];

  Map<String, Object?> toMap(){
    return  {
      'id': id,
      'name': name,
      'email': email,
      'auth_token': authToken
    };
  }
}