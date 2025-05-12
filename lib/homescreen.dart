import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'db_service/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool Personal = true;
  bool College = false;
  bool Office = false;

  bool suggest = false;

  TextEditingController taskController = TextEditingController();

  Stream ? todoStream ;
  getData()async{
    todoStream = await DataBaseService().getTask(Personal? "personal": College? "college": "office");
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget  getWork(){
    return StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData ?
          Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder:(context,index) {
                DocumentSnapshot docSnap = snapshot.data.docs[index];
                return CheckboxListTile(
                  activeColor: Colors.greenAccent.shade700,
                  title: Text(docSnap['work']),
                  value: docSnap["Yes"],
                  onChanged: (newValue) {
                    setState(() async {
                      Future.delayed(Duration(seconds: 5),()async{
                        await DataBaseService().removeMethod(docSnap['Id'], Personal? "personal": College? "college": "office");
                      });
                      await DataBaseService().tickMethod(docSnap['Id'], Personal? "personal": College? "college": "office");
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
          )
          : Center(child: CircularProgressIndicator());
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBox();
        },
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 70, left: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white38, Colors.white12],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "Hii,",
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            SizedBox(height: 11),
            Container(
              child: Text(
                "Mukesh",
                style: TextStyle(fontSize: 54, color: Colors.black),
              ),
            ),
            SizedBox(height: 11),
            Container(
              child: Text(
                "Let's the work begins",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Personal
                    ? Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Personal",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    : GestureDetector(
                      onTap: () async {
                        setState(() {
                          Personal = true;
                          College = false;
                          Office = false;
                          getData();
                        });
                      },
                      child: Text("Personal", style: TextStyle(fontSize: 20)),
                    ),
                College
                    ? Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "College",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    : GestureDetector(
                      onTap: () async {
                        setState(() {
                          Personal = false;
                          College = true;
                          Office = false;
                          getData();
                        });
                      },
                      child: Text("College", style: TextStyle(fontSize: 20)),
                    ),
                Office
                    ? Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Office",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    : GestureDetector(
                      onTap: () async {
                        setState(() {
                          Personal = false;
                          College = false;
                          Office = true;
                          getData();
                        });
                      },
                      child: Text("Office", style: TextStyle(fontSize: 20)),
                    ),
              ],
            ),
            SizedBox(height: 20),
            getWork(),

          ],
        ),
      ),
    );
  }

 Future openBox() {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SingleChildScrollView(

              child: Container(
                height: 200,
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel),
                        ),
                    SizedBox(width: 16),
                    Text("Add Task",style: TextStyle(
                      color: Colors.blueGrey
                    ),)],),
                    SizedBox(height: 16),
                    Text("Task Name",style: TextStyle(
                      color: Colors.blueGrey
                    ),),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        )
                      ),
                      child: TextField(
                        controller: taskController,
                        decoration: InputDecoration(
                          hintText: "Enter Task",
                          border: InputBorder.none
                        ) )) ,
                  SizedBox(height: 11,),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(11),
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: GestureDetector(
                        onTap: (){
                          String id = randomAlphaNumeric(10);
                          Map<String,dynamic> userTodo = {
                            "work": taskController.text,
                            "Id" : id,
                            "Yes" : false,
                          };
                          Personal ? DataBaseService().addPersonalTask(userTodo, id)
                              : College ? DataBaseService().addCollegeTask(userTodo, id)
                              : DataBaseService().addOfficeTask(userTodo, id);
                          Navigator.pop(context);
                        },
                        child: Text('Add',style: TextStyle(
                          color: Colors.black,
                        ),textAlign: TextAlign.center,),
                      ),
                    ),
                  )
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
