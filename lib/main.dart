import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const BanglaNewsApp());

class BanglaNewsApp extends StatelessWidget {
  const BanglaNewsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'বাংলা নিউজ',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087F8C)),
      scaffoldBackgroundColor: const Color(0xFFF4F7FA),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF10243A), foregroundColor: Colors.white),
    ),
    home: const NewsHomePage(),
  );
}

class NewsSource {
  final String name, url;
  const NewsSource(this.name, this.url);
}

class NewsItem {
  final String title, summary, link, source, category;
  final DateTime? date;
  NewsItem({required this.title, required this.summary, required this.link, required this.source, required this.category, required this.date});
}

const sources = <NewsSource>[
  NewsSource('জাগো নিউজ ২৪', 'https://www.jagonews24.com/rss/rss.xml'),
  NewsSource('বাংলা ট্রিবিউন', 'https://www.banglatribune.com/feed'),
  NewsSource('রাইজিংবিডি', 'https://www.risingbd.com/rss/rss.xml'),
  NewsSource('বাংলানিউজ২৪', 'https://www.banglanews24.com/rss/rss.xml'),
  NewsSource('বিডি২৪লাইভ', 'https://www.bd24live.com/feed'),
  NewsSource('প্রথম আলো', 'https://www.prothomalo.com/feed/'),
];

const categories = ['সর্বশেষ', 'জাতীয়', 'রাজনীতি', 'আন্তর্জাতিক', 'খেলাধুলা', 'অর্থনীতি', 'বিনোদন', 'প্রযুক্তি'];

String cleanText(String value) => value
  .replaceAll(RegExp(r'<[^>]*>'), ' ')
  .replaceAll('&nbsp;', ' ').replaceAll('&amp;', '&')
  .replaceAll('&quot;', '"').replaceAll('&#39;', "'")
  .replaceAll(RegExp(r'\s+'), ' ').trim();

