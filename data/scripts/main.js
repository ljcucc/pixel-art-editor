function int(value){
  return Java.to(value,"int");
}
function stringList(value){
  return Java.to(value,"java.lang.String[]");
}
function intList(value){
  return Java.to(value, "int[]");
}
function createEvent(callback){
  var runnable = Java.extend(java.lang.Runnable,function(){
    callback();
  })
  return new runnable();
}
/*function print(value){
  Editor.makeToast(value);
}*/

(function (){
  print("main script is running");

  Editor.addElement(Editor.createMenuBar());
  Editor.addElement(Editor.createMenu(
    "File",
    stringList([
      "Open file [:e]",
      "Save file [:w]",
      "Close [:q]",
      "New tab [:newtab]"
    ])
  ));

  Editor.addElement(
    Editor.createMenu(
      "Edit",
      stringList([
        "Undo [u]" ,
        "Redo [r]",
        "Cut [d]",
        "Copy [c]",
        "Paste [p]"
      ])
    )
  );

  print("#1");

  var canvas = Element.createCanvas(
    intList([128,128]),
    intList([250,100])
  )
  Editor.addElement(canvas);

  println("Canvas added");

  Editor.setupElements();
})();

true;
