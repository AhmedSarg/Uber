
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:uber/presentation/client_details/viewmodel/client_details_cubit/client_details_cubit.dart';
import 'package:uber/presentation/client_map/viewmodel/client_map_cubit/client_map_cubit.dart';
import 'package:uber/presentation/driver_details/viewmodel/driver_details_cubit/driver_details_cubit.dart';
import 'package:uber/presentation/driver_map/viewmodel/driver_map_cubit/driver_map_cubit.dart';

import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/theme_manager.dart';



class MyApp extends StatefulWidget {

  MyApp._internal(); // Named Constructor

  int appState = 0; // State

  static final MyApp _instance =
  MyApp._internal(); // Singleton or Single Instance

  factory MyApp() => _instance; // Factory

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ClientMapCubit()),
        BlocProvider(create: (context) => DriverMapCubit()),
        BlocProvider(create: (context) => DriverDetailsCubit()),
        BlocProvider(create: (context) => ClientDetailsCubit()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.splashRoute,
        theme: getApplicationTheme(),
      ),
    );
  }
}
