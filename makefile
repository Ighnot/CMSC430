compile: scanner.o parser.o listing.o types.o
	g++ -o compile scanner.o parser.o listing.o types.o
	
scanner.o: scanner.c types.h listing.h tokens.h
	g++ -c scanner.c

scanner.c: scanner.l
	flex scanner.l
	mv lex.yy.c scanner.c

parser.o: parser.c types.h listing.h symbols.h
	g++ -c parser.c

parser.c tokens.h: parser.y
	bison -d -v parser.y
	mv parser.tab.c parser.c
	cp parser.tab.h tokens.h

listing.o: listing.cc listing.h
	g++ -c listing.cc

types.o: types.cc types.h
	g++ -c types.cc

clean:
	rm -f compile *.o tokens.h scanner.c parser.tab.h parser.output parser.c

test: compile
	./compile < test/semantic1.txt
	./compile < test/semantic2.txt
	./compile < test/semantic3.txt
	./compile < test/semantic4.txt
	./compile < test/semantic5.txt
	./compile < test/semantic6.txt
	./compile < test/semantic7.txt
	./compile < test/valid1.txt
	./compile < test/valid2.txt
	./compile < test/valid3.txt
	./compile < test/semantic8.txt
	./compile < test/semantic9.txt
	./compile < test/semantic10.txt
	./compile < test/semantic11.txt
	./compile < test/semantic12.txt
	./compile < test/semantic13.txt
	./compile < test/semantic14.txt
	./compile < test/semantic15.txt
	./compile < test/semantic16.txt
	./compile < test/semantic17.txt
	./compile < test/semantic18.txt
	./compile < test/semantic19.txt
