import 'package:cleaning_service_app/core/widgets/app_app_bar.dart';
import 'package:cleaning_service_app/core/widgets/app_snackbar.dart';
import 'package:cleaning_service_app/core/widgets/app_text_field.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  final formKey = GlobalKey<FormState>();

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/profile');
      }
      else if (next.error != null) {
        showCustomSnackBar(message: next.error!, isSuccess: false);
      }
  
});
    return Scaffold(
      appBar: AppAppBar(title: "Login") as PreferredSizeWidget,
      //  AppBar(
      //   title: Text("Login", style: theme.textTheme.headlineMedium),
      // ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Cleaning Service!",
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 128),
            
                     
                AppTextField(
                  controller: phoneNumberController,
                  label: "Phone Number",
                  obSecureText: false,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required.";
                    }
                    if (value.trim().length < 9 || value.trim().length > 12) {
                      return "Phone number must be between 9 and 12 digits";
                    }
                    return null;
                  },
                  onChanged: (p0) {
                    formKey.currentState?.validate();
                  },
                ),
                const SizedBox(height: 16),
               
                AppTextField(
                  controller: passwordController,
                  label: "Password",
                  obSecureText: true,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required.";
                    }
                    return null;
                  },
                  onChanged: (p0) {
                    formKey.currentState?.validate();
                  },
                ),

                // if (authState.error != null)
                // Text(
                //   authState.error!,
                //   style: const TextStyle(color: Colors.red),
                // ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          await ref
                              .read(authControllerProvider.notifier)
                              .login(
                                phoneNumberController.text.trim(),
                                passwordController.text.trim(),
                              );
                        },
                  child: authState.isLoading
                      ? CircularProgressIndicator()
                      : const Text("Login"),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Text("Do't have an account?"),
                    TextButton(
                      onPressed: () {
                        context.go('/register');
                        print("clicking.......");
                      },
                      child: Text("Register here"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
