import 'package:flutter/material.dart';

class LoginOther extends StatelessWidget{
  const LoginOther({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  color: Colors.white60,
                  thickness: 1,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'Hoặc tiếp tục với',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              Expanded(
                child: Divider(
                  color: Colors.white60,
                  thickness: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff18181b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(width: 1, color: Colors.white),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30)
                ),

                icon: Image.asset(
                  'assets/icons/google.png',
                  width: 25,
                  height: 25,
                ),

                label: Text(
                  'Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                ),
              ),

              SizedBox(width: 40,),

              ElevatedButton.icon(
                onPressed: () {}, 

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff18181b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(width: 1, color: Colors.white)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                ),

                icon: Image.asset(
                  'assets/icons/facebook.png',
                  width: 25,
                  height: 25,
                ),

                label: Text(
                  'Facebook',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chưa có tài khoản?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              SizedBox(width: 10,),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: Text(
                    'Đăng ký ngay',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xfff6339a),
                    ),
                  ),
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}