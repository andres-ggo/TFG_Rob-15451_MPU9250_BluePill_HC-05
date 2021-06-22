/* Andres Gomez (2021), a partir del codigo de Juan Palomares (2020) */

import processing.opengl.*; // Se incluyen las librerias.
import processing.serial.*;

// Se define las variables.

Serial port;                                           // Se define el puerto serie del cual se obtendran los datos.

String roll1 = "0.0", pitch1 = "0.0", yaw1 = "0.0";    // Se define las variables "string" que adoptaran el "string" que llegue por el serial (Satelite 1).
Float Roll1 = 0.0, Pitch1 = 0.0, Yaw1 = 0.0;           // Estas variables guardaran el valor transformado a "float" de los "string" que lleguen por el serial (Satelite 1).

String pot1 = "0,0", pot2 = "0.0", detumbling = "0.0";   // De un modo analogo a lo anterior, variables "String" que seran transfomradas en "float".
Float Pot1 = 0.0, Pot2 = 0.0, Detumbling = 0.0;
boolean overButton = false;                              // Variable booleana que sirve para determinar si se esta o no encima del boton con el raton.


// Se elabora la funcion setup.

void setup() {
  size(1600, 1000, OPENGL);             // Se define el tamano de la ventana.
  ortho();                              // Establece una proyeccion ortogonal.
  textSize(20);                         // Establece un valor concreto al tamano del texto.
  port = new Serial(this, "COM9", 115200);    // Se configura la variable del puerto serie.
  port.bufferUntil('\n');                     // Con esto se asegura que se leeran datos hasta que se llegue a un salto de linea.
  
}

// Elaboramos la funcion draw.

void draw() {
  background(198);         // Establece un fondo gris.
  update();                // Se llama a la funcion update, que permite pulsar el boton.
    IMU();                 // Llama a la funcion IMU.
}
  
void update() {
  if (mouseX >= 1111 && mouseX <= 1287 &&         // Define que espacio ocupa el boton y lo que pasa 
      mouseY >= 880 && mouseY <= 910) {           // cuando se pasa el raton por encima.
    overButton = true;
  }else{
    overButton = false;
  }
}

void mousePressed(){      // Si se pulsa el raton mientras se esta encima del raton,
  if(overButton){         // se manda un '1' a traves del puerto serie. 
    port.write('1');
  }
}
