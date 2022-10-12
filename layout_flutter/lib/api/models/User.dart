class User {
  final int userId;
  final int id;
  final String title;
  const User({required this.userId, required this.id, required this.title});

  // convert json to object
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userId: json['userId'],
      id: json['id'],
      title: json['title']
    );
  }
  // convert list json to list object
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['id'] = id;
    map['title'] = title;
    return map;
  }
}
