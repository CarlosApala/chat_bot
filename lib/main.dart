import 'package:chat_bot_frontend/features/sendChat/data/models/message_model.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/entities/chat.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/repositories/chat_repository.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/usecases/chat_crud_use_case.dart';
import 'package:chat_bot_frontend/features/sendChat/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_bot_frontend/features/sendChat/presentation/bloc/lista_contacto/lista_contacto_bloc.dart';
import 'package:chat_bot_frontend/features/sendChat/presentation/bloc/listchat/listchat_bloc.dart';
import 'package:chat_bot_frontend/features/sendChat/presentation/pages/HomeScreen.dart';
import 'package:chat_bot_frontend/features/sendChat/presentation/pages/SendMessage.dart';
import 'package:chat_bot_frontend/features/sendChat/presentation/pages/initialScreen.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'features/sendChat/data/repositories/chat_repostory_implement.dart';

final sl = GetIt.instance; // Service locator

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([ChatSchema, ChatModelSchema],
      directory: dir.path); // Asegúrate de haber generado el código para Isar
  sl.registerLazySingleton(() => isar);

  // Repositorio
  sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(sl<Isar>()));

  runApp(MyApp(
    isar: isar,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required isar});
  Isar? isar;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(ChatCrudUseCase(sl<ChatRepository>())),
        ),
        BlocProvider(
            create: (context) =>
                ListchatBloc(ChatCrudUseCase(sl<ChatRepository>()))),
        BlocProvider(
          create: (context) => ListaContactoBloc(),
        )
      ],
      child: FluentApp(
        routes: {
          '/': (context) => HomeScreen(),
          '/message': (context) => SendMessage(),
          '/initial': (context) => InintialScreen()
        },
        title: 'Flutter Demo',
        theme: FluentThemeData(),
        debugShowCheckedModeBanner: false,
        /* ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ), */
        initialRoute: '/',
      ),
    );
  }
}
