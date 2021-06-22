
#include <Arduino.h>
#include <stdint.h>
#include "SCMD.h"         //Librerias proporcionadas por el fabricante del componente de forma gratuita en la misma pagina de venta del mismo.
#include "SCMD_config.h"  
#include "Wire.h"         //Libreria incluida en Arduino para conexion I2C.

#define LEDPIN PC13       //Se define la variable LEDPIN (Utilidad en el debugging).

SCMD myMotorDriver;       //Definicion de la variable myMotorDriver, de la classe SCMD definida por la libreria.

int i=0;

void setup() {
  
  Serial.begin(115200);   //Inicializacion del bus serie.
  
  while(!Serial) {
  Serial.print("...");    //Espera hasta que se complete el proceso anterior.
  };
  Serial.print("\n");
 
  pinMode(LEDPIN, OUTPUT);

  delay(500); 
  
  Serial.println("Starting sketch."); //Utilidad en el proceso del debugging.
  

  myMotorDriver.settings.commInterface = I2C_MODE;  //Conexion del componente mediante I2C.
  myMotorDriver.settings.I2CAddress = 0x61;         //Definicion de la direccion I2C del esclavo. Esta depende del patron que muestra (por defecto o modificado) en su parte trasera. En este caso 1100 corresponde a 0x61.

                                                    
  delay(500);
  
  Wire.begin();                       //Inicializacion del bus I2C.
  Serial.print("Read ID = 0x");
  Serial.println(myMotorDriver.begin(), HEX); //Devuelve la ID del controlador, a la par que lo inicia.
 
  while (myMotorDriver.begin() != 0xA9){
    Serial.println("ID mismatch, trying again.");  //Si la ID no coincide con 0xA9, se entrara en este bucle. Probablemente no se saldra de el sin arreglar previamente el hardware.
    delay(50);                                     
  }
  
  Serial.println("ID matches 0xA9");

  Serial.println("Waiting for ready");            //Comentarios para ayudar en el debugging.
  while( myMotorDriver.ready() == false);         //Bucle que obliga al componente a estar listo mediante la funcion ready() antes de seguir.
  Serial.println("Done!");

  while ( myMotorDriver.busy());                  //Bucle similar al anterior, si no funciona la funcion busy() no se puede continuar.
  myMotorDriver.enable();

  Serial.println();

}

void loop() {

  Serial.println(i);
  //Serial.println("Now using the resistance.");

  i++;
  myMotorDriver.setDrive(0,0,255);
  myMotorDriver.setDrive(1,0,255);

  if(i == 255) i = 0;

  delay(50);

//  digitalWrite(LEDPIN, 1);                         //El led se activa cuando gira en un sentido y se apaga cuando lo hace en el otro o simplemente no permite el paso de la corriente. Es una funcion meramente estetica y que pierde el sentido cuando se trabaja con mas de una carga.
//  myMotorDriver.setDrive(1, 1, 255);               
//                                                   
//  delay(500);
//  digitalWrite (LEDPIN, 0);
//  myMotorDriver.setDrive(1, 0, 255);
//
//  delay(500);
//  myMotorDriver.setDrive(1, 1, 0);
}
