import 'package:benimkoin/provider/portfolio_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/components/selectionbox/selectionbox3data.dart';
import 'package:benimkoin/constants/colors.dart';
import 'package:benimkoin/data/dbhelper.dart';
import 'package:provider/provider.dart';

class AddCryptoScreen extends StatefulWidget {
  const AddCryptoScreen(
      {super.key, required this.coinSymbol, required this.coinName});

  final String? coinSymbol;
  final String? coinName;

  @override
  State<AddCryptoScreen> createState() => _AddCryptoScreenState();
}

class _AddCryptoScreenState extends State<AddCryptoScreen> {
  final dbHelper = PortfolioDatabase.instance;
  TextEditingController adetController = TextEditingController();
  TextEditingController fiyatController = TextEditingController();
  SelectionBox3Data selectedTime = SelectionBox3Data.al;
  double totalAdded = 0;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    FontWeight textFontWeights = FontWeight.w600;

    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
          child: Column(children: [
        //İŞLEM EKLE TEXT
        Padding(
            padding: const EdgeInsets.fromLTRB(40, 30, 0, 10),
            child: Row(children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded))),
              const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'İşlem Ekle',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  )),
            ])),
        //DIŞ CONTAİNER
        Padding(
          padding: const EdgeInsets.fromLTRB(55, 0, 55, 100),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black)),
            child: Column(
              children: [
                //SelectionBox
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 40),
                    child: CupertinoSlidingSegmentedControl<SelectionBox3Data>(
                      backgroundColor: HexColor(grayComponentBackground),
                      thumbColor: HexColor(white),
                      groupValue: selectedTime,
                      onValueChanged: (SelectionBox3Data? value) {
                        if (value != null) {
                          setState(() {
                            selectedTime = value;
                          });
                        }
                      },
                      children: <SelectionBox3Data, Widget>{
                        SelectionBox3Data.al: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Satın Al",
                              style: TextStyle(
                                  color: HexColor(black),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            )),
                        SelectionBox3Data.sat: Text(
                          "Satış Yap",
                          style: TextStyle(
                            color: HexColor(black),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      },
                    )),
                //COIN CONTAINER

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Row(children: [
                                    Expanded(
                                      child: Text(
                                        widget.coinName!,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        widget.coinSymbol!.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: HexColor(grayComponentText)),
                                      ),
                                    )
                                  ]),
                                )),
                            //Down Arrow
                            const Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(
                                            Icons.keyboard_arrow_down_sharp))))
                          ],
                        ),
                      )),
                ),
                //ADET TEXT
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'Adet',
                          style: TextStyle(
                              fontSize: 17, fontWeight: textFontWeights),
                        ))),
                //ADET TEXTFIELD
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextField(
                          onChanged: (value) => _calculateResult(),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          controller: adetController,
                          cursorColor: HexColor(mainColorLight),
                          decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              hintText: ' 0.00',
                              hintStyle: TextStyle(color: HexColor(grayLight))),
                        ),
                      )),
                ),
                //FIYAT TEXT
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'Fiyat',
                          style: TextStyle(
                              fontSize: 17, fontWeight: textFontWeights),
                        ))),
                //FIYAT TEXTFIELD
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 50),
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextField(
                          onChanged: (value) => _calculateResult(),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          controller: fiyatController,
                          cursorColor: HexColor(mainColorLight),
                          decoration: InputDecoration(
                              suffixIcon: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                child: ImageIcon(
                                  AssetImage("lib/assets/images/TLlogo.png"),
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              hintText: ' 0.00',
                              hintStyle: TextStyle(color: HexColor(grayLight))),
                        ),
                      )),
                ),
                //TOPLAM HARCAMA CONTAINER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    height: deviceHeight / 10,
                    width: deviceWidth,
                    child: Container(
                      decoration: BoxDecoration(
                          color: HexColor(grayComponentBackground),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  child: Text(
                                    'Toplam Harcama',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                                child: Row(children: [
                                  const ImageIcon(
                                    AssetImage("lib/assets/images/TLlogo.png"),
                                    size: 40,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '$totalAdded',
                                      style: const TextStyle(fontSize: 27),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ]),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                //İŞLEM EKLE BUTTON
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor(mainColorLight),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                            child: Text(
                          'İşlem Ekle',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: HexColor(white)),
                        )),
                      ),
                      onPressed: () {
                        _submitData();
                      }),
                )
              ],
            ),
          ),
        ),
      ])),
    ));
  }

  Future<void> _submitData() async {
    final name = widget.coinName;
    var cost = double.tryParse(fiyatController.text);
    var quantity = double.tryParse(adetController.text);

    if (cost == null || quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid data')),
      );
      return;
    }

    if (selectedTime == SelectionBox3Data.sat) {
      cost *= -1;
      quantity *= -1;
    }

    await PortfolioDatabase.instance.addAsset(name!, cost, quantity);
    await PortfolioDatabase.instance.deleteRowsWithZeroQuantity();

    // Notify the provider about the change
    await Provider.of<PortfolioProvider>(context, listen: false)
        .loadTransactions();
    await Provider.of<PortfolioProvider>(context, listen: false)
        .calculateTotalValue();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Varlık eklendi')),
    );
    fiyatController.clear();
    adetController.clear();
    Navigator.pop(context);
  }

  void _calculateResult() {
    setState(() {
      double addedQuantity = double.tryParse(adetController.text) ?? 0.0;
      double addedPrice = double.tryParse(fiyatController.text) ?? 0.0;
      totalAdded = addedQuantity * addedPrice;
    });
  }

  @override
  void dispose() {
    adetController.dispose();
    fiyatController.dispose();
    super.dispose();
  }
}
