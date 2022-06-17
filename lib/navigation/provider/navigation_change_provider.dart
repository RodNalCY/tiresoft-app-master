import 'package:flutter/material.dart';
import 'package:tiresoft/navigation/models/navigation_item_model.dart';

class NavigationChangeProvider extends ChangeNotifier {
  NavigationItemModel _navigationItemModel =
      NavigationItemModel.registro_inspeccion;

  NavigationItemModel get navigationItemModel => _navigationItemModel;
  void setNavigationItem(NavigationItemModel navigationItemModel) {
    _navigationItemModel = navigationItemModel;
    notifyListeners();
  }
}
