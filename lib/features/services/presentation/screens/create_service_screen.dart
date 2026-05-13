import 'package:cleaning_service_app/core/widgets/app_dropdown.dart';
import 'package:cleaning_service_app/core/widgets/app_snackbar.dart';
import 'package:cleaning_service_app/core/widgets/app_text_field.dart';
import 'package:cleaning_service_app/features/services/data/models/create_service_request.dart';
import 'package:cleaning_service_app/features/services/presentation/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateServiceScreen extends ConsumerStatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateServiceScreenState();
}

class _CreateServiceScreenState extends ConsumerState<CreateServiceScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String category = "Home";

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    final state = ref.watch(createServiceProvider);
    ref.listen(createServiceProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          showCustomSnackBar(
            message: 'Service created successfully.',
            isSuccess: true,
          );
        },
        error: (e, _) {
          showCustomSnackBar(message: e.toString(), isSuccess: false);
        },
      );
    });
    return Scaffold(
      appBar: AppBar(title: Text("Create Service")),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            AppTextField(
              controller: titleController,
              label: "Title",
              obSecureText: false,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Title is required.";
                }
                if (value.length < 10) {
                  return "Title is too short.";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: descriptionController,
              label: "Description",
              obSecureText: false,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Description is required.";
                }
                if (value.length < 20) {
                  return "Description is too short.";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: priceController,
              label: "price",
              obSecureText: false,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Price is required.";
                }
                if (double.parse(value) <= 0) {
                  return "Price should be greater than 0.";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppDropdown(
              label: "Cleaning Service Category",
              items: ["Home", "Office", "Deep Cleaning"],
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select service category.";
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      await ref
                          .read(createServiceProvider.notifier)
                          .createService(
                            CreateServiceRequest(
                              title: titleController.text,
                              description: descriptionController.text,
                              price: double.parse(priceController.text.trim()),
                            ),
                          );
                    },
              child: state.isLoading
                  ? CircularProgressIndicator()
                  : Text("Create Service"),
            ),
          ],
        ),
      ),
    );
  }
}
