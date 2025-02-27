import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/appConfigurationCubit.dart';
import 'package:eschool/ui/widgets/customRoundedButton.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();

  static Widget routeInstance() {
    return AuthScreen();
  }
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final AnimationController _bottomMenuHeightAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  late final Animation<double> _bottomMenuHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ),
  );
  late final Animation<double> _bottomMenuHeightDownAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ),
  );

  Future<void> startAnimation() async {
    //cupertino page transtion duration
    await Future.delayed(const Duration(milliseconds: 300));

    _bottomMenuHeightAnimationController.forward();
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  void dispose() {
    _bottomMenuHeightAnimationController.dispose();
    super.dispose();
  }

  Widget _buildLottieAnimation() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top +
              MediaQuery.of(context).size.height * (0.05),
        ),
        height: MediaQuery.of(context).size.height * (0.4),
        child: Image.asset(
          "assets/images/login.png",  // Replace this with your static image path
          fit: BoxFit.none, // Adjust the fit as needed (e.g., BoxFit.cover, BoxFit.contain)
        ),
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _bottomMenuHeightAnimationController,
        builder: (context, child) {
          final height = MediaQuery.of(context).size.height *
              (0.525) *
              _bottomMenuHeightUpAnimation.value -
              MediaQuery.of(context).size.height *
                  (0.05) *
                  _bottomMenuHeightDownAnimation.value;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: BoxDecoration(
              color: Color(0xFFF8A800),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 400),
              child: _bottomMenuHeightAnimationController.value != 1.0
                  ? const SizedBox()
                  : Padding( // Added Padding widget
                padding: const EdgeInsets.all(16.0), // Adjust padding as needed
                child: Container( //Added Container widget for rounded corners and shadow.
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the box
                    borderRadius: BorderRadius.circular(30.0), //Rounded Corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow offset
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0), //Inner padding for the box
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0), //Reduced horizontal padding
                        child: Text(
                          context
                              .read<AppConfigurationCubit>()
                              .getAppConfiguration()
                              .tagline,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                            color: Utils.getColorScheme(context).onSurface,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      CustomRoundedButton(
                        onTap: () {
                          Get.toNamed(Routes.studentLogin);
                        },
                        widthPercentage: 0.8,
                        backgroundColor:
                        Utils.getColorScheme(context).primary,
                        buttonTitle:
                        "${Utils.getTranslatedLabel(loginAsKey)} ${Utils.getTranslatedLabel(studentKey)}",
                        showBorder: false,
                      ),
                      SizedBox(height: height * 0.04),
                      CustomRoundedButton(
                        onTap: () {
                          Get.toNamed(Routes.parentLogin);
                        },
                        widthPercentage: 0.8,
                        backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                        buttonTitle:
                        "${Utils.getTranslatedLabel(loginAsKey)} ${Utils.getTranslatedLabel(parentKey)}",
                        titleColor: Utils.getColorScheme(context).primary,
                        showBorder: true,
                        borderColor:
                        Utils.getColorScheme(context).primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8A800),
      body: Stack(
        children: [
          _buildLottieAnimation(),
          _buildBottomMenu(),
        ],
      ),
    );
  }
}
