// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, must_be_immutable, library_private_types_in_public_api

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

import '../providers/login_form_provider.dart';
import '../services/services.dart';

import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AuthBackground(
            child: SingleChildScrollView(
                child: Column(
          children: [
            const SizedBox(height: 250),
            CardContainer(
                child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_literals_to_create_immutables
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.white,
                              blurRadius: 5,
                              offset: Offset(0, 0),
                            )
                          ]),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text('Login',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 18, 201, 159),
                                    fontSize: 38)),
                            const SizedBox(height: 10),
                            ChangeNotifierProvider(
                              create: (_) => LoginFormProvider(),
                              child: _LoginForm(),
                              // child: StaggerDemo1(),
                            )
                          ],
                        ),
                      )),
                )
              ],
            )),
            const SizedBox(
              height: 50,
            ),
            TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'register'),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Text(
                  'Create new account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 18, 201, 159),
                  ),
                ))
          ],
        ))));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginService = Provider.of<LoginServices>(context);
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelText: 'Username',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  prefixIcon: Icon(Icons.account_circle,
                      color: Color.fromARGB(255, 18, 201, 159)),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                ),
                onChanged: (value) => loginForm.username = value,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Please, enter your username';
                }),
            const SizedBox(height: 20),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: 'User password',
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                  prefixIcon: Icon(Icons.lock_outline_rounded,
                      color: Color.fromARGB(255, 18, 201, 159)),
                  iconColor: Color.fromRGBO(0, 153, 153, 1)),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter your password';
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 18, 201, 159)),
                  fixedSize: MaterialStateProperty.all(
                      const Size(double.infinity, 30)),
                ),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (loginForm.isValidForm()) {
                    final String? errorMessage = await loginService.postLogin(
                        loginForm.username, loginForm.password);
                    if (errorMessage == 'ROLE_ADMIN') {
                      Navigator.pushNamed(context, 'adminCategories');
                    } else if (errorMessage == 'ROLE_USER') {
                      Navigator.pushNamed(context, 'productscreen');
                    } else {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: errorMessage,
                        borderRadius: 30,
                        //loopAnimation: true,
                        confirmBtnColor: Colors.red,
                      );
                    }
                  }
                },
                child: const Center(child: Text('Login')),
              ),
            ),
          ],
        ));
  }
}

class StaggerAnimation extends StatelessWidget {
  var message;

  StaggerAnimation({
    Key? key,
    required this.controller,
    this.message,
  })  :

        // Each animation defined here transforms its value during the subset
        // of the controller's duration defined by the animation's interval.
        // For example the opacity animation transforms its value during
        // the first 10% of the controller's duration.

        opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              0.100,
              curve: Curves.ease,
            ),
          ),
        ),
        width = Tween<double>(
          begin: 50.0,
          end: 250.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.125,
              0.250,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(begin: 50.0, end: 50).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 16.0),
          end: const EdgeInsets.only(bottom: 16.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(4.0),
          end: BorderRadius.circular(4.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.375,
              0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        color = ColorTween(
          begin: Colors.red,
          end: Colors.red,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.200,
              0.250,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation borderRadius;
  final Animation color;

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity.value,
        child: Container(
          width: width.value,
          height: height.value,
          decoration: BoxDecoration(
            color: color.value,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: borderRadius.value,
          ),
          child: Center(
            child: SizedBox(
                width: width.value,
                child: TextFormField(
                    readOnly: true,
                    initialValue: 'ERROR TO LOGIN',
                    decoration: const InputDecoration(
                        disabledBorder: UnderlineInputBorder(),
                        prefixIcon: Icon(Icons.error_outline),
                        iconColor: Color.fromRGBO(0, 153, 153, 1)))),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: buildAnimation,
      animation: controller,
    );
  }
}

class StaggerDemo1 extends StatefulWidget {
  const StaggerDemo1({super.key});

  @override
  _StaggerDemo1State createState() => _StaggerDemo1State();
}

class _StaggerDemo1State extends State<StaggerDemo1>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller!.forward().orCancel;
      await _controller!.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0; // 1.0 is normal animation speed.

    final loginService = Provider.of<LoginServices>(context);
    final loginForm = Provider.of<LoginFormProvider>(context);
    String? message;
    return Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'Username',
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                  border: OutlineInputBorder(),
                  iconColor: Color.fromRGBO(0, 153, 153, 1)),
              onChanged: (value) => loginForm.username = value,
            ),
            const SizedBox(height: 20),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: 'User password',
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  iconColor: Color.fromRGBO(0, 153, 153, 1)),
              onChanged: (value) => loginForm.password = value,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.cyan),
                  fixedSize: MaterialStateProperty.all(
                      const Size(double.infinity, 30)),
                ),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (loginForm.isValidForm()) {
                    final String? errorMessage = await loginService.postLogin(
                        loginForm.username, loginForm.password);
                    if (errorMessage == 'a') {
                      Navigator.pushNamed(context, 'index');
                    } else if (errorMessage == 'u') {
                      Navigator.pushNamed(context, 'user');
                    } else {
                      message = errorMessage;
                      _playAnimation();
                    }
                  }
                },
                child: const Center(child: Text('Login')),
              ),
            ),
            StaggerAnimation(
              controller: _controller!.view,
              message: message,
            ),
          ],
        ));
  }
}
