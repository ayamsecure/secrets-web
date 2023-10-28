# Web Vault builds for Ayam Secure Secrets Web

- This repo is forked from bw_web_builds

### When a new vw-web-vault release has been published:

1. from terminal, `git checkout master` (ignore untracked changes) and then `git fetch upstream` and then `git merge upstream/master`
2. `git checkout release` and then `git rebase master` to bring in new changes into release branch
3. from release branch, create new version branch `git checkout -b 2023.8.2`
4. Create new patchfile based on latest patch, give it an additional decimal place (2023.8.2.1) so that when sorted it will be picked as latest, no need to update any other files
5. run SED commands on patchfile, run 2 manual deletes, then manually verify no other changes needed
6. ensure Dockerfile copy resources is set to: `COPY --chown=node:node resources-ayam /resources`
7. start colima (make sure it has at least 8 GB RAM) and then from project root run `make docker-extract`
8. this command first calls the `make docker` command which is the docker build on the default Dockerfile
9. move tar extract from docker_builds/ to artifacts/, then rsync to server web-vault dir
10. on server, `tar -xf name-of-archive.tar.bz2(gz) -C /path/to/dir`

```
docker build -f Dockerfile -t jayknyn/ayam-secrets-web:2023.9.1 .
```

### Patches to be made:

- run from project root

```
export PATCHFILE=patches/v2023.9.1.1.patch
sed -i 's#Vaultwarden wiki#Ayam Secure Secrets Docs#g' $PATCHFILE
sed -i 's#let title = "Vaultwarden Web"#let title = "Ayam Secure Secrets"#g' $PATCHFILE
sed -i 's#class="col">Vaultwarden Web<#class="col">Ayam Secure Secrets (powered by Bitwarden)<#g' $PATCHFILE
sed -i 's#A modified version of the Bitwarden&reg; Web Vault for Vaultwarden##' $PATCHFILE
sed -i 's#Vaultwarden Web<br#Ayam Secure Secrets (powered by Bitwarden)<br#g' $PATCHFILE
sed -i 's#Title="Vaultwarden Web"#Title="Ayam Secure Secrets"#g' $PATCHFILE
sed -i 's#href="https://github.com/dani-garcia/vaultwarden/"#href="https://ayamsecure.com/contact/"#g' $PATCHFILE
sed -i 's#<title page-title>Vaultwarden Web</title>#<title page-title>Ayam Secure Secrets Web Vault</title>#g' $PATCHFILE
sed -i 's#alt="Vaultwarden logo"#alt="Ayam Secure Secrets logo"#g' $PATCHFILE
sed -i 's#"name": "Vaultwarden Web"#"name": "Ayam Secure Secrets Web Vault"#g' $PATCHFILE
sed -i 's#otpauth://totp/Vaultwarden#otpauth://totp/AyamSecureSecrets#g' $PATCHFILE
sed -i 's#issuer=Vaultwarden#issuer=AyamSecureSecrets#g' $PATCHFILE

```

- manually delete 6 lines in frontend-layout.component "...unofficial..."
- in file "apps/web/src/app/layouts/footer.component.html" delete div containing col-8

### Project Setup:

1. Fork `https://github.com/dani-garcia/bw_web_builds` master branch to my master branch, create a release branch off of master and keep all my patches merged into release
2. Git clone repo and in master branch set upstream with: `git remote add upstream git@github.com:dani-garcia/bw_web_builds.git` and verify with `git remote -v`

### Reference:

- in std notes: "ayam secrets vaultwarden custom, web-vault"
