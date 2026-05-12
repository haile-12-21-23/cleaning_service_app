import 'package:cleaning_service_app/core/widgets/app_dropdown.dart';
import 'package:cleaning_service_app/core/widgets/app_text_field.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_state.dart';
import 'package:cleaning_service_app/features/auth/presentation/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {

  final formKey = GlobalKey<FormState>();

  final phoneNumberController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/profile');
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account", style: theme.textTheme.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  "Welcome to Cleaning Service!",
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 30),

                ProfileAvatar(
                  imageUrl: "",
                  onEdit: () {
                    print("Edit profile clicked");
                  },
                ),
                const SizedBox(height: 30),

                AppDropdown(
                  label: "Register as:",
                  items: const ["provider", "client"],
                  value: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                    formKey.currentState?.validate();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select role";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 16),
            
                AppTextField(
                  controller: nameController,
                  label: " Full Name",
                  obSecureText: false,
                  keyboardType: TextInputType.name,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    if (value.trim().length < 5) {
                      return "Name must be al least 5 characters";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    formKey.currentState?.validate();
                  },
                ),
              
                const SizedBox(height: 16),
            
              
                AppTextField(
                  controller: phoneNumberController,
                  label: "Phone Number",
                  obSecureText: false,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required.";
                    }
                    if (value.trim().length < 9 || value.trim().length > 12) {
                      return "Phone number must be between 9 and 12 digits";
                    }
                    return null;
                  },
                  onChanged: (value) {
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
                    if (value.trim().length < 6) {
                      return "Password is too short.";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    formKey.currentState?.validate();
                  },
                ),
               
                if (authState.error != null)
                  Text(
                    authState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
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
                              .register(
                                nameController.text.trim(),
                                selectedRole ?? '',
                                "default.png",
                                phoneNumberController.text.trim(),
                                passwordController.text.trim(),
                              );
                        },
                  child: authState.isLoading
                      ? CircularProgressIndicator()
                      : const Text("Register"),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: Text("login here"),
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
