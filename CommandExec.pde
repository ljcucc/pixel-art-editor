void CmdExec(JSONArray lisp){
  CommandParse(lisp, 0);
}

void CommandParse(JSONArray lisp, int indent){
  int pos = -1;
  
  String cmd_name = "";
  ArrayList<FreeTypeValue> args = new ArrayList<FreeTypeValue>();
  for(int i = 0; i < lisp.size(); i++){
    Object lispObj = lisp.get(i);
    if(lispObj instanceof JSONArray){
      CommandParse((JSONArray)lispObj, indent+1);
    }else{
      pos ++;
      
      if(lispObj instanceof String){
        if(lispObj instanceof String && ((String)lispObj).length() == 0) continue;
        
        if(pos == 0){
          if(((String)lispObj).charAt(0) == '$'){
            cmd_name = (((String)lispObj).substring(1, ((String)lispObj).length()));
            continue;
          }
        }
      }
      
      args.add(new FreeTypeValue(lispObj));

      
      //println(indent+", "+pos+": "+(String)lispObj);
    }
  }
  
  if(cmd_name.length() > 0)
    CommandExec(cmd_name,args);
  else if(args.size() == 1){
    //return 
  }
}

void CommandExec(String name, ArrayList<FreeTypeValue> args){
  println("running command: "+name);
  if(name.equals("print")){
    pd.append(args.get(0).getString());
  }else if(name.equals("setup")){
    println("args[0]: "+ args.get(0));
    println("args[1]: "+ args.get(1));
    settingsSetup(args.get(0).getString(), args.get(1));
  }
}

void settingsSetup(String name, FreeTypeValue value){
  if(name.equals("$FONT_SIZE")){
    FONT_SIZE = value.getInt();
  }
}
