#define signalPin 2
#define switchPin 3
#define LEDPin 13

bool isOn = false;
unsigned long t0;

void step() {
	unsigned long time = (micros()-t0) >> 2;
	Serial.write(0xff);
	Serial.write((time >> 0x10) & 0xff);
	Serial.write((time >> 0x08) & 0xff);
	Serial.write((time >> 0x00) & 0xff);
}

void sw() {
	if(isOn) {
		isOn = false;
		digitalWrite(LEDPin, LOW);
		detachInterrupt(digitalPinToInterrupt(signalPin));
	} else {
		isOn = true;
		t0 = micros();
		digitalWrite(LEDPin, HIGH);
		attachInterrupt(digitalPinToInterrupt(signalPin), step, RISING);
	}
}

void setup() {
	Serial.begin(1000000);
	pinMode(signalPin, INPUT);
	pinMode(switchPin, INPUT);
	pinMode(LEDPin, OUTPUT);
	digitalWrite(LEDPin, LOW);
	attachInterrupt(digitalPinToInterrupt(switchPin), sw, RISING);
}

void loop() {
}