String guessCategory(String text) {
  if (RegExp(r'খেলা|ক্রিকেট|ফুটবল|বিশ্বকাপ|লিগ').hasMatch(text)) return 'খেলাধুলা';
  if (RegExp(r'রাজনীতি|নির্বাচন|সংসদ|আওয়ামী লীগ|বিএনপি').hasMatch(text)) return 'রাজনীতি';
  if (RegExp(r'বিশ্ব|যুক্তরাষ্ট্র|ভারত|পাকিস্তান|চীন|ইরান|ইসরায়েল|আন্তর্জাতিক').hasMatch(text)) return 'আন্তর্জাতিক';
  if (RegExp(r'অর্থনীতি|ব্যাংক|শেয়ার|বাজার|ডলার|দাম|ব্যবসা|রপ্তানি').hasMatch(text)) return 'অর্থনীতি';
  if (RegExp(r'সিনেমা|নাটক|অভিনয়|গান|বিনোদন|তারকা').hasMatch(text)) return 'বিনোদন';
  if (RegExp(r'প্রযুক্তি|মোবাইল|স্মার্টফোন|কৃত্রিম বুদ্ধিমত্তা|এআই|ইন্টারনেট').hasMatch(text)) return 'প্রযুক্তি';
  return 'জাতীয়';
}

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});
  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  List<NewsItem> allNews = [];
  bool loading = true;
  String error = '', selectedCategory = 'সর্বশেষ', selectedSource = 'সব সংবাদমাধ্যম', searchText = '';
  final searchController = TextEditingController();

  @override
  void initState() { super.initState(); refreshNews(); }
  @override
  void dispose() { searchController.dispose(); super.dispose(); }

  Future<List<NewsItem>> loadFeed(NewsSource source) async {
    final response = await http.get(Uri.parse(source.url), headers: {
      'User-Agent': 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 Chrome/120 Mobile Safari/537.36',
      'Accept': 'application/rss+xml, application/atom+xml, application/xml, text/xml, */*',
    }).timeout(const Duration(seconds: 16));
    if (response.statusCode != 200) throw Exception('HTTP \${response.statusCode}');
    final document = xml.XmlDocument.parse(response.body);
    final nodes = document.findAllElements('item').toList();
    final entries = nodes.isNotEmpty ? nodes : document.findAllElements('entry').toList();
    final result = <NewsItem>[];
    for (final node in entries) {
      String child(String name) => node.findElements(name).isEmpty ? '' : node.findElements(name).first.innerText.trim();
      final title = cleanText(child('title'));
      final linkElements = node.findElements('link');
      final linkElement = linkElements.isEmpty ? null : linkElements.first;
      var link = child('link');
      if (link.isEmpty && linkElement != null) link = linkElement.getAttribute('href') ?? '';
      final description = child('description').isNotEmpty ? child('description') : child('summary').isNotEmpty ? child('summary') : child('content');
      final dateText = child('pubDate').isNotEmpty ? child('pubDate') : child('published').isNotEmpty ? child('published') : child('updated');
      DateTime? date = DateTime.tryParse(dateText);
      if (date == null && dateText.isNotEmpty) {
        try { date = DateTime.parse(dateText); } catch (_) {}
      }
      if (title.isEmpty || link.isEmpty) continue;
      result.add(NewsItem(title: title, summary: cleanText(description), link: link, source: source.name, date: date, category: guessCategory('$title $description')));
    }
    return result;
  }

  Future<void> refreshNews() async {
    setState(() { loading = true; error = ''; });
    final results = await Future.wait(sources.map((source) async {
      try { return await loadFeed(source); } catch (_) { return <NewsItem>[]; }
    }));
    final merged = results.expand((items) => items).toList();
    merged.sort((a, b) {
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return b.date!.compareTo(a.date!);
    });
    if (!mounted) return;
    setState(() {
      allNews = merged;
      loading = false;
      if (merged.isEmpty) error = 'এ মুহূর্তে কোনো সংবাদ লোড করা যায়নি। ইন্টারনেট সংযোগ পরীক্ষা করে আবার চেষ্টা করুন।';
    });
  }

  List<NewsItem> get visibleNews => allNews.where((item) {
    final categoryMatch = selectedCategory == 'সর্বশেষ' || item.category == selectedCategory;
    final sourceMatch = selectedSource == 'সব সংবাদমাধ্যম' || item.source == selectedSource;
    final q = searchText.toLowerCase().trim();
    return categoryMatch && sourceMatch && (q.isEmpty || item.title.toLowerCase().contains(q) || item.summary.toLowerCase().contains(q));
  }).toList();

  Future<void> openArticle(NewsItem item) async {
    final uri = Uri.tryParse(item.link);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('সংবাদটি খোলা যাচ্ছে না।')));
    }
  }

  String timeLabel(DateTime? date) {
    if (date == null) return 'সময় উল্লেখ নেই';
    final local = date.toLocal();
    final diff = DateTime.now().difference(local);
    if (diff.inMinutes < 1 && diff.inSeconds >= 0) return 'এইমাত্র';
    if (diff.inMinutes < 60 && diff.inMinutes >= 0) return '\${diff.inMinutes} মিনিট আগে';
    if (diff.inHours < 24 && diff.inHours >= 0) return '\${diff.inHours} ঘণ্টা আগে';
    return '\${local.day}/\${local.month}/\${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final news = visibleNews;
    return Scaffold(
      appBar: AppBar(
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('বাংলা নিউজ', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
          Text('দেশের সংবাদ, এক জায়গায়', style: TextStyle(fontSize: 11, color: Color(0xFFD4E8EC))),
        ]),
        actions: [IconButton(tooltip: 'রিফ্রেশ', onPressed: loading ? null : refreshNews, icon: const Icon(Icons.refresh_rounded)), const SizedBox(width: 6)],
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          decoration: const BoxDecoration(color: Color(0xFF10243A), borderRadius: BorderRadius.vertical(bottom: Radius.circular(22))),
          child: Column(children: [
            TextField(
              controller: searchController,
              onChanged: (v) => setState(() => searchText = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'সংবাদ খুঁজুন...', hintStyle: const TextStyle(color: Color(0xFFB7C8D4)),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFB7C8D4)),
                suffixIcon: searchText.isEmpty ? null : IconButton(onPressed: () { searchController.clear(); setState(() => searchText = ''); }, icon: const Icon(Icons.close, color: Colors.white)),
                filled: true, fillColor: const Color(0xFF203A52), contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 38, child: ListView.separated(
              scrollDirection: Axis.horizontal, itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final item = categories[i], active = selectedCategory == categories[i];
                return ChoiceChip(
                  label: Text(item), selected: active, onSelected: (_) => setState(() => selectedCategory = item),
                  selectedColor: const Color(0xFF19A6A0), backgroundColor: const Color(0xFF203A52),
                  labelStyle: TextStyle(color: active ? Colors.white : const Color(0xFFD6E2E9), fontWeight: FontWeight.w600, fontSize: 12),
                  side: BorderSide.none, showCheckmark: false, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                );
              },
            )),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 7),
          child: Row(children: [
            const Expanded(child: Text('সর্বশেষ সংবাদ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF172D42)))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE1E8EE))),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                value: selectedSource, icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                style: const TextStyle(fontSize: 11, color: Color(0xFF34495E), fontWeight: FontWeight.w600),
                items: ['সব সংবাদমাধ্যম', ...sources.map((s) => s.name)].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => selectedSource = v ?? 'সব সংবাদমাধ্যম'),
              )),
            ),
          ]),
        ),
        Expanded(child: RefreshIndicator(
          onRefresh: refreshNews,
          child: loading && allNews.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : news.isEmpty
              ? ListView(children: [
                  const SizedBox(height: 70),
                  Icon(error.isNotEmpty ? Icons.wifi_off_rounded : Icons.article_outlined, size: 48, color: const Color(0xFF91A2B1)),
                  const SizedBox(height: 14),
                  Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 28), child: Text(error.isNotEmpty ? error : 'এই বিভাগে কোনো সংবাদ পাওয়া যায়নি।', textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF607487), height: 1.5)))),
                  const SizedBox(height: 16),
                  Center(child: OutlinedButton.icon(onPressed: refreshNews, icon: const Icon(Icons.refresh), label: const Text('আবার চেষ্টা করুন'))),
                ])
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 5, 14, 24), itemCount: news.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = news[index];
                    return Material(
                      color: Colors.white, borderRadius: BorderRadius.circular(17),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(17), onTap: () => openArticle(item),
                        child: Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF0C9A91), shape: BoxShape.circle)),
                            const SizedBox(width: 7),
                            Expanded(child: Text(item.source, style: const TextStyle(color: Color(0xFF087F8C), fontWeight: FontWeight.w800, fontSize: 11))),
                            Text(timeLabel(item.date), style: const TextStyle(color: Color(0xFF8795A2), fontSize: 10)),
                          ]),
                          const SizedBox(height: 9),
                          Text(item.title, style: const TextStyle(fontSize: 15, height: 1.45, fontWeight: FontWeight.w800, color: Color(0xFF1C3044))),
                          if (item.summary.isNotEmpty) ...[
                            const SizedBox(height: 7),
                            Text(item.summary, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, height: 1.5, color: Color(0xFF657789))),
                          ],
                          const SizedBox(height: 10),
                          Row(children: [
                            Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFEAF5F5), borderRadius: BorderRadius.circular(7)), child: Text(item.category, style: const TextStyle(color: Color(0xFF087F8C), fontSize: 10, fontWeight: FontWeight.w700))),
                            const Spacer(), const Text('মূল সংবাদ পড়ুন', style: TextStyle(color: Color(0xFF087F8C), fontSize: 11, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 3), const Icon(Icons.open_in_new_rounded, size: 13, color: Color(0xFF087F8C)),
                          ]),
                        ])),
                      ),
                    );
                  },
                ),
        )),
        Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(12, 8, 12, 10), color: Colors.white,
          child: const Text('শিরোনাম ও সংক্ষিপ্ত বিবরণ সংবাদমাধ্যমের RSS ফিড থেকে। সম্পূর্ণ সংবাদ পড়তে মূল ওয়েবসাইটে যান।', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Color(0xFF82909D)))),
      ]),
    );
  }
}
