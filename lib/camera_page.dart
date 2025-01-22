import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  bool _isUploading = false;

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
  }

  Future<void> _getImage(ImageSource source) async {
    await _requestPermissions();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _saveImageLocally();
        _saveImageToGallery();
        _uploadImageToSupabase();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveImageLocally() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagePath = '${appDir.path}/captured_image.jpg';
    await _image!.copy(imagePath);
  }

  Future<void> _saveImageToGallery() async {
    if (_image != null) {
      final result = await ImageGallerySaver.saveFile(_image!.path);
      print(result);
    }
  }

  Future<void> _uploadImageToSupabase() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final response = await Supabase.instance.client.storage
          .from('photo-bucket') // Replace with your bucket name
          .upload('${DateTime.now().millisecondsSinceEpoch}.jpg', _image!);

      setState(() {
        _isUploading = false;
      });

      if (response != null || response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image Uploaded Successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed'),
          ),
        );
      }
    } on Exception catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload failed!'),
        ),
      );
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Photo Upload App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _image != null
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      _image!,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/Animation.gif',
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () => _getImage(ImageSource.camera),
                  child:
                      Icon(Icons.camera_alt, size: 30, color: Colors.black87),
                ),
                SizedBox(height: 16), // Space between buttons
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () => _getImage(ImageSource.gallery),
                  child:
                      const Icon(Icons.image, size: 30, color: Colors.black87),
                ),
                SizedBox(height: 16), // Space between buttons
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: _isUploading
                      ? null
                      : _uploadImageToSupabase, // Disable button during upload
                  child: _isUploading
                      ? Center(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            child: const CircularProgressIndicator(
                              color: Colors.black87,
                            ),
                          ),
                        )
                      : const Icon(Icons.cloud_upload,
                          size: 30, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
