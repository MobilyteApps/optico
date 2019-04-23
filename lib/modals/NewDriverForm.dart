
class NewDriverForm {
  List<Data> dataList;

  NewDriverForm({this.dataList});

  NewDriverForm.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      dataList = new List<Data>();
      json['data'].forEach((v) {
        dataList.add(new Data.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (this.dataList != null) {
      data['data'] = this.dataList.map((v) => v.toJson()).toList();
    }
    return data;
  }

    setCheckValue(int value,int index,int subIndex) {
    dataList[index].questionList[subIndex].answer = value;
    dataList.toSet();
  }

  setCommentValue(var value,int index,int subIndex) {
    dataList[index].questionList[subIndex].comment = value;
    dataList.toSet();
  }
}

class Data {
  var title;
  List<AllQuestions> questionList;

  Data({this.title, this.questionList});

  Data.fromJson(Map<dynamic, dynamic> json) {
    title = json['titleKey'];
    if (json['allQuestions'] != null) {
      questionList = new List<AllQuestions>();
      json['allQuestions'].forEach((v) {
        questionList.add(new AllQuestions.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['titleKey'] = this.title;
    if (this.questionList != null) {
      data['allQuestions'] = this.questionList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllQuestions {
  var question;
  var answer;
  var comment;

  AllQuestions({this.question, this.answer});

  AllQuestions.fromJson(Map<dynamic, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
    comment = json['comment'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['comment'] = this.comment;
    return data;
  }
}

























// class NewDriverForm{
//   List<Data> dataList;
//   NewDriverForm({this.dataList});
//   factory NewDriverForm.fromJson(Map<dynamic,dynamic> parsedJson){
//     var list = parsedJson['data'] as List;
//     List<Data> data = list.map((i) => Data.fromJson(i)).toList();
//     return NewDriverForm(
//       dataList : data
//     );
//   }

//   setcheckValue(int value,int index,int subIndex) {
//     dataList[index].questionList[subIndex].answer = value;
//     dataList.toSet();
//   }

//   // Map<String, dynamic> toJson() => {'data': dataList};
//   // List<dynamic> toJson() => []

// }

// class Data{

//   var title;
//   List<Questions> questionList;
//   Data({
//     this.title, this.questionList
// });

// factory Data.fromJson(Map<dynamic, dynamic> parsedJson){

//     var list = parsedJson['allQuestions'] as List;
//     List<Questions> allQuestions = list.map((i) => Questions.fromJson(i)).toList();


//     return Data(
//         title: parsedJson['titleKey'],
//         questionList: allQuestions

//     );
//   }
// }

// class Questions{
//   var question;
//   var answer;

//   Questions({
//   this.question, this.answer
//   });

//   factory Questions.fromJson(Map<dynamic, dynamic> parsedJson){
//     return Questions(
//         question: parsedJson['question'],
//         answer : parsedJson['answer'],
//     );
//   }


//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['question'] = this.question;
//     data['answer'] = this.answer;
//     return data;
//   }

// }