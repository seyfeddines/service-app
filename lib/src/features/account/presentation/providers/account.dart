import 'package:flutter/material.dart';

class Account with ChangeNotifier {
  Account();

  final String id = '1';
  final String name = 'farah';
  final String image = 'https://imgs.search.brave.com/dINrJr9nmKMj6NuJQnOV54QTOsKybA0-1d09346_7MY/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93MC5w/ZWFrcHguY29tL3dh/bGxwYXBlci8zMDMv/MjQvSEQtd2FsbHBh/cGVyLWlzbGFtaWMt/Z2lybC1ibGFjay1i/dXJxYS1tdXNsaW0t/Z2lybC10aHVtYm5h/aWwuanBn';
  final double rating = 4;
  final String email = 'farah@gmail.com';
  final String phoneNumber = '0791287629';

  bool idIsMe(String id) => this.id == id;
}
