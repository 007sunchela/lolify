import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolify/models/meme_model.dart';
import 'package:lolify/providers/memes_favourite_provider.dart';
import 'package:lolify/providers/memes_search_provider.dart';
import 'package:lolify/providers/theme_provider.dart';
import 'package:lolify/utility/download_dialog.dart';
import 'package:lolify/utility/error_download_dialog.dart';
import 'package:lolify/utility/error_permission_dialog.dart';
import 'package:lolify/widgets/navbar_bottom.dart';
import 'package:lolify/widgets/slidable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lolify/db/db_service.dart';
import 'package:lolify/utility/add_dialog.dart';
import 'package:lolify/utility/error_add_dialog.dart';

class MemePage extends StatefulWidget {
  const MemePage({super.key});
  @override
  State<MemePage> createState() => _MemePageState();
}

class _MemePageState extends State<MemePage> {
  int _selectedIndex = 0;
  final DataBaseService dbService = DataBaseService();

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<MemesSearchProvider>(context, listen: false).setCategory =
        'lol';
    Provider.of<MemesSearchProvider>(context, listen: false).setCount = 1;
    Provider.of<MemesSearchProvider>(context, listen: false).currentMemes = [];
    Provider.of<MemesSearchProvider>(context, listen: false).setLoad = false;
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
      MemesSearchProvider,
      MemesFavouriteProvider
    >(
      builder: (context, theme, memes, favourite, child) {
        return Scaffold(
          backgroundColor: theme.getTheme.colorScheme.surface,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Ключевое слово:'),
                            content: StatefulBuilder(
                              builder: (BuildContext context, setState) {
                                String? selectedCategory = memes.getCategory;

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButton<String>(
                                      value: selectedCategory,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          memes.setCategory = newValue!;
                                        });
                                      },
                                      items:
                                          <String>[
                                            'lol',
                                            'literally',
                                            'anime',
                                            'programmer',
                                            'animal',
                                            'game',
                                            'music',
                                            'work',
                                            'sad',
                                            'love',
                                            'student',
                                            'hard',
                                          ].map<DropdownMenuItem<String>>((
                                            String value,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                    ),
                                  ],
                                );
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Закрыть',
                                  style: TextStyle(
                                    color: theme.getTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.getTheme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 36.0,
                      ),
                      shadowColor: Colors.black45,
                      elevation: 8,
                    ),
                    child: Text(
                      'Выбрать фильтр',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.getTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Количество мемов:'),
                            content: StatefulBuilder(
                              builder: (BuildContext context, setState) {
                                int? selectedCount = memes.getCount;

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButton<int>(
                                      value: selectedCount,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          memes.setCount = newValue!;
                                        });
                                      },
                                      items:
                                          List.generate(
                                            10,
                                            (index) => index + 1,
                                          ).map((count) {
                                            return DropdownMenuItem<int>(
                                              value: count,
                                              child: Text(count.toString()),
                                            );
                                          }).toList(),
                                    ),
                                  ],
                                );
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Закрыть',
                                  style: TextStyle(
                                    color: theme.getTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.getTheme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 36.0,
                      ),
                      shadowColor: Colors.black45,
                      elevation: 8,
                    ),
                    child: Text(
                      'Выбрать количество',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.getTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      memes.getMemesByFilter();
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
                ),
                if (memes.getMemes.isEmpty && memes.getLoad)
                  Center(
                    child: Image.asset(
                      'assets/images/loading.gif',
                      fit: BoxFit.cover,
                    ),
                  )
                else if (memes.getMemes.isEmpty && !memes.getLoad)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'Meмы не были найдены!',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.getTheme.colorScheme.error,
                        ),
                      ),
                    ),
                  )
                else if (memes.getMemes.isNotEmpty && !memes.getLoad)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          if (constraints.maxWidth > 600)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                    childAspectRatio: 0.85,
                                  ),
                              itemCount: memes.getMemes.length,
                              itemBuilder: (context, index) {
                                Meme meme = memes.getMemes[index];
                                return SlidableWidget(
                                  meme: meme,
                                  flag: 0,
                                  onAdd: () async {
                                    try {
                                      await favourite.addMeme(
                                        meme.desc,
                                        meme.imageUrl,
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
                                  onSave: () => downloadImage(meme.imageUrl),
                                  onShare: () =>
                                      shareMeme(meme.desc, meme.imageUrl),
                                );
                              },
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: memes.getMemes.length,
                              itemBuilder: (context, index) {
                                Meme meme = memes.getMemes[index];
                                return SlidableWidget(
                                  meme: meme,
                                  flag: 0,
                                  onAdd: () async {
                                    try {
                                      await favourite.addMeme(
                                        meme.desc,
                                        meme.imageUrl,
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
                                  onSave: () => downloadImage(meme.imageUrl),
                                  onShare: () =>
                                      shareMeme(meme.desc, meme.imageUrl),
                                );
                              },
                            ),
                        ],
                      );
                    },
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
