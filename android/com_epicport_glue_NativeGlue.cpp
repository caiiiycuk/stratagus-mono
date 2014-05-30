#include "include/com_epicport_glue_NativeGlue.h"

extern int epicport_game_mode;

extern int epicport_inc_gold;
extern int epicport_inc_oil;
extern int epicport_inc_wood;

JNIEXPORT jint JNICALL Java_com_epicport_glue_NativeGlue_gameMode
  (JNIEnv *, jclass) {
  return epicport_game_mode;   
}

JNIEXPORT void JNICALL Java_com_epicport_glue_NativeGlue_buyResource
  (JNIEnv *, jclass, jint resource, jint inc) {
    if (resource == 1) {
      epicport_inc_gold += inc;
    }

    if (resource == 2) {
      epicport_inc_oil += inc;
    }

    if (resource == 3) {
      epicport_inc_wood += inc;
    }
}