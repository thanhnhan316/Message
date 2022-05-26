final String tableUser = "users";

//đặt tên để thống nhất tên chung
class UserFields {
  static final List<String> values = [
    id,
    userName,
    fullName,
    password,
    email,
    avatar,
    status
  ];

  static final String id = 'id';
  static final String userName = 'userName';
  static final String fullName = 'fullName';
  static final String password = 'password';
  static final String email = 'email';
  static final String avatar = 'avatar';
  static final String status = 'status';
}

class User {
  final int? id;
  final String userName;
  final String fullName;
  final String password;
  final String email;
  final String avatar;
  final String status;

  User(
      {this.id,
      required this.userName,
      required this.fullName,
      required this.password,
      required this.email,
      required this.avatar,
      required this.status});

// truyền tham số cho copy thì sẽ trả về User
  User copy(
          {int? id,
          String? userName,
          String? fullName,
          String? password,
          String? email,
          String? avatar,
          String? status}) =>
      User(
          id: id ?? this.id,
          userName: userName ?? this.userName,
          fullName: fullName ?? this.fullName,
          password: password ?? this.password,
          email: email ?? this.email,
          avatar: avatar ?? this.avatar,
          status: status ?? this.status);

  static User fromJson(Map<String, Object?> json) => User(
      id: json[UserFields.id] as int?,
      userName: json[UserFields.userName] as String,
      fullName: json[UserFields.fullName] as String,
      password: json[UserFields.password] as String,
      email: json[UserFields.email] as String,
      avatar: json[UserFields.avatar] as String,
      status: json[UserFields.status] as String);

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.userName: userName,
        UserFields.fullName: fullName,
        UserFields.password: password,
        UserFields.email: email,
        UserFields.avatar: avatar,
        UserFields.status: status
      };
}
