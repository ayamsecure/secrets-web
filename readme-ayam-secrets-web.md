# Web Vault builds for Ayam Secure Secrets Web

- This repo is forked from bw_web_builds

### When a new vw-web-vault release has been published:

1. from terminal, `git checkout master` (ignore untracked changes) then `git fetch upstream` then `git merge upstream/master` then `git push origin master`
2. `git checkout main-ayam` then `git merge master` to bring in new changes into main-ayam branch, resolve conflicts (accept incoming for ayam changes), `git add .` then `git commit` to conclude merge and `git push`
3. from main-ayam branch, create new version branch `git checkout -b 2024.5.1`
4. Create new patchfile based on latest patch, give it an additional decimal place (2024.5.0.1) so that when sorted it will be picked as latest, no need to update any other files
5. run SED commands (below) on patchfile, run 1 manual mulit-line deletes, then manually verify no other changes needed (18 mentions still of vaultwarden)
6. ensure Dockerfile copy resources is set to: `COPY --chown=node:node resources-ayam /resources`
7. git push changes and use colima x86 on optimont (or jibhi3) (to follow upstream use of amd64 for web files build) to build image:
   `docker buildx build --platform linux/amd64 -f Dockerfile -t jayknyn/ayam-secrets-web:2024.5.1 --load .`
8. docker login then `docker push jayknyn/ayam-secrets-web:2024.5.1`
9. git push changes and after testing on staging service merge into main-ayam via PR
<!-- 7. start colima (make sure it has at least 8 GB RAM) and then from project root run `make docker-extract`
10. this command first calls the `make docker` command which is the docker build on the default Dockerfile
11. move tar extract from docker_builds/ to artifacts/, then rsync to server web-vault dir
12. on server, `tar -xf name-of-archive.tar.bz2(gz) -C /path/to/dir` -->

### Patches to be made:

- run from project root

```
export PATCHFILE=patches/v2024.5.0.1.patch
sed -i 's#Vaultwarden wiki#Ayam Secure Secrets Docs#g' $PATCHFILE    # 2 changes
sed -i 's#let title = "Vaultwarden Web"#let title = "Ayam Secure Secrets"#g' $PATCHFILE    # 1 change
sed -i 's#class="col">Vaultwarden Web<#class="col">Ayam Secure Secrets (powered by Bitwarden)<#g' $PATCHFILE    # 1 change
sed -i 's#A modified version of the Bitwarden&reg; Web Vault for Vaultwarden##' $PATCHFILE    # 2 changes
sed -i 's#Vaultwarden Web<br#Ayam Secure Secrets (powered by Bitwarden)<br#g' $PATCHFILE    # 1 change
sed -i 's#Title="Vaultwarden Web"#Title="Ayam Secure Secrets"#g' $PATCHFILE    # 1 change
sed -i 's#href="https://github.com/dani-garcia/vaultwarden"#href="https://ayamsecure.com/contact"#g' $PATCHFILE    # 1 change
sed -i 's#<title page-title>Vaultwarden Web</title>#<title page-title>Ayam Secure Secrets Web Vault</title>#g' $PATCHFILE    # 1 change
sed -i 's#logo-themed" alt="Vaultwarden"#logo-themed" alt="Ayam Secure Secrets"#g' $PATCHFILE    # 2 changes
sed -i 's#"name": "Vaultwarden Web"#"name": "Ayam Secure Secrets Web Vault"#g' $PATCHFILE    # 1 change
sed -i 's#otpauth://totp/Vaultwarden#otpauth://totp/AyamSecureSecrets#g' $PATCHFILE    # 1 change
sed -i 's#issuer=Vaultwarden#issuer=AyamSecureSecrets#g' $PATCHFILE    # 1 change
sed -i 's#<div class="col-8 text-center">#<div class="col text-center">#g' $PATCHFILE    # 1 change
sed -i 's#https://vaultwarden#https://secrets#g' $PATCHFILE    # 4 changes
sed -i 's#Vaultwarden CHANGES#Ayam Secure Changes#g' $PATCHFILE    # 2 changes
sed -i 's#left with a Vaultwarden icon#left with a Secrets icon#g' $PATCHFILE    # 1 change
sed -i 's#not supported by Vaultwarden#not supported by Ayam Secure Secrets#g' $PATCHFILE    # 1 change

```

- in section `frontend-layout.component` manually delete 5 lines inclusive of div tags (class small) "...unofficial..." and change `@@ -1,6 +1,11 @@` to `@@ -1,6 +1,6 @@`

- there are still 18 mentions of Vaultwarden, all around billing

Patch Notes:

- for v2024.5.1, actual release was 2024.5.1b and latest patchfile was 2024.5.0, so went with 2024.5.1 for image tag and branch name
- for v2024.1.1b, change was reverting a fix in the v2024.1.0.patch, change reflected in v2024.1.0.1.patch
- for v2024.1.1, the only change was in the Dockerfile pointing to 2024.1.1 bw client hash updates, no new patchfile

Old Notes:

```
- "Vaultwarden wiki" > "Ayam Secure Secrets Docs" x2
- "Vaultwarden Web" in x6 places
  - let title = "Vaultwarden Web" x1
  - class="col">Vaultwarden Web< x1
  - "A modified version..." x1
```

### Project Setup:

1. Fork `https://github.com/dani-garcia/bw_web_builds` master branch to my master branch, create a main branch off of master and keep all my patches merged into main
2. Git clone repo and in master branch set upstream with: `git remote add upstream git@github.com:dani-garcia/bw_web_builds.git` and verify with `git remote -v`

### Reference:

- in std notes: "ayam secrets vaultwarden custom, web-vault"

### Scratch

```
docker buildx build --platform linux/amd64 -f Dockerfile -t jayknyn/ayam-secrets-web:2024.5.1 --load .
```

- old docker build: `docker build -f Dockerfile -t jayknyn/ayam-secrets-web:2024.5.1 .`
