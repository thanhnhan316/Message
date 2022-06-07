// import 'dart:typed_data';

// final String tablePicture = "picture";

// //đặt tên để thống nhất tên chung
// class PictureFields {
//   static final List<String> values = [id, idUser, picture];

//   static final String id = "id";
//   static final String idUser = "idUser";
//   static final String picture = "picture";
// }

// class Picture {
//   final int? id;
//   final int idUser;
//   final Uint8List picture;

//   Picture({this.id, required this.idUser, required this.picture});

//   Picture copy({int? id, int? idUser, Uint8List? picture}) => Picture(
//       id: id ?? this.id,
//       idUser: idUser ?? this.idUser,
//       picture: picture ?? this.picture);

//   static Picture fromJson(Map<String, Object?> json) => Picture(
//       id: json[PictureFields.id] as int,
//       idUser: json[PictureFields.idUser] as int,
//       picture: json[PictureFields.picture] as Uint8List);

//   Map<String, Object?> toJson() => {
//         PictureFields.id: id,
//         PictureFields.idUser: idUser,
//         PictureFields.picture: picture
//       };

//   // Picture.fromMap(Map map, this.id, this.title, this.picture) {
//   //   id = map[id];
//   //   title = map[title];
//   //   picture = map[picture];
//   // }

//   // Map<String, dynamic> toMap() => {
//   //       "id": id,
//   //       "title": title,
//   //       "picture": picture,
//   //     };
// }
