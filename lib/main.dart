import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Add card",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF223263))),
          backgroundColor: Colors.white,
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formkey = GlobalKey<FormState>();
  late String cardno, expirydate, securitycode, cardholder;
  late DateTime date;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 155,
              child: Form(
                key: formkey,
                child: ListView(
                  children: <Widget>[
                    buildcardno(),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: buildexpiry(context),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: buildsecurity(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    buildcardholder(),
                  ],
                ),
              ),
            ),
            // const Spacer(),
            buildsubmit(),
          ],
        ),
      ),
    );
  }

  Widget buildcardno() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Card Number',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF223263))),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: '1231 - 2312 - 3123 - 1231',
            hintStyle: TextStyle(color: Color(0xFFEBF0FF)),
            errorStyle: TextStyle(color: Color(0xFFE78787)),
            border: OutlineInputBorder(),
          ),
          onSaved: (value) => setState(() => cardno = value!),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.length != 16) {
              return 'enter a valid card no';
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Widget buildexpiry(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Expiration Date',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF223263))),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: '12/12',
            hintStyle: TextStyle(color: Color(0xFFEBF0FF)),
            errorStyle: TextStyle(color: Color(0xFFE78787)),
            border: OutlineInputBorder(),
          ),
          controller: controller,
          onTap: () {
            FocusScope.of(context).unfocus();
            pickdate(context);
          },
          validator: (value) {
            if (value!.isNotEmpty) {
              return null;
            } else {
              return 'date must not be empty';
            }
          },
        ),
      ],
    );
  }

  Widget buildsecurity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Security Code',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF223263))),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
              hintText: '123',
              hintStyle: TextStyle(color: Color(0xFFEBF0FF)),
              errorStyle: TextStyle(color: Color(0xFFE78787)),
              border: OutlineInputBorder()),
          onSaved: (value) => setState(() => securitycode = value!),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.length != 3) {
              return 'enter a valid security code';
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Widget buildcardholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Card Holder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF223263),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
              hintText: 'John doe',
              hintStyle: TextStyle(
                  color: Color(0xFFEBF0FF), fontWeight: FontWeight.bold),
              errorStyle: TextStyle(color: Color(0xFFE78787)),
              border: OutlineInputBorder()),
          onSaved: (value) => setState(() => cardholder = value!),
          validator: (value) {
            if (value!.isEmpty) {
              return 'name must not be empty';
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Future<void> pickdate(BuildContext context) async {
    final initialdate = DateTime.now();
    final newdate = await showDatePicker(
      context: context,
      initialDate: initialdate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 99),
    );
    if (newdate != null) {
      setState(() {
        date = newdate;
        expirydate = '${newdate.month}/${newdate.year}';
        controller.text = expirydate;
      });
    }
  }

  Widget buildsubmit() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xFFAE90D4)),
        ),
        child: const Text("Add Card",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
        onPressed: () {
          final isvalid = formkey.currentState!.validate();
          if (isvalid) {
            formkey.currentState!.save();
            print('cardno is $cardno');
            print('expiry date is $expirydate');
            print('securitycode is $securitycode');
            print('cardholder is $cardholder');
            formkey.currentState!.reset();
            controller.clear();
          }
        },
      ),
    );
  }
}
