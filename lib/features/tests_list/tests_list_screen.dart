import 'package:flutter/material.dart';

class TestsListScreen extends StatefulWidget {

  const TestsListScreen({
    super.key
    });

  @override
  State<TestsListScreen> createState() => _TestsListScreenState();
}

class _TestsListScreenState extends State<TestsListScreen> {


  @override
  void dispose() {

    super.dispose();
  }

  void _goToChosenTest() {
    debugPrint("User are going to chosen test");
    Navigator.of(context).pushNamed(
      '/successReg/testList/testDescription',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Список тестов'),
        centerTitle: true,
      ),

      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, i) => ListTile(
          title: Text('Test $i'),
          trailing: const Icon(Icons.keyboard_double_arrow_right),
          onTap: () {
          _goToChosenTest();
          },
        ),

      ),
    );
  }
  
  

        
          //     final coin = state.coinsList[i];
        
          //     return CryptoCoinTile(coin: coin);
          //     },, 
          // padding: const EdgeInsets.only(top: 16),
          //   itemCount: state.coinsList.length,
          //   separatorBuilder: (context, index) => Divider(color: theme.dividerColor),
            
          //   itemBuilder: (context, i) {
        
          //     final coin = state.coinsList[i];
        
          //     return CryptoCoinTile(coin: coin);
          //     },
          //   );
}