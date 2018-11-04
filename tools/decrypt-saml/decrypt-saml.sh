#!/bin/bash
#
# https://crypto.stackexchange.com/questions/51713/decrypting-encrypted-saml-attributes-with-openssl
# https://security.stackexchange.com/questions/188457/how-can-i-use-openssl-to-decrypt-aes-encrypted-data-using-the-key-and-initializa
#

# Decrypted RSA PRIVATE KEY
SP_PRIVATE_KEY="spPrivateKeyFile.key"

function decrypt_aes_help()
{
	echo "decrypt-saml -- Decrypt SAML Response"
	echo "Usage:  decrypt-saml.sh <key_file> <data_file>"
	echo 
}

function decrypt_aes() 
{
	# aes key size: 128/192/256
    local CIPHER_KEY_FILE=$1
    local CIPHER_DATA_FILE=$2
    local AES_KEY_SIZE=$3

    #echo ">>> Create KEY with SALT"
    dos2unix ${CIPHER_KEY_FILE}
    sed -i '/^\s*$/d' ${CIPHER_KEY_FILE}
    base64 -d ${CIPHER_KEY_FILE} > cipherkey.bin
    openssl rsautl -decrypt -inkey ${SP_PRIVATE_KEY} -in cipherkey.bin -out plainkey.bin
    local KEY=$(xxd -p -c256 plainkey.bin)

    #echo ">>> Read IV"
    dos2unix ${CIPHER_DATA_FILE}
    sed -i '/^\s*$/d' ${CIPHER_DATA_FILE}
	base64 -d ${CIPHER_DATA_FILE} > cipherdata.bin  
    local IV=$(xxd -p -l 16 cipherdata.bin)

    #echo ">>> Decrypt RESPONSE"
    openssl aes-${AES_KEY_SIZE}-cbc -d -nopad -K $KEY -iv $IV -in cipherdata.bin | cut -b 17- 
}


key_file=$1
data_file=$2

if [ -z "$1" -o -z "$2" ]; then
	decrypt_aes_help
	exit 1
fi;

if [ ! -f "$key_file" ]; then
	echo "ERROR key_file does not exist: $key_file"
	echo
	decrypt_aes_help
	exit 1
elif [ ! -f "$data_file" ]; then
	echo "ERROR data_file does not exist: $data_file"
	echo
	decrypt_aes_help
	exit 1
elif [ ! -f "${SP_PRIVATE_KEY}" ]; then
	echo "ERROR SP_PRIVATE_KEY does not exist: $SP_PRIVATE_KEY"
	echo
	decrypt_aes_help
	exit 1
fi;

decrypt_aes $key_file $data_file 256
