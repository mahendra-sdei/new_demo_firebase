import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_demo_firebase/app_setup/app_router.dart';
import 'package:photo_manager/photo_manager.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<AssetEntity> assets = [];
  File imageFile;
  File img;
  ImagePicker imagePicker;

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );
    setState(() {
      assets = recentAssets;
    });

    imageFile = await assets[0].file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Gallery',
          style: TextStyle(color: Colors.black45),
        ),
        actions: [
          IconButton(
              onPressed: () {
                imageFile == null
                    ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select the picture')))
                    : Navigator.pushNamed(context, AppRouter.POST_AND_DESC, arguments: imageFile);
              },
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.blueAccent,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                child: imageFile==null?Container(): Image.file(
                      imageFile,
                      fit: BoxFit.fill,
                    )
              )),
          Expanded(
            flex: 1,
            child: GridView.builder(
              reverse: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: assets.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                    onTap: () async{
                      imageFile = await assets[index].file;
                      setState(() {});
                    },
                    child: AssetThumbnail(asset: assets[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key key,
    @required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return CircularProgressIndicator();
        // If there's data, display it as an image
        return InkWell(
          // onTap: () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (_) {
          //         if (asset.type == AssetType.image) {
          //           // If this is an image, navigate to ImageScreen
          //           return ImageScreen(imageFile: asset.file);
          //         } else {
          //           // if it's not, navigate to VideoScreen
          //           return VideoScreen(videoFile: asset.file);
          //         }
          //       },
          //     ),
          //   );
          // },
          child: Stack(
            children: [
              // Wrap the image in a Positioned.fill to fill the space
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              // Display a Play icon if the asset is a video
              if (asset.type == AssetType.video)
                Center(
                  child: Container(
                    color: Colors.blue,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    Key key,
    @required this.imageFile,
  }) : super(key: key);

  final Future<File> imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: FutureBuilder<File>(
        future: imageFile,
        builder: (_, snapshot) {
          final file = snapshot.data;
          if (file == null) return Container();
          return Image.file(file);
        },
      ),
    );
  }
}
//
// class VideoScreen extends StatefulWidget {
//   const VideoScreen({
//     Key key,
//     @required this.videoFile,
//   }) : super(key: key);
//
//   final Future<File> videoFile;
//
//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }
//
// class _VideoScreenState extends State<VideoScreen> {
//   VideoPlayerController _controller;
//   bool initialized = false;
//
//   @override
//   void initState() {
//     _initVideo();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   _initVideo() async {
//     final video = await widget.videoFile;
//     _controller = VideoPlayerController.file(video)
//     // Play the video again when it ends
//       ..setLooping(true)
//     // initialize the controller and notify UI when done
//       ..initialize().then((_) => setState(() => initialized = true));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: initialized
//       // If the video is initialized, display it
//           ? Scaffold(
//         body: Center(
//           child: AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             // Use the VideoPlayer widget to display the video.
//             child: VideoPlayer(_controller),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             // Wrap the play or pause in a call to `setState`. This ensures the
//             // correct icon is shown.
//             setState(() {
//               // If the video is playing, pause it.
//               if (_controller.value.isPlaying) {
//                 _controller.pause();
//               } else {
//                 // If the video is paused, play it.
//                 _controller.play();
//               }
//             });
//           },
//           // Display the correct icon depending on the state of the player.
//           child: Icon(
//             _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           ),
//         ),
//       )
//       // If the video is not yet initialized, display a spinner
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }
