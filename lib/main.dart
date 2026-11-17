import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    ),
    home: const DirectoryPage(),
  );
}

class MediaItem {
  final String name, category, url, location;
  const MediaItem(this.name, this.category, this.url, {this.location = 'বাংলাদেশ'});
}

const categories = ['সব', 'জাতীয় সংবাদপত্র', 'অনলাইন সংবাদমাধ্যম', 'টিভি চ্যানেল', 'ই-পেপার', 'রেডিও', 'স্থানীয় সংবাদপত্র', 'ইংরেজি সংবাদমাধ্যম'];

const media = <MediaItem>[
  MediaItem('প্রথম আলো', 'জাতীয় সংবাদপত্র', 'https://www.prothomalo.com'),
  MediaItem('বাংলাদেশ প্রতিদিন', 'জাতীয় সংবাদপত্র', 'https://www.bd-pratidin.com'),
  MediaItem('কালের কণ্ঠ', 'জাতীয় সংবাদপত্র', 'https://www.kalerkantho.com'),
  MediaItem('সমকাল', 'জাতীয় সংবাদপত্র', 'https://samakal.com'),
  MediaItem('যুগান্তর', 'জাতীয় সংবাদপত্র', 'https://www.jugantor.com'),
  MediaItem('দৈনিক ইত্তেফাক', 'জাতীয় সংবাদপত্র', 'https://www.ittefaq.com.bd'),
  MediaItem('মানবজমিন', 'জাতীয় সংবাদপত্র', 'https://mzamin.com'),
  MediaItem('নয়া দিগন্ত', 'জাতীয় সংবাদপত্র', 'https://www.dailynayadiganta.com'),
  MediaItem('বণিক বার্তা', 'জাতীয় সংবাদপত্র', 'https://bonikbarta.net'),
  MediaItem('দৈনিক ইনকিলাব', 'জাতীয় সংবাদপত্র', 'https://dailyinqilab.com'),
  MediaItem('জনকণ্ঠ', 'জাতীয় সংবাদপত্র', 'https://www.dailyjanakantha.com'),
  MediaItem('আমাদের সময়', 'জাতীয় সংবাদপত্র', 'https://www.dainikamadershomoy.com'),
  MediaItem('BDnews24', 'অনলাইন সংবাদমাধ্যম', 'https://bangla.bdnews24.com'),
  MediaItem('বাংলানিউজ২৪', 'অনলাইন সংবাদমাধ্যম', 'https://www.banglanews24.com'),
  MediaItem('বাংলা ট্রিবিউন', 'অনলাইন সংবাদমাধ্যম', 'https://www.banglatribune.com'),
  MediaItem('জাগো নিউজ ২৪', 'অনলাইন সংবাদমাধ্যম', 'https://www.jagonews24.com'),
  MediaItem('রাইজিংবিডি', 'অনলাইন সংবাদমাধ্যম', 'https://www.risingbd.com'),
  MediaItem('ঢাকা পোস্ট', 'অনলাইন সংবাদমাধ্যম', 'https://www.dhakapost.com'),
  MediaItem('ঢাকা টাইমস', 'অনলাইন সংবাদমাধ্যম', 'https://www.dhakatimes24.com'),
  MediaItem('বার্তা২৪', 'অনলাইন সংবাদমাধ্যম', 'https://www.barta24.com'),
  MediaItem('বাংলাদেশ সংবাদ সংস্থা (বাসস)', 'অনলাইন সংবাদমাধ্যম', 'https://www.bssnews.net'),
  MediaItem('সময় নিউজ', 'অনলাইন সংবাদমাধ্যম', 'https://www.somoynews.tv'),
  MediaItem('দৈনিক আজাদী', 'স্থানীয় সংবাদপত্র', 'https://dainikazadi.net', location: 'চট্টগ্রাম'),
  MediaItem('দৈনিক পূর্বাঞ্চল', 'স্থানীয় সংবাদপত্র', 'https://purbanchal.com', location: 'খুলনা'),
  MediaItem('দৈনিক করতোয়া', 'স্থানীয় সংবাদপত্র', 'https://www.karatoa.com.bd', location: 'বগুড়া'),
  MediaItem('দৈনিক পূর্বকোণ', 'স্থানীয় সংবাদপত্র', 'https://www.dainikpurbokone.net', location: 'চট্টগ্রাম'),
  MediaItem('দৈনিক গ্রামবাংলা', 'স্থানীয় সংবাদপত্র', 'https://www.gramerkagoj.com', location: 'যশোর'),
  MediaItem('সময় টিভি', 'টিভি চ্যানেল', 'https://www.somoynews.tv'),
  MediaItem('এনটিভি', 'টিভি চ্যানেল', 'https://www.ntvbd.com'),
  MediaItem('চ্যানেল আই', 'টিভি চ্যানেল', 'https://www.channelionline.com'),
  MediaItem('একাত্তর টিভি', 'টিভি চ্যানেল', 'https://ekattor.tv'),
  MediaItem('আরটিভি', 'টিভি চ্যানেল', 'https://www.rtvonline.com'),
  MediaItem('যমুনা টিভি', 'টিভি চ্যানেল', 'https://jamuna.tv'),
  MediaItem('বিটিভি', 'টিভি চ্যানেল', 'https://btv.gov.bd'),
  MediaItem('ইন্ডিপেনডেন্ট টিভি', 'টিভি চ্যানেল', 'https://www.independent24.com'),
  MediaItem('ই-প্রথম আলো', 'ই-পেপার', 'https://epaper.prothomalo.com'),
  MediaItem('ই-কালের কণ্ঠ', 'ই-পেপার', 'https://epaper.kalerkantho.com'),
  MediaItem('ই-যুগান্তর', 'ই-পেপার', 'https://epaper.jugantor.com'),
  MediaItem('ই-সমকাল', 'ই-পেপার', 'https://epaper.samakal.com'),
  MediaItem('ইত্তেফাক ই-পেপার', 'ই-পেপার', 'https://epaper.ittefaq.com.bd'),
  MediaItem('দ্য ডেইলি স্টার', 'ইংরেজি সংবাদমাধ্যম', 'https://www.thedailystar.net'),
  MediaItem('ঢাকা ট্রিবিউন', 'ইংরেজি সংবাদমাধ্যম', 'https://www.dhakatribune.com'),
  MediaItem('দ্য ফিন্যান্সিয়াল এক্সপ্রেস', 'ইংরেজি সংবাদমাধ্যম', 'https://thefinancialexpress.com.bd'),
  MediaItem('নিউ এজ', 'ইংরেজি সংবাদমাধ্যম', 'https://www.newagebd.net'),
  MediaItem('ডেইলি সান', 'ইংরেজি সংবাদমাধ্যম', 'https://www.daily-sun.com'),
  MediaItem('বিবিসি বাংলা রেডিও', 'রেডিও', 'https://www.bbc.com/bengali'),
  MediaItem('বাংলাদেশ বেতার', 'রেডিও', 'https://betar.gov.bd'),
  MediaItem('রেডিও টুডে', 'রেডিও', 'https://www.radiotodaybd.fm'),
  MediaItem('রেডিও ফূর্তি', 'রেডিও', 'https://radiofoorti.fm'),
];

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key});
  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  String selected = 'সব';
  String query = '';
  final search = TextEditingController();

  @override
  void dispose() { search.dispose(); super.dispose(); }

  List<MediaItem> get filtered => media.where((m) {
    final categoryMatch = selected == 'সব' || m.category == selected;
    final q = query.trim().toLowerCase();
    return categoryMatch && (q.isEmpty || m.name.toLowerCase().contains(q) || m.location.toLowerCase().contains(q));
  }).toList();

  IconData categoryIcon(String category) {
    switch (category) {
      case 'জাতীয় সংবাদপত্র': return Icons.newspaper_rounded;
      case 'অনলাইন সংবাদমাধ্যম': return Icons.language_rounded;
      case 'টিভি চ্যানেল': return Icons.tv_rounded;
      case 'ই-পেপার': return Icons.menu_book_rounded;
      case 'রেডিও': return Icons.radio_rounded;
      case 'স্থানীয় সংবাদপত্র': return Icons.location_city_rounded;
      case 'ইংরেজি সংবাদমাধ্যম': return Icons.translate_rounded;
      default: return Icons.public_rounded;
    }
  }

  void openMedia(MediaItem item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MediaWebPage(item: item)));
  }

  @override
  Widget build(BuildContext context) {
    final items = filtered;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF10243A),
        foregroundColor: Colors.white,
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('বাংলা নিউজ', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
          Text('বাংলাদেশের সংবাদমাধ্যম এক জায়গায়', style: TextStyle(fontSize: 11, color: Color(0xFFD4E8EC))),
        ]),
      ),
      body: Column(children: [
        Container(
          color: const Color(0xFF10243A),
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: TextField(
            controller: search,
            onChanged: (v) => setState(() => query = v),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'পত্রিকা বা চ্যানেলের নাম লিখুন',
              hintStyle: const TextStyle(color: Color(0xFFB7C8D4)),
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFB7C8D4)),
              suffixIcon: query.isEmpty ? null : IconButton(onPressed: () { search.clear(); setState(() => query = ''); }, icon: const Icon(Icons.close, color: Colors.white)),
              filled: true, fillColor: const Color(0xFF203A52),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
        ),
        SizedBox(
          height: 54,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 7),
            itemBuilder: (context, i) {
              final c = categories[i], active = c == selected;
              return ChoiceChip(
                label: Text(c), selected: active,
                onSelected: (_) => setState(() => selected = c),
                selectedColor: const Color(0xFF087F8C),
                backgroundColor: Colors.white,
                labelStyle: TextStyle(color: active ? Colors.white : const Color(0xFF34495E), fontSize: 11, fontWeight: FontWeight.w700),
                side: BorderSide(color: active ? const Color(0xFF087F8C) : const Color(0xFFE0E7ED)),
                showCheckmark: false,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 9),
          child: Row(children: [
            const Expanded(child: Text('সংবাদমাধ্যমের তালিকা', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF172D42)))),
            Text('${items.length}টি', style: const TextStyle(color: Color(0xFF718096), fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
        ),
        Expanded(
          child: items.isEmpty
            ? const Center(child: Text('কোনো সংবাদমাধ্যম পাওয়া যায়নি।'))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final item = items[i];
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => openMedia(item),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        child: Row(children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(color: const Color(0xFFEAF5F5), borderRadius: BorderRadius.circular(12)),
                            child: Icon(categoryIcon(item.category), color: const Color(0xFF087F8C), size: 23),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1C3044))),
                            const SizedBox(height: 3),
                            Text(item.location + ' • ' + item.category, style: const TextStyle(fontSize: 10, color: Color(0xFF7A8997))),
                          ])),
                          const Icon(Icons.open_in_new_rounded, size: 18, color: Color(0xFF087F8C)),
                        ]),
                      ),
                    ),
                  );
                },
              ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 11),
          child: const Text('সংবাদ পড়তে বা দেখতে তালিকার নামের ওপর চাপ দিন। সব ওয়েবসাইট তাদের নিজস্ব কর্তৃপক্ষ পরিচালনা করে।', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Color(0xFF82909D))),
        ),
      ]),
    );
  }
}


