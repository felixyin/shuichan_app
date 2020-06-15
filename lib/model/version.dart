class Data {
  String version;
  String name;
  String url;

  Data.fromJson(Map<String, dynamic> json)
      : version = json['version'],
        name = json['name'],
        url = json['url'];

  @override
  String toString() {
    return 'name: $name ,version: $version,url: $url';
  }
}

class Version {
  Data data;
  int status;
  bool success;

  Version.formJson(Map<String, dynamic> json)
      : status = json['status'],
        success = json['success'],
        data = Data.fromJson(json['data']);

  @override
  String toString() {
    return 'status: $status ,success: $success,date: ${data.toString()}';
  }
}
