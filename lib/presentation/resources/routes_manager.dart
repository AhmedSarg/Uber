import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/data/models/driver_model.dart';
import 'package:uber/data/models/trip_model.dart';
import 'package:uber/presentation/Feedback/view/feedback_view.dart';
import 'package:uber/presentation/client_details/view/client_details_view.dart';
import 'package:uber/presentation/client_map/view/client_map_view.dart';
import 'package:uber/presentation/driver_details/view/driver_details_view.dart';
import 'package:uber/presentation/driver_map/view/driver_map_view.dart';
import 'package:uber/presentation/driver_search/view/driver_search_view.dart';
import 'package:uber/presentation/reciept/view/reciept_view.dart';
import 'package:uber/presentation/resources/strings_manager.dart';
import 'package:uber/presentation/user_authentication/register/view/verification_view.dart';

import '../user_authentication/login/view/login_view.dart';
import '../user_authentication/register/view/register_view.dart';
import '../selection/view/selection_view.dart';
import '../splash/view/splash_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String selectionRoute = "/selection";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String verificationRoute = "/verification";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String onBoardingRoute = "/onBoarding";
  static const String feedbackRoute = "/feedback";
  static const String clientMapRoute = "/clientMap";
  static const String driverSearchRoute = "/driverSearch";
  static const String driverDetailsRoute = "/driverDetails";
  static const String driverMapRoute = "/driverMap";
  static const String clientDetailsRoute = "/clientDetails";
  static const String recieptRoute = "/reciept";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.selectionRoute:
        return MaterialPageRoute(builder: (_) => const SelectionView());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case Routes.verificationRoute:
        return MaterialPageRoute(builder: (_) => const VerificationView());
      case Routes.feedbackRoute:
        return MaterialPageRoute(builder: (_) => const FeedbackView());
      case Routes.clientMapRoute:
        return MaterialPageRoute(builder: (_) => ClientMapView());
      case Routes.driverSearchRoute:
        Trip trip = (settings.arguments as List)[0];
        return MaterialPageRoute(
            builder: (_) => DriverSearchView(
                  trip: trip,
                ));
      case Routes.driverDetailsRoute:
        Trip trip = (settings.arguments as List)[0];
        // Trip trip = Trip(
        //   tripId: "sndjabsdisabudasbdiuabisudas",
        //   clientUsername: "AhmedSarg",
        //   pickupLocation: const LatLng(30, 30),
        //   destinationLocation: const LatLng(30, 30),
        //   cost: 30,
        //   distance: 3000,
        //   expectedTime: 10,
        //   comment: "comment",
        // );
        // trip.driverUsername = "SherifMohamed";
        return MaterialPageRoute(builder: (_) => DriverDetailsView(trip: trip));
      case Routes.driverMapRoute:
        return MaterialPageRoute(builder: (_) => DriverMapView());
      case Routes.clientDetailsRoute:
        Trip trip = (settings.arguments as List)[0];
        return MaterialPageRoute(builder: (_) => ClientDetailsView(trip: trip));
      case Routes.recieptRoute:
        Trip trip = (settings.arguments as List)[0];
        return MaterialPageRoute(builder: (_) => RecieptView(trip: trip));
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
