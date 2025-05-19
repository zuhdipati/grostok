import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grostok/core/const/app_assets.dart';
import 'package:grostok/core/routes/app_route.dart';
import 'package:grostok/core/const/app_colors.dart';
import 'package:grostok/presentation/splash/cubit/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is GoNextPage) {
            Navigator.pushNamed(context, AppRoutes.navigation);
          }
        },
        child: Center(
          child: Image.asset(
            AppAssets.appLogo,
            height: 400,
            width: 400,
          ),
        ),
      ),
    );
  }
}
