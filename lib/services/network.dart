import 'package:http/http.dart';

class Network {
  Uri url;
  Map<String,String> headers;

  Network(this.url,this.headers);

  Future getData() async {
    try {
      String data = '';
      Response response = await get(url,headers: headers);

      if (response.statusCode == 200) {
        print('API request successful!');
        //to check if there is no error
        data = response.body;

        return data;
      } else {
        print('API Error:${response.statusCode}');
        return "";
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
