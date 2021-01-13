OPENSSL := openssl

C := JP
ST := tokyo
L := chofu
O := The University of Electro-Communications
OU := Koken Club
DOMAIN := koken.club.uec.ac.jp

NULL :=
SPACE := $(NULL) $(NULL)
OPENSSL_RANDOM_FILE_DELIMITER := :

.PHONY: all clean
.PRECIOUS: %.key %.csr

help:
	@echo "Commands:"
	@echo "  %.csr  generate certificate signing request with private key"
	@echo "  %.key  generate private key"
	@echo "  clean  remove all generated files"
	@echo "  help   show this help message"

clean:
	$(RM) randfile*.txt *.key *.csr

randfile%.txt:
	$(OPENSSL) rand -base64 200000 > $@

%.key: randfile1.txt randfile2.txt randfile3.txt
	umask 77; \
	$(OPENSSL) genrsa -des3 -rand $(subst $(SPACE),$(OPENSSL_RANDOM_FILE_DELIMITER),$^) 2048 > $@

%.csr: %.key
	umask 77; \
	$(eval SJ := "/C=$(C)/ST=$(ST)/L=$(L)/O=$(O)/OU=$(OU)/CN=$*.$(DOMAIN)") \
	$(OPENSSL) req -batch -new -key $^ -sha256 -out $@ -subj $(SJ)

