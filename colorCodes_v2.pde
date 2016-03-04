import spacebrew.*;

Spacebrew sb;

ArrayList<JSONObject> circles = new ArrayList<JSONObject>();

void setup() {
  size(800, 600);
  
  sb = new Spacebrew( this );
  
  // publishers
    sb.addPublish( "colorCircle", "circle", "" );
  
  // subscribers
    sb.addSubscribe( "r" , "range" );
    sb.addSubscribe( "g" , "range" );
    sb.addSubscribe( "b" , "range" );
    
    sb.addSubscribe( "name" , "string" );
    
    sb.addSubscribe( "colorCircle", "circle" );
  
  sb.connect( "localhost" , "colorCodes_v2" , "" );
}

/* VARIABLES */

  String titleText = "_colorCodes";
  int titleLeftNo = 400;
  int titleTopNo = 300;
  
  int r = 0;
  int g = 0;
  int b = 0;
  
  int circleX = mouseX;
  int circleY = mouseY;

  String enteredName = "";
  
  JSONObject newCircle = new JSONObject();

  JSONObject incomingCircle = new JSONObject();

/* end of VARIABLES */

void draw() {
  background(0, 0, 0);
  
  fill(255, 255, 255);
  textAlign(CENTER);
  textSize(45);
  text( titleText, titleLeftNo, titleTopNo );
  
  newCircle.setInt( "x", mouseX );
  newCircle.setInt( "y", mouseY );
  newCircle.setInt( "radius", 0 );
  newCircle.setInt( "r", 255 );
  newCircle.setInt( "g", 0 );
  newCircle.setInt( "b", 0 );
  newCircle.setString( "name", "placeholder" );
  
  fill( r, g, b );
  ellipse( circleX, circleY, 55, 55 );
  
  for ( int i=0; i<circles.size(); i++){
      
    JSONObject c = circles.get(i);
    int cX = c.getInt( "x" );
    int cY = c.getInt( "y" );
    //int cX = c.getInt( "radius", 0 );
    int cR = c.getInt( "r" );
    int cG = c.getInt( "g" );
    int cB = c.getInt( "b" );
        
    fill( cR, cG, cB );
    ellipse( cX, cY, 55, 55 );
    
    println( cX, cY);
  }
  
  fill( 255 );
  textAlign(CENTER);
  textSize(14);
  text( enteredName, circleX, circleY + 45);
    
  sb.send( "colorCircle", "circle", newCircle.toString() );
}

void onRangeMessage( String name, int value ){
  
  
  if ( name.equals( "r" )){
    r = (int) map( value, 0, 1023, 0, 255 );
  } else if ( name.equals( "g" )){
    g = (int) map( value, 0, 1023, 0, 255 );
  } else if ( name.equals( "b" )){
    b = (int) map( value, 0, 1023, 0, 255 );
  }
  
}

void onStringMessage( String name, String value ){
  
  println( "got string message " + name + " : " + value );
  
  enteredName = value;
  
}

void onCustomMessage( String name, String type, String value ){
  
  if ( type.equals( "circle" ) ){

    JSONObject newCircle = JSONObject.parse( value );
    
    boolean isNew = true;
    
    // search through arraylist for our circle
    for ( int i=0; i<circles.size(); i++){
      
      JSONObject c = circles.get(i);
      String cName = c.getString("name");
      
      if ( cName.equals( newCircle.getString("name" ) ) ){
        circles.get(i).setInt("x", newCircle.getInt( "x" ));
        circles.get(i).setInt("y", newCircle.getInt( "y" ));
        circles.get(i).setInt("r", newCircle.getInt( "r" ));
        circles.get(i).setInt("g", newCircle.getInt( "g" ));
        circles.get(i).setInt("b", newCircle.getInt( "b" ));
        
        isNew = false;
        
        
      }
    }
    
    if ( isNew == true ){
      circles.add( newCircle );
    }
    
  }
  
}