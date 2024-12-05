class FetchImagesResponse {
  int? width;
  int? height;
  List<Sizes>? sizes;
  String? format;
  String? url;
  String? hash;
  String? blurhash;

  FetchImagesResponse(
      {this.width,
      this.height,
      this.sizes,
      this.format,
      this.url,
      this.hash,
      this.blurhash});

  FetchImagesResponse.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    if (json['sizes'] != null) {
      sizes = <Sizes>[];
      json['sizes'].forEach((v) {
        sizes!.add(new Sizes.fromJson(v));
      });
    }
    format = json['format'];
    url = json['url'];
    hash = json['hash'];
    blurhash = json['blurhash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    if (this.sizes != null) {
      data['sizes'] = this.sizes!.map((v) => v.toJson()).toList();
    }
    data['format'] = this.format;
    data['url'] = this.url;
    data['hash'] = this.hash;
    data['blurhash'] = this.blurhash;
    return data;
  }
}

class Sizes {
  int? width;
  int? height;
  String? url;

  Sizes({this.width, this.height, this.url});

  Sizes.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    data['url'] = this.url;
    return data;
  }
}
