import 'package:get_it/get_it.dart';
import 'package:help/core/services/auth_service.dart';
import 'package:help/core/services/firestore.dart';
import 'package:help/core/utils/firestore_utils.dart';
import 'package:help/core/utils/storageUtil.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<StorageUtil>(() => StorageUtil());
  locator.registerLazySingleton<AuthService>(() => AuthServiceReal());
  locator.registerLazySingleton<IFireStoreServices>(() => FireStoreServices());
  locator.registerLazySingleton<FireStoreUtils>(() => FireStoreUtils());
}

///Dont push without changing this to real auth service
