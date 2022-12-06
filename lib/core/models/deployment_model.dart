class DeploymentModel {
  int? id;
  int? server_id;
  int? site_id;
  int? type;
  String? commit_hash;
  String? commit_author;
  String? commit_message;
  String? started_at;
  String? ended_at;
  String? status;
  String? displayable_type;

  DeploymentModel(
      {
        this.id,
        this.server_id,
        this.site_id,
        this.type,
        this.commit_hash,
        this.commit_author,
        this.commit_message,
        this.started_at,
        this.ended_at,
        this.status,
        this.displayable_type,
    });

  DeploymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    server_id = json['server_id'];
    site_id = json['site_id'];
    type = json['type'];
    commit_hash = json['commit_hash'];
    commit_author = json['commit_author'];
    commit_message = json['commit_message'];
    started_at = json['started_at'];
    ended_at = json['ended_at'];
    status = json['status'];
    displayable_type = json['displayable_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['server_id'] = this.server_id;
    data['site_id'] = this.site_id;
    data['type'] = this.type;
    data['commit_hash'] = this.commit_hash;
    data['commit_author'] = this.commit_author;
    data['commit_message'] = this.commit_message;
    data['started_at'] = this.started_at;
    data['ended_at'] = this.ended_at;
    data['status'] = this.status;
    data['displayable_type'] = this.displayable_type;
    return data;
  }
}
