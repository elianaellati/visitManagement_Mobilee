
import 'package:url_launcher/url_launcher.dart';

class MapUtil {

  MapUtil._();

  static Future<void> openMap(String lat, String lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    print("OPENING URI ${uri.toString()}");
    if (await canLaunchUrl(uri)){
      await launchUrl(uri);
    }else{
      throw 'Could not launch uri ${uri.toString()}';
    }
  }
}