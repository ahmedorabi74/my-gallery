import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../constant/constants.dart';
import '../../models/image_model.dart';

part 'fetch_image_state.dart';

class FetchImageCubit extends Cubit<FetchImageState> {
  FetchImageCubit() : super(FetchImageInitial());

  void resetToFetchedImages() {
    if (fetchedImages.isNotEmpty) {
      emit(FetchImagSuccess(
          images: fetchedImages)); // Emit previously fetched images
    } else {
      emit(
          FetchImageInitial()); // If no images were fetched, return to initial state
    }
  }

  final ImagePicker picker = ImagePicker();
  late File selectedImage; // To store the selected image
  List<String> fetchedImages = [];
  String? token = Constants.userToken;
  String? baseUrl = Constants.baseUrl;

  Future<void> fetchImages() async {
    emit(FetchImagLoading());

    final url = Uri.parse('$baseUrl/my-gallery');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          // 'Content-Type': 'application/json',
          // Optional, helps specify the format
        },
      );

      if (response.statusCode == 200) {
        {
          final jsonResponse = jsonDecode(response.body);
          ImageModel imageModel = ImageModel.fromJson(jsonResponse);

          if (imageModel.status == 'success' && imageModel.data != null) {
            fetchedImages = imageModel.data!.images!; // Save fetched images
            emit(FetchImagSuccess(images: fetchedImages));
          } else {
            emit(FetchImagFailure(
                errorMessage: imageModel.message ?? 'Failed to load images'));
          }
        }
      } else {
        emit(FetchImagFailure(errorMessage: 'Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(FetchImagFailure(errorMessage: 'An error occurred: $e'));
    }
  }

  // Pick image from Gallery
  Future<void> pickImageFromGallery() async {
    try {
      var pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        selectedImage = File(pickedImage.path);
        emit(PickImagSuccess(
            images: selectedImage)); // Emit success state with the image path
      } else {
        emit(PickImagFailure(errorMessage: 'No image selected'));
      }
    } catch (e) {
      emit(PickImagFailure(errorMessage: 'Error selecting image: $e'));
    }
  }

  // Pick image from Camera
  Future<void> pickImageFromCamera() async {
    try {
      var pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        selectedImage = File(pickedImage.path);
        emit(PickImagSuccess(
            images: selectedImage)); // Emit success state with the image path
      } else {
        emit(PickImagFailure(errorMessage: 'No image captured'));
      }
    } catch (e) {
      emit(PickImagFailure(errorMessage: 'Error capturing image: $e'));
    }
  }
}
