#ifndef __GET_INPUT_H__
#define __GET_INPUT_H__

//assume following function is defined:
//unsigned int get_until_impl(char*buf,unsigned int size,const char*const separators,unsigned int nsep)

#include <stdint.h>
#include <stdlib.h>

static unsigned int get_until(char*buf,unsigned int size,const char*const separators,unsigned int nsep){
    return get_until_impl(buf,size,separators,nsep);
}
static unsigned int get_line(char*buf,unsigned int size){
    char*separators="\n";
    return get_until(buf,size,separators,2);//sizeof(separators));
}
static uint64_t get_uint(char*buf,unsigned int size){
    char*separators=" \t\n";
    get_until(buf,size,separators,4);//sizeof(separators));
    uint64_t out = strtoul(buf,0,0);
    return out;
}
#endif