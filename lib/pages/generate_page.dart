import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolify/db/db_service.dart';
import 'package:lolify/providers/meme_generate_provider.dart';
import 'package:lolify/providers/memes_favourite_provider.dart';
import 'package:lolify/providers/theme_provider.dart';
import 'package:lolify/utility/add_dialog.dart';
import 'package:lolify/utility/download_dialog.dart';
import 'package:lolify/utility/error_add_dialog.dart';
import 'package:lolify/utility/error_download_dialog.dart';
import 'package:lolify/utility/error_permission_dialog.dart';
import 'package:lolify/widgets/navbar_bottom.dart';
import 'package:lolify/widgets/slidable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});
  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  final DataBaseService dbService = DataBaseService();
  int _selectedIndex = 1;

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<MemeGenerateProvider>(context, listen: false).currentMeme =
        null;
    Provider.of<MemeGenerateProvider>(context, listen: false).setLoad = false;
  }

  // скачать мем
  Future<void> downloadImage(String imageUrl) async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      try {
        late String downloadDirectory;
        if (Platform.isAndroid) {
          downloadDirectory = '/storage/emulated/0/Download';
        } else if (Platform.isIOS) {
          downloadDirectory =
              '/var/mobile/Containers/Data/Application/<UUID>/Documents';
        }

        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String filePath = '$downloadDirectory/image_$timestamp.jpg';

        while (await File(filePath).exists()) {
          timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          filePath = '$downloadDirectory/image_$timestamp.jpg';
        }

        Dio dio = Dio();
        await dio.download(imageUrl, filePath);
        if (mounted) {
          showDownloadSuccessDialog(context);
        }
      } catch (e) {
        if (mounted) {
          showErrorDownloadDialog(context);
        }
      }
    } else {
      if (mounted) {
        showErrorPermissionDialog(context);
      }
    }
  }

  // поделиться мемом
  Future<void> shareMeme(String desc, String imageUrl) async {
    await SharePlus.instance.share(ShareParams(text: '$desc\n$imageUrl'));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      ThemeProvider,
      MemeGenerateProvider,
      MemesFavouriteProvider
    >(
      builder: (context, theme, meme, favourite, child) {
        return Scaffold(
          backgroundColor: theme.getTheme.colorScheme.surface,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        meme.generateMeme();
                      },
                      style:
                          ElevatedButton.styleFrom(
                            backgroundColor: theme.getTheme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            elevation: 10,
                          ).copyWith(
                            shadowColor: WidgetStateProperty.all(Colors.black),
                          ),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 300,
                          minHeight: 50,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Сгенерировать мем',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.getTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                if (meme.getMeme == null && meme.getLoad)
                  Center(
                    child: Image.asset(
                      'assets/images/loading.gif',
                      fit: BoxFit.cover,
                    ),
                  )
                else if (meme.getMeme == null && !meme.getLoad)
                  Center(
                    child: Text(
                      'Мем не был получен!',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.getTheme.colorScheme.error,
                      ),
                    ),
                  )
                else if (meme.getMeme != null && !meme.getLoad)
                  SlidableWidget(
                    meme: meme.getMeme!,
                    flag: 0,
                    onAdd: () async {
                      try {
                        await favourite.addMeme(
                          meme.getMeme!.desc,
                          meme.getMeme!.imageUrl,
                        );
                        if (context.mounted) {
                          showAddSuccessMemeDialog(context);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showErrorAddDialog(context);
                        }
                      }
                    },
                    onSave: () => downloadImage(meme.getMeme!.imageUrl),
                    onShare: () =>
                        shareMeme(meme.getMeme!.desc, meme.getMeme!.imageUrl),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: NavBottom(
            onTabChange: _onTabChanged,
            currentIndex: _selectedIndex,
          ),
        );
      },
    );
  }
}
