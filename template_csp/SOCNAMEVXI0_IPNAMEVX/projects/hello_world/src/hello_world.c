

// Map printing functions to JTAG, UART or whatever is available
static void print_impl(const char*string){
    //TODO
}
#include "print.h"


int main(void){
  print("hello_world built on ");
  print(__DATE__);
  print(" ");
  println(__TIME__);
  println("");
  println("exit");
  return 0;
}
