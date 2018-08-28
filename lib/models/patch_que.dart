

class PatchQue{
  Map<int, int> map; //que id/slot index

  PatchQue({this.map}){
    if(this.map == null){
      map = Map<int,int>();
    }
  }

}