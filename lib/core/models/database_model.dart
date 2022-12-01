class DatabaseModel {
  int? id;
  String? name;
  String? status;
  String? created_at;

  DatabaseModel({
    this.id,
    this.name,
    this.status,
    this.created_at,
  });

  DatabaseModel.fromJson(Map<String, dynamic> json) {
    id= json['id'];
    name= json['name'];
    status= json['status'];
    created_at= json['created_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.created_at;

    return data;
  }
}
