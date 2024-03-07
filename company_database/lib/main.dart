import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';

dynamic database;

class Company {
  final String compName;
  final String empName;
  final int empId;
  final double empSal;
  Company({
    required this.compName,
    required this.empName,
    required this.empId,
    required this.empSal,
  });
  Map<String, dynamic> companyMap() {
    return {
      'compName': compName,
      'empName': empName,
      'empId': empId,
      'empSal': empSal,
    };
  }

  @override
  String toString() {
    return '{compName: $compName,empName: $empName,empId: $empId,empSal: $empSal,}';
  }
}

Future insertCompanyData(Company obj) async {
  final localDB = await database;
  await localDB.insert(
    "Company",
    obj.companyMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Company>> getCompanyData() async {
  final localDB = await database;
  List<Map<String, dynamic>> listCompany = await localDB.query("Company");
  return List.generate(listCompany.length, (i) {
    return Company(
      compName: listCompany[i]['compName'],
      empName: listCompany[i]['empName'],
      empId: listCompany[i]['empId'],
      empSal: listCompany[i]['empSal'],
    );
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = openDatabase(
    join(await getDatabasesPath(), "CompanyDB.db"),
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE Company(
        compName TEXT,
        empName TEXT ,
        empId INT PRIMARY KEY,
        empSal REAL)''');
    },
  );
//insert into
  Company phase1 = Company(
    compName: "Google",
    empName: "Sagar Kumbhar",
    empId: 12,
    empSal: 1.2,
  );
  insertCompanyData(phase1);
  Company phase2 = Company(
    compName: "Microsoft",
    empName: "Vishal More",
    empId: 13,
    empSal: 1.2,
  );
  insertCompanyData(phase2);
  Company phase3 = Company(
    compName: "Amazone",
    empName: "Suyash Kakade",
    empId: 2,
    empSal: 1.2,
  );
  insertCompanyData(phase3);
  Company phase4 = Company(
    compName: "Techbulls",
    empName: "Sudhir Kasare",
    empId: 5,
    empSal: 1.2,
  );
  await insertCompanyData(phase4);
  print(await getCompanyData());
}
