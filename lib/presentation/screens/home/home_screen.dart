import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdumb/presentation/providers/home_providers.dart';
import 'package:imdumb/presentation/widgets/category_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const route = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genresAsync = ref.watch(genresProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: genresAsync.when(
        data: (genres) {
          return ListView.builder(
            itemCount: genres.length,
            addAutomaticKeepAlives: true, // Performance: Keep State
            itemBuilder: (context, index) {
              return CategorySection(genre: genres[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
