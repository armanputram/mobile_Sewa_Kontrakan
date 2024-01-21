import 'package:flutter/material.dart';
import 'package:mobile_projek/pemilik/landingPemilik.dart';
import 'package:mobile_projek/penyewa/landingpagePenyewa.dart';
import 'package:mobile_projek/users/landingPage.dart';

Widget getLandingPageByRole(String role) {
  switch (role) {
    case 'pemilik':
      return LandingPagePemilik();
    case 'penyewa':
      return LandingPagePenyewa();
    default:
      return LandingPage();
  }
}
