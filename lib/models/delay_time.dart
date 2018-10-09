import 'dart:math';

class DelayTime{
  final int hr;
  final int min;
  final int sec;
  final int ms;

  const DelayTime({this.hr = 0, this.min = 0, this.sec = 0, this.ms = 0});

  int getDelay(){
    return ms + sec * 1000 + min * 60 * 1000 + hr * 60 * 60 * 1000; 
  }

  double getDoubleSecond(){
  
    return ((this.sec + (this.ms.toDouble() / 100)) * 10).round() / 10;
  }

  @override
  String toString(){
    String time = "";

    if(hr != 0){
      time += "${hr}h";
    }
    if(min != 0){
      time += "${min}m";
    }

    time += "$sec.${(ms/100).truncate()}";

    return time;
  }

  DelayTime copyWithDouble(double sec, {
    int hr,
    int min,
  }) {
    return DelayTime(
      hr: hr ?? this.hr,
      min: min ?? this.min,
      sec: sec.truncate(),
      ms: ((sec - sec.truncate()) * 100).truncate()
    );
  }

  DelayTime copyWith({
    int hr,
    int min,
    int sec,
    int ms,
  }) {
    return DelayTime(
      hr: hr ?? this.hr,
      min: min ?? this.min,
      sec: sec ?? this.sec,
      ms: ms ?? this.ms,
    );
  }
}