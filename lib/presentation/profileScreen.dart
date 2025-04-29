import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttergsi/api/profileApi.dart';
import 'package:fluttergsi/api/wilayahApi.dart';
import 'package:fluttergsi/presentation/loginPage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fluttergsi/template/template.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class OptionItem {
  final String id;
  final String name;

  OptionItem({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => name;
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final Template t = Template();

  // Individual controllers
  final TextEditingController nikController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  String? _selectedJenisKelamin;
  List<String> optionsJenisKelamin = ['L', 'P'];
  String gambarKtp = '';

  String? _selectedGolonganDarah;
  List<String> optionsGolonganDarah = [
    'A',
    'B',
    'AB',
    'O',
  ];

  final TextEditingController alamatController = TextEditingController();
  final TextEditingController rtController = TextEditingController();
  final TextEditingController rwController = TextEditingController();

  String? _selectedAgama;
  List<String> optionsAgama = [
    'Islam',
    'Kristen',
    'Hindu',
    'Buddha',
    'Konghucu',
  ];
  String? _selectedstatusPerkawinan;
  List<String> optionsStatusKawin = [
    'Belum Kawin',
    'Kawin',
    'Cerai Hidup',
    'Cerai Mati',
  ];
  // final TextEditingController statusPekerjaanController =
  //     TextEditingController();
  String? _selectedPekerjaan;
  List<String> optionsPekerjaan = [
    'Belum / Tidak Bekerja',
    'Mengurus Rumah Tangga',
    'Pelajar / Mahasiswa',
    'Pensiunan',
    'Pegawai Negeri Sipil',
    'Tentara Nasional Indonesia',
    'Kepolisian RI',
    'Perdagangan',
    'Petani / Pekebun',
    'Peternak',
    'Nelayan / Perikanan',
    'Industri',
    'Konstruksi',
    'Transportasi',
    'Karyawan Swasta',
    'Karyawan BUMN',
    'Karyawan BUMD',
    'Karyawan Honorer',
    'Buruh Harian Lepas',
    'Buruh Tani / Perkebunan',
    'Buruh Nelayan / Perikanan',
    'Buruh Peternakan',
    'Pembantu Rumah Tangga',
    'Tukang Cukur',
    'Tukang Listrik',
    'Tukang Batu',
    'Tukang Kayu',
    'Tukang Sol Sepatu',
    'Tukang Las / Pandai Besi',
    'Tukang Jahit',
    'Penata Rambut',
    'Penata Rias',
    'Penata Busana',
    'Mekanik',
    'Tukang Gigi',
    'Seniman',
    'Tabib',
    'Paraji',
    'Perancang Busana',
    'Penerjemah',
    'Imam Masjid',
    'Pendeta',
    'Pastur',
    'Wartawan',
    'Ustadz / Mubaligh',
    'Juru Masak',
    'Promotor Acara',
    'Anggota DPR-RI',
    'Anggota DPD',
    'Anggota BPK',
    'Presiden',
    'Wakil Presiden',
    'Anggota Mahkamah Konstitusi',
    'Anggota Kabinet / Kementerian',
    'Duta Besar',
    'Gubernur',
    'Wakil Gubernur',
    'Bupati',
    'Wakil Bupati',
    'Walikota',
    'Wakil Walikota',
    'Anggota DPRD Provinsi',
    'Anggota DPRD Kabupaten',
    'Dosen',
    'Guru',
    'Pilot',
    'Pengacara',
    'Notaris',
    'Arsitek',
    'Akuntan',
    'Konsultan',
    'Dokter',
    'Bidan',
    'Perawat',
    'Apoteker',
    'Psikiater / Psikolog',
    'Penyiar Televisi',
    'Penyiar Radio',
    'Pelaut',
    'Peneliti',
    'Sopir',
    'Pialang',
    'Paranormal',
    'Pedagang',
    'Perangkat Desa',
    'Kepala Desa',
    'Biarawati',
    'Wiraswasta',
    'Anggota Lembaga Tinggi',
    'Artis',
    'Atlit',
    'Chef',
    'Manajer',
    'Tenaga Tata Usaha',
    'Operator',
    'Pekerja Pengolahan, Kerajinan',
    'Teknisi',
    'Asisten Ahli',
    'Lainnya',
  ];

  String? _selectedKewarganegaraan;
  List<String> optionsKewarganegaraan = ['WNI', 'WNA'];

  // final TextEditingController berlakuHinggaController = TextEditingController();
  // final TextEditingController kodeBankController = TextEditingController();
  final TextEditingController noRekeningController = TextEditingController();

  // Kelurahan and Desa Dropdown
  OptionItem? selectedProvinsi;
  OptionItem? selectedKecamatan;
  OptionItem? selectedKabupaten;
  OptionItem? selectedKelurahan;
  OptionItem? selectedKodeBank;

  List<OptionItem> provinsiOptions = [];
  List<OptionItem> kabupatenOptions = [];
  List<OptionItem> kecamatanOptions = [];
  List<OptionItem> kelurahanOptions = [];
  List<OptionItem> kodeBankOptions = [
    OptionItem(id: '002', name: 'BRI'),
    OptionItem(id: '008', name: 'Bank Mandiri'),
    OptionItem(id: '009', name: 'Bank Negara Indonesia'),
    OptionItem(id: '011', name: 'Bank Danamon'),
    OptionItem(id: '013', name: 'Bank Permata'),
    OptionItem(id: '014', name: 'BCA'),
    OptionItem(id: '016', name: 'BII Maybank'),
    OptionItem(id: '019', name: 'Bank Panin'),
    OptionItem(id: '022', name: 'CIMB Niaga'),
    OptionItem(id: '023', name: 'Bank UOB Indonesia'),
    OptionItem(id: '028', name: 'Bank OCBC NISP'),
    OptionItem(id: '031', name: 'Citibank'),
    OptionItem(id: '032', name: 'JPMorgan Chase Bank'),
    OptionItem(id: '036', name: 'Bank China Construction Bank Indonesia'),
    OptionItem(id: '037', name: 'Bank Artha Graha Internasional'),
    OptionItem(id: '042', name: 'MUFG Bank'),
    OptionItem(id: '046', name: 'Bank DBS Indonesia'),
    OptionItem(id: '050', name: 'Standard Chartered'),
    OptionItem(id: '054', name: 'Bank Capital Indonesia'),
    OptionItem(id: '061', name: 'ANZ Indonesia'),
    OptionItem(id: '067', name: 'Deutsche Bank AG'),
    OptionItem(id: '069', name: 'Bank OF China'),
    OptionItem(id: '076', name: 'Bank Bumi Arta'),
    OptionItem(id: '087', name: 'Bank HSBC Indonesia'),
    OptionItem(id: '088', name: 'Bank Antardaerah'),
    OptionItem(id: '089', name: 'Bank Rabobank'),
    OptionItem(id: '095', name: 'Bank Jtrust Indonesia'),
    OptionItem(id: '097', name: 'Bank Mayapada International'),
    OptionItem(id: '110', name: 'BJB'),
    OptionItem(id: '111', name: 'Bank DKI'),
    OptionItem(id: '112', name: 'Bank DIY'),
    OptionItem(id: '112S', name: 'Bank DIY Syariah'),
    OptionItem(id: '113', name: 'Bank Jateng'),
    OptionItem(id: '114', name: 'Bank Jatim'),
    OptionItem(id: '114S', name: 'Bank Jatim Syariah'),
    OptionItem(id: '115', name: 'Bank Jambi'),
    OptionItem(id: '115S', name: 'Bank Jambi Syariah'),
    OptionItem(id: '116', name: 'Bank Aceh'),
    OptionItem(id: '117', name: 'Bank Sumut'),
    OptionItem(id: '117S', name: 'Bank Sumut Syariah'),
    OptionItem(id: '118', name: 'Bank Nagari'),
    OptionItem(id: '118S', name: 'Bank Nagari Syariah'),
    OptionItem(id: '119', name: 'Bank Riau'),
    OptionItem(id: '120', name: 'Bank Sumsel Babel'),
    OptionItem(id: '120S', name: 'Bank Sumsel Babel Syariah'),
    OptionItem(id: '121', name: 'Bank Lampung'),
    OptionItem(id: '122', name: 'Bank Kalsel'),
    OptionItem(id: '122S', name: 'Bank Kalsel Syariah'),
    OptionItem(id: '123', name: 'Bank Kalbar'),
    OptionItem(id: '123S', name: 'Bank Kalbar Syariah'),
    OptionItem(id: '124', name: 'Bank Kaltim'),
    OptionItem(id: '124S', name: 'Bank Kaltim Syariah'),
    OptionItem(id: '125', name: 'Bank Kalteng'),
    OptionItem(id: '126', name: 'Bank Sulselbar'),
    OptionItem(id: '126S', name: 'Bank Sulselbar Syariah'),
    OptionItem(id: '127', name: 'Bank Sulut'),
    OptionItem(id: '128', name: 'Bank NTB'),
    OptionItem(id: '129', name: 'Bank Bali'),
    OptionItem(id: '130', name: 'Bank NTT'),
    OptionItem(id: '131', name: 'Bank Maluku'),
    OptionItem(id: '132', name: 'Bank Papua'),
    OptionItem(id: '133', name: 'Bank Bengkulu'),
    OptionItem(id: '134', name: 'Bank Sulteng'),
    OptionItem(id: '135', name: 'Bank Sultra'),
    OptionItem(id: '137', name: 'Bank Banten'),
    OptionItem(id: '145', name: 'Bank Nusantara Parahyangan'),
    OptionItem(id: '146', name: 'Bank Of India Indonesia'),
    OptionItem(id: '147', name: 'Bank Muamalat'),
    OptionItem(id: '151', name: 'Bank Mestika'),
    OptionItem(id: '152', name: 'Bank Shinhan'),
    OptionItem(id: '153', name: 'Bank Sinarmas'),
    OptionItem(id: '157', name: 'Bank Maspion Indonesia'),
    OptionItem(id: '161', name: 'Bank Ganesha'),
    OptionItem(id: '164', name: 'Bank ICBC Indonesia'),
    OptionItem(id: '167', name: 'Bank QNB Indonesia'),
    OptionItem(id: '200', name: 'BTN'),
    OptionItem(id: '200S', name: 'BTN Syariah'),
    OptionItem(id: '212', name: 'Bank Woori Saudara'),
    OptionItem(id: '213', name: 'Bank SMBC Indonesia'),
    OptionItem(id: '405', name: 'Bank Victoria Syariah'),
    OptionItem(id: '425', name: 'BJB Syariah'),
    OptionItem(id: '426', name: 'Bank Mega'),
    OptionItem(id: '441', name: 'Bank Bukopin'),
    OptionItem(id: '451', name: 'Bank Syariah Indonesia'),
    OptionItem(id: '472', name: 'Bank Jasa Jakarta'),
    OptionItem(id: '484', name: 'Bank KEB Hana'),
    OptionItem(id: '485', name: 'Bank MNC'),
    OptionItem(id: '490', name: 'Bank Neo Commerce'),
    OptionItem(id: '494', name: 'Bank Raya Indonesia'),
    OptionItem(id: '498', name: 'Bank SBI Indonesia'),
    OptionItem(id: '501', name: 'BCA Digital'),
    OptionItem(id: '503', name: 'Bank National Nobu'),
    OptionItem(id: '506', name: 'Bank Mega Syariah'),
    OptionItem(id: '513', name: 'Bank INA'),
    OptionItem(id: '517', name: 'Bank Panin Syariah'),
    OptionItem(id: '520', name: 'Bank Prima'),
    OptionItem(id: '521', name: 'Bank Syariah Bukopin'),
    OptionItem(id: '523', name: 'Bank Sahabat Sampoerna'),
    OptionItem(id: '526', name: 'Bank Oke Indonesia'),
    OptionItem(id: '535', name: 'Bank Seabank Indonesia'),
    OptionItem(id: '536', name: 'Bank BCA Syariah'),
    OptionItem(id: '542', name: 'Bank Jago'),
    OptionItem(id: '542S', name: 'Bank Jago Syariah'),
    OptionItem(id: '547', name: 'Bank BTPN Syariah'),
    OptionItem(id: '548', name: 'Bank Multiarta Sentosa'),
    OptionItem(id: '553', name: 'Bank Hibank Indonesia'),
    OptionItem(id: '555', name: 'Bank Index'),
    OptionItem(id: '559', name: 'Bank CNB'),
    OptionItem(id: '562', name: 'Superbank'),
    OptionItem(id: '564', name: 'Bank Mandiri Taspen'),
    OptionItem(id: '566', name: 'Bank Victoria International'),
    OptionItem(id: '567', name: 'Allo Bank'),
    OptionItem(id: '600', name: 'ATMB LSB'),
    OptionItem(id: '688', name: 'BPR KS'),
    OptionItem(id: '724', name: 'Bank DKI Syariah'),
    OptionItem(id: '725', name: 'Bank Jateng Syariah'),
    OptionItem(id: '734', name: 'Bank Sinarmas Syariah'),
    OptionItem(id: '777', name: 'Finnet'),
    OptionItem(id: '867', name: 'Bank Eka'),
    OptionItem(id: '945', name: 'Bank IBK Indonesia'),
    OptionItem(id: '949', name: 'Bank CTBC Indonesia'),
    OptionItem(id: '950', name: 'Bank Commonwealth'),
    OptionItem(id: '987', name: 'ATMB Plus'),
    OptionItem(id: 'dana', name: 'DANA'),
    OptionItem(id: 'gopay', name: 'GoPay'),
    OptionItem(id: 'linkaja', name: 'LinkAja'),
    OptionItem(id: 'ovo', name: 'OVO'),
    OptionItem(id: 'shopeepay', name: 'Shopeepay'),
  ];

  File? _gambarKtp;
  String? _base64Image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      setState(() {
        _gambarKtp = file;
        _base64Image = base64String;
      });
    }
  }

  void _saveProfile() async {
    t.showLoadingDialog(context, null);

    var body = {
      "nik": nikController.text,
      "nama": namaController.text,
      "tempatLahir": tempatLahirController.text,
      "tanggalLahir": tanggalLahirController.text,
      "jenisKelamin": _selectedJenisKelamin ?? '',
      "golDarah": _selectedGolonganDarah ?? '',
      "alamat": alamatController.text,
      "rt": rtController.text,
      "rw": rwController.text,
      "kel": selectedKelurahan?.name ?? '',
      "desa": selectedKelurahan?.name ?? '',
      "provinsi": selectedProvinsi?.name ?? '',
      "kabupaten": selectedKabupaten?.name ?? '',
      "kecamatan": selectedKecamatan?.name ?? '',
      "agama": _selectedAgama ?? '',
      "statusPekerjaan": _selectedPekerjaan ?? '',
      "statusPerkawinan": _selectedstatusPerkawinan ?? '',
      "pekerjaan": _selectedPekerjaan ?? '',
      "kewarganegaraan": _selectedKewarganegaraan ?? '',
      "berlakuHingga": "2025-04-08",
      "kodeBank": selectedKodeBank?.id ?? '',
      "noRekening": noRekeningController.text,
      "gambarKtp": "data:image/jpeg;base64,${_base64Image}",
    };

    var response = await ApiProfile().update(body);

    if (response.status == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.message}')),
      );
      t.hideLoadingDialog(context);
      setState(() {});
    } else {
      t.hideLoadingDialog(context);

      // Check if the error message is "Unauthorized"
      if (response.message!.contains('Unauthorized')) {
        // Redirect to login screen if unauthorized
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update Profile failed: ${response.message}')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Show the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update Profile failed: ${response.message}')),
        );
      }
    }
  }

  void _loadProfileAndProvinsi() async {
    t.showLoadingDialog(context, null);

    try {
      // Fetch profile
      var profileBody = {'id': '0'};
      var profileResponse = await ApiProfile().get(profileBody);

      if (profileResponse.status == true) {
        nikController.text = profileResponse.data?.profile?.nik ?? '';
        accountNameController.text =
            profileResponse.data?.profile?.accountName ?? '';
        namaController.text = profileResponse.data?.profile?.nama ?? '';
        if (profileResponse.data?.profile?.gambarKtp != '' ||
            profileResponse.data?.profile?.gambarKtp != null) {
          gambarKtp = profileResponse.data?.profile?.gambarKtp ?? '';
        }

        tempatLahirController.text =
            profileResponse.data?.profile?.tempatLahir ?? '';
        tanggalLahirController.text =
            profileResponse.data?.profile?.tanggalLahir ?? '';
        _selectedJenisKelamin = profileResponse.data?.profile?.jenisKelamin;
        _selectedGolonganDarah = profileResponse.data?.profile?.golDarah;
        alamatController.text = profileResponse.data?.profile?.alamat ?? '';
        rtController.text = profileResponse.data?.profile?.rt ?? '';
        rwController.text = profileResponse.data?.profile?.rw ?? '';

        _selectedAgama = profileResponse.data?.profile?.agama;
        _selectedstatusPerkawinan =
            profileResponse.data?.profile?.statusPerkawinan;
        _selectedPekerjaan = profileResponse.data?.profile?.statusPekerjaan;
        _selectedKewarganegaraan =
            profileResponse.data?.profile?.kewarganegaraan;

        String? kodeBankName = profileResponse.data?.profile?.kodeBank;

        if (kodeBankName != null && kodeBankName.isNotEmpty) {
          selectedKodeBank = kodeBankOptions.firstWhere(
            (option) => option.id == kodeBankName,
            orElse: () => OptionItem(id: '', name: ''),
          );
        }

        noRekeningController.text =
            profileResponse.data?.profile?.noRekening ?? '';
      }

      // Fetch provinsi
      var provinsiBody = {'id': '0'};
      var provinsiResponse = await ApiWilayah().Provinsi(provinsiBody);

      if (provinsiResponse.status == true) {
        provinsiOptions = provinsiResponse.data!.map((e) {
          return OptionItem(id: e.id!, name: e.nama!);
        }).toList();

        String? provinsiName = profileResponse.data?.profile?.provinsi;

        if (provinsiName != null && provinsiName.isNotEmpty) {
          selectedProvinsi = provinsiOptions.firstWhere(
            (option) => option.name == provinsiName,
            orElse: () => OptionItem(id: '', name: ''),
          );

          if (selectedProvinsi?.name != '') {
            _fetchKabupatenLoad(
                selectedProvinsi!.id,
                profileResponse.data?.profile?.kabupaten ?? '',
                profileResponse.data?.profile!.kecamatan ?? '',
                profileResponse.data?.profile!.kel ?? '');
          }
        }
      } else {
        provinsiOptions = [];
      }

      setState(() {});
    } catch (e) {
      log('Error occurred: $e');
    } finally {
      t.hideLoadingDialog(context);
    }
  }

  void _fetchKabupatenLoad(String id, String selectedKabupatenData,
      String selectedKecamatanData, String selectedKelurahanData) async {
    t.showLoadingDialog(context, null);
    var body = {'id': id};
    var login = await ApiWilayah().Kabupaten(body);

    if (login.status == true) {
      kabupatenOptions = login.data!.map((e) {
        return OptionItem(id: e.id!, name: e.nama!);
      }).toList();

      String? kabupatenName = selectedKabupatenData;
      if (kabupatenName != null && kabupatenName.isNotEmpty) {
        selectedKabupaten = kabupatenOptions.firstWhere(
          (option) => option.name == kabupatenName,
          orElse: () => OptionItem(id: '', name: ''),
        );
      }

      if (selectedKabupaten?.name != '') {
        _fetchKecamatanLoad(selectedKabupaten!.id, selectedKecamatanData,
            selectedKelurahanData);
      }

      t.hideLoadingDialog(context);
      setState(() {});
    } else {
      kabupatenOptions = [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('get kabupaten failed')),
      );
      t.hideLoadingDialog(context);
    }
  }

  void _fetchKecamatanLoad(String id, String selectedKecamatanData,
      String selectedKelurahanData) async {
    t.showLoadingDialog(context, null);
    var body = {'id': id};
    var login = await ApiWilayah().Kecamatan(body);

    if (login.status == true) {
      kecamatanOptions = login.data!.map((e) {
        return OptionItem(id: e.id!, name: e.nama!);
      }).toList();

      String? kecamatanName = selectedKecamatanData;
      if (kecamatanName != null && kecamatanName.isNotEmpty) {
        selectedKecamatan = kecamatanOptions.firstWhere(
          (option) => option.name == kecamatanName,
          orElse: () => OptionItem(id: '', name: ''),
        );
      }

      if (selectedKecamatan?.name != '') {
        _fetchKelurahanLoad(selectedKecamatan!.id, selectedKelurahanData);
      }

      t.hideLoadingDialog(context);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('get kecamatan failed')),
      );
      kecamatanOptions = [];
      t.hideLoadingDialog(context);
    }
  }

  void _fetchKelurahanLoad(String id, String selectedKelurahanData) async {
    t.showLoadingDialog(context, null);
    var body = {'id': id};
    var login = await ApiWilayah().Kelurahan(body);

    if (login.status == true) {
      kelurahanOptions = login.data!.map((e) {
        return OptionItem(id: e.id!, name: e.nama!);
      }).toList();

      String? kelurahanName = selectedKelurahanData;
      if (kelurahanName != null && kelurahanName.isNotEmpty) {
        selectedKelurahan = kelurahanOptions.firstWhere(
          (option) => option.name == kelurahanName,
          orElse: () => OptionItem(id: '', name: ''),
        );
      }

      t.hideLoadingDialog(context);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('get kelurahan failed')),
      );
      kelurahanOptions = [];
      t.hideLoadingDialog(context);
    }
  }

  void _fetchKabupaten(String id) async {
    t.showLoadingDialog(context, null);
    var body = {'id': id};
    var login = await ApiWilayah().Kabupaten(body);

    if (login.status == true) {
      kabupatenOptions = login.data!.map((e) {
        return OptionItem(id: e.id!, name: e.nama!);
      }).toList();

      t.hideLoadingDialog(context);
      setState(() {});
    } else {
      kabupatenOptions = [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('get kabupaten failed')),
      );
      t.hideLoadingDialog(context);
    }
  }

  void _fetchKecamatan(String id) async {
    t.showLoadingDialog(context, null);
    var body = {'id': id};
    var login = await ApiWilayah().Kecamatan(body);

    if (login.status == true) {
      kecamatanOptions = login.data!.map((e) {
        return OptionItem(id: e.id!, name: e.nama!);
      }).toList();

      t.hideLoadingDialog(context);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('get kecamatan failed')),
      );
      kecamatanOptions = [];
      t.hideLoadingDialog(context);
    }
  }

  void _fetchKelurahan(String id) async {
    t.showLoadingDialog(context, null);
    var body = {'id': id};
    var login = await ApiWilayah().Kelurahan(body);

    if (login.status == true) {
      kelurahanOptions = login.data!.map((e) {
        return OptionItem(id: e.id!, name: e.nama!);
      }).toList();

      t.hideLoadingDialog(context);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('get kelurahan failed')),
      );
      kelurahanOptions = [];
      t.hideLoadingDialog(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileAndProvinsi();
    });
  }

  @override
  void dispose() {
    nikController.dispose();
    namaController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();
    alamatController.dispose();
    rtController.dispose();
    rwController.dispose();

    // kodeBankController.dispose();
    // noRekeningController.dispose();
    super.dispose();
  }

  Widget _buildTextFieldDisabled(
    String label,
    TextEditingController controller,
    BuildContext context,
  ) {
    bool isTanggal = label.toLowerCase().contains('tanggal');
    bool isRTorRW = label.toLowerCase().contains('rt') ||
        label.toLowerCase().contains('rw') ||
        label.toLowerCase().contains('nik');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true, // respect disabled
        enabled: false, // actually disable input
        keyboardType: isRTorRW ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isRTorRW ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: isTanggal ? const Icon(Icons.calendar_today) : null,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    BuildContext context,
  ) {
    bool isTanggal = label.toLowerCase().contains('tanggal');
    bool isRTorRW = label.toLowerCase().contains('rt') ||
        label.toLowerCase().contains('rw') ||
        label.toLowerCase().contains('nik');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: isTanggal, // readOnly if tanggal
        keyboardType: isRTorRW
            ? TextInputType.number
            : TextInputType.text, // number if RT/RW
        inputFormatters: isRTorRW
            ? [FilteringTextInputFormatter.digitsOnly]
            : null, // only digits if RT/RW
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: isTanggal ? const Icon(Icons.calendar_today) : null,
        ),
        onTap: isTanggal
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  controller.text = "${pickedDate.toLocal()}"
                      .split(' ')[0]; // format to yyyy-MM-dd
                }
              }
            : null,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, OptionItem? value,
      List<OptionItem> options, Function(OptionItem?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownSearch<OptionItem>(
        selectedItem: value,
        items: options,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
        popupProps: const PopupProps.menu(
          showSearchBox: true,
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Gambar KTP ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: gambarKtp.isNotEmpty
                ? Image.memory(
                    base64Decode(gambarKtp.contains(',')
                        ? gambarKtp.split(',').last
                        : gambarKtp),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Invalid image data'));
                    },
                  )
                : _gambarKtp != null
                    ? Image.file(_gambarKtp!, fit: BoxFit.cover)
                    : const Center(child: Text('Tap to upload image')),
          ),
        ),
      ],
    );
  }

  Widget buildDropdown({
    required String label,
    required List<String> options,
    required String? selectedValue,
    required void Function(String?) onChanged,
    bool showSearchBox = false, // <-- New parameter, default is true
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownSearch<String>(
        selectedItem: selectedValue,
        items: options,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        onChanged: onChanged,
        popupProps: PopupProps.menu(
          showSearchBox: showSearchBox, // <-- Control search on/off here
          searchFieldProps: const TextFieldProps(
            decoration: InputDecoration(
              labelText: 'Cari...', // Search field placeholder
              border: OutlineInputBorder(),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (accountNameController.text != '')
                  _buildTextFieldDisabled(
                      'Account Name ', accountNameController, context),
                _buildTextField('NIK', nikController, context),
                _buildTextField('Nama', namaController, context),
                _buildTextField('Tempat Lahir', tempatLahirController, context),
                _buildTextField(
                    'Tanggal Lahir', tanggalLahirController, context),
                buildDropdown(
                  label: 'Jenis Kelamin',
                  options: optionsJenisKelamin,
                  selectedValue: _selectedJenisKelamin,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedJenisKelamin = newValue;
                    });
                  },
                ),
                buildDropdown(
                  label: 'Golongan Darah',
                  options: optionsGolonganDarah,
                  selectedValue: _selectedGolonganDarah,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGolonganDarah = newValue;
                    });
                  },
                ),
                _buildTextField('Alamat', alamatController, context),
                _buildTextField('RT', rtController, context),
                _buildTextField('RW', rwController, context),
                _buildDropdownField(
                    'Provinsi', selectedProvinsi, provinsiOptions, (value) {
                  setState(() {
                    selectedProvinsi = value;
                    _fetchKabupaten(value?.id ?? '0');
                  });
                }),
                _buildDropdownField(
                    'Kabupaten/Kota', selectedKabupaten, kabupatenOptions,
                    (value) {
                  setState(() {
                    selectedKabupaten = value;
                    _fetchKecamatan(value?.id ?? '0');
                  });
                }),
                _buildDropdownField(
                    'Kecamatan', selectedKecamatan, kecamatanOptions, (value) {
                  setState(() {
                    selectedKecamatan = value;
                    _fetchKelurahan(value?.id ?? '0');
                  });
                }),
                _buildDropdownField(
                    'Kel/Desa', selectedKelurahan, kelurahanOptions, (value) {
                  setState(() {
                    selectedKelurahan = value;
                  });
                }),
                buildDropdown(
                  label: 'Agama',
                  options: optionsAgama,
                  selectedValue: _selectedAgama,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAgama = newValue;
                    });
                  },
                ),
                buildDropdown(
                  label: 'Status Perkawinan',
                  options: optionsStatusKawin,
                  selectedValue: _selectedstatusPerkawinan,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedstatusPerkawinan = newValue;
                    });
                  },
                ),
                buildDropdown(
                  label: 'Pekerjaan',
                  options: optionsPekerjaan,
                  selectedValue: _selectedPekerjaan,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPekerjaan = newValue;
                    });
                  },
                  showSearchBox: true,
                ),
                buildDropdown(
                  label: 'Kewarganegaraan',
                  options: optionsKewarganegaraan,
                  selectedValue: _selectedKewarganegaraan,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedKewarganegaraan = newValue;
                    });
                  },
                ),
                // _buildTextField(
                //     'Berlaku Hingga', berlakuHinggaController, context),
                _buildDropdownField('Bank', selectedKodeBank, kodeBankOptions,
                    (value) {
                  setState(() {
                    selectedKodeBank = value;
                  });
                }),
                _buildTextField('No Rekening', noRekeningController, context),
                const SizedBox(height: 20),
                _buildImagePicker(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
