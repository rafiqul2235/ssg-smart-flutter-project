import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/repository/approval_history_repo.dart';
import 'package:ssg_smart2/data/repository/approval_repo.dart';
import 'package:ssg_smart2/data/repository/attendance_repo.dart';
import 'package:ssg_smart2/data/repository/auth_repo.dart';
import 'package:ssg_smart2/data/repository/banner_repo.dart';
import 'package:ssg_smart2/data/repository/brand_repo.dart';
import 'package:ssg_smart2/data/repository/category_repo.dart';
import 'package:ssg_smart2/data/repository/chat_repo.dart';
import 'package:ssg_smart2/data/repository/notification_repo.dart';
import 'package:ssg_smart2/data/repository/onboarding_repo.dart';
import 'package:ssg_smart2/data/repository/user_repo.dart';
import 'package:ssg_smart2/data/repository/search_repo.dart';
import 'package:ssg_smart2/data/repository/splash_repo.dart';
import 'package:ssg_smart2/helper/network_info.dart';
import 'package:ssg_smart2/provider/approval_hisotry_provider.dart';
import 'package:ssg_smart2/provider/approval_provider.dart';
import 'package:ssg_smart2/provider/attendance_provider.dart';
import 'package:ssg_smart2/provider/leave_provider.dart';
import 'package:ssg_smart2/provider/master_data_provider.dart';
import 'package:ssg_smart2/provider/auth_provider.dart';
import 'package:ssg_smart2/provider/banner_provider.dart';
import 'package:ssg_smart2/provider/category_provider.dart';
import 'package:ssg_smart2/provider/chat_provider.dart';
import 'package:ssg_smart2/provider/localization_provider.dart';
import 'package:ssg_smart2/provider/location_provider.dart';
import 'package:ssg_smart2/provider/notification_provider.dart';
import 'package:ssg_smart2/provider/onboarding_provider.dart';
import 'package:ssg_smart2/provider/report_provider.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/provider/search_provider.dart';
import 'package:ssg_smart2/provider/splash_provider.dart';
import 'package:ssg_smart2/provider/support_ticket_provider.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/provider/user_dashboard_provider.dart';
import 'package:ssg_smart2/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'data/repository/leave_repo.dart';
import 'data/repository/master_data_repo.dart';
import 'data/repository/location_repo.dart';
import 'data/repository/report_repo.dart';
import 'data/repository/user_dashboard_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => UserRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => UserDashboardRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ReportRepo(dioClient: sl()));
  sl.registerLazySingleton(() => MasterDataRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BrandRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BannerRepo(dioClient: sl()));
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(() => SearchRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  //sl.registerLazySingleton(() => CartRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => LocationRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => LeaveRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => AttendanceRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ApprovalHistoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ApprovalRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => UserProvider(userRepo: sl()));
  sl.registerFactory(() => UserDashboardProvider(userDashboardRepo: sl()));
  sl.registerFactory(() => ReportProvider(reportRepo: sl()));
  sl.registerFactory(() => CategoryProvider(categoryRepo: sl()));
  sl.registerFactory(() => BannerProvider(bannerRepo: sl()));
  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl()));
  sl.registerFactory(() => SearchProvider(searchRepo: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => SupportTicketProvider(supportTicketRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LocationProvider(sharedPreferences: sl(), locationRepo: sl()));
  sl.registerLazySingleton(() => MasterDataProvider(masterDataRepo: sl()));
  sl.registerLazySingleton(() => LeaveProvider(leaveRepo: sl()));
  sl.registerLazySingleton(() => AttendanceProvider(attendanceRepo: sl()));
  sl.registerLazySingleton(() => ApprovalHistoryProvider(approvalHistoryRepo: sl()));
  sl.registerLazySingleton(() => ApprovalProvider(approvalRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Connectivity());
}
