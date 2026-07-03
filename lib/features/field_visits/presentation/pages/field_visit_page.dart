import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';

/// EP-009-US008: agronomist logs a field visit — checklist, notes, optional
/// GPS coordinates, and an optional photo (JPEG, base64-encoded — no object
/// storage is configured for this project, see FieldVisit.attachPhoto on the
/// backend for the same tradeoff).
class FieldVisitPage extends StatefulWidget {
  const FieldVisitPage({required this.visitId, super.key});

  final String visitId;

  @override
  State<FieldVisitPage> createState() => _FieldVisitPageState();
}

class _FieldVisitPageState extends State<FieldVisitPage> {
  late final controller = AppDependenciesScope.of(context)
      .createFieldVisitController(visitId: widget.visitId);
  final items = const [
    'Check sensors (battery, signal, calibration)',
    'Assess for the presence of pests / diseases',
    'Take soil/plant tissue samples',
    'Photograph the state of the crop',
    'Check irrigation system / drippers',
    'Record technical notes',
  ];

  bool _locating = false;
  bool _pickingPhoto = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      controller.setLocation(position.latitude, position.longitude);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get current location')),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _pickPhoto() async {
    setState(() => _pickingPhoto = true);
    try {
      final picker = ImagePicker();
      final photo = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1280,
        imageQuality: 70,
      );
      if (photo == null) return;
      final bytes = await File(photo.path).readAsBytes();
      controller.setPhoto(base64Encode(bytes));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not capture photo')),
        );
      }
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(28, 34, 28, 40),
            children: [
              Row(
                children: [
                  Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.chevron_left, size: 30),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text('Field visit',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.latitude != null
                            ? 'GPS: ${controller.latitude!.toStringAsFixed(4)}, '
                                '${controller.longitude!.toStringAsFixed(4)}'
                            : 'No location captured yet',
                      ),
                    ),
                    FilledButton(
                        onPressed: _locating ? null : _useCurrentLocation,
                        style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF80A482)),
                        child: _locating
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('Use current')),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: controller.completed.length / controller.total,
                      color: AppColors.primary,
                      backgroundColor: AppColors.border,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${controller.completed.length}/${controller.total}'),
                ],
              ),
              const SizedBox(height: 28),
              const Text('CHECKLIST',
                  style: TextStyle(
                      color: AppColors.muted, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              for (var i = 0; i < items.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => controller.toggle(i),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(
                              controller.completed.contains(i)
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: AppColors.primary),
                          const SizedBox(width: 14),
                          Expanded(
                              child: Text(items[i],
                                  style: const TextStyle(fontSize: 16))),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              const Text('PHOTO AND NOTES',
                  style: TextStyle(
                      color: AppColors.muted, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickingPhoto ? null : _pickPhoto,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFC7CEC3)),
                    borderRadius: BorderRadius.circular(8),
                    image: controller.photoBase64 != null
                        ? DecorationImage(
                            image: MemoryImage(
                                base64Decode(controller.photoBase64!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: controller.photoBase64 == null
                      ? Center(
                          child: _pickingPhoto
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.camera_alt_outlined, size: 32),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                minLines: 5,
                maxLines: 5,
                onChanged: controller.setNotes,
                decoration: InputDecoration(
                  hintText: 'Technical notes from the visit...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
              const SizedBox(height: 34),
              FilledButton(
                onPressed: () async {
                  await controller.save();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Visit saved')));
                  }
                },
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18)),
                child: Text(controller.saved ? 'Saved' : 'Save this visit'),
              ),
            ],
          );
        },
      ),
    );
  }
}
