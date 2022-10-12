import 'package:authenticate/data/api/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data/api/api.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;

   // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }
  String getDate() {
    // ignore: unnecessary_null_comparison
    if (selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('dd/MM/yyyy').format(selectedDate);
    }
  }
  List listProvince = [];
  List listDistrict = [];
  List listWard = [];
  var selectedProvince;
  var selectedDistrict;
  var selectedWard;

  DropdownMenuItem<String> item(String value) {
    return DropdownMenuItem(child: Text(value));
  }

  @override
  void initState() {
    super.initState();
    apiService();
  }

  void apiService() async {
    listProvince = await getProvince();
    if (listProvince.isNotEmpty) {
      setState(() {});
    }
  }

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullnameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final sexController = TextEditingController();
  final citizenshipController = TextEditingController();

  bool? groupValue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            textFile("Enter your username", "Username", Icon(Icons.person),
                controller: usernameController),
            textFile("Enter your password", "Password", Icon(Icons.lock),controller: passwordController),
            textFile("Enter your fullname", "Fullname", Icon(Icons.person),controller: fullnameController),
            textFileNumberInput("Enter your phone", "Phone", Icon(Icons.phone),controller: phoneController),
            textFileNumberInput("Enter your citizenship", "Citizenship",
                Icon(Icons.card_membership),controller: citizenshipController),
             Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                  showDate = true;
                },
                child: const Text('Date Picker'),
              ),
            ),
            showDate ? Center(child: Text(getDate())) : const SizedBox(),
            Text("Address"),
            SizedBox(
              width: 250,
              child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text("Select province"),
                  value: selectedProvince,
                  onChanged: (Value) async {
                    setState(() {
                      selectedProvince = Value;
                    });
                    selectedDistrict = null;
                    selectedWard = null;
                    listDistrict = await getDistrict(apiUrlProvince +
                        "/" +
                        selectedProvince.split(".")[0] +
                        "?depth=2");
                    if (listDistrict.isNotEmpty) {
                      setState(() {});
                    }
                  },
                  items: [
                    for (var i in listProvince)
                      DropdownMenuItem(
                        child: Text(i['name']),
                        value: i['code'].toString() + "." + i['name'],
                      )
                  ]),
            ),
            SizedBox(
              width: 250,
              child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text("Select district"),
                  value: selectedDistrict,
                  onChanged: (Value) async {
                    setState(() {
                      selectedDistrict = Value;
                    });
                    selectedWard = null;
                    listWard = await getWard(apiAddressUrl +
                        "/d/" +
                        selectedDistrict.split(".")[0] +
                        "?depth=2");
                    if (listWard.isNotEmpty) {
                      setState(() {});
                    }
                  },
                  items: [
                    for (var i in listDistrict)
                      DropdownMenuItem(
                        child: Text(i['name']),
                        value: i['code'].toString() + "." + i['name'],
                      )
                  ]),
            ),
            SizedBox(
              width: 250,
              child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text("Select ward"),
                  value: selectedWard,
                  onChanged: (Value) {
                    setState(() {
                      selectedWard = Value;
                    });
                  },
                  items: [
                    for (var i in listWard)
                      DropdownMenuItem(
                        child: Text(i['name']),
                        value: i['name'],
                      )
                  ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Gender"),
                SizedBox(
                  height: 30,
                  width: 150,
                  child: RadioListTile(
                      title: Text("Male"),
                      value: true,
                      groupValue: groupValue,
                      onChanged: (bool? value) {
                        setState(() {
                          groupValue = value;
                        });
                      }),
                ),
                SizedBox(
                  width: 150,
                  height: 30,
                  child: RadioListTile(
                      title: Text("Female"),
                      value: false,
                      groupValue: groupValue,
                      onChanged: (bool? value) {
                        setState(() {
                          groupValue = value;
                        });
                      }),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () async {
                  Map data = {
                    "username": usernameController.text,
                    "password": passwordController.text,
                    "fullname": fullnameController.text,
                    "phone": phoneController.text,
                    "citizenship":citizenshipController.text,
                    "address":selectedWard+", "+selectedDistrict.split(".")[1]+", "+selectedProvince.split(".")[1],
                    "sex":groupValue,
                    "role":"ROLE_LANDLORD",
                    "birthday":getDate()
                  };
                  bool check = await signup(data);
                  if(check) print("Sign up ok");
                },
                child: Text("Sign up"))
          ],
        ),
      ),
    );
  }
}

Widget textFile(String hintText, String label, Icon prefixIcon,
    {TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: hintText,
        prefixIcon: prefixIcon,
        label: Text(label),
      ),
    ),
  );
}

Widget textFileNumberInput(String hintText, String label, Icon prefixIcon,{TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: hintText,
        prefixIcon: prefixIcon,
        label: Text(label),
      ),
    ),
  );
}


