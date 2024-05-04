import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class CoffeeItem {
  final String name;
  final double price;

  CoffeeItem({required this.name, required this.price});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CoffeeMenu(),
    );
  }
}

class CoffeeMenu extends StatefulWidget {
  @override
  _CoffeeMenuState createState() => _CoffeeMenuState();
}

class _CoffeeMenuState extends State<CoffeeMenu> {
  List<CoffeeItem> _menuItems = [
    CoffeeItem(name: 'Espresso', price: 2.5),
    CoffeeItem(name: 'Latte', price: 3.5),
    CoffeeItem(name: 'Cappuccino', price: 3.0),
    CoffeeItem(name: 'Mocha', price: 4.0),
  ];

  Map<CoffeeItem, int> _cartItems = {};

  double _totalPrice = 0.0;

  void _addToCart(CoffeeItem item) {
    setState(() {
      if (_cartItems.containsKey(item)) {
        _cartItems[item] = _cartItems[item]! + 1;
      } else {
        _cartItems[item] = 1;
      }
      _totalPrice += item.price;
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _totalPrice = 0.0;
    });
  }

  void _navigateToOrderSummary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummary(
          cartItems: _cartItems,
          totalPrice: _totalPrice,
          onOrderSubmitted: () => _clearCart(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 6),
        child: Container(
          color: Colors.blue, // Set background color to blue
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Text(
              'Coffee Shop',
              style: TextStyle(
                color: Colors.white, // Set text color to white
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _addToCart(item),
                          ),
                        ],
                      ),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total: \$${_totalPrice.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _clearCart(),
                  child: Text('Clear Cart'),
                ),
                ElevatedButton(
                  onPressed: () => _navigateToOrderSummary(context),
                  child: Text('View Order'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Exit the app
                SystemNavigator.pop();
              },
              child: Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final Map<CoffeeItem, int> cartItems;
  final double totalPrice;
  final VoidCallback onOrderSubmitted;

  OrderSummary({
    required this.cartItems,
    required this.totalPrice,
    required this.onOrderSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: cartItems.entries
                    .map((entry) => ListTile(
                  title: Text('${entry.value} ${entry.key.name}'),
                  subtitle: Text('\$${(entry.key.price * entry.value).toStringAsFixed(2)}'),
                ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  onOrderSubmitted();
                  Navigator.pop(context);
                },
                child: Text('Submit Order'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back to Menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
