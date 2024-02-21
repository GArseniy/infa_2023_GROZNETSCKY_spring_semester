MAIN_FILE=main.c
OBJ_MAIN_FILE=main.o
EXE_MAIN_FILE=main.out


LIB_FILE=functions.asm
OBJ_LIB_FILE=functions.o


GCC_MAKE_OBJ=gcc -m32 -std=c99 -c ${MAIN_FILE} -o ${OBJ_MAIN_FILE}

NASM_MAKE_OBJ=nasm -f elf32 ${LIB_FILE} -o ${OBJ_LIB_FILE}

GCC_LINK=gcc -m32 ${OBJ_MAIN_FILE} ${OBJ_LIB_FILE} -o ${EXE_MAIN_FILE}

RUN=./${EXE_MAIN_FILE}

CLEAR_OBJ=rm *.o


all:
	@${GCC_MAKE_OBJ}
	@${NASM_MAKE_OBJ}
	@${GCC_LINK}


clear:
	@${CLEAR_OBJ}
