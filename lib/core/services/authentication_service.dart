import 'dart:async';
import '../models/user.dart';
import '../../locator.dart';
import 'api.dart';

class AuthenticationService {
  Api _api = locator<Api>();

  StreamController<User> userController = StreamController<User>();
  User user = User.initial();

  Future<bool> login(String token) async {
    var fetchedUser = await _api.getUserProfile(token);

    var hasUser = fetchedUser != null;
    if (hasUser) {
      userController.add(fetchedUser);
      user = fetchedUser;
    }

    return hasUser;
  }
}
