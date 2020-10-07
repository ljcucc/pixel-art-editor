void CommandExec(JSONArray lisp){
  CommandExec(lisp, 0);
}

void CommandExec(JSONArray lisp, int indent){
  int pos = -1;
  for(int i = 0; i < lisp.size(); i++){
    Object lispObj = lisp.get(i);
    if(lispObj instanceof JSONArray){
      CommandExec((JSONArray)lispObj, indent+1);
    }else if(lispObj instanceof String){
      if(((String)lispObj).length() == 0) continue;
      pos ++;
      
      println(indent+", "+pos+": "+(String)lispObj);
    }else continue;
  }
}
