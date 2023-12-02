void setup() {
  // put your setup code here, to run once:
  pinMode(11, OUTPUT); // pin 11 als OUTPUT konfigurieren
  TCCR2A = _BV(COM2A1) | _BV(WGM20); // Aktivierung von Signalgenerator und PWM Modus
  TCCR2B = _BV(CS22) | _BV(CS20); //Einstellung der Ausgangsfrequenz durch den Prescaler CS20, CS21, CS22
  OCR2A = 25;  //Einstellung der Dutycycle durch anpassung der Wert von OCR2A
}

void loop() {
  // put your main code here, to run repeatedly:

}