class MediaWebPage extends StatefulWidget {
  final MediaItem item;
  const MediaWebPage({super.key, required this.item});
  @override
  State<MediaWebPage> createState() => _MediaWebPageState();
}

class _MediaWebPageState extends State<MediaWebPage> {
  late final WebViewController controller;
  bool loading = true;
  bool canGoBack = false;
  bool canGoForward = false;
  String pageTitle = '';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => loading = true),
        onPageFinished: (_) async {
          final back = await controller.canGoBack();
          final forward = await controller.canGoForward();
          final title = await controller.getTitle() ?? '';
          if (!mounted) return;
          setState(() { loading = false; canGoBack = back; canGoForward = forward; pageTitle = title; });
        },
        onWebResourceError: (error) {
          if (!mounted || !error.isForMainFrame!) return;
          setState(() => loading = false);
        },
      ))
      ..loadRequest(Uri.parse(widget.item.url));
  }

  Future<bool> handleBack() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) async {
      if (!didPop && await handleBack() && mounted) Navigator.of(context).pop();
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF10243A),
        foregroundColor: Colors.white,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          Text(pageTitle.isEmpty ? widget.item.url : pageTitle,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Color(0xFFD4E8EC))),
        ]),
        actions: [
          IconButton(tooltip: 'রিফ্রেশ', onPressed: () => controller.reload(), icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(children: [
        if (loading) const LinearProgressIndicator(minHeight: 2),
        Expanded(child: WebViewWidget(controller: controller)),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconButton(tooltip: 'পেছনে', onPressed: canGoBack ? () => controller.goBack() : null, icon: const Icon(Icons.arrow_back)),
            IconButton(tooltip: 'সামনে', onPressed: canGoForward ? () => controller.goForward() : null, icon: const Icon(Icons.arrow_forward)),
            IconButton(tooltip: 'হোম', onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.home_outlined)),
            IconButton(tooltip: 'রিফ্রেশ', onPressed: () => controller.reload(), icon: const Icon(Icons.refresh)),
          ]),
        ),
      ]),
    ),
  );
}
