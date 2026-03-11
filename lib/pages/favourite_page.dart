import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolify/models/meme_model.dart';
import 'package:lolify/providers/memes_favourite_provider.dart';
import 'package:lolify/providers/theme_provider.dart';
import 'package:lolify/utility/delete_dialog.dart';
import 'package:lolify/utility/download_dialog.dart';
import 'package:lolify/utility/error_delete_dialog.dart';
import 'package:lolify/utility/error_download_dialog.dart';
import 'package:lolify/utility/error_permission_dialog.dart';
import 'package:lolify/widgets/navbar_bottom.dart';
import 'package:lolify/widgets/slidable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});
  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  int _selectedIndex = 2;

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<MemesFavouriteProvider>(context, listen: false).currentMemes =
        [];
    Provider.of<MemesFavouriteProvider>(context, listen: false).setLoad = false;
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
    return Consumer2<ThemeProvider, MemesFavouriteProvider>(
      builder: (context, theme, memes, child) {
        return Scaffold(
          backgroundColor: theme.getTheme.colorScheme.surface,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    memes.getMemesFromDB();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.getTheme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    shadowColor: Colors.black45,
                    elevation: 5,
                  ),
                  child: Text(
                    'Получить мемы',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.getTheme.colorScheme.onPrimary,
                    ),
                  ),
                ),

                // Проверка на загрузку мемов
                memes.getMemes.isEmpty && memes.getLoad
                    ? Center(
                        child: Image.asset(
                          'assets/images/loading.gif',
                          fit: BoxFit.cover,
                        ),
                      )
                    : memes.getMemes.isEmpty && !memes.getLoad
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Мемы не были найдены!',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.getTheme.colorScheme.error,
                            ),
                          ),
                        ),
                      )
                    : memes.getMemes.isNotEmpty && !memes.getLoad
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: [
                              if (constraints.maxWidth > 600)
                                GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 8.0,
                                        childAspectRatio: 0.85,
                                      ),
                                  itemCount: memes.getMemes.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Meme meme = memes.getMemes[index];
                                    return SlidableWidget(
                                      meme: meme,
                                      flag: 1,
                                      onDelete: () async {
                                        try {
                                          await memes.deleteMeme(meme.id!);
                                          if (context.mounted) {
                                            showDeleteSuccessDialog(context);
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            showErrorDeleteDialog(context);
                                          }
                                        }
                                      },
                                      onSave: () =>
                                          downloadImage(meme.imageUrl),
                                      onShare: () =>
                                          shareMeme(meme.desc, meme.imageUrl),
                                    );
                                  },
                                )
                              else
                                ListView.builder(
                                  itemCount: memes.getMemes.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Meme meme = memes.getMemes[index];
                                    return SlidableWidget(
                                      meme: meme,
                                      flag: 1,
                                      onDelete: () async {
                                        try {
                                          await memes.deleteMeme(meme.id!);
                                          if (context.mounted) {
                                            showDeleteSuccessDialog(context);
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            showErrorDeleteDialog(context);
                                          }
                                        }
                                      },
                                      onSave: () =>
                                          downloadImage(meme.imageUrl),
                                      onShare: () =>
                                          shareMeme(meme.desc, meme.imageUrl),
                                    );
                                  },
                                ),
                            ],
                          );
                        },
                      )
                    : SizedBox.shrink(),
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
