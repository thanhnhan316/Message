class Messages {
  // final User sender;
  final String time;
  final String content;
  final bool send;

  Messages(
      {
      // required this.sender,
      required this.time,
      required this.content,
      required this.send});
}

// data Message

List<Messages> messages = [
  Messages(
      time: '5:30 PM',
      content: 'Hey, how\'s it going? What did you do today?',
      send: true),
  Messages(
      time: '4:30 PM',
      content:
          'Just walked my doge. She was super duper cute. The best pupper!!',
      send: true),
  Messages(time: '3:45 PM', content: 'How\'s the doggo?', send: false),
  Messages(time: '3:15 PM', content: 'All the food', send: true),
  Messages(
      time: '2:30 PM',
      content: 'Nice! What kind of food did you eat?',
      send: false),
  Messages(time: '2:00 PM', content: 'I ate so much food today.', send: false),
  Messages(
      time: '5:30 PM',
      content: 'Hey, how\'s it going? What did you do today?',
      send: true),
  Messages(
      time: '4:30 PM',
      content:
          'Just walked my doge. She was super duper cute. The best pupper!!',
      send: true),
  Messages(time: '3:45 PM', content: 'How\'s the doggo?', send: true),
  Messages(time: '3:45 PM', content: 'How\'s the doggo?', send: true),
  Messages(time: '3:15 PM', content: 'All the food', send: false),
  Messages(
      time: '2:30 PM',
      content: 'Nice! What kind of food did you eat?',
      send: false),
  Messages(time: '2:00 PM', content: 'I ate so much food today.', send: true),
];
