import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galleryy/constant/constants.dart';
import 'package:galleryy/models/image_model.dart';
import 'package:galleryy/screens/LoginPage.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../cubits/fetch_image_cubit/fetch_image_cubit.dart';
import '../cubits/upload_image_cubit/upload_image_cubit.dart';
import '../main.dart';
import '../widgets/Button.dart';
import '../widgets/custom_image_card.dart';
import '../widgets/text_button.dart'; // Assuming you have a widget to show an image

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ImageModel imageModel;
    bool isLoading = false;
    void showImageSourceDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    onPressed: () {
                      context.read<FetchImageCubit>().pickImageFromCamera();
                      Navigator.pop(
                          context); // Close the dialog after selection
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Gallery',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    onPressed: () {
                      context.read<FetchImageCubit>().pickImageFromGallery();
                      Navigator.pop(
                          context); // Close the dialog after selection
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 183, 248),
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      color: Color(0xff4A4A4A),
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Baloo Thambi 2",
                    ),
                  ),
                  Text(
                    Constants.userName!,
                    style: const TextStyle(
                      color: Color(0xff4A4A4A),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Baloo Thambi 2",
                    ),
                  )
                ],
              ),
              const SizedBox(height: 37),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextButton(
                    iconColor: const Color(0xffC83B3B),
                    icon: Icons.exit_to_app,
                    buttonColor: const Color(0xffFFFFFF),
                    onPressed: () {
                      // Log out logic
                      sharedPref.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    text: "Log out",
                  ),
                  CustomTextButton(
                    icon: Icons.cloud_upload_rounded,
                    iconColor: const Color(0xffFFEB38),
                    buttonColor: const Color(0xffFFFFFF),
                    onPressed: () {
                      showImageSourceDialog(); // Pick an image directly
                    },
                    text: "Upload",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<FetchImageCubit, FetchImageState>(
                  builder: (context, state) {
                    if (state is FetchImagLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FetchImagFailure) {
                      return Center(
                        child: Text(
                            'Failed to load images: ${state.errorMessage}'),
                      );
                    } else if (state is FetchImagSuccess) {
                      if (state.images.isNotEmpty) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 24.0,
                            mainAxisSpacing: 24.0,
                          ),
                          itemCount: state.images.length,
                          itemBuilder: (context, index) {
                            return CustomImageCard(
                                imageUrl: state.images[index]);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('No images found.'),
                        );
                      }
                    } else if (state is PickImagFailure) {
                      context
                          .read<FetchImageCubit>()
                          .resetToFetchedImages(); // no request again✅✅
                      // context.read<FetchImageCubit>().reset(); request again!!
                    } else if (state is PickImagSuccess) {
                      // Show the selected image
                      return Column(
                        children: [
                          BlocListener<UploadImageCubit, UploadImageState>(
                            listener: (context, state) {
                              if (state is UploadImagSuccess) {
                                context.read<FetchImageCubit>().fetchImages();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor:
                                          Color.fromARGB(255, 1, 185, 38),
                                      content:
                                          Text('Image uploaded successfully')),
                                );
                                isLoading = false;
                              } else if (state is UploadImagFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Upload failed: ${state.errorMessage}')),
                                );
                                isLoading = false;
                              } else if (state is UploadImagLoading) {
                                isLoading = true;
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(state.images))),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Button(
                                buttonWidth: 110,
                                buttonColor:
                                    const Color.fromARGB(210, 174, 81, 228),
                                onPressed: () {
                                  context
                                      .read<FetchImageCubit>()
                                      .resetToFetchedImages();
                                },
                                text: "Cancel",
                              ),
                              Button(
                                buttonWidth: 110,
                                buttonColor:
                                    const Color.fromARGB(210, 174, 81, 228),
                                onPressed: () {
                                  showImageSourceDialog();
                                },
                                text: 'New',
                              ),
                              Button(
                                buttonWidth: 110,
                                buttonColor:
                                    const Color.fromARGB(210, 174, 81, 228),
                                onPressed: () {
                                  final pickedImage =
                                      state.images; // Get the picked image file
                                  context
                                      .read<UploadImageCubit>()
                                      .uploadImage(pickedImage);
                                },
                                text: "Upload",
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
