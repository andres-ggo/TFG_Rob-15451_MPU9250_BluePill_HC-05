#include <SoftwareSerial.h> // Se incluye la libreria SoftwareSerial, obtenida en https://github.com/PaulStoffregen/SoftwareSerial .
SoftwareSerial BT(3,4); // Se definen respectivamente los pines RX y TX de arduino que se conectan al HC-05.

void setup(){
  BT.begin(38400); // Se inicializa el puerto serie BT (Para Modo AT 2 y comunicacion con el puerto BT que recibe).
  
  Serial.begin(38400); // Se inicializa el puerto serie y se define su velocidad de comunicacion.
}

void loop(){
  if (BT.available()){            // Si llega un dato por el puerto serie BT se envia al monitor serial. Es
     Serial.write(BT.read());     // decir, enviamos por el ordenador remoto, recibimos en el conectado por cable.
}
  if (Serial.available()){        // Si llega un dato por el monitor serial se envia al puerto BT. Si se escribe
     BT.write(Serial.read());     // en el monitor serie, se recibe en ordenador remoto.
}
}
