import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

Future<bool> hasInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    log('lookup result: google.com: $result');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
