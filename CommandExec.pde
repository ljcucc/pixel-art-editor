void CmdExec(JSONArray lisp){
  println(lisp);
  CommandParse(lisp, 0);
}

FreeTypeValue CommandParse(JSONArray lisp, int indent){
  int pos = -1;
  
  println("indent: "+indent);
  println("pos: "+ pos);
  println(lisp.size());
  
  String cmd_name = "";
  ArrayList<FreeTypeValue> args = new ArrayList<FreeTypeValue>();
  for(int i = 0; i < lisp.size(); i++){
    Object lispObj = lisp.get(i);
    println("pos: "+ pos);
    
    if(lispObj instanceof JSONArray){
      pos ++;
      args.add(CommandParse((JSONArray)lispObj, indent+1));
      println("new wrapping");
    }else{
      if(lispObj instanceof String){
        String value = (String)lispObj;
        if(lispObj instanceof String && value.length() == 0) continue;
        if(value.trim().equals("")) continue;
        
        pos ++;
        
        println(pos+" :"+value);
        
        if(pos == 0){
          if(value.charAt(0) == '$'){
            cmd_name = (value.substring(1, value.length()));
            continue;
          }
        }
      }
      
      args.add(new FreeTypeValue(lispObj));
    }
  }
  
  println("cmd_name: "+cmd_name);
  
  if(cmd_name.length() > 0){
    return CommandExec(cmd_name,args);
  }else if(args.size() == 1){
    return args.get(0);
  }
  
  return new FreeTypeValue();
}

FreeTypeValue CommandExec(String name, ArrayList<FreeTypeValue> args){
  println("running command: "+name);
  
  if(CommandLibrary.containsKey(name)){
    CommandLibrary.get(name).exec(args);
  }else{
    cd.error("Command function \""+name+"\" not found!");
  }
  
  //if(name.equals("print")){
  //  println("printing... "+args.get(0).getString());
  //  pd.append(args.get(0).getString());
  //}else if(name.equals("setup")){
  //  println("args[0]: "+ args.get(0));
  //  println("args[1]: "+ args.get(1));
  //  settingsSetup(args.get(0).getString(), args.get(1));
  //}else if(name.equals("=")){
  //  print("eql condition...");
  //  return new FreeTypeValue(args.get(0).getInt() == args.get(1).getInt());
  //}else if(name.equals("+")){
  //  println("adding...");
  //  return new FreeTypeValue(args.get(0).getInt() + args.get(1).getInt());
  //}else if(name.equals("-")){
  //  println("adding...");
  //  return new FreeTypeValue(args.get(0).getInt() + args.get(1).getInt());
  //}
  
  return new FreeTypeValue();
}

void settingsSetup(String name, FreeTypeValue value){
  if(name.equals("$FONT_SIZE")){
    FONT_SIZE = value.getInt();
  }
}
