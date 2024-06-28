import 'package:covalence/core/asset_path/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<ShadFormState>();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ShadForm(
          key: formKey,
          child: Column(
            children: [
              const Spacer(flex: 1),
              const SizedBox(height: 20),
              Image.asset(AppAsset.callVector),
              const SizedBox(height: 20),
              ShadInputFormField(
                id: 'username',
                
                label: const Text('Chat Room ID'),
                placeholder: const Text('Enter your chat room id'),
                description: const Text('Lorem Ipsum is simply dummy text.'),
                validator: (v) {
                  if (v.length < 5) {
                    return 'Enter a valid chat room id.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
               ShadButton(
                width: double.infinity,
                height: 50,
                text:const Text('Join Call'),
             
                 onPressed: () {
                     if (formKey.currentState!.validate()) {
                       print(
                           'validation succeeded with ${formKey.currentState!.value}');
                     } else {
                       print('validation failed');
                     }
                   },
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
