import 'package:app_project_dc/page/home_page.dart';
import 'package:app_project_dc/widget/main_bounce_tabar.dart';
import 'package:app_project_dc/widget/main_side_menu.dart';
import 'package:app_project_dc/widget/main_social_share_buttons.dart';
import 'package:app_project_dc/widget/view_document.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'HomePage': (_) => HomePage(),
  'MainBounceTabar': (_) => MainBounceTabar(),
  'ViewDocument': (_) => ViewDocument(),
  'MainSideMenu': (_) => MainSideMenu(),
  'MainSocialShareButtons': (_) => MainSocialShareButtons(),
};
