import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lupiter/generated/lupiter_assets.g.dart';
import 'package:lupiter/lupiter_const.dart';
import 'package:lupiter/lupiter_cubit.dart';
import 'package:lupiter/lupiter_style.dart';
import 'package:lupiter/models/lupiter_state.dart';
import 'package:lupiter/widgets/lupiter_data.dart';
import 'package:lupiter/widgets/navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

// TODO(bug): fix Google Fonts in release
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cubit = LupiterCubit(
    await LupiterState.fromMemory(
      database: await openDatabase(
        'db.db',
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE orders (id INTEGER PRIMARY KEY, name varchar(255), '
            'address VARCHAR(255), zipCode varchar(6), city varchar(255))',
          );
        },
      ),
      preferences: await SharedPreferences.getInstance(),
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: Settings.supportedLocales,
      path: LupiterAssets.translations,
      startLocale: Settings.defaultLocale,
      fallbackLocale: Settings.defaultLocale,
      child: Builder(
        builder: (context) {
          final ez = EasyLocalization.of(context)!;
          return FutureBuilder(
            future: ez.delegate.load(ez.currentLocale!),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox.shrink();
              }

              return BlocProvider<LupiterCubit>(
                lazy: false,
                create: (_) => cubit,
                child: BlocBuilder<LupiterCubit, LupiterState>(
                  buildWhen: (previous, current) =>
                      previous.appState.theme != current.appState.theme,
                  builder: (context, state) {
                    return MaterialApp(
                      title: 'Lupiter',
                      restorationScopeId: 'lupiter',
                      locale: ez.locale,
                      localizationsDelegates: ez.delegates,
                      supportedLocales: ez.supportedLocales,
                      themeMode: state.appState.theme,
                      theme: lightTheme,
                      darkTheme: darkTheme,
                      initialRoute: '/',
                      builder: (context, child) {
                        cubit.postInit(context);
                        return LupiterData(
                          splash: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            alignment: Alignment.center,
                            child: Image.asset(
                              LupiterAssets.icon,
                              fit: BoxFit.scaleDown,
                              width: 150,
                              height: 150,
                            ),
                          ),
                          child: child!,
                        );
                      },
                      home: BlocBuilder<LupiterCubit, LupiterState>(
                        buildWhen: (previous, current) => false,
                        builder: (context, state) {
                          return const NavigationScreen();
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
