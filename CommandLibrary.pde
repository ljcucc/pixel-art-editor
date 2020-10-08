class Command{
  public FreeTypeValue exec(ArrayList<FreeTypeValue> args){
    return new FreeTypeValue();
  }
}

void onCommandInit(){
  CommandLibrary.put("+", new Command(){});
}

HashMap<String, Command> CommandLibrary = new HashMap<String, Command>();
