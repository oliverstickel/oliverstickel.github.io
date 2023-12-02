int Helligkeit; //0 = keine Helligkeit und 255 = volle Helligkeit
void setup() {
  // put your setup code here, to run once:
pinMode(11,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  Helligkeit = 1;
  analogWrite(11, Helligkeit); //Erzeugung eines PWM-Signal mit ein (Helligkeit/255)% Dutycycle
}
