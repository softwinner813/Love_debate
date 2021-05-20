import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/cupertino.dart';



class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child){
            return Stack(
              children: [
                Scaffold(
                  appBar: CustomAppBar(title: "Profile"),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _setProfilePic(viewModel),
                      _userName(viewModel),
                      SizedBox(height: 16,),
                      Divider(thickness: 1),
                      Expanded(
                        child: ListView(
                          children: viewModel.profileItems.map((profileItem) => profileItemUI(viewModel, profileItem)).toList(),
                        ),
                      )
                    ],
                  )
                ),
                viewModel.viewState == ViewState.Busy ? Positioned.fill(child: Loading()) : Container(),
                viewModel.isUploading ? Container(
                  color: Colors.black45,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.firstColor),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      Text("Uploading File: ${viewModel.uploadingProgress}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white,))
                    ],
                  ),
                ) : Container()
              ],
            );
          }
      ),
    );
  }

  Widget _setProfilePic(ProfileViewModel viewModel) {
    var userPic = viewModel.userDetail != null ? viewModel.userDetail.profilePic : null;
    return imageWithActionButton(userPic, viewModel);
  }

  Widget _userName(ProfileViewModel viewModel) {
    var userName = viewModel.userDetail != null ? viewModel.userDetail.firstName + " " + viewModel.userDetail.lastName : "";
    return Text(userName, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),);
  }

  double actionWidgetSize = 120;
  double plusIconSize = 25;
  double profileImageSize = 110;

  Widget imageWithActionButton(String imageUrl, ProfileViewModel viewModel) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        width: actionWidgetSize,
        height: actionWidgetSize,
        child: Stack(children: [_setProfilePicture(imageUrl), _setPlusIcon(viewModel)]));
  }

  Widget _setPlusIcon(ProfileViewModel viewModel) {
    return Positioned(
      bottom: 20,
      left: (actionWidgetSize - plusIconSize - 5),
      child: InkWell(
        onTap: () {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return GalleryDialogBoxView();
              }).then((value) {
            print("Value is: $value");
            if (value != null) {
              switch (value) {
                case "gallery":
                  openGallery(viewModel);
                  break;
                case "camera":
                  openCamera(viewModel);
                  break;
              }
              // viewModel.setImageFile = value;
            }
          });
        },
        child: Container(
            width: plusIconSize, // PlusIconSize = 20.0;
            height: plusIconSize, // PlusIconSize = 20.0;
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 43, 84),
                borderRadius: BorderRadius.circular(12.5)),
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 15.0,
            )),
      ),
    );
  }

  Widget _setProfilePicture(String imageName) {
    return Positioned(
        left: (actionWidgetSize / 2) - (profileImageSize / 2),
        child: Container(
          padding:
              EdgeInsets.all(1.0), // Add 1.0 point padding to create border
          height: profileImageSize, // ProfileImageSize = 50.0;
          width: profileImageSize, // ProfileImageSize = 50.0;
          decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(profileImageSize / 2),
              border: Border.all(color: AppColors.firstColor, width: 4),
          ),
          child: (imageName != null && imageName != 'null') ? ClipOval(
            child: Image.network(
                "https://lovedebate.co/public/assets/images/profile/thumb_$imageName",
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                }),
          ) : Image.asset('images/dummy.png'),
        )
    );
  }

  //TODO: Image Picker and Cropper

  openCamera(ProfileViewModel viewModel) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path), viewModel);
    }
  }

  openGallery(ProfileViewModel viewModel) async {
    final pickedFile =
    await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path), viewModel);
    }
  }


  Future<Null> _cropImage(File imageFile, ProfileViewModel viewModel) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        // aspectRatioPresets: Platform.isAndroid
        //     ? [
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square
        //       ]
        //     : [
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.square
        //       ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            // toolbarColor: Colors.deepOrange,
            // toolbarWidgetColor: Colors.white,
            // initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
          // aspectRatioLockEnabled: true
        ));
    if (croppedFile != null) {
      viewModel.setImageFile = croppedFile;
    }
  }
}

Widget profileItemUI(ProfileViewModel viewModel, ProfileItem profile) {
  return Column(
    children: <Widget>[
      InkWell(
        onTap: () => profile.suffixIcon == Icons.verified  ? null : viewModel.goTo(profile),
        child: Container(
          margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          child: Row(
            children: <Widget>[
              Icon(profile.prefixIcon, color: AppColors.firstColor, size: 20),
              SizedBox(width: 12,),
              Expanded(child: Text(profile.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))),
              SizedBox(width: 8,),
              profile.suffixIcon != null ? Icon(profile.suffixIcon,size: 20,color: profile.suffixIcon == Icons.verified ? Colors.green : Colors.grey,) : Container(),
            ],
          ),
        ),
      ),
      Divider(thickness: 1)
    ],
  );
}
