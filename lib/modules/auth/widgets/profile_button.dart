import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  File? _localImage;
  String? _googlePhoto;
  static const _imageKey = 'profile_image_path';

  @override
  void initState() {
    super.initState();
    _loadGooglePhoto();
    _loadLocalImage();
  }

  Future<void> _loadGooglePhoto() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _googlePhoto = user.photoURL;
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar foto do Google: $e");
    }
  }

  Future<void> _loadLocalImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPath = prefs.getString(_imageKey);

      if (savedPath != null) {
        final file = File(savedPath);
        if (await file.exists()) {
          setState(() => _localImage = file);
        }
      }
    } catch (e) {
      debugPrint("Erro ao carregar imagem salva: $e");
    }
  }

  ImageProvider _getImage() {
    if (_googlePhoto != null) {
      return NetworkImage(_googlePhoto!);
    }
    if (_localImage != null) {
      return FileImage(_localImage!);
    }
    return const AssetImage('assets/profile_avatar.png');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/profile'),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.black.withOpacity(0.1),
        backgroundImage: _getImage(),
      ),
    );
  }
}
