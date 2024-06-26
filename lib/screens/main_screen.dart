import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_forest_flutter/layout/default_layout.dart';
import 'package:secret_forest_flutter/models/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  Future<List<Themes>> getThemes() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final dio = Dio();
    final response = await dio.get(
      'http://localhost:3000/themes',
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.data;
      final List<Themes> themes =
          responseData.map<Themes>((theme) => Themes.fromJson(theme)).toList();
      return themes;
    } else {
      throw Exception('Failed to load themes');
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return DefaultLayout(
      body: Center(
        child: FutureBuilder<List<Themes>>(
          future: getThemes(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Themes>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              context.pushReplacement('/');
              return const Text('Error');
            } else {
              final themes = snapshot.data!;
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: themes.length,
                itemBuilder: (context, index) {
                  final theme = themes[index];
                  return InkWell(
                    onTap: () {
                      context.push('/theme/${theme.id}');
                    },
                    child: Text(
                      theme.title,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
