class Model {
  final String username;
  final String password;

  Model({this.username, this.password});

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      username: json['username'],
      password: json['password'],
    );
  }
}
