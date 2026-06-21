import 'package:flutter/material.dart';

import 'pages/perimeter_security_page.dart';

class PerimeterSecurityRoutes {
  const PerimeterSecurityRoutes._();

  static const String security = '/perimeter-security';

  static Map<String, WidgetBuilder> get routes => {
        security: (_) => const PerimeterSecurityPage(),
      };
}
