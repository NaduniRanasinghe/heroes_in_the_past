import 'package:flutter/material.dart';
import 'package:stories_of_heroes/Authentication/authentication.dart';
import 'package:stories_of_heroes/Other/dialogs.dart';
import 'package:stories_of_heroes/Other/waiting.dart';

class Registration extends StatefulWidget
{
  Registration
  ({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState()
  {
    // TODO: implement createState
    return _RegistrationState();
  }
}

enum FormType
{
  login,
  register
}
class _RegistrationState extends State<Registration>
{
  DialogBox dialog = new DialogBox();

  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";
  bool waiting = false;

  //functions
  bool validate()
  {
      final form = formKey.currentState;

      if(form.validate())
        {
          form.save();
          return true;
        }
    else
      {
        return false;
      }
  }
  void submit() async
  {
    if(validate())
      {
        try
            {
              if(_formType == FormType.login)
                {
                  String userId = await widget.auth.SignIn(_email, _password);
                  print("Login User Id = " + userId);
                }
                else
                  {
                    String userId = await widget.auth.SignUp(_email, _password);

                    print("Register User Id = " + userId);
                  }
              waiting ? Waiting():
                  widget.onSignedIn();
            }
            catch(e)
              {
                dialog.information(context, "Error = ", e.toString());
                print("Error = " +e.toString());
              }
      }
  }
  void toRegister()
  {

    formKey.currentState.reset();

    setState(()
    {
        _formType = FormType.register;
    });

  }

  void toLogIn()
  {

    formKey.currentState.reset();

    setState(()
    {
      _formType = FormType.login;
    });

  }




  //interface design
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Center(child: Text("Heroes",style: TextStyle(color: Colors.white),)),
      ),
      body: Container
        (
        margin: EdgeInsets.all(15.0),

        child: Form
          (
            key: formKey,

          child: Column
            (
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: inputfields() + inputbuttons(),
            ),
          ),
      ),



    );
  }


  //text input fields
  List<Widget> inputfields()
  {
    return
        [
          SizedBox(height: 40.0,),
          heroLogo(),
          SizedBox(height: 20.0,),


          TextFormField
            (
            decoration: InputDecoration(labelText: 'Email'),
            validator: (val)
            {
              return val.isEmpty ? 'Email is required' : null;
            },
            onSaved: (val)
            {
              return _email = val;

            },
            ),
          TextFormField
            (
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,

                  validator: (val)
                  {
                  return val.isEmpty ? 'Password is required' : null;
                  },
                  onSaved: (val)
                  {
                  return _password = val;

                  },

          ),

          SizedBox(height: 20.0,),
        ];
  }
  Widget heroLogo()
  {

    return Hero
      (
      tag: 'hero',

      child: CircleAvatar(
        radius: 100,
        child: ClipOval(
          child: Image.network(
            'https://pngimage.net/wp-content/uploads/2018/06/h-logo-png-3.png',
          ),
        ),
      ),



//      CircleAvatar
//        (
//        backgroundColor: Colors.transparent,
//        radius: 50.0,
//        child: Icon(Icons.person,)
//      ),
    );
  }

//buttons
  List<Widget> inputbuttons()
  {
  if(_formType== FormType.login)
  {
    return
      [
        RaisedButton
          (
          color: Colors.redAccent,
          child: Text("Login", style: TextStyle(fontSize: 20.0),),
          textColor: Colors.white,


          onPressed: submit,
        ),

        FlatButton
          (
          child: Text("Create account?", style: TextStyle(fontSize: 14.0),),
          textColor: Colors.red,
          onPressed: toRegister,

        ),

      ];
  }
  else
    {
      return
        [
          RaisedButton
            (
            color: Colors.redAccent,
            child: Text("Register", style: TextStyle(fontSize: 20.0),),
            textColor: Colors.white,


            onPressed: submit,
          ),

          FlatButton
            (
            child: Text("Already have an account? Login", style: TextStyle(fontSize: 14.0),),
            textColor: Colors.red,
            onPressed: toLogIn,

          ),

        ];
    }
  }

}