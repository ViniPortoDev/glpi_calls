import 'package:app_glpi_ios/app/shared/errors/failure.dart';

class LoginFailure extends Failure {
  LoginFailure(message) : super(message:message);

  @override
  List<Object> get props => [message];
}