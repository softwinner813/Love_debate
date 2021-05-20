import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/cupertino.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SplashViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashViewModel>(
      create: (context) => SplashViewModel(),
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                    height: 250,
                    width: 250,
                    child: Image.asset("images/LoveDebatelogo.png")
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




