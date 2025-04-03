import 'package:equatable/equatable.dart';

abstract class ShlokaEvent extends Equatable{

  @override
  List<Object> get props=>[];
}

class FetchShloka extends ShlokaEvent{

  final String shloka;
  FetchShloka(this.shloka);

  @override
  List<Object> get props=>[shloka];

}