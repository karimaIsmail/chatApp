import 'package:chatapp/core/errors/expentions.dart';
import 'package:http/http.dart' as http;

class ImageBytes {
  Future imageBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } on Exception catch (e) {
      handleException(e);
    }
  }
}
