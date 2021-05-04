import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/base/model/base_view_model.dart';
import '../../../../core/init/network/vexana_manager.dart';
import '../model/login_model.dart';
import '../service/ILoginService.dart';
import '../service/login_service.dart';

part 'login_view_model.g.dart';

class LoginViewModel = _LoginViewModelBase with _$LoginViewModel;

abstract class _LoginViewModelBase with Store, BaseViewModel {
  GlobalKey<FormState> formstate =
      GlobalKey(); //request sayfamdaki formun validasyonunu sağlarız.
  GlobalKey<ScaffoldState> scaffoldstate = GlobalKey();
  ILoginService loginService;

  TextEditingController emailController;
  TextEditingController passwordController;
  void setContext(BuildContext context) => this.context = context;
  void init() {
    loginService = LoginService(VexanaManager.instance.networkManager);
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @observable
  bool isLoading = false;

  @observable
  bool isLockOpen = false;

  @action
  Future<void> fetchLoginService() async {
    isLoadingChange();
    if (formstate.currentState.validate()) {
      final response = await loginService.fetchUserControl(LoginModel(
          email: emailController.text, password: passwordController.text));

      if (response != null) {
        scaffoldstate.currentState
            .showSnackBar(SnackBar(content: Text(response.token)));
        // localeManager.setStringValue(PreferencesKeys.TOKEN, response.token);
      }
    }
    isLoadingChange();
  }

  @action
  void isLoadingChange() {
    isLoading = !isLoading;
  }

  @action
  void isLockStateChange() {
    isLockOpen = !isLockOpen;
  }
}
