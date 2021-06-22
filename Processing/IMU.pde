/* Andres Gomez (2021), a partir del codigo de Juan Palomares (2020) */

// Esta funcion muestra la informacion relativa a la orientacion obtenida mediante la IMU.

void IMU() {
 
  lights();         // Se muestra la iluminacion.
  
  // Representacion de la orientacion del CubeSat.
  
  textSize(20);
  pushMatrix();                         // Se guarda el sistema de coordenadas actual en el stack.
  translate(width/4, height/2, 0);      // Se traslada el origen de coordenadas al centro del que sera el satelite.
  fill(0);                              // Lo siguiente que se dibuje se hara en negro.
  text("ACTITUD 3D", -65, -225);        // Se muestran los datos del satelite.
  text("Roll: "+Roll1+"º", -55, 245);                        
  text("Pitch: "+Pitch1+"º", -55, 295); 
  text("Yaw: "+Yaw1+"º", -55, 345); 
  scale(5, 5, 5);                       // Se escala el sistema coordenado.
  rotateY(radians(180));                // Para que sea mas simple el visionado del comportamiento del sistema.
  rotateY(radians(Yaw1));               // Se realiza la primera rotacion. Los ejes de rotacion no son los que correspondrian en los ejes fisicos de la IMU, partiendo de que se utilizan ejes left-handed (https://processing.org/tutorials/p3d/).
  rotateX(radians(Pitch1));             // Se realiza la segunda rotacion.
  rotateZ(radians(Roll1));              // Se realiza la tercera rotacion.
  noStroke();                           // Lo siguiente que se dibuje no tendra bordes.
  beginShape(QUADS);                    // El satelite se define como un cubo que a su vez se define por las caras cuadradas que lo forman.
  
  // Cara delantera.
  
  fill(0, 255, 0);       // Se seleecciona el color de los siguiente que se dibujara.
  vertex(-20, -20, 20);  // Se definen los vertices que daran forma a una cara.
  vertex(20, -20, 20);
  vertex(20, 20, 20);
  vertex(-20, 20, 20);
  
  // Cara trasera.
  
  fill(0, 0, 255); 
  vertex(-20, -20, -20); 
  vertex(20, -20, -20);
  vertex(20, 20, -20);
  vertex(-20, 20, -20);
  
  // Cara lateral izquierda.
  
  fill(255, 0, 0); 
  vertex(-20, -20, -20); 
  vertex(-20, -20, 20);
  vertex(-20, 20, 20);
  vertex(-20, 20, -20);
  
  // Cara lateral derecha.
  
  fill(255, 255, 0); 
  vertex(20, -20, -20); 
  vertex(20, -20, 20);
  vertex(20, 20, 20);
  vertex(20, 20, -20);
  
  // cara superior.
  
  fill(255, 0, 255); 
  vertex(-20, -20, -20);
  vertex(20, -20, -20);
  vertex(20, -20, 20);
  vertex(-20, -20, 20);
  
  // Cara inferior.
  
  fill(0, 255, 255); 
  vertex(-20, 20, -20); 
  vertex(20, 20, -20);
  vertex(20, 20, 20);
  vertex(-20, 20, 20);
  endShape();           // Ya no se dibujaran mas cuadrados.
  popMatrix();          // Se reestablece el sistema de coordenadas al que estaba guardado en el stack.
  
  // Representacion del campo magnetico respecto del CubeSat y las potencias enviadas a cada magnetopar.
  
  pushMatrix();                                             // Se guarda el sistema de coordenadas actual en el stack.
  translate(3*width/4, height/2, 0);                        // Se traslada el origen de coordenadas al centro del que sera el satelite.
  fill(0);                                                  // Lo siguiente que se dibuje se hara en negro.
  text("ACTITUD Y POTENCIA EN PLANTA", -165, -225);         // Se muestran los datos del satelite.
  text("Rumbo: "+Yaw1+"º", -70, 245);        
  text("Potencia al magnetopar 1: "+Pot1, -150, 295); 
  text("Potencia al magnetopar 2: "+Pot2, -150, 345); 
  
  scale(5, 5, 5); // Se escala el sistema coordenado.
  
  //Boton de inicio del detumbling.
   
   if(Detumbling == 0){  //Aspecto del boton si no se ha iniciado el detumbling.
     
     beginShape(); 
     stroke(50,150);      //Definicion del borde.
     
     if(overButton){  fill(170);  }else{  fill(150);  }  //Aclarado del interior del boton si se pasa por encima el raton.
                                                         
     vertex(17.5, 76, -15);    //Vertices del cuadrado que forma el boton.
     vertex(17.5, 82, -15);
     vertex(-17.5, 82, -15);
     vertex(-17.5, 76, -15);
   
     endShape(CLOSE);
   
     fill(70);
     textSize(3.5);
     text("Start detumbling", -16.5, 80, -15);     //Texto del boton sin pulsar.
     
     }else{    //Si se ha iniciado el detumbling, se cambia el formato del boton.
       
     fill(70);
     textSize(3.5);
     text("Detumbling...", -11, 80, -15);         //El boton no esta, solo se visualiza esto. Detumbling en proceso.
     
   }
   
   //Flecha del campo magnetico terrestre.
   
   noFill();           //Sin relleno.
   stroke(50,150);     //Definicion del marco.
   strokeJoin(ROUND);  //Definicion del formato de union de las lineas del marco/borde.
   strokeWeight(0.75); //Definicion del grosor de las lineas del marco.
   beginShape(); 
      
   vertex(-40, 0);
   vertex(-25, -5);
   vertex(-25, -2);
   vertex(35, -2);
   vertex(35, 2);
   vertex(-25, 2);
   vertex(-25, 5);
   
   endShape(CLOSE);
   
   rotateZ(radians(Yaw1)); //Se cambia la visualizacion y el unico angulo que se ve es el Heading (Yaw1 en este programa), en el plano de la pantalla.
   
   
   //PCB con su forma.
   
   noStroke(); //Sin borde.
   beginShape();
  
    fill(51, 100, 210); // Se selecciona el color de lo siguiente que se dibujara.
    
    vertex(-30, -30, -20);  //Cada uno de los siguientes ccuator bloques es un lado de la placa (5 puntos por cada).
    vertex(-30, -20, -20);
    vertex(-28.5, -16, -20);
    vertex(-28.5, 16, -20);
    vertex(-30, 20, -20);
    
    vertex(-30, 30, -20);
    vertex(-20, 30, -20);
    vertex(-16, 28.5, -20);
    vertex(16, 28.5, -20);
    vertex(20, 30, -20);
    
    vertex(30, 30, -20);
    vertex(30, 20, -20);
    vertex(28.5, 16, -20);
    vertex(28.5, -16, -20);
    vertex(30, -20, -20);
    
    vertex(30, -30, -20);
    vertex(20, -30, -20);
    vertex(16, -28.5, -20);
    vertex(-16, -28.5, -20);
    vertex(-20, -30, -20);
    
    
    endShape();
    
    
    //Dibujo de los magnetopares con sus patas.
    
    noStroke();          //Sin bordes.
    beginShape(QUADS);
    
    //MAGNETOPAR 1.
    
    fill(203,109,81);
    vertex(-27, -17, -18);
    vertex(-27, 17, -18);
    vertex(-19, 17, -18);
    vertex(-19, -17, -18);
    
    fill(235,235,235);      //Patas del primer magnetopar.
    vertex(-28, -17, -18);
    vertex(-28, -19.5, -18);
    vertex(-18, -19.5, -18);
    vertex(-18, -17, -18);
    
    fill(235,235,235);
    vertex(-28, 17, -18);
    vertex(-28, 19.5, -18);
    vertex(-18, 19.5, -18);
    vertex(-18, 17, -18);
    
    //MAGNETOPAR 2
    
    fill(203,109,81);
    vertex(19, -27, -18);
    vertex(19, -19, -18);
    vertex(-15, -19, -18);
    vertex(-15, -27, -18);
    
    fill(235,235,235);      //Patas del segundo magnetopar.
    vertex(19, -28, -18);
    vertex(19, -18, -18);
    vertex(21.5, -18, -18);
    vertex(21.5, -28, -18);  
    
    fill(235,235,235);
    vertex(-15, -28, -18);
    vertex(-15, -18, -18);
    vertex(-17.5, -18, -18);
    vertex(-17.5, -28, -18);
    
    //Dibujo de la forma de la IMU.
    
    fill(4,45,191);
    vertex(24, 26, -18);
    vertex(24, 14, -18);
    vertex(5, 14, -18);
    vertex(5, 26, -18);
    
   
    endShape();
  
    //Contenido de la IMU.
  
    textSize(3);            //Texto blanco.
    fill(255, 255, 255);
    text("IMU", 5.5, 17, -18);
    
    textSize(2.3);          //Texto negro (en distinto tamano).
    fill(0, 0, 0, 200);
    text("Drawn Y-axis", 6.5, 21, -18);
    
    beginShape();   //Punta de la flecha del eje.
    fill(0,0,0);
    vertex(7, 23, -18);
    vertex(10, 23.75, -18);
    vertex(10, 22.25, -18);
    endShape();
    
    beginShape(LINES);   //Linea de la flecha del eje.
    stroke(0,255);
    strokeWeight(0.50);
    fill(0,0,0);
    vertex(10, 23, -18);
    vertex(20, 23, -18);
    endShape();
  
  
  //Indicadores de potencia de los magnetopares.
  
  //(nada mas aparecer, el vertical es el 1 y el horizontal (paralelo al eje de la imu) el 2).
  
    noStroke();    //Sin borde.
    
    
    beginShape();   //Caja blanca del magnetopar1.
    fill(200);
    vertex(-25, -13, -18);
    vertex(-21, -13, -18);
    vertex(-21, 13, -18);
    vertex(-25, 13, -18);
    endShape();
    
    beginShape();   //Punta de flecha superior de la caja del magnetopar 1.
    fill(200);
    vertex(-23, -16, -18);
    vertex(-20, -13, -18);
    vertex(-26, -13, -18);
    endShape();
    
    beginShape();   //Punta de flecha inferior de la caja del magnetopar 1.
    fill(200);
    vertex(-20, 13, -18);
    vertex(-23, 16, -18);
    vertex(-26, 13, -18);
    endShape();
    
    beginShape();   //Caja blanca y punta de flecha derecha del magnetopar 2.
    fill(200);
    vertex(-11, -25, -18);
    vertex(15, -25, -18);
    vertex(15, -26, -18);
    vertex(18, -23, -18);
    vertex(15, -20, -18);
    vertex(15, -21, -18);
    vertex(-11, -21, -18);
    endShape();
    
    beginShape();   //Punta de flecha izquierda del magnetopar 2. (Hay que hacerlo a parte si no sale un fallo en el color).
    fill(200);
    vertex(-14, -23, -18);
    vertex(-11, -26, -18);
    vertex(-11, -20, -18);
    endShape();
    
    beginShape();   //Barra negra oscilante indicadora del magnetopar 1.
    fill(0);
    vertex(-24, -(Pot1/255)*13, -18); //Parte proporcional en la barra del valor de la potencia del magnetopar 1 entre 255 y -255.
    vertex(-22, -(Pot1/255)*13, -18);
    vertex(-22, 0, -18);
    vertex(-24, 0, -18);
    endShape();
    
    beginShape();   //Barra negra oscilante indicadora del magnetopar 2.
    fill(0);
    vertex((-(Pot2/255)*13)+2, -22, -18);  //Parte proporcional en la barra del valor de la potencia del magnetopar 2, desplazada dos unidades (solidaria al magnetopar, que tambien lo esta).
    vertex((-(Pot2/255)*13)+2, -24, -18);
    vertex(2, -24, -18);
    vertex(2, -22, -18);
    endShape();
    
    beginShape(LINES);   //Lineas centrales de las flechas indicadoras de potencia de cada magnetopar.
    stroke(0,100);
    strokeWeight(0.50);
    fill(230);
    vertex(-25.5, 0, -18); //Magnetopar 1.
    vertex(-20.5, 0, -18);
    
    vertex(2, -25.5, -18); //Magnetopar 2.
    vertex(2, -20.5, -18);
    endShape();
    
    
    
  
  
  popMatrix(); // Se reestablece el sistema de coordenadas al que estaba guardado en el stack.
}
