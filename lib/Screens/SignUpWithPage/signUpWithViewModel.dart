import 'package:app_push_notifications/Helpers/importFiles.dart';
// import 'package:app_push_notifications/Utils/GlobalModels.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class SignUpWithViewModel with ChangeNotifier implements LoaderState{

  SessionManager session = SessionManager();
  final _firebaseAuth = FirebaseAuth.instance;
  NavigationService _navigationService = NavigationService();

  //=======================================================================
  //================= LoaderState Abstract Implement ======================
  //=======================================================================

  @override
  ViewState _state;

  @override
  // TODO: implement viewState
  ViewState get viewState => _state;

  @override
  void setSate(ViewState state) {
    // TODO: implement setSate
    _state = state;
    notifyListeners();
  }

  SignUpWithViewModel(){
    setSate(ViewState.Idle);
  }


  appleLogIn() async{
      final AuthorizationResult result = await
      AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.user);
          //All the required credentials

          final AppleIdCredential _auth = result.credential;
          final OAuthProvider oAuthProvider = new OAuthProvider(providerId: "apple.com");

          final AuthCredential credential = oAuthProvider.getCredential(
            idToken: String.fromCharCodes(_auth.identityToken),
            accessToken: String.fromCharCodes(_auth.authorizationCode),
          );

          await _firebaseAuth.signInWithCredential(credential);

          // update the user information
          if (_auth.fullName != null) {
            _firebaseAuth.currentUser().then( (value) async {
              UserUpdateInfo user = UserUpdateInfo();
              print("Email: ${_auth.email}");
              print("User: ${_auth.user}");
              print('${_auth.fullName.givenName}');
              print('${_auth.fullName.familyName}');
              Map<String, dynamic> body;
              if (_auth.email ==null){
                body = {
                  'APPLE_SID' : _auth.user.toString(),
                  'first_name' : _auth.fullName.givenName.toString(),
                  'last_name' : _auth.fullName.familyName.toString(),
                };
              }else{
                body = {
                  'APPLE_SID' : _auth.user.toString(),
                  'first_name' : _auth.fullName.givenName.toString(),
                  'last_name' : _auth.fullName.familyName.toString(),
                  'email' : _auth.email.toString(),
                };
              }
              await value.updateProfile(user);
              socialSignUp(body);
            });
          }

        break;
        case AuthorizationStatus.error:
          showToast("Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          showToast('User cancelled');
//          print('User cancelled');
          break;
      }
  }

  ///Google SignUp
  signUpWithGoogle() async {
    try {
      final GoogleSignIn _googleSignUp = GoogleSignIn(
          scopes: <String>[
            'email',
            "https://www.googleapis.com/auth/userinfo.email",
            "https://www.googleapis.com/auth/userinfo.profile",
          ]);

      GoogleSignInAccount data = await _googleSignUp.signIn() ?? null;

      if (data != null) {
        Map<String, dynamic> body = {
          'GOOGLE_SID' :data.id ,
          'first_name' : data.displayName.split(" ")[0],
          'last_name' : data.displayName.split(" ")[1],
          'email' : data.email,
        };
        socialSignUp(body);
      }else{
        _googleSignUp.signOut();
      }
    } catch (error) {
      showToast(error.toString());
    }
  }


  signUpWithFaceBook() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
    final _result = await facebookLogin.logIn(['email','public_profile']);
    final token = _result.accessToken.token;
    if (token == null){
      facebookLogin.logOut();
    }else{
      setSate(ViewState.Busy);
      final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
      final profile = jsonDecode(graphResponse.body);
      setSate(ViewState.Idle);
      if (profile['error'] != null){
        showToast(profile['error']['message']);
      }else{
        switch (_result.status) {
          case FacebookLoginStatus.loggedIn:
            Map<String, dynamic> body;
            if (profile['email'] == null){
              body = {
                'FB_SID' : profile['id'].toString(),
                'first_name' : profile['first_name'].toString(),
                'last_name' : profile['last_name'].toString(),
              };
            }else{
              body = {
                'FB_SID' : profile['id'].toString(),
                'first_name' : profile['first_name'].toString(),
                'last_name' : profile['last_name'].toString(),
                'email' : profile['email'].toString(),
              };
            }
            socialSignUp(body);
            break;
          case FacebookLoginStatus.cancelledByUser:
            showToast('Login cancelled by the user.');
            break;
          case FacebookLoginStatus.error:
            showToast("Something went wrong with the login process.\nHeres the error Facebook gave us: ${_result.errorMessage}");
            break;
        }
      }
    }
  }

  ///ApiCall Social Login/SignUp.
  socialSignUp(Map<String, dynamic> body){
      setSate(ViewState.Busy);
      ApiBaseHelper().post(authorization: false, url: WebService.login,body: body,isFormData: false).then(
              (responseJSON) async {
                setSate(ViewState.Idle);
                Map<String, dynamic> parsedJSON = json.decode(responseJSON);
                if(parsedJSON.containsKey('success')) {
                  var parseObject = SignInModel.fromJson(parsedJSON['success']);
                  await session.saveAuthenticationToken(authToken: parseObject.token);
                  if(parseObject.alreadLogin == false){
                    goToSignUpWithPersonalInfo(arguments: {'isSocialLogin' : true, 'user' : parseObject.user});
                  }else{
                    await session.saveUserInfo(user: parseObject.user);
                    if(parseObject.user.onboadingStatus == 0){
                      goToOnBoardingPage();
                    }else{
                      goToTabBarControllerPage();
                    }
                  }
                } else{
                  showToast('Something went wrong');
                }
          }, onError: (error){
          showToast('Something went wrong');
      });
  }

  goToTabBarControllerPage(){
    _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '2'});
  }

  goToOnBoardingPage(){
    _navigationService.navigateWithPush(UserPreferencesViewRoute);
  }

  goToSignUpWithPersonalInfo({Map<String, dynamic> arguments}) {
    _navigationService.navigateWithPush(SignUpWithPersonalInfoRoute, arguments: arguments);
  }
}