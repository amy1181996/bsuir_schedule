import 'dart:io';

mixin SharedApi {
  final _client = HttpClient();
  static const _host = "https://iis.bsuir.by/api/v1/";

  Future<HttpClientResponse> getResponse(String localPath) async {
    final url = Uri.parse('$_host$localPath');
    final request = await _client.getUrl(url);
    final response = await request.close();
    return response;
  }
}
