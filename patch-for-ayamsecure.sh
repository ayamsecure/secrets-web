#!/bin/bash
# patch file to replace Vaultwarden with Ayam Secure

export PATCHFILE=patches/v2025.1.1.1.patch
# 4 changes:
sed -i 's#https://vaultwarden#https://secrets#g' $PATCHFILE

# 2 changes:
sed -i 's#Vaultwarden wiki#Ayam Secure Secrets Docs#g' $PATCHFILE
sed -i 's#Vaultwarden CHANGES#Ayam Secure Changes#g' $PATCHFILE
sed -i 's#logo-themed" alt="Vaultwarden"#logo-themed" alt="Ayam Secure Secrets"#g' $PATCHFILE
sed -i 's#A modified version of the Bitwarden&reg; Web Vault for Vaultwarden##' $PATCHFILE

# 1 change:
sed -i 's#let title = "Vaultwarden Web"#let title = "Ayam Secure Secrets"#g' $PATCHFILE
sed -i 's#class="col">Vaultwarden Web<#class="col">Ayam Secure Secrets (powered by Bitwarden)<#g' $PATCHFILE
sed -i 's#Vaultwarden Web<br#Ayam Secure Secrets (powered by Bitwarden)<br#g' $PATCHFILE
sed -i 's#Title="Vaultwarden Web"#Title="Ayam Secure Secrets"#g' $PATCHFILE
sed -i 's#href="https://github.com/dani-garcia/vaultwarden"#href="https://ayamsecure.com/contact"#g' $PATCHFILE
sed -i 's#<title page-title>Vaultwarden Web</title>#<title page-title>Ayam Secure Secrets Web Vault</title>#g' $PATCHFILE
sed -i 's#"name": "Vaultwarden Web"#"name": "Ayam Secure Secrets Web Vault"#g' $PATCHFILE
sed -i 's#otpauth://totp/Vaultwarden#otpauth://totp/AyamSecureSecrets#g' $PATCHFILE
sed -i 's#issuer=Vaultwarden#issuer=AyamSecureSecrets#g' $PATCHFILE
sed -i 's#<div class="col-8 text-center">#<div class="col text-center">#g' $PATCHFILE
sed -i 's#left with a Vaultwarden icon#left with a Secrets icon#g' $PATCHFILE
sed -i 's#not supported by Vaultwarden#not supported by Ayam Secure Secrets#g' $PATCHFILE
sed -i 's#Vaultwarden Web#Ayam Secure Secrets#g' $PATCHFILE

