import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/home_stream.model.dart';
import 'package:tk8/data/repositories/home_stream.repository.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/screens/home_stream/bloc/home_stream.bloc.dart';
import 'package:tk8/ui/screens/home_stream/cards/card_base.viewmodel.dart';

import '../../../../_helpers/service_injection.dart';

class HomeStreamCardViewModelBaseMock extends Mock
    implements HomeStreamCardViewModelBase {}

class HomeStreamRepositoryMock extends Mock implements HomeStreamRepository {}

HomeStreamRepositoryMock homeStreamRepositoryMock;

void main() {
  initializeServiceInjectionForTesting();

  setUpAll(() {
    homeStreamRepositoryMock = HomeStreamRepositoryMock();
    getIt.registerLazySingleton<HomeStreamRepository>(
        () => homeStreamRepositoryMock);
  });

  setUp(() {
    reset(homeStreamRepositoryMock);
  });

  group('HomeStreamBloc', () {
    group('setCurrentPage', () {
      HomeStreamCardViewModelBaseMock item1;
      HomeStreamCardViewModelBaseMock item2;
      HomeStreamCardViewModelBaseMock item3;

      setUpAll(() {
        item1 = HomeStreamCardViewModelBaseMock();
        item2 = HomeStreamCardViewModelBaseMock();
        item3 = HomeStreamCardViewModelBaseMock();
      });

      setUp(() {
        reset(item1);
        reset(item2);
        reset(item3);
      });

      blocTest<HomeStreamBloc, HomeStreamState>(
        'should call deactivate, activate and warmup to page items',
        build: () {
          when(homeStreamRepositoryMock.loadHomeStream(
            nextCursor: anyNamed('nextCursor'),
          )).thenAnswer(
            (_) async => const PaginatedListResponse<HomeStream>(list: []),
          );
          final bloc = HomeStreamBloc(
              initialState: HomeStreamState(
            isBusy: false,
            homeStreamItems: [item1, item2, item3],
          ));
          reset(item1);
          reset(item2);
          reset(item3);
          return bloc;
        },
        act: (cubit) {
          cubit.setCurrentPage(1);
        },
        verify: (cubit) {
          verify(item1.onDeactivate());
          verify(item2.onActivate());
          verify(item3.onWarmup());
        },
      );
    });
  });
}
