# TFG_Rob-15451_MPU9250_BluePill_HC-05

En este _repository_ de GitHub, se encuentra disponible el código final necesario para poder replicar la experimentación llevada a cabo durante el desarrollo de mi Trabajo de Fin de Grado, llamado "Implementación de una placa de control de actitud 2D con magnetorquers para CubeSats".

Como puede verse en el título, se trata de un sistema formado por un microprocesador STM32 Blue Pill, programado a través de St-link y comunicado y alimentado a través de un cable USB, y al que se le han conectado tres componentes.

En primer lugar una IMU MPU-9250 a través de SPI en los pines A4, A5, A6, y A7 (primer bus SPI de la Blue Pill), mediante la cual se lee la actitud de la placa gracias a la librería de rafacastalla "https://github.com/rafacastalla/MPU9250-1".

En segundo lugar, se conecta un driver de motor ROB-15451 por I2C, y para el cual se utilizan las librerías proporcionadas a través de la página del vendedor, SparkFun: "https://github.com/sparkfun/SparkFun_Serial_Controlled_Motor_Driver_Arduino_Library". Dicho componente se encarga de la regulación de la corriente que recorre los magnetorquers a cada momento, y se conecta a la BluePill en el primer bus I2C, es decir, los pines B6 y B7.

Por último, se añade un módulo Bluetooth HC-05, conectado a los pines del primer bus UART de la placa, en los pines A9 y A10, este no necesita librerías y sirve, sobretodo, para evitar el posible torque producido por los cables en el airbearing del laboratorio TIEG2.

Se puede ver como el código está dividido en tres grupos. El primero es el programa final de Arduino, que comunica con Processing, además, está el código de Processing encargado de visualizar los datos que llegan de ese programa, y finalmente, se encuentran los distintos programas de pruebas de componentes por separado, que como podrá verse si se analiza el programa principal, son básicamente los trozos que lo conforman. Espero que esta biblioteca sea de utilidad para los siguientes proyectistas del grupo PLATHON y para todo aquel que la considere de utilidad. Por ese motivo, se trata de un documento público y a disposición de todo aquél que lo quiera. Eso sí, espero y pido por favor que si se utiliza, modifica, o aprovecha, se me cite debidamente, como yo he tratado de hacer a lo largo de todo el proyecto.
