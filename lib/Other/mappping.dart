import 'package:flutter/material.dart';
import 'package:stories_of_heroes/Authentication/registration.dart';
import 'package:stories_of_heroes/Heroes/homepage.dart';
import 'package:stories_of_heroes/Authentication/authentication.dart';

class Mapping extends StatefulWidget
{
  final AuthImplementation auth;

  Mapping
  ({
    this.auth,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Mapping();
  }
}

enum AuthStatus
{
  notSignedIn,
  signedIn,
}


class _Mapping extends State<Mapping>
{
  AuthStatus authStatus = AuthStatus.notSignedIn;

   void initState()
    {
      super.initState();
      widget.auth.getCurrentUser().then((firebaseUserId)
      {
        setState(()
        {
          authStatus = firebaseUserId ==null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        });

      });
    }

    void _signedIn()
    {
      setState(()
      {
        authStatus = AuthStatus.signedIn;
      });
    }

  void _signedOut()
  {
    setState(()
    {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    switch(authStatus)
    {
        case AuthStatus.notSignedIn:
        return Registration
          (
          auth: widget.auth,
          onSignedIn: _signedIn,
          );


        case AuthStatus.signedIn:
        return Home
          (
            auth:widget.auth,
            onSignedOut: _signedOut,
        );
    }

    return null;
  }

}