void CmdExec(JSONArray lisp){
  CommandParse(lisp, 0);
}

void CommandParse(JSONArray lisp, int indent){
  int pos = -1;
  
  String cmd_name = "";
  ArrayList<String> args = new ArrayList<String>();
  for(int i = 0; i < lisp.size(); i++){
    Object lispObj = lisp.get(i);
    if(lispObj instanceof JSONArray){
      CommandParse((JSONArray)lispObj, indent+1);
    }else if(lispObj instanceof String){
      if(((String)lispObj).length() == 0) continue;
      pos ++;
      
      if(pos == 0 && ((String)lispObj).charAt(0) == '$'){
        cmd_name = (((String)lispObj).substring(1, ((String)lispObj).length()));
      }else{
        args.add((String)lispObj);
      }
      
      println(indent+", "+pos+": "+(String)lispObj);
    }else continue;
  }
  
  if(cmd_name.length() > 0)
    CommandExec(cmd_name,args);
}

void CommandExec(String name, ArrayList<String> args){
  print("running command: "+name);
  if(name.equals("print")){
    pd.append(args.get(0));
  }else if(name.equals("setup")){
    settingsSetup(args.get(0), args.get(1));
  }
}

void settingsSetup(String name, String value){
  if(name.equals("FONT_SIZE")){
    FONT_SIZE = Integer.valueOf(value);
  }
}
