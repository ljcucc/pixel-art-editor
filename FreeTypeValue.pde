enum ValueType{
  STRING, NUMBER, BOOLEAN, INT, UNDEFINED
};

class FreeTypeValue{
  protected String value;
  protected ValueType type = ValueType.UNDEFINED;
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
    i_num = init;
    type = ValueType.INT;
  }
  
  public void setValue(String init){
    value = init;
    type = ValueType.UNDEFINED;
  }
  
  protected void transform_type(){
    
    if(type != ValueType.UNDEFINED) return;
    
    if(isNaN(value)){
      if(value.equals("ture") || value.equals("false")){
        type = ValueType.BOOLEAN;
        b_val = value.equals("true");
      }else{
        type = ValueType.STRING;
      }
    }else{
      try{
          i_num = Integer.valueOf(value);
          type = ValueType.INT;
        }catch(Exception e){
          type = ValueType.NUMBER;
          f_num = Float.valueOf(value);
        }
    }
  }
  
  ValueType getType(){
    transform_type();
    return type;
  }
  
  float getNumber(){
    transform_type();
    return f_num;
  }
  
  int getInt(){
    transform_type();
    return i_num;
  }
  
  boolean getBoolean(){
    transform_type();
    return b_val;
  }
  
  String getString(){
    return value;
  }
}
