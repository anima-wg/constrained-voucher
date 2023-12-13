mbedtls_x509_crt cert;
mbedtls_x509_crt caCert;
uint32_t         certVerifyResultFlags;
// ...
int result = mbedtls_x509_crt_verify(&cert, &caCert, NULL, NULL,
                             &certVerifyResultFlags, NULL, NULL);
