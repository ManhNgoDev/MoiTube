import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/widgets/feed/video_card.dart';
import 'package:moitube_app/models/video.dart';
import 'package:moitube_app/services/search_history_service.dart';
import 'package:moitube_app/services/video_service.dart';

class SearchTab extends StatefulWidget {
    const SearchTab({super.key});

    @override
    State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();
  final VideoService _videoService = VideoService();
  final SearchHistoryService _historyService = SearchHistoryService();

  bool _loading = false;
  String? _error;
  List<Video> _results = [];
  List<String> _recents = [];

  @override
  void initState() {
    super.initState();
    _loadRecents();
  }

  Future<void> _loadRecents() async {
    final items = await _historyService.getRecentSearches();
    if (!mounted) return;
    setState(() => _recents = items);
  }

  Future<void> _clearRecents() async {
    await _historyService.clear();
    if (!mounted) return;
    setState(() => _recents = []);
  }

  Future<void> _search(String term) async {
    final q = term.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _historyService.addRecentSearch(q);
      final list = await _videoService.searchVideos(q, page: 1, limit: 20);
      if (!mounted) return;
      setState(() {
        _results = list;
        _loading = false;
      });
      await _loadRecents();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onTapSuggestion(String term) {
    _controller.text = term;
    _search(term);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xffe24594)))
                  : _results.isNotEmpty
                      ? _buildResults()
                      : _buildDiscovery(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.white),
        textInputAction: TextInputAction.search,
        onSubmitted: _search,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm video, kênh...',
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: const Icon(Icons.search, color: Colors.white54),
          suffixIcon: _controller.text.trim().isEmpty
              ? null
              : IconButton(
                  onPressed: () => setState(() {
                    _controller.clear();
                    _results = [];
                    _error = null;
                  }),
                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
          filled: true,
          fillColor: const Color(0xff0b0b0b),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: const BorderSide(color: Color(0xffe24594), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: const BorderSide(color: Color(0xffe24594), width: 1.5),
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildDiscovery() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (_error != null) ...[
          Text('Lỗi: $_error', style: const TextStyle(color: Colors.redAccent)),
          const SizedBox(height: 12),
        ],
        _buildRecentSection(),
      ],
    );
  }

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history, color: Colors.white70, size: 18),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Tìm kiếm gần đây',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(
              onPressed: _recents.isEmpty ? null : _clearRecents,
              child: const Text('Xóa tất cả', style: TextStyle(color: Color(0xffe24594))),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_recents.isEmpty)
          const Text('Chưa có lịch sử tìm kiếm.', style: TextStyle(color: Colors.white38))
        else
          ..._recents.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => _onTapSuggestion(t),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xff161616),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.history, color: Colors.white38, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResults() {
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final v = _results[index];
        return VideoCard(video: v);
      },
    );
  }
}