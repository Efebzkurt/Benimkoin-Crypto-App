import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KullaniciSozlesmesi extends StatefulWidget {
  const KullaniciSozlesmesi({super.key});

  @override
  State<KullaniciSozlesmesi> createState() => _KullaniciSozlesmesiState();
}

class _KullaniciSozlesmesiState extends State<KullaniciSozlesmesi> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          'Kullanıcı Sözleşmesi',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          //Mail Image
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SizedBox(
                height: deviceHeight / 5,
                child:
                    Image.asset("lib/assets/images/kullanicisozlesmesi.png")),
          ),
          //Texts

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              _kullanicisozlesmesi,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              _kullanicisozlesmesi2,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              _kullanicisozlesmesi3,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              _kullanicisozlesmesi4,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
            ),
          ),

          SizedBox(
              height: deviceHeight / 5,
              child: Image.asset("lib/assets/images/benimkoinlogo2.png")),
        ])),
      )),
    );
  }

  final String _kullanicisozlesmesi =
      '1. Piyasa verileri, Coingecko tarafından sağlanmaktadır ve Benimkoin, gösterilen fiyatlar hakkında sorumluluk kabul etmez. Benimkoin, kullanılan kaynaklarca sağlanan hatalı veya noksan veriler nedeniyle oluşabilecek zarardan herhangi bir şekilde sorumlu tutulamaz.';
  final String _kullanicisozlesmesi2 =
      '2. Benimkoin, uygulamada kullanılan istatistik ve verilere dayanan yatırım kararları hakkında sorumlu tutulamaz';
  final String _kullanicisozlesmesi3 =
      '3. Benimkoin, uygulama üzerinden sunulan hizmetleri değiştirme ve sonlandırma hakkına sahiptir.';
  final String _kullanicisozlesmesi4 =
      '4. Uygulamada gösterilen üçüncü şahısların sağladığı reklamlardan sorumluluk kabul edilmez.';
}
