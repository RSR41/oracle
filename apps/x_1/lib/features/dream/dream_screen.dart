import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_1/core/theme/app_colors.dart';

class DreamScreen extends ConsumerStatefulWidget {
  const DreamScreen({super.key});

  @override
  ConsumerState<DreamScreen> createState() => _DreamScreenState();
}

class _DreamScreenState extends ConsumerState<DreamScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _results = []; // Mock results

  void _search(String query) {
    setState(() {
      _results.clear();
      if (query.isNotEmpty) {
        // Mock search logic
        if (query.toLowerCase().contains('dragon')) {
          _results.add('Seeing a Dragon: Great luck and success.');
          _results.add('Riding a Dragon: Promotion or high status.');
        } else if (query.toLowerCase().contains('snake')) {
          _results.add('Snake Bite: Wealth coming in.');
          _results.add('Killing a Snake: Overcoming obstacles.');
        } else {
          _results.add(
              'Dream about "$query": No exact match found, but generally refers to your inner thoughts about this subject.');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dream Interpretation')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search (e.g., Dragon, Snake)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _search('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _search,
            ),
          ),

          // Popular Keywords
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _KeywordChip(
                    label: 'Dragon', onTap: () => _updateSearch('Dragon')),
                _KeywordChip(
                    label: 'Snake', onTap: () => _updateSearch('Snake')),
                _KeywordChip(
                    label: 'Water', onTap: () => _updateSearch('Water')),
                _KeywordChip(label: 'Fire', onTap: () => _updateSearch('Fire')),
                _KeywordChip(
                    label: 'Falling', onTap: () => _updateSearch('Falling')),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Results
          Expanded(
            child: _results.isEmpty && _searchController.text.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'What did you dream about?',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.auto_awesome,
                              color: AppColors.primary),
                          title: Text(_results[index]),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Show details
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _updateSearch(String term) {
    _searchController.text = term;
    _search(term);
  }
}

class _KeywordChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeywordChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        onPressed: onTap,
        backgroundColor: AppColors.surface,
      ),
    );
  }
}
