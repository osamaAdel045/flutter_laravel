class Server {
  int? id;
  String? name;
  String? region;
  String? ip_address;
  String? php_version;
  String? database_type;
  String? type;
  String? size;
  bool? is_ready;

  Server(
      {this.id,
      this.name,
      this.region,
      this.ip_address,
      this.php_version,
      this.database_type,
      this.type,
      this.size,
      this.is_ready});

  Server.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    region = json['region'];
    ip_address = json['ip_address'];
    php_version = json['php_version'];
    database_type = json['database_type'];
    type = json['type'];
    size = json['size'];
    is_ready = json['is_ready'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['region'] = this.region;
    data['ip_address'] = this.ip_address;
    data['php_version'] = this.php_version;
    data['database_type'] = this.database_type;
    data['type'] = this.database_type;
    data['size'] = this.size;
    data['is_ready'] = this.is_ready;
    return data;
  }
}
