import 'package:get_it/get_it.dart';
import 'package:help/core/utils/storageUtil.dart';

GetIt locator = GetIt.instance;

setUpLocator() {
  locator.registerLazySingleton<StorageUtil>(() => StorageUtil());
}
