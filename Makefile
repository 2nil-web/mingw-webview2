
MAGICK=magick
RC=windres
STRIP=strip
UPX=upx

EXEXT=.exe
CPPFLAGS += -I WebView/include
#LDFLAGS += -L WebView/x64 -lWebView2Loader -mwindows
LDFLAGS += -mwindows
#LDFLAGS += -static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic
LDFLAGS += -static

PREFIX=webview2-mingw
SRCS=$(wildcard *.cpp)
OBJS=$(SRCS:.cpp=.o)
OBJS += ${PREFIX}_res.o

TARGET=${PREFIX}${EXEXT}

all : ${TARGET}

${TARGET} : ${OBJS} WebView2Loader.dll

${PREFIX}_res.o : ${PREFIX}.ico

WebView2Loader.dll : WebView/x64/WebView2Loader.dll
	cp WebView/x64/WebView2Loader.dll .

strip : $(TARGET)
	$(STRIP) $(TARGET) | true
	$(STRIP) WebView2Loader.dll | true

upx : strip
	$(UPX) $(TARGET) | true
	$(UPX) WebView2Loader.dll | true

clean :
	rm -f *~ ${PREFIX}.ico *.o $(OBJS)

rclean :
	rm -f *~ *.d ${PREFIX}.ico *.o $(OBJS) $(TARGET) WebView2Loader.dll


# Ces régles implicites ne sont pas utiles quand on fait 'make rclean' (voir même make clean ...)
ifneq ($(MAKECMDGOALS),rclean)
%.exe: %.o
	$(LINK.cpp) $^ $(LOADLIBES) $(LDLIBS) -o $@

%.exe: %.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

%.exe: %.cpp
	$(LINK.cc) $^ $(LOADLIBES) $(LDLIBS) -o $@

%.ico : %.png
	${MAGICK} convert -background none $< $@

%.ico : %.svg
	${MAGICK} convert -background none $< $@

# Régles pour construire les fichier objet d'après les .rc
%.o : %.rc
	$(RC) $(CPPFLAGS) $< --include-dir . $(OUTPUT_OPTION)

%.d: %.c
	@echo Checking header dependencies from $<
	@$(COMPILE.c) -isystem /usr/include -MM $< >> $@

#	@echo "Building "$@" from "$<
%.d: %.cpp
	@echo Checking header dependencies from $<
	@$(COMPILE.cpp) -isystem /usr/include -MM $< >> $@

# Inclusion des fichiers de dépendance .d
ifdef OBJS
-include $(OBJS:.o=.d)
endif
endif

