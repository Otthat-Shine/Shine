// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:shine/common/dialogs.dart';
import 'package:shine/common/file_picker_wrapper.dart';
import 'package:shine/widgets/forms.dart';

class CreateConcertForm {
  final formKey = GlobalKey<FormState>();
  final TextEditingController txFiles = TextEditingController();
  final TextEditingController txDest = TextEditingController();

  String _name = '';
  String _password = '';
  List<String> _files = [];
  String _dest = '';

  get name => _name;

  get password => _password;

  get files => _files;

  get dest => _dest;

  Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ui(context),
        );
      },
    );
  }

  Widget ui(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            primary: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter the name', labelText: 'Name'),
                  onSaved: (v) => _name = v!.trim(),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Please enter the name' : null,
                  autovalidateMode: AutovalidateMode.always,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter the password', labelText: 'Password'),
                  onSaved: (v) => _password = v!.trim(),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Please enter the password'
                      : null,
                  autovalidateMode: AutovalidateMode.always,
                  obscureText: true,
                ),
                TextWithButtonFormField<List<String>>(
                  buttonText: 'Choose',
                  decoration: const InputDecoration(
                      hintText: 'files', labelText: 'Files'),
                  onPressed: (state) async {
                    List<String>? selectedFiles =
                        await FilePickerWrapper.pickFiles(
                      context: context,
                      title: 'Select the files to make concert file',
                    );
                    if (selectedFiles == null) return;
                    txFiles.text = selectedFiles.join(';');
                    state.didChange(selectedFiles);
                  },
                  onSaved: (v) => _files = v!,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Please select files' : null,
                  txController: txFiles,
                  autovalidateMode: AutovalidateMode.always,
                  readOnly: true,
                ),
                TextWithButtonFormField<String>(
                  buttonText: 'Choose',
                  decoration: const InputDecoration(
                      hintText: 'destination', labelText: 'Destination'),
                  onPressed: (state) async {
                    if (!context.mounted) return;
                    String? selectedPath =
                        await FilePickerWrapper.getDirectoryPath(
                      title: 'Select a location to save the concert file',
                    );
                    if (selectedPath == null) return;
                    txDest.text = selectedPath;
                    state.didChange(selectedPath);
                  },
                  onSaved: (v) => _dest = v!,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Please select a location'
                      : null,
                  txController: txDest,
                  autovalidateMode: AutovalidateMode.always,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Get.back();
                        } else {
                          Dialogs.error('Please check the input');
                        }
                      },
                      child: const Text('Create'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    return formKey.currentState!.validate();
  }
}

class ExtractConcertForm {
  final formKey = GlobalKey<FormState>();
  final TextEditingController txConcertFile = TextEditingController();
  final TextEditingController txDest = TextEditingController();

  String _concertFile = '';
  String _password = '';
  String _dest = '';

  get concertFile => _concertFile;

  get password => _password;

  get dest => _dest;

  Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ui(context),
        );
      },
    );
  }

  Widget ui(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            primary: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWithButtonFormField<String>(
                  buttonText: 'Choose',
                  decoration: const InputDecoration(
                      hintText: 'concert file', labelText: 'Concert File'),
                  onPressed: (state) async {
                    String? selectedFile =
                        await FilePickerWrapper.pickSignalFile(
                      context: context,
                      title: 'Please select a concert file',
                    );
                    if (selectedFile == null) return;
                    txConcertFile.text = selectedFile;
                    state.didChange(selectedFile);
                  },
                  onSaved: (v) => _concertFile = v!,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Please select a concert file'
                      : null,
                  txController: txConcertFile,
                  autovalidateMode: AutovalidateMode.always,
                  readOnly: true,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter the password', labelText: 'Password'),
                  onSaved: (v) => _password = v!.trim(),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Please enter the password'
                      : null,
                  autovalidateMode: AutovalidateMode.always,
                  obscureText: true,
                ),
                TextWithButtonFormField<String>(
                  buttonText: 'Choose',
                  decoration: const InputDecoration(
                      hintText: 'destination', labelText: 'Destination'),
                  onPressed: (state) async {
                    if (!context.mounted) return;
                    String? selectedPath =
                        await FilePickerWrapper.getDirectoryPath(
                      title: 'Select a location to extract the concert file',
                    );
                    if (selectedPath == null) return;
                    txDest.text = selectedPath;
                    state.didChange(selectedPath);
                  },
                  onSaved: (v) => _dest = v!,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Please select a location'
                      : null,
                  txController: txDest,
                  autovalidateMode: AutovalidateMode.always,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Get.back();
                        } else {
                          Dialogs.error('Please check the input');
                        }
                      },
                      child: const Text('Extract'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    return formKey.currentState!.validate();
  }
}
