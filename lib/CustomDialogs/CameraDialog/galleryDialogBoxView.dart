import 'package:app_push_notifications/Helpers/importFiles.dart';

class GalleryDialogBoxView extends StatefulWidget {
  @override
  _GalleryDialogBoxViewState createState() => _GalleryDialogBoxViewState();
}

class _GalleryDialogBoxViewState extends State<GalleryDialogBoxView> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Select An Action",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: (){
                      Navigator.pop(context,"camera");
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.camera_alt,size: 35,color: AppColors.firstColor),
                      SizedBox(height: 8,),
                      Text("Take Photo",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),)
                    ],
                  ),
                ),



                InkWell(
                  onTap: (){
                    Navigator.pop(context,"gallery");
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.camera,size: 35,color: AppColors.firstColor),
                      SizedBox(height: 8,),
                      Text("Open Gallery",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),)
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

}
