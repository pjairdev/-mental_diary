import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import '../widgets/bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String? googlePhoto;
  String? googleName;

  static const _imageKey = 'profile_image_path';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadGoogleUser();
      await _loadSavedImage();
    });
  }

  // ---------------------------------------------------------------
  // 🔵 CARREGA USUÁRIO
  // ---------------------------------------------------------------
  Future<void> _loadGoogleUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final isGoogle =
          user.providerData.any((p) => p.providerId == 'google.com');

      // 🔵 Login Google → usar sempre displayName e photoURL do Firebase Auth
      if (isGoogle) {
        setState(() {
          googleName = user.displayName ?? "Usuário";
          googlePhoto = user.photoURL; // SEMPRE EXISTE APÓS CORREÇÃO NO LOGIN
        });
        return;
      }

      // 🔵 Email/senha → Carregar do Database
      final Uri dbUrl = Uri.https(
        "connect-8d1ed-default-rtdb.firebaseio.com",
        "/users/${user.uid}.json",
      );

      final response = await http.get(dbUrl);
      if (response.statusCode == 200 && response.body != "null") {
        final data = jsonDecode(response.body);

        setState(() {
          googleName = data["name"] ?? user.email!.split("@")[0];
          googlePhoto = data["photoUrl"];
        });
      } else {
        setState(() {
          googleName = user.email!.split("@")[0];
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar usuário: $e");
    }
  }

  // ---------------------------------------------------------------
  // 🔵 NÃO CARREGA CACHE PARA GOOGLE LOGIN
  // ---------------------------------------------------------------
  Future<void> _loadSavedImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null &&
          user.providerData.any((p) => p.providerId == 'google.com')) {
        return; // Google NÃO usa cache
      }

      final prefs = await SharedPreferences.getInstance();
      final savedPath = prefs.getString(_imageKey);

      if (savedPath != null) {
        final file = File(savedPath);
        if (await file.exists()) {
          setState(() => _profileImage = file);
        }
      }
    } catch (e) {
      debugPrint("Erro ao carregar imagem salva: $e");
    }
  }

  // ---------------------------------------------------------------
  // 🔵 SALVA IMAGEM LOCAL
  // ---------------------------------------------------------------
  Future<File> _saveImageToAppDir(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    return image.copy('${appDir.path}/$fileName');
  }

  // ---------------------------------------------------------------
  // 🔵 ENVIA IMAGEM AO STORAGE + SALVA URL NO DATABASE
  // ---------------------------------------------------------------
  Future<void> _setProfileImage(File image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final isGoogle =
          user.providerData.any((p) => p.providerId == 'google.com');

      if (isGoogle) return; // segurança extra

      // Storage
      final ref =
          FirebaseStorage.instance.ref().child("users/${user.uid}/profile.jpg");

      await ref.putFile(image);

      final url = await ref.getDownloadURL();

      // DB
      final Uri dbUrl = Uri.https(
        "connect-8d1ed-default-rtdb.firebaseio.com",
        "/users/${user.uid}.json",
      );

      await http.patch(
        dbUrl,
        body: jsonEncode({"photoUrl": url}),
      );

      // Cache
      final saved = await _saveImageToAppDir(image);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_imageKey, saved.path);

      setState(() {
        _profileImage = saved;
        googlePhoto = url;
      });
    } catch (e) {
      debugPrint("Erro ao enviar imagem: $e");
    }
  }

  // ---------------------------------------------------------------
  // 🔵 ESCOLHER IMAGEM
  // ---------------------------------------------------------------
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 85,
    );

    if (img != null) await _setProfileImage(File(img.path));
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      imageQuality: 85,
    );

    if (img != null) await _setProfileImage(File(img.path));
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text("Tirar foto"),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text("Escolher da galeria"),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // 🔵 LOGOUT
  // ---------------------------------------------------------------
  Future<void> _confirmLogout() async {
    final bool? confirmed = await showCupertinoModalPopup<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoActionSheet(
        title: const Text(
          "Deseja realmente sair?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        message: const Text(
          "Você será desconectado da sua conta.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sair", style: TextStyle(fontSize: 18)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancelar", style: TextStyle(fontSize: 17)),
        ),
      ),
    );

    if (confirmed == true) _logout();
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      }
    } catch (e) {
      debugPrint("Erro ao sair: $e");
    }
  }

  // ---------------------------------------------------------------
  // 🔵 UI
  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isGoogle =
        user?.providerData.any((p) => p.providerId == 'google.com') ?? false;

    // Definição CORRETA da imagem:
    final ImageProvider imageProvider = isGoogle
        ? NetworkImage(googlePhoto ?? user?.photoURL ?? "")
        : (_profileImage != null
            ? FileImage(_profileImage!)
            : (googlePhoto != null
                ? NetworkImage(googlePhoto!)
                : const AssetImage('assets/profile_avatar.png')
                    as ImageProvider));

    return Scaffold(
      backgroundColor: const Color(0xFFE4EAF0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Meu Perfil",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // ---------------------------------------------------------
                // FOTO DO PERFIL
                // ---------------------------------------------------------
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: isGoogle ? null : _showImageOptions,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: imageProvider,
                            ),
                            if (!isGoogle)
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF1B9A8),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        googleName ?? "[Nome do Usuário]",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                _buildOption(
                  icon: Icons.lock_outline,
                  label: "Segurança e senha",
                  onTap: () {},
                ),
                _buildOption(
                  icon: Icons.notifications_none_outlined,
                  label: "Notificações",
                  onTap: () {},
                ),
                _buildOption(
                  icon: Icons.download_outlined,
                  label: "Exportar Meus Dados",
                  onTap: () {},
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1B9A8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F2E8),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
