enum ValueType{
  STRING, NUMBER, BOOLEAN, INT
};

class FreeTypeValue{
  protected String value;
  protected ValueType type;
  protected float f_num;
  protected int i_num = -1;
  protected boolean b_val = false;
  
  FreeTypeValue(String init){
    this.setValue(init);
  }
  
  FreeTypeValue(Object b){
    if(b instanceof String){
      this.setValue((String)b);
    }else if(b instanceof Integer){
      this.setValue((Integer)b);
    }
  }
  
  public void setValue(Integer init){
    value = String.valueOf(init);
    i_num = init;
    type = ValueType.INT;
  }
  
  public void setValue(String init){
    value = init;
    
    if(isNaN(init)){
      if(init.equals("ture") || init.equals("false")){
        type = ValueType.BOOLEAN;
      }else{
        type = ValueType.STRING;
      }
    }else
      type = ValueType.NUMBER;
    
    
    switch(type){
      case NUMBER:
        try{
          i_num = Integer.valueOf(value);
          type = ValueType.INT;
        }catch(Exception e){
          f_num = Float.valueOf(init);
        }
        break;
      case BOOLEAN:
        b_val = init.equals("true");
        break;
    }
  }
  
  ValueType getType(){
    return type;
  }
  
  float getNumber(){
    return f_num;
  }
  
  int getInt(){
    return Integer.valueOf(value);
  }
  
  boolean getBoolean(){
    return b_val;
  }
  
  String getString(){
    return value;
  }
}
