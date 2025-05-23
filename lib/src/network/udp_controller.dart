import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:minecraft_controller/src/enums/action_enum.dart';
import 'package:minecraft_controller/src/enums/keys_enum.dart';
import 'package:minecraft_controller/src/utils/logger_utils.dart';
import 'package:udp/udp.dart';

class UdpController {
  UDP? _udpSender;
  String? _serverAddress;
  final int _serverPort = 65432;
  bool _isSocketReady = false;

  bool get isSocketReady => _isSocketReady;

  String? get serverAddress => _serverAddress;
  final _code = 'musaddiq625';

  Future<void> init({required String serverAddress}) async {
    LoggerUtils.logs('Server Address: $serverAddress');
    _serverAddress = serverAddress;

    LoggerUtils.logs('Initializing Socket...');
    if (await _initSender()) _isSocketReady = await _pingServer();
    if (_isSocketReady) LoggerUtils.logs('Socket initialized!');
  }

  Future<void> dispose() async {
    _udpSender?.close();
  }

  Future<bool> _initSender() async {
    try {
      _udpSender = await UDP.bind(Endpoint.any());
      LoggerUtils.logs(
          "UDP sender ready on ${_udpSender!.socket!.address.address}:${_udpSender!.socket!.port}");
      return true;
    } catch (e) {
      LoggerUtils.logs("Error initializing UDP sender: $e");
      return false;
    }
  }

  /// Pings a UDP server at [serverIp] and [serverPort].
  Future<bool> _pingServer() async {
    if (_serverAddress == null) {
      LoggerUtils.logs("Server address not set, cannot ping.");
      return false;
    }

    var endpoint = Endpoint.unicast(
      InternetAddress(_serverAddress!),
      port: Port(_serverPort),
    );

    String pingMsg = jsonEncode({"ping": _code});
    List<int> data = utf8.encode(pingMsg);

    await _udpSender!.send(data, endpoint);
    LoggerUtils.logs("Sent ping: $pingMsg to $_serverAddress:$_serverPort");

    Completer<bool> completer = Completer<bool>();

    _udpSender!.asStream().listen((Datagram? datagram) {
      if (datagram != null) {
        String response = utf8.decode(datagram.data);
        LoggerUtils.logs("Received response: $response");
        if (jsonDecode(response)['pong'] == 'musaddiq625') {
          LoggerUtils.logs(
              "Received pong response from $_serverAddress:$_serverPort");
          completer.complete(true);
        }
      }
    });

    return await completer.future.timeout(
      Duration(seconds: 3),
      onTimeout: () => false,
    );
  }

  void sendAction(
    KeysEnum key, {
    double? x,
    double? y,
    bool isSinglePress = false,
    bool isLongPress = false,
  }) async {
    if (!_isSocketReady || _udpSender == null || _serverAddress == null) {
      LoggerUtils.logs("UDP sender not ready or server address is null!");
      return;
    }
    try {
      Map<String, dynamic> messageMap = {};
      late ActionEnum action;
      if (isSinglePress) {
        action = ActionEnum.press;
      } else if (isLongPress) {
        action = ActionEnum.start;
      } else {
        action = ActionEnum.stop;
      }

      switch (key) {
        case KeysEnum.left:
        case KeysEnum.right:
        case KeysEnum.up:
        case KeysEnum.down:
        case KeysEnum.jump:
        case KeysEnum.attack:
        case KeysEnum.sneak:
        case KeysEnum.use:
        case KeysEnum.inventory:
        case KeysEnum.pause:
          messageMap[key.name] = action.name;
        case KeysEnum.hotBar1:
        case KeysEnum.hotBar2:
        case KeysEnum.hotBar3:
        case KeysEnum.hotBar4:
        case KeysEnum.hotBar5:
        case KeysEnum.hotBar6:
        case KeysEnum.hotBar7:
        case KeysEnum.hotBar8:
        case KeysEnum.hotBar9:
          messageMap[key.name] = ActionEnum.press.name;
        default:
          break;
      }

      if (x != null && y != null) {
        messageMap["mouse"] = {'x': x, 'y': y};
      }

      if (messageMap.isEmpty) {
        LoggerUtils.logs("Empty message, not sending anything.");
        return;
      }

      String message = jsonEncode(messageMap);
      List<int> data = utf8.encode(message);
      var endpoint = Endpoint.unicast(
        InternetAddress(_serverAddress!),
        port: Port(_serverPort),
      );

      LoggerUtils.logs(
          "Sending message: $message to $_serverAddress:$_serverPort");
      _udpSender!.send(data, endpoint);
      LoggerUtils.logs("Message sent successfully!");
    } catch (e) {
      LoggerUtils.logs("Error sending UDP message: $e");
    }
  }
}
