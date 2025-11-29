import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
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

    // Executa após layout pronto
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadGoogleUser();
      await _loadSavedImage();
    });
  }

  /// Carrega nome e foto da conta Google
  Future<void> _loadGoogleUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        setState(() {
          googleName = user.displayName ?? "Usuário";
          googlePhoto = user.photoURL; // URL da foto Google
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar dados do Google: $e");
    }
  }

  Future<void> _loadSavedImage() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final prefs = await SharedPreferences.getInstance();
      final savedPath = prefs.getString(_imageKey);

      if (!mounted) return;

      if (savedPath != null) {
        final file = File(savedPath);
        if (await file.exists()) {
          setState(() {
            _profileImage = file;
          });
        }
      }
    } catch (e) {
      debugPrint("Erro ao carregar imagem salva: $e");
    }
  }

  /// Salva imagem localmente
  Future<File> _saveImageToAppDir(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    return image.copy('${appDir.path}/$fileName');
  }

  /// Troca foto + salva
  Future<void> _setProfileImage(File image) async {
    try {
      final saved = await _saveImageToAppDir(image);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_imageKey, saved.path);

      if (!mounted) return;

      setState(() {
        _profileImage = saved; // substitui foto do Google
      });
    } catch (e) {
      debugPrint("Erro ao salvar imagem manual: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 85,
    );

    if (image != null) {
      await _setProfileImage(File(image.path));
    }
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      imageQuality: 85,
    );

    if (image != null) {
      await _setProfileImage(File(image.path));
    }
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
              title: const Text('Tirar foto'),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
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

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      }
    } catch (e) {
      print("Erro ao sair: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _profileImage != null
        // Se usuário já trocou manualmente -> usa arquivo local
        ? FileImage(_profileImage!)
        // Caso contrário -> usa foto Google se existir
        : (googlePhoto != null
              ? NetworkImage(googlePhoto!)
              : const AssetImage('assets/profile_avatar.png'));

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

                // Card perfil
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      googlePhoto != null
                          ? CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: NetworkImage(googlePhoto!),
                            )
                          : GestureDetector(
                              onTap: _showImageOptions,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage:
                                        imageProvider as ImageProvider,
                                  ),
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

                      // Nome do usuário Google
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
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1B9A8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Logout',
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
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
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
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
