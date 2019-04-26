import 'package:flutter/material.dart';
import 'package:compliance/screens/vehicle.dart';
import 'package:compliance/screens/driverRoadTrip/testform.dart';
import 'package:compliance/screens/splash_screen.dart';
import 'package:compliance/screens/inspection_report.dart';
import 'package:compliance/screens/partsScreens/front_screen.dart';
import 'package:compliance/screens/SignIn.dart';
import 'package:compliance/screens/SignUp.dart';
import 'package:compliance/screens/partsScreens/preview_screen.dart';
import 'package:compliance/screens/vehicle_selection.dart';
import 'package:compliance/screens/partsScreens/back_screen.dart';
import 'package:compliance/screens/partsScreens/left_screen.dart';
import 'package:compliance/screens/partsScreens/rightSide_screen.dart';
import 'package:compliance/screens/partsScreens/leftSide_screen.dart';
import 'package:compliance/screens/partsScreens/right_screen.dart';
import 'package:compliance/screens/partsScreens/front_nose.dart';
import 'package:compliance/screens/partsScreens/rear_door.dart';
import 'package:compliance/screens/partsScreens/questions_screen.dart';
import 'package:compliance/screens/partsScreens/partsSelection_screen.dart';
import 'package:compliance/screens/pre_trip_report.dart';
import 'package:compliance/screens/armouredCarScreens/armoured_part_selection_screen.dart';
import 'package:compliance/screens/armouredCarScreens/armoured_preview_screen.dart';
import 'package:compliance/screens/post_trip_report.dart';
import 'package:compliance/screens/driverRoadTrip/backing_and_parking.dart';
import 'package:compliance/screens/driverRoadTrip/coupling_and_uncoupling.dart';
import 'package:compliance/screens/driverRoadTrip/placing_the_vehicle_in_motion.dart';
import 'package:compliance/screens/driverRoadTrip/pre_trip_inspection.dart';
import 'package:compliance/screens/driverRoadTrip/preview_driver_road_trip.dart';
import 'package:compliance/screens/finalReportScreens/final_driver_road_test_report.dart';
import 'package:compliance/screens/finalReportScreens/final_inspection_report.dart';
import 'package:compliance/screens/finalReportScreens/final_post_inspection_report.dart';
import 'package:compliance/screens/finalReportScreens/final_pre_inspection_report.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => SplashScreen(),
        '/vehicle': (BuildContext context) => Vehicle(),
        '/driver_form': (BuildContext context) => DriverForm(),
        '/inspection': (BuildContext context) => InspectionReport(),
        '/signIn': (BuildContext context) => SignIn(),
        '/signUp': (BuildContext context) => SignUp(),
        '/front_screen': (BuildContext context) => FrontScreen(),
        '/preview_screen': (BuildContext context) => Preview(),
        '/vehicle_selection': (BuildContext context) => VehicleSelection(),
        '/back_screen': (BuildContext context) => BackScreen(),
        '/left_screen': (BuildContext context) => LeftScreen(),
        '/right_screen': (BuildContext context) => RightScreen(),
        '/rightSide_screen': (BuildContext context) => RightSideScreen(),
        '/leftSide_screen': (BuildContext context) => LeftSideScreen(),
        '/front_nose': (BuildContext context) => FrontNoseScreen(),
        '/rear_door': (BuildContext context) => RearDoorScreen(),
        '/pre_trip_report': (BuildContext context) => PreTripReport(),
        '/post_trip_report': (BuildContext context) => PostTripReport(),
        '/pre_trip_inspection': (BuildContext context) => PreTripInspection(),
        '/backing_and_parking': (BuildContext context) => BackingAndParking(),
        '/coupling_and_uncoupling': (BuildContext context) => CouplingAndUncoupling(),
        '/placing_the_vehicle_in_motion': (BuildContext context) => PlacingTheVehicleInMotion(),
        '/preview_driver_road_trip': (BuildContext context) => PreviewDriverRoadTrip(),
        '/questions_screen': (BuildContext context) => QuestionsScreen(),
        '/parts_selection': (BuildContext context) => PartsSelection(),
        '/armoured_parts_selection': (BuildContext context) => ArmouredPartsSelection(),
            '/final_driver_road_test_report': (BuildContext context) =>FinalDriverRoadTestReport(),
            '/final_inspection_report': (BuildContext context) =>FinalInspectionReport(),
            '/final_post_inspection_report': (BuildContext context) =>FinalPostInspectionReport(),
            '/final_pre_inspection_report': (BuildContext context) =>FinalPreInspectionReport(),
            '/armoured_preview': (BuildContext context) => ArmouredPreview(),
      }));
}
