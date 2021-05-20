class CategoryModel {
  int cId;
  String cName;
  int cType;
  int cStatus;

  CategoryModel({this.cId, this.cName, this.cType, this.cStatus});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    cId = json['c_id'];
    cName = json['c_name'];
    cType = json['c_type'];
    cStatus = json['c_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['c_id'] = this.cId;
    data['c_name'] = this.cName;
    data['c_type'] = this.cType;
    data['c_status'] = this.cStatus;
    return data;
  }
}