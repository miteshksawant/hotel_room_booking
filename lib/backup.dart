import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class Room {
  List<Member> members;

  Room() : members = [];
}

class Member {
  String firstName = '';
  String lastName = '';
  bool isChild = false;
  DateTime? dateOfBirth;

  Member();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Member Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddMemberScreen(),
    );
  }
}

class AddMemberScreen extends StatefulWidget {
  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  List<Room> rooms = [Room()]; // Initial room

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Members to Room'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          for (int i = 0; i < rooms.length; i++) _buildRoomSection(i),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _addRoom,
            child: const Text('Add Room'),
          ),
        ],
      ),
    );
  }


  Widget _buildRoomSection(int roomIndex) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Room ${roomIndex + 1}'),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteRoom(roomIndex),
                ),
              ],
            ),
            SizedBox(height: 8.0,),
            Container(
              color: Colors.grey,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Members'),
                  GestureDetector(
                    onTap: () => _addMember(roomIndex),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade700,
                        border: Border.all(
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            for (int memberIndex = 0; memberIndex < rooms[roomIndex].members.length; memberIndex++)
              _buildMemberSection(roomIndex, memberIndex),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberSection(int roomIndex, int memberIndex) {
    Member member = rooms[roomIndex].members[memberIndex];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Member ${memberIndex + 1}'),
            const SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        member.firstName = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        member.lastName = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Child'),
                Checkbox(
                  value: member.isChild,
                  onChanged: (value) {
                    setState(() {
                      member.isChild = value ?? false;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Date of Birth',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4.0),
                GestureDetector(
                  onTap: () {
                    _selectDate(roomIndex, memberIndex);
                  },
                  child: Text(
                    member.dateOfBirth != null ? member.dateOfBirth!.toString() : 'MM,DD,YYYY',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(int roomIndex, int memberIndex) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: rooms[roomIndex].members[memberIndex].dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != rooms[roomIndex].members[memberIndex].dateOfBirth) {
      // Check if the age is more than 3 years
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - picked.year;

      if (currentDate.month < picked.month ||
          (currentDate.month == picked.month && currentDate.day < picked.day)) {
        age--;
      }

      if (age <= 3) {
        setState(() {
          rooms[roomIndex].members[memberIndex].dateOfBirth = picked;
        });
      } else {
        // Show an alert or take any other appropriate action
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Age'),
              content: Text('The child\'s age should not be more than 3 years.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _addRoom() {
    setState(() {
      rooms.add(Room());
    });
  }

  void _deleteRoom(int roomIndex) {
    setState(() {
      rooms.removeAt(roomIndex);
    });
  }

  void _addMember(int roomIndex) {
    if (rooms[roomIndex].members.length < 3) {
      setState(() {
        rooms[roomIndex].members.add(Member());
      });
    } else {
      // Show an alert or take any other appropriate action
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Member Limit Reached'),
            content: Text('A room can have a maximum of 3 members.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


}
