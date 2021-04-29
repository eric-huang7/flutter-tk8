import 'package:tk8/services/services.dart';

import 'mocks.dart';

void initializeServiceInjectionForTesting({
  bool mockSecureStore = true,
}) {
  setupServicesInjection();
  getIt.allowReassignment = true;

  if (mockSecureStore) {
    getIt.registerLazySingleton<SecureStoreService>(
      () => SecureStoreServiceMock(),
    );
  }
}
