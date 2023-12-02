void setup() {
  // put your setup code here, to run once:
pinMode(3,OUTPUT);
pinMode(9,OUTPUT);
pinMode(6,OUTPUT);
pinMode(5,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  
  analogWrite(3, 25); 
  analogWrite(9, 50); 
  analogWrite(5, 75); 
  analogWrite(6, 100); 

}
