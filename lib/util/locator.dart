import 'package:get_it/get_it.dart';
import 'package:treveler/data/datasources/auth_local_data_source_impl.dart';
import 'package:treveler/data/datasources/auth_remote_data_source_impl.dart';
import 'package:treveler/data/datasources/booking_remote_data_source_impl.dart';
import 'package:treveler/data/datasources/guide_local_data_source_impl.dart';
import 'package:treveler/data/datasources/guide_remote_data_source_impl.dart';
import 'package:treveler/data/datasources/interest_point_data_source_impl.dart';
import 'package:treveler/data/datasources/interest_point_local_data_source_impl.dart';
import 'package:treveler/data/datasources/payment_remote_data_source_impl.dart';
import 'package:treveler/data/datasources/user_local_data_source_impl.dart';
import 'package:treveler/data/datasources/user_remote_data_source_impl.dart';
import 'package:treveler/data/repositories/auth_repository_impl.dart';
import 'package:treveler/data/repositories/booking_repository_impl.dart';
import 'package:treveler/data/repositories/guide_repository_impl.dart';
import 'package:treveler/data/repositories/interest_point_repository_impl.dart';
import 'package:treveler/data/repositories/payment_repository_impl.dart';
import 'package:treveler/data/repositories/user_repository_impl.dart';
import 'package:treveler/data/util/device_utils.dart';
import 'package:treveler/domain/datasources/auth_local_data_source.dart';
import 'package:treveler/domain/datasources/auth_remote_data_source.dart';
import 'package:treveler/domain/datasources/booking_remote_data_source.dart';
import 'package:treveler/domain/datasources/guide_local_data_source.dart';
import 'package:treveler/domain/datasources/guide_remote_data_source.dart';
import 'package:treveler/domain/datasources/interest_point_local_data_source.dart';
import 'package:treveler/domain/datasources/interest_point_remote_data_source.dart';
import 'package:treveler/domain/datasources/payment_remote_data_source.dart';
import 'package:treveler/domain/datasources/user_local_data_source.dart';
import 'package:treveler/domain/datasources/user_remote_data_source.dart';
import 'package:treveler/domain/repositories/auth_repository.dart';
import 'package:treveler/domain/repositories/booking_repository.dart';
import 'package:treveler/domain/repositories/guide_repository.dart';
import 'package:treveler/domain/repositories/interest_point_repository.dart';
import 'package:treveler/domain/repositories/payment_repository.dart';
import 'package:treveler/domain/repositories/user_repository.dart';
import 'package:treveler/domain/usecases/activate_booking_usecase.dart';
import 'package:treveler/domain/usecases/add_booking_usecase.dart';
import 'package:treveler/domain/usecases/buy_booking_usecase.dart';
import 'package:treveler/domain/usecases/change_password_with_code_usecase.dart';
import 'package:treveler/domain/usecases/check_premium_usecase.dart';
import 'package:treveler/domain/usecases/check_session_usecase.dart';
import 'package:treveler/domain/usecases/check_user_is_logged_usecase.dart';
import 'package:treveler/domain/usecases/clean_user_data_usecase.dart';
import 'package:treveler/domain/usecases/contact_us_usecase.dart';
import 'package:treveler/domain/usecases/delete_account_usecase.dart';
import 'package:treveler/domain/usecases/fetch_premium_usecase.dart';
import 'package:treveler/domain/usecases/get_all_bookings_usecase.dart';
import 'package:treveler/domain/usecases/get_all_guides_usecase.dart';
import 'package:treveler/domain/usecases/get_all_interest_points_usecase.dart';
import 'package:treveler/domain/usecases/get_email_usecase.dart';
import 'package:treveler/domain/usecases/get_payment_options.dart';
import 'package:treveler/domain/usecases/login_usecase.dart';
import 'package:treveler/domain/usecases/register_usecase.dart';
import 'package:treveler/domain/usecases/select_language_usecase.dart';
import 'package:treveler/domain/usecases/send_code_usecase.dart';
import 'package:treveler/domain/usecases/verify_code_usecase.dart';
import 'package:treveler/domain/usecases/verify_discount_code_usecase.dart';
import 'package:treveler/util/geolocation.dart';

