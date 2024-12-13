import 'package:app_glpi_ios/app/modules/change_password/change_password_page.dart';
import 'package:app_glpi_ios/app/modules/change_password/change_password_store.dart';
import 'package:app_glpi_ios/app/modules/home/home_store.dart';
import 'package:app_glpi_ios/app/modules/init/init.dart';
import 'package:app_glpi_ios/app/modules/login/login_page.dart';
import 'package:app_glpi_ios/app/modules/login/login_store.dart';
import 'package:app_glpi_ios/app/modules/orcamento_details/orcamento_details_page.dart';
import 'package:app_glpi_ios/app/modules/orcamento_details/orcamento_details_store.dart';
import 'package:app_glpi_ios/app/modules/profile/profile_page.dart';
import 'package:app_glpi_ios/app/modules/profile/profile_store.dart';
import 'package:app_glpi_ios/app/modules/receipt/receipt_page.dart';
import 'package:app_glpi_ios/app/modules/receipt/receipt_store.dart';
import 'package:app_glpi_ios/app/modules/upload/upload_page.dart';
import 'package:app_glpi_ios/app/modules/upload/upload_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/home/home_page.dart';
import 'modules/new_ticket/new_ticket_page.dart';
import 'modules/new_ticket/new_ticket_store.dart';
import 'modules/orcamento/orcamento_page.dart';
import 'modules/orcamento/orcamento_store.dart';
import 'modules/orcamento_form/orcamento_form_page.dart';
import 'modules/orcamento_form/orcamento_form_store.dart';
import 'modules/ticket/ticket_page.dart';
import 'modules/ticket/ticket_store.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(() => LoginStore());
    i.addLazySingleton(() => ChangePasswordStore());
    i.addLazySingleton(() => HomeStore());
    i.addLazySingleton(() => TicketStore());
    i.addLazySingleton(() => NewTicketStore());
    i.addLazySingleton(() => UploadStore());
    i.addLazySingleton(() => ProfileStore());
    i.addLazySingleton(() => OrcamentoFormStore());
    i.addLazySingleton(() => OrcamentoStore());
    i.addLazySingleton(() => OrcamentoDetailsStore());
    i.addLazySingleton(() => ReceiptStore());
  }
  
  @override
  void routes(r) {
    r.child('/', child: (_) => const InitPage());
    r.child('/login', child: (_) => const LoginPage()); 
    r.child('/home', child: (_) => HomePage(user: r.args.data[0],), transition: TransitionType.fadeIn);
    r.child('/changePassword', child: (_) => ChangePasswordPage(user: r.args.data[0],));
    r.child('/ticket', child: (_) => TicketPage(user: r.args.data[0], ticket: r.args.data[1],), transition: TransitionType.fadeIn);
    r.child('/newticket', child: (_) => NewTicketPage(user: r.args.data[0], entityId: r.args.data[1],));
    r.child('/upload', child: (_) => UploadPage(ticket: r.args.data[0], user: r.args.data[1], sessionToken: r.args.data[2],));
    r.child('/profile', child: (_) => ProfilePage(user: r.args.data[0],));
    r.child('/orcamento_form', child: (_) => const OrcamentoFormPage(),);
    r.child('/orcamento', child: (_) => const OrcamentoPage(),);
    r.child('/orcamento_details', child: (_) => const OrcamentoDetailsPage(),);
    r.child('/receipt', child: (_) => const ReceiptPage(),);
  }
}
