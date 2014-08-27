
module TestSDP {
  uses {
    interface Boot;

    interface Leds;    

    interface StdControl as SerialControl;
    interface StdOut;

    interface Resource;
    interface SDCard;

    interface Timer<TMilli> as Timer;
    
    interface Counter<TMilli,uint32_t> as MilliCounter;
    interface Counter<T32khz,uint16_t> as Msp430Counter32khz;
  }  
  
} implementation {

#include <stdio.h>
extern int      sprintf(char *__s, const char *__fmt, ...)
__attribute__((C));

// LFN 1: 2778 bytes


#include "diskio.c"
#include "ff.c"
//#include "option/ccsbcs.c"
//#include "ff_async.c"

  uint16_t uart_value;
  uint8_t buffer[512];
  
  /***************************************************************************/
    FATFS myfs;
    FIL myfile;
    BYTE buff[16];     // File read buffer
    UINT br;           // File read count

    FATFS *fs;
    
    DWORD fre_clust, fre_sect, tot_sect;
  
  /***************************************************************************/
  /* BOOT                                                                    */
  /***************************************************************************/

  event void Boot.booted() 
  {  
    call SerialControl.start();

    call StdOut.print("Test Application\n\r");

    fs = &myfs;        
    P2DIR |= BIT1;
    P2SEL &= ~BIT1;
    P2OUT |= BIT1;
    call Resource.request();
  }

  /***************************************************************************/
  /* TIMER                                                                   */
  /***************************************************************************/
  event void Resource.granted()
  {
    call StdOut.print("Resource granted\n\r");
  }
    
  event void SDCard.writeDone(uint32_t addr, uint8_t*buf, uint16_t count, error_t error)
  {
    call StdOut.print("SDCard write done\n\r");
  }

  event void SDCard.readDone(uint32_t addr, uint8_t*buf, uint16_t count, error_t error)
  {
    call StdOut.print("SDCard read done\n\r");
  }

  /***************************************************************************/
  /* TIMER                                                                   */
  /***************************************************************************/
  uint16_t counter;
  
  event void Timer.fired()
  {
    call StdOut.printBase10uint16(call Msp430Counter32khz.get());
    call StdOut.print("\n\r");                  
  }
  
  
  task void fileTestTask()
  {
    uint16_t i;
    char filename[13];
//    char dirname[13];

    f_mount(0, &myfs);        

    for (counter = 1002; counter < 10000; counter++)
    {
      sprintf(filename, "data/%d.txt", counter);

//      call StdOut.print("mkdir: ");
//      call StdOut.printBase10uint8(f_mkdir(dirname));                  
//      call StdOut.print("\n\r");                  

      call StdOut.print("open: ");
      call StdOut.printBase10uint8(f_open(&myfile, filename, FA_WRITE | FA_OPEN_ALWAYS));                  
      call StdOut.print("\n\r");                  

      call StdOut.print("seek: ");
      call StdOut.printBase10uint8(f_lseek(&myfile, f_size(&myfile)));                  
      call StdOut.print("\n\r");                  

      call StdOut.print("printf: ");
      call StdOut.printBase10uint8(f_printf(&myfile, "%ld\n", call MilliCounter.get()));                  
      call StdOut.print("\n\r");                  

      for (i = 0; i < 1024; i++)
      {
        f_printf(&myfile, "123456789\n");
//        call StdOut.print("printf: ");
//        call StdOut.printBase10uint8(f_printf(&myfile, "%ld\n", call MilliCounter.get()));                  
//        call StdOut.print("\n\r");                  
      }

      call StdOut.print("printf: ");
      call StdOut.printBase10uint8(f_printf(&myfile, "%ld\n", call MilliCounter.get()));                  
      call StdOut.print("\n\r");                  
      
      f_close(&myfile);

      call StdOut.print(filename);
      call StdOut.print("\n\r");                  

      call Leds.led1Toggle();
    }

    f_mount(0, NULL);        

    call Leds.led0On();
  }

  async event void Msp430Counter32khz.overflow()
  {
//    call Leds.led0Toggle();
  }


  async event void MilliCounter.overflow()
  {
//    call Leds.led0Toggle();
  }

  /***************************************************************************/
  /* SERIAL                                                                  */
  /***************************************************************************/

  uint8_t tmpchar;
  uint16_t i;

  task void StdOutTask()
  {    
    char str[2];    
    atomic str[0] = tmpchar;
    
    switch(str[0]) {

      case '1':   if (call Resource.request() == FAIL)
                    call StdOut.print("Start Fail\n\r");
                  break;

      case '0':   if (call Resource.release() == SUCCESS)
                    call StdOut.print("Resource released\n\r");
                  break;

      case 'p':   call StdOut.print("print:\n\r");
                  for (i = 0; i < 512; i++)
                  {
                    call StdOut.printHex(buffer[i]);
                  }
                  call StdOut.print("\n\r");
                  break;

      case 'c':   call StdOut.print("clear:\n\r");
                  for (i = 0; i < 512; i++)
                  {
                    buffer[i] = 0;
                  }
                  break;

      case 'w':   call StdOut.print("write:\n\r");      
                  for (i = 0; i < 512; i++)
                  {
                    buffer[i] = i;
                  }

                  call StdOut.printBase10uint8(call SDCard.write(0, buffer, 512));
                  break;

      case 'r':   call StdOut.print("read:\n\r");      
                  call SDCard.read(10, buffer, 256);
                  break;

      case 't':   
                  post fileTestTask();
                  break;


      case '2':   call StdOut.print("write (2):\n\r");      
                  for (i = 0; i < 512; i++)
                  {
                    buffer[i] = 2;
                  }
                  call SDCard.write(0, buffer, 512);
                  
                  break;

      case '3':   call StdOut.print("read (2):\n\r");      
                  call SDCard.read(0, buffer, 512);
                  break;


      case 'e':   
                  call StdOut.print("erase:\n\r");      
                  call SDCard.clearSectors(0, 1);
                  break;

      case 'f':
                  f_mount(0, &myfs);        
//                  f_getfree(0, &fre_clust, &fs);

                  /* Get total sectors and free sectors */
                  tot_sect = (myfs.n_fatent - 2) * myfs.csize;
                  fre_sect = fre_clust * myfs.csize;

                  f_mount(0, NULL);        

                  /* Print free space in unit of KB (assuming 512 bytes/sector) */
                  call StdOut.printBase10uint32(tot_sect >> 1);
                  call StdOut.print(" KB total drive space\n\r");
                  call StdOut.printBase10uint32(fre_sect >> 1);
                  call StdOut.print(" KB free drive space\n\r");
                  break;

      case 'm':   
                  f_mount(0, &myfs);        
                  
                  f_open(&myfile, "1.1G", FA_READ);
                  
                  call StdOut.print("read:\n\r");      

                  f_read(&myfile, buffer, 11, &br);
                  f_close(&myfile);
                  f_mount(0, NULL);        

                  buffer[12] = '\0';
                  call StdOut.print((char*)buffer);      
                  call StdOut.print("\n\r Bytes:");      
                  call StdOut.printBase10uint16(br);
                  call StdOut.print("\n\r");      
                  break;

      case 's':   
                  f_mount(0, &myfs);        
                  
                  f_open(&myfile, "test02.txt", FA_WRITE | FA_OPEN_ALWAYS);
                  
                  f_lseek(&myfile, f_size(&myfile));
                  
                  call StdOut.print("write:\n\r");      
                  for (i = 0; i < 512; i++)
                  {
                    buffer[i] = i;
                  }

                  call StdOut.printBase10uint16(f_write(&myfile, buffer, 256, &br));
                  call StdOut.print("\n\r");      

                  call StdOut.printBase10uint16(f_close(&myfile));
                  call StdOut.print("\n\r");      

                  f_mount(0, NULL);        

//                  buffer[256] = '\0';
//                  call StdOut.print(buffer);      
//                  call StdOut.print("\n\r");      
//                  call StdOut.printBase10uint16(br);
//                  call StdOut.print("\n\r");      

//                  call StdOut.print("size: ");      
//                  call StdOut.printBase10uint32(call SDCard.readCardSize());
//                  call StdOut.print("\n\r");      
                  break;                  


      case 'q':   if (call Timer.isRunning())
                    call Timer.stop();
                  else
                    call Timer.startPeriodic(1024);
                  break;                  

      case '\r':  call StdOut.print("\n\r");
                  break;
                  
      default:    str[1] = '\0';
                  call StdOut.print(str);
                  break;
     }
  }
  
  /* incoming serial data */
  async event void StdOut.get(uint8_t data) 
  {
    call Leds.led2Toggle();

    tmpchar = data;
    
    post StdOutTask();
  }



  /***************************************************************************/
  /***************************************************************************/
  /***************************************************************************/

}
