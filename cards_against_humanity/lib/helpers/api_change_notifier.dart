import 'package:cards_against_humanity/exceptions/connection_exception.dart';
import 'package:cards_against_humanity/helpers/http_helper.dart';
import 'package:cards_against_humanity/models/white_card.dart';
import 'package:flutter/widgets.dart';

enum NotifierState { initial, loading, loaded }

class ApiChangeNotifier extends ChangeNotifier {
  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  Object? _post;
  Object? get post => _post;
  void _setPost(Object post) {
    _post = post;
    notifyListeners();
  }

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  void enterLobby(String lobbyId, String playerId, String nickname) async {
    _setState(NotifierState.loading);
    try {
      final post = await API.enterLobby(lobbyId, playerId, nickname);
      _setPost(post);
    } on Failure catch (f) {
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }

  void createLobby(String playerId, String nickname, int roundDuration,
      int maxRoundNumber) async {
    _setState(NotifierState.loading);
    try {
      final post = await API.createLobby(
          playerId, nickname, roundDuration, maxRoundNumber);
      _setPost(post);
    } on Failure catch (f) {
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }

  void setPlayerReady(String lobbyId, String playerId) async {
    _setState(NotifierState.loading);
    try {
      final post = await API.setPlayerReady(lobbyId, playerId);
      _setPost(post);
    } on Failure catch (f) {
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }

  void playCard(
      String lobbyId, String playerId, List<WhiteCard> cardList) async {
    _setState(NotifierState.loading);
    try {
      final cardIds = cardList.map((c) => c.id).toList();
      final post = await API.playCard(lobbyId, playerId, cardIds);
      _setPost(post);
    } on Failure catch (f) {
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }

  void voteWinner(String lobbyId, String playerId, votedPlayerId) async {
    _setState(NotifierState.loading);
    try {
      final post = await API.voteWinner(lobbyId, playerId, votedPlayerId);
      _setPost(post);
    } on Failure catch (f) {
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }

  void reset() {
    _post = null;
    _failure = null;
    _setState(NotifierState.initial);
  }
}
