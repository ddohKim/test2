class TimeCalculator {
  String getTimeDiff(DateTime createdDate) {
    DateTime now = DateTime.now();
    Duration timeDiff = now.difference(
        createdDate); //미래 먼저 쓰고 과거를 쓰면 몇일 전일인지 나옴

    if (timeDiff.inMinutes <= 60) {
      return '${timeDiff.inMinutes}분 전';
    }
    else if (timeDiff.inHours <= 24) {
      return '${timeDiff.inHours}시간 전';
    }
    else {
      return '${timeDiff.inDays}일 전';
    }
  }
}