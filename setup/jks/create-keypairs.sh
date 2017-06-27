#!/bin/bash

# NOTE:
# * keytool
#   + https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html
# * store type: jks, or pkcs12
# * key algorithms: rsa, or ec
# * signature algorithms
#   + http://docs.oracle.com/javase/8/docs/technotes/guides/security/StandardNames.html#Signature
#     SHA1withRSA      SHA1withECDSA
#     SHA224withRSA    SHA224withECDSA
#     SHA256withRSA    SHA256withECDSA
#     SHA384withRSA    SHA384withECDSA
#     SHA512withRSA    SHA512withECDSA
#
myAlias="myalias"
myAliasPassword="changeit"
myStoreName="keystore.jks"
myStoreType="jks"  ## don't chanage this...
myStorePassword="changeit"

myValDays="356"

myEmail="hello@world.com"
myCommonName="www.google.com"
myOrgUnit="Department"
myCompany="Company"
myCity="LA"
myState="CA"
myCountry="US"

function rsa_keys()
{
	myKeyAlg="rsa"
	myKeySize="1024"
	mySigAlg="SHA256withRSA"
}

function ec_keys()
{
	myKeyAlg="ec"
	myKeySize="256"
	mySigAlg="SHA256withECDSA"
}


# Use RSA
#rsa_keys
ec_keys

# Create the keystore
keytool -genkeypair -keyalg ${myKeyAlg} -keysize ${myKeySize} -sigalg ${mySigAlg} \
-alias ${myAlias} -keypass ${myAliasPassword} -validity ${myValDays} \
-keystore ${myStoreName} -storetype ${myStoreType} -storepass ${myStorePassword} \
-dname "emailAddress=${myEmail},CN=${myCommonName},O=${myCompany},OU=${myOrgUnit},L=${myCity},ST=${myState},C=${myCountry}"

# Convert to PKCS12 format
myP12StoreName=${myStoreName}.p12
keytool -importkeystore -noprompt -destkeystore ${myP12StoreName} -deststoretype PKCS12  \
-deststorepass ${myStorePassword} -destkeypass ${myAliasPassword} \
-srckeystore ${myStoreName} -srcstorepass ${myStorePassword} -srcalias ${myAlias} -srckeypass ${myAliasPassword}

# Extract encrypted private key, then decrypt it
myEncPrivateKey=${myAlias}_enc_private_key.pem
myPrivateKey=${myAlias}_private_key.pem
openssl pkcs12 -nocerts -in ${myP12StoreName} -passin pass:${myStorePassword} -out ${myEncPrivateKey} -passout pass:${myStorePassword}
openssl ${myKeyAlg} -text -in ${myEncPrivateKey} -passin pass:${myStorePassword} -out ${myPrivateKey}

# Extract public key
myPublicCert="${myAlias}_public_cert.pem"
openssl pkcs12 -clcerts -nokeys -in ${myP12StoreName} -passin pass:${myStorePassword} -out ${myPublicCert}
openssl x509 -text -in ${myPublicCert}
##keytool -printcert -file ${myPublicCert}
