import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as gAds;

class Ad extends StatefulWidget {
  @override
  State<Ad> createState() => _Ad();

}
class _Ad extends State<Ad> {
  final gAds.BannerAd myBanner = gAds.BannerAd(
    adUnitId: 'ca-app-pub-1303060875111425/9734389796',
    size: gAds.AdSize.banner,
    request: gAds.AdRequest(),
    listener: gAds.BannerAdListener(),
  );
  final gAds.NativeAd myNative = gAds.NativeAd(
    adUnitId: 'ca-app-pub-1303060875111425/8396207644',
    factoryId: 'adFactoryExample',
    request: gAds.AdRequest(),
    listener: gAds.NativeAdListener(),
  );
  @override
  void initState() {
   super.initState();
   myBanner.load();
   myNative.load();
 }
 @override
 Widget build(BuildContext context) {
	final adWidget = gAds.AdWidget(ad: myNative);
 return Container(
   	alignment: Alignment.center,
   	child: adWidget,
   width: 500,
   height: 100,
 );
 }


}
