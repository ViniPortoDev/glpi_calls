import 'package:app_glpi_ios/app/shared/errors/failure.dart';

class CredentialsFailure extends Failure {
  final String message;

  CredentialsFailure({this.message = 'Usuário ou senha inválidos'})
      : super(message: message);

  @override
  List<Object> get props => [message];
}

class CredentialsExpiredFailure extends Failure {
  final String message;

  CredentialsExpiredFailure({this.message = 'Atualize sua senha!'})
      : super(message: message);

  @override
  List<Object> get props => [message];
}