import 'package:equatable/equatable.dart';

  abstract class ShlokaState extends Equatable {

  @override
  List<Object> get props => [];

  }

  class ShlokaInitialState extends ShlokaState{}

  class ShlokaLoading extends ShlokaState{}

  class ShlokaLoaded extends ShlokaState{

    final String translationEnglish;
    final String translationHindi;
    final String explanationEnglish;
    final String explanationHindi;
    final String summaryEnglish;
    final String summaryHindi;
    ShlokaLoaded(this.translationEnglish , this.translationHindi , this.explanationEnglish ,this.explanationHindi,this.summaryEnglish,this.summaryHindi);

    @override
    List<Object> get props => [translationEnglish,translationHindi,explanationEnglish,explanationHindi,summaryEnglish,summaryHindi];

  }

class ShlokaError extends ShlokaState {
  final String message;
  ShlokaError(this.message);

  @override
  List<Object> get props => [message];
}

