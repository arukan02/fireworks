import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MusicUpload extends StatelessWidget {
  const MusicUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('音楽アップロード'),
      ),
      body: Container(
             child:MusicUploadSF(),
      )


    );
  }
}
class MusicUploadSF extends StatefulWidget {
  @override
  _MusicUploadState createState() => _MusicUploadState();
}

class _MusicUploadState extends State<MusicUploadSF> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _clearCachedFiles() async {
    _resetState();
    try {
      bool? result = await FilePicker.platform.clearTemporaryFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }


  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        key: _scaffoldKey,

        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: DropdownButton<FileType>(
                        hint: const Text('LOAD PATH FROM'),
                        value: _pickingType,
                        items: FileType.values
                            .map((fileType) => DropdownMenuItem<FileType>(
                          child: Text(fileType.toString()),
                          value: fileType,
                        ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _pickingType = value!;
                          if (_pickingType != FileType.custom) {
                            _controller.text = _extension = '';
                          }
                        })),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 100.0),
                    child: _pickingType == FileType.custom
                        ? TextFormField(
                      maxLength: 15,
                      autovalidateMode: AutovalidateMode.always,
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'File extension',
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                    )
                        : const SizedBox(),
                  ),
                 /* ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 200.0),
                    child: SwitchListTile.adaptive(
                      title: Text(
                        'Pick multiple files',
                        textAlign: TextAlign.right,
                      ),
                      onChanged: (bool value) =>
                          setState(() => _multiPick = value),
                      value: _multiPick,
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => _pickFiles(),
                          child: Text('ファイルを選択'),
                        ),
                        SizedBox(height: 10),
                        /*ElevatedButton(
                          onPressed: () => _selectFolder(),
                          child: const Text('Pick folder'),
                        ),*/
                        SizedBox(height: 10),

                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _clearCachedFiles(),
                          child: const Text('キャンセル'),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) => _isLoading
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const CircularProgressIndicator(),
                    )
                        : _userAborted
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const Text(
                        'User has aborted the dialog',
                      ),
                    )
                        : _directoryPath != null
                        ? ListTile(
                      title: const Text('Directory path'),
                      subtitle: Text(_directoryPath!),
                    )
                        : _paths != null
                        ? Container(
                      padding:
                      const EdgeInsets.only(bottom: 30.0),
                      height:
                      MediaQuery.of(context).size.height *
                          0.50,
                      child: Scrollbar(
                          child: ListView.separated(
                            itemCount: _paths != null &&
                                _paths!.isNotEmpty
                                ? _paths!.length
                                : 1,
                            itemBuilder: (BuildContext context,
                                int index) {
                              final bool isMultiPath =
                                  _paths != null &&
                                      _paths!.isNotEmpty;
                              final String name =
                                      (isMultiPath
                                          ? _paths!
                                          .map((e) => e.name)
                                          .toList()[index]
                                          : _fileName ?? '...');
                              final path = kIsWeb
                                  ? null
                                  : _paths!
                                  .map((e) => e.path)
                                  .toList()[index]
                                  .toString();

                              return Column(
                                  children:[ListTile(
                                                    title: SelectableText(
                                                      name,
                                                    ),
                                                    subtitle: Text(path ?? ''),

                                            ),
                                    upLoadFile(path: path ?? '', name:name)
                              ]);
                            },
                            separatorBuilder:
                                (BuildContext context,
                                int index) =>
                            const Divider(),
                          )),
                    )
                        : _saveAsFileName != null
                        ? ListTile(
                      title: const Text('Save file'),
                      subtitle: Text(_saveAsFileName!),
                    )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class upLoadFile extends StatefulWidget {
  const upLoadFile({ Key? key, required this.name,  required this.path}) : super(key: key);
  final String name;
  final String path;
  @override
  _upLoadFileState createState() => _upLoadFileState();
}

class _upLoadFileState extends State<upLoadFile> {
  double _progress  = 0;
  void initState() {
    super.initState();
    //_upload();
  }
  Future<void> _upload() async {
    File file = File(widget.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      var uploadTask = storage.ref("music/"+widget.name).putFile(file);
      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _progress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      });
      }).onError((error) {
        // do something to handle error
      });}catch (e) {
      print(e);
    }
    print(widget.name);
    print(widget.path);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Column(
                children:[ElevatedButton(
                    child: const Text('アップロード'),
                    onPressed: () => _upload()
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  value: _progress,
                  color: Colors.blue, backgroundColor: Colors.black12
                ),
              ),
          ])
    );
  }
}
/*
class upLoadFile extends StatefulWidget {


  @override
  Future<_upLoadFile> createState()   => _upLoadFile();
}

class _upLoadFile extends State<upLoadFile>{
  void test(name, path) async{
    File file = File(path);
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref("music/"+name).putFile(file);
    } catch (e) {
      print(e);
    }
    print(name);
    print(path);
  }
}
*/