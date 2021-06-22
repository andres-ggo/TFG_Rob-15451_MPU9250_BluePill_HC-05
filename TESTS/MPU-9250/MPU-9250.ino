/*Andres Gomez y Miguel Reurer 2021*/


#include "MPU9250.h" //Libreria de rafacastalla (https://github.com/rafacastalla/MPU9250-1)
#include "SPI.h"     //Libreria SPI de Arduino


MPU9250 IMU(SPI,PA4);  //Se coloca un objeto de clase MPU9250 en el bus SPI y el pin PA4 (A4 en la placa, ejerce de Chip Selector).
//MPU9250 IMU(SPI,10);  //Se coloca un objeto de clase MPU9250 en el bus SPI y el pin PA4 (A4 en la placa, ejerce de Chip Selector).
int status;

unsigned long now = 0;                  //Variables de integracion
unsigned long last_sum = 0;
unsigned long dT = 0;


float Gpitch = 0, Groll = 0, Gyaw = 0;  //Variables geometricas
float Atotal = 0, Apitch = 0, Aroll = 0;
float Mpitch = 0, Mroll = 0;
float M_x_eq = 0, M_y_eq = 0;
float Mag_x_damp = 0, Mag_y_damp = 0;
float Heading = 0;
float G_pitch_output = 0, G_roll_output = 0;
bool Gyro_sync = false;


float rad_to_deg = 57.29577951;         //Conversion de radianes a grados y viceversa
float deg_to_rad = 0.01745329;



void setup() {
  
  // serial to display data
  Serial.begin(115200);
  while(!Serial) {}
  
  status = IMU.begin();   //Funcion que inicia la IMU, y entre otras cosas, calibra el giroscopio.
                          //Si falla el proceso, devuelve un valor negativo y se para el programa.
  if (status < 0) {
    Serial.println("IMU initialization unsuccessful");
    Serial.println("Check IMU wiring or try cycling power");
    Serial.print("Status: ");
    Serial.println(status);
    while(1) {}    
  }

  IMU.setGyroRange(IMU.GYRO_RANGE_500DPS); //Se cambia el rango de medicion del giroscopio, lo que hace mas preciso el sensor
                                           //debido a que el valor por defecto (2000dps) resulta excesivo para la velocidad 
                                           //angular, teoricamente no tan elevada, del satelite.
 
//  calibrate_mag();           //Esta funcion calibra el magnetometro. Tarda bastante, unos 2 minutos, durante los cuales es necesario
                             //estar "dibujando" un 8 con la placa en la mano. Los valores que se obtienen de una vez para otra son
                             //considerablemente dispares, aunque con los intentos se ve que confluyen. Se recomienda realizar el proceso
                             //mas de una vez para observar dicha confluencia y calcular unos valores medios.

                             //Cuando ya se tengan los valores deseados, se comenta y guardan los valores obtenidos en las siguientes lineas(siempre descomentadas).

    IMU.setMagCalX(11.79,1.11); //La primera columna corresponede al bias magnetico y la segunda al factor de escala, mencionados en la funcion calibrate_mag();
    IMU.setMagCalY(43.07,1.14);
    IMU.setMagCalZ(2.99,0.82);
    
    
}

void loop() {
  
  //display_data();   //Esta funcion plotea los valores RAW del acelerometro, giroscopio, magnetometro, y termometro.
                      //Por lo general esta comentada, pero si se quisiese se podria descomentar y leer dichos valores.

  //PROCESO DE INTEGRACION NUMERICA:
  
  now = millis();           //Milisegundos transcurridos desde el principio de la compilacion.
  dT = now - last_sum;      //Variable de integracion numerica. Calcula el tiempo transcurrido entre este loop y el anterior.
  last_sum = now;           //Se renueva el valor del tiempo del loop() actual para usarlo en el siguiente.
  
  euler_heading(dT);
}

void calibrate_mag(){
  
    IMU.calibrateMag();
    
    Serial.println("Done");    
    
    Serial.print(IMU.getMagBiasX_uT());  //Valores del bias magnetico
    Serial.print(", ");
    Serial.print(IMU.getMagBiasY_uT());
    Serial.print(", ");
    Serial.println(IMU.getMagBiasZ_uT());
    
    Serial.print(IMU.getMagScaleFactorX()); //Valores del factor de escala
    Serial.print(", ");
    Serial.print(IMU.getMagScaleFactorY());
    Serial.print(", ");
    Serial.println(IMU.getMagScaleFactorZ());
    
}

void euler_heading(unsigned long dT){

  IMU.readSensor(); //Lectura del sensor (Valores RAW).
  
  Gpitch += dT*(IMU.getGyroY_rads())*rad_to_deg*0.001;    //0,001 es la conversion del resultado de la funcion milis()
  Groll += dT*(IMU.getGyroX_rads())*rad_to_deg*0.001;     //de milisegundos a segundos.
  Gyaw += dT*(IMU.getGyroZ_rads())*rad_to_deg*0.001;

  Gpitch = Gpitch + Groll*sin(dT*(IMU.getGyroZ_rads())*0.001);   //Compensa el problema del gimbal lock. Explicado en la memoria.
  Groll = Groll - Gpitch*sin(dT*(IMU.getGyroZ_rads())*0.001);    

  Atotal = sqrt((IMU.getAccelX_mss() * IMU.getAccelX_mss()) + (IMU.getAccelY_mss() * IMU.getAccelY_mss()) + (IMU.getAccelZ_mss() * IMU.getAccelZ_mss()));     //Calculo de la aceleracion total.
  Apitch = asin((float)IMU.getAccelX_mss() / Atotal) * rad_to_deg;                                                                                            //Cabeceo mediante los valores del acelerometro.
  Aroll = asin((float)IMU.getAccelY_mss() / Atotal) * rad_to_deg;                                                                                             //Alabeo mediante los valores del acelerometro.

  //VALORES DE CALIBRACION DEL ACELEROMETRO

  Apitch -= 0.18;  //Valores de calibracion del acelerometro. No hay ScaleFactor, pero funcionan considerablemente bien. Para obtenerlos es necesario ponerlos a 0,0.
  Aroll -= -3.55;  //Tambien es necesario descomentar los tres prints que suceden a estas lineas y si se quiere, para limpiar la lectura des del monitor serie, comentar
                  //el resto de prints de esta funcion. Una vez obtenidos, guardar los valores y sustituirlos por el 0,0. Al repetir el programa con los nuevos valores
                  //deberiamos ver como los valores se aproximan ahora al cero. Si no convencen, repetir el proceso (poner a 0,0 y leer). Una vez finalizado el proceso,
                  //volver a dejar como estaba: (Los prints comentados y el resto descomentados y las variables, cambiadas, sin comentar).
                  
//    Serial.print(Apitch,6);
//    Serial.print("\t ");
//    Serial.println(Aroll,6);


  if (Gyro_sync)  //Proceso que solo se realiza al principio, para sincronizar el filtro en un comienzo
  {
    Gpitch = Gpitch * 0.98 + Apitch * 0.02;        //Filtro complementario. Se ajusta la lectura del giroscopio con la del acelerometro.
    Groll = Groll * 0.98 + Aroll * 0.02;           //Algunas fuentes utilizan 0,9996 y 0,0004. Tal como esta se obtienen mejores resultados.
  }                                                                                                                               
  else
  {
    Gpitch = Apitch;            //Solo se entra en este else{} en el primer loop() (ya que la variable Gyro_sync se incia como "false". 
    Groll = Aroll;              //Sincroniza las lecturas del acelerometro y el giroscopio.
    Gyro_sync = true;
  }

  G_pitch_output = G_pitch_output * 0.9 + Gpitch * 0.1;   //Amortigua los picos en la lectura final del girocopio.
  G_roll_output = G_roll_output * 0.9 + Groll * 0.1;      
                                                                                                                                  
  Mpitch = -G_roll_output * deg_to_rad;     //Conversion al sistema de referencia del magnetometro y conversion a radianes (unidades Arduino).
  Mroll = G_pitch_output * deg_to_rad;

  M_x_eq = IMU.getMagX_uT() * cos(Mpitch) + IMU.getMagY_uT() * sin(Mroll) * sin(Mpitch) - IMU.getMagZ_uT() * cos(Mroll) * sin(Mpitch); //Funciones mencionadas, proyectan el rumbo en el plano horizontal.
  M_y_eq = IMU.getMagY_uT() * cos(Mroll) + IMU.getMagZ_uT() * sin(Mroll); 

  Mag_x_damp = Mag_x_damp * 0.9 + M_x_eq * 0.1;  //Amortigua los valores (Igual que G_pitch_output) para reducir los picos de lectura.
  Mag_y_damp = Mag_y_damp * 0.9 + M_y_eq * 0.1;

  Heading = -atan2(Mag_y_damp, Mag_x_damp) * rad_to_deg;    //Como se comenta en la memoria, se ha cambiado alguna cosa (x por y) y el signo del principio.
                                                            //Originalmente, cuando habia x/y, la lectura estaba desplazada 90 grados en sentido horario y sin el negativo del principio,
                                                            //lo que hacia que la lectura sumase los angulos en sentido antihorario en vez de horario.
  
  //Heading += Declination; //Esta linea se puede descomentar si se quiere ser preciso del todo. Anade la declinacion del lugar geografico en el que nos encontramos.
                            //Se puede obtener en https://www.ign.es/web/gmt-declinacion-magnetica.

  if (Heading < 0) Heading += 360;
  if (Heading >= 360) Heading -= 360; //Estas dos lineas contienen el valor del heading entre 0 y 360 grados.

  
  
  Serial.print(G_pitch_output,6);
  Serial.print("\t ");
  Serial.print(G_roll_output,6);
  Serial.print("\t ");
  Serial.print(Gyaw,6);
  Serial.print("\t ");
  Serial.println(Heading,6);


  
//
}

void display_data(){

  IMU.readSensor();  //Lectura del sensor (Valores RAW).
  
  Serial.print(IMU.getAccelX_mss(),6);
  Serial.print("\t");
  Serial.print(IMU.getAccelY_mss(),6);
  Serial.print("\t");
  Serial.print(IMU.getAccelZ_mss(),6);
  Serial.print("\t");
  Serial.print(IMU.getGyroX_rads()*rad_to_deg,6); //Ese numero es 180/pi para tenerlo en deg/s
  Serial.print("\t");
  Serial.print(IMU.getGyroY_rads()*rad_to_deg,6);
  Serial.print("\t");
  Serial.print(IMU.getGyroZ_rads()*rad_to_deg,6);
  Serial.print("\t");
  Serial.print(IMU.getMagX_uT(),6);
  Serial.print("\t");
  Serial.print(IMU.getMagScaleFactorX(),6);
  Serial.print("\t");
  Serial.print(IMU.getMagY_uT(),6);
  Serial.print("\t");
  Serial.print(IMU.getMagZ_uT(),6);
  Serial.print("\t");
  Serial.println(IMU.getTemperature_C(),6);
  
}
