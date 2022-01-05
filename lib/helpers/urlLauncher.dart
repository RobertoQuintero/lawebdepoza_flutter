import 'package:lawebdepoza_mobile/models/models.dart';
import 'package:lawebdepoza_mobile/services/notifications_service.dart';
import 'package:url_launcher/url_launcher.dart';

Future urlLauncher(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    NotificationsService.showSnackbar('Error de conexión');
  }
}

Future urlLauncherMap(Coordinates coordinates) async {
  final url =
      'http://www.google.com/maps/place/${coordinates.lat},${coordinates.lng}';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    NotificationsService.showSnackbar('Error de conexión');
  }
}
