import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tk8/ui/widgets/adaptive_progress_indicator.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import 'bloc/home_stream.bloc.dart';
import 'cards/card_base.viewmodel.dart';
import 'cards/image/image_card.dart';
import 'cards/video/video_card.dart';

class HomeStreamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeStreamBloc(),
      child: HomeStreamScreenView(),
    );
  }
}

class HomeStreamScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<HomeStreamBloc, HomeStreamState>(
        builder: (context, state) {
          if (state.isBusy && state.homeStreamItems.isEmpty) {
            return const Center(child: AdaptiveProgressIndicator());
          }
          return PageView.builder(
            onPageChanged: (page) {
              context.read<HomeStreamBloc>().setCurrentPage(page);
            },
            scrollDirection: Axis.vertical,
            itemCount: state.homeStreamItems.length,
            itemBuilder: (context, index) {
              final item = state.homeStreamItems[index];
              if (item.type == HomeStreamCardType.image) {
                return HomeStreamImageCard(viewModel: item);
              } else {
                return HomeStreamVideoCard(viewModel: item);
              }
            },
          );
        },
      ),
    );
  }
}
