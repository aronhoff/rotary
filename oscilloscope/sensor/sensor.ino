#define CHANNELS 2

void setup() {
  Serial.begin(1000000); 
}

void loop() {
  Serial.write(0xff);                                                         
  int val = analogRead(0);                                              
  Serial.write((val >> 8) & 0xff);                                            
  Serial.write(val & 0xff);
#if CHANNELS > 1
  val = digitalRead(A0)*1023;
  //val = analogRead(1);                                              
  Serial.write((val >> 8) & 0xff);                                            
  Serial.write(val & 0xff);
#endif
#if CHANNELS > 2
  val = analogRead(2);
  Serial.write((val >> 8) & 0xff);                                            
  Serial.write(val & 0xff);
#endif
 }