final getIt = GetIt.instance;
const String contactUs = "https://wa.me/+34633202620";
const String termsAndConditions = "https://treveler.es/condiciones-generales-de-ventas/";

void setupLocator() {
  const String baseUrl = "https://api.treveler.es:8443/treveler";
  // const String baseUrl = "http://192.168.88.123:8080";

  // Data sources
  getIt.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl());
  getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(baseUrl, getIt(), getDeviceLanguage()));
  getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(baseUrl, getIt(), getDeviceLanguage()));
  getIt.registerLazySingleton<GuideRemoteDataSource>(
      () => GuideRemoteDataSourceImpl(baseUrl, getIt(), getDeviceLanguage()));
  getIt.registerLazySingleton<GuideLocalDataSource>(() => GuideLocalDataSourceImpl());
  getIt.registerLazySingleton<InterestPointRemoteDataSource>(
      () => InterestPointRemoteDataSourceImpl(baseUrl, getIt(), getDeviceLanguage()));
  getIt.registerLazySingleton<InterestPointLocalDataSource>(() => InterestPointLocalDataSourceImpl());
  getIt.registerLazySingleton<PaymentRemoteDataSource>(
      () => PaymentRemoteDataSourceImpl(baseUrl, getIt(), getDeviceLanguage()));
  getIt.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSourceImpl(baseUrl, getIt(), getDeviceLanguage()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<GuideRepository>(
    () => GuideRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<InterestPointRepository>(
    () => InterestPointRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerFactory<CleanUserDataUseCase>(() => CleanUserDataUseCase(getIt(), getIt()));
  getIt.registerFactory<CheckSessionUseCase>(() => CheckSessionUseCase(getIt(), getIt()));
  getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt(), getIt(), getIt()));
  getIt.registerFactory<RegisterUseCase>(() => RegisterUseCase(getIt(), getIt(), getIt()));
  getIt.registerFactory<SendCodeUseCase>(() => SendCodeUseCase(getIt()));
  getIt.registerFactory<VerifyCodeUseCase>(() => VerifyCodeUseCase(getIt()));
  getIt.registerFactory<ChangePasswordWithCodeUseCase>(() => ChangePasswordWithCodeUseCase(getIt()));
  getIt.registerFactory<GetAllGuidesUseCase>(() => GetAllGuidesUseCase(getIt()));
  getIt.registerFactory<GetPaymentOptionsUseCase>(() => GetPaymentOptionsUseCase(getIt()));
  getIt.registerFactory<VerifyDiscountCodeUseCase>(() => VerifyDiscountCodeUseCase(getIt()));
  getIt.registerFactory<GetEmailUseCase>(() => GetEmailUseCase(getIt()));
  getIt.registerFactory<SelectLanguageUseCase>(() => SelectLanguageUseCase(getIt()));
  getIt.registerFactory<DeleteAccountUseCase>(() => DeleteAccountUseCase(getIt(), getIt()));
  getIt.registerFactory<GetAllInterestPointsUseCase>(() => GetAllInterestPointsUseCase(getIt()));
  getIt.registerFactory<FetchPremiumUseCase>(() => FetchPremiumUseCase(getIt()));
  getIt.registerFactory<CheckPremiumUseCase>(() => CheckPremiumUseCase(getIt()));
  getIt.registerFactory<ActivateBookingUseCase>(() => ActivateBookingUseCase(getIt()));
  getIt.registerFactory<GetAllBookingsUseCase>(() => GetAllBookingsUseCase(getIt()));
  getIt.registerFactory<AddBookingUseCase>(() => AddBookingUseCase(getIt()));
  getIt.registerFactory<BuyBookingUseCase>(() => BuyBookingUseCase(getIt()));
  getIt.registerFactory<CheckUserIsLoggedUseCase>(() => CheckUserIsLoggedUseCase(getIt()));
  getIt.registerFactory<ContactUsUseCase>(() => ContactUsUseCase(contactUs));

  //Utils
  getIt.registerLazySingleton<Geolocation>(() => Geolocation());
}
