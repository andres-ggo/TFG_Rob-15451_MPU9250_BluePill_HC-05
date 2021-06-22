/*Andres Gomez 2021*/

void setup(){
  Serial1.begin(115200); // Se inicializa el puerto serie 1 del STM32, es decir, la conexion con el modulo HC-05.
  delay(100); // Retardo de 100 milisegundos.
  Serial.begin(115200); // Se inicializa el puerto serie.
  delay(100); // Retardo de 100 milisegundos.
}

void loop(){

  if (Serial1.available()){ // Si llega un dato por el puerto serie 1 (HC-05) se envia al monitor serial.
     Serial.write(Serial1.read());
}
  if (Serial.available()){ // Si llega un dato por el monitor serial se envia al puerto serie 1 (HC-05).
     Serial1.write(Serial.read());
}
}
