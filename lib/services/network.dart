import 'package:http/http.dart';

class Network {
  String url;

  Network(this.url);

  Future getData() async {
    try {
      Response response = await get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('API request successful!');
        //to check if there is no error
        String data = response.body;

        return data;
      } else {
        print('API Error:${response.statusCode}');

        return '';
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
