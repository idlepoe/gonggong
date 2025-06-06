class BetCardStats {
  final int totalUp;
  final int totalDown;

  BetCardStats({required this.totalUp, required this.totalDown});

  int get total => totalUp + totalDown;

  double get upRate => total == 0 ? 0.5 : totalUp / total;
  double get downRate => total == 0 ? 0.5 : totalDown / total;

  double get upOdds => _calcOdds(totalUp, totalDown, 'up');
  double get downOdds => _calcOdds(totalUp, totalDown, 'down');

  static double _calcOdds(int up, int down, String direction) {
    final total = up + down;
    final selected = direction == 'up' ? up : down;
    return total == 0 || selected == 0 ? 2.0 : (total / selected).clamp(1.1, 10.0);
  }
}
