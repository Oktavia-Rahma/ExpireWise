import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  Map<String, dynamic> _deviceData = {};

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    Map<String, dynamic> data = {};

    try {
      if (kIsWeb) {
        final info = await plugin.webBrowserInfo;
        data = {
          "Model": info.userAgent ?? "Unknown",
          "Brand": info.vendor ?? "Unknown",
          "Versi": describeEnum(info.browserName),
        };
      } else if (Platform.isAndroid) {
        final info = await plugin.androidInfo;
        data = {
          "Model": info.model ?? "Unknown",
          "Brand": info.brand ?? "Unknown",
          "Versi": "Android ${info.version.release}",
        };
      } else if (Platform.isIOS) {
        final info = await plugin.iosInfo;
        data = {
          "Model": info.utsname.machine ?? "Unknown",
          "Brand": "Apple",
          "Versi": "iOS ${info.systemVersion}",
        };
      } else if (Platform.isWindows) {
        final info = await plugin.windowsInfo;
        data = {
          "Model": info.computerName,
          "Brand": "Windows",
          "Versi": "${info.majorVersion}.${info.minorVersion}",
        };
      } else if (Platform.isMacOS) {
        final info = await plugin.macOsInfo;
        data = {
          "Model": info.model ?? "Mac",
          "Brand": "Apple",
          "Versi": info.osRelease ?? "Unknown",
        };
      } else {
        data = {"Info": "Perangkat tidak dikenali"};
      }
    } catch (e) {
      data = {"Error": e.toString()};
    }

    if (mounted) setState(() => _deviceData = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text('Informasi Perangkat'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _deviceData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "📱 Detail Perangkat",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: _deviceData.entries.map((e) {
                        return Card(
                          color: Colors.white,
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.devices_other,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              e.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(e.value.toString()),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
