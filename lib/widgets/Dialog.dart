import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/fetch_image_cubit/fetch_image_cubit.dart';

class Dialog extends StatelessWidget {
  const Dialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Image From'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ElevatedButton(
              child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Camera',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              onPressed: () {
                context.read<FetchImageCubit>().pickImageFromCamera();
                Navigator.pop(context); // Close the dialog after selection
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              onPressed: () {
                context.read<FetchImageCubit>().pickImageFromGallery();
                Navigator.pop(context); // Close the dialog after selection
              },
            ),
          ],
        ),
      ),
    );
  }
}
