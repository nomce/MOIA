CC=gcc
CFLAGS=-c -Wall
ALLLIBS=fonctionsTCP
PROJET=TCP


all: ${PROJET}

${PROJET}: ${ALLLIBS}.a
	${CC} -Wall -o server${PROJET} server${PROJET}.c ${ALLLIBS}.a
	${CC} -Wall -o client${PROJET} client${PROJET}.c ${ALLLIBS}.a

${ALLLIBS}.a: ${ALLLIBS}.o
	ar ruv ${ALLLIBS}.a ${ALLLIBS}.o
	ranlib ${ALLLIBS}.a
	
${ALLLIBS}.o: ${ALLLIBS}.c
	${CC} ${CFLAGS} ${ALLLIBS}.c -o ${ALLLIBS}.o

clean:
	rm -rf *o
