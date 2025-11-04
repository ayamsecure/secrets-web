# Web Vault builds for Ayam Secure Secrets Web

- This repo is forked from bw_web_builds

### When a new vw-web-vault release has been published:

1. from terminal, `git checkout master` (ignore untracked changes) then `git fetch upstream` then `git merge upstream/master` then `git push origin master`
2. `git checkout main-ayam` then `git merge master` to bring in new changes into main-ayam branch, resolve conflicts (accept incoming for ayam changes), `git add .` then `git commit` to conclude merge and `git push`
3. from main-ayam branch, create new version branch `git checkout -b 2025.1.1`
4. Create new patchfile based on latest patch, give it an additional decimal place (2025.1.1.1) so that when sorted it will be picked as latest, no need to update any other files
5. run SED commands (below) on patchfile, run 2 manual mulit-line deletes, then manually verify no other changes needed in `resources` dir

- verify login.component.html against upstream bitwarden-clients repos (find release, browse branch: clients/apps/web/src/app/auth/login/)
- verify locales/en/message.json against upstream (clients/apps/web/src/locales/en/messages.json)

6. ensure Dockerfile copy resources is set to: `COPY resources-ayam /resources`
7. git push changes and use colima x86 on optimac (16GB RAM, 4 CPU) (or jibhi3) (to follow upstream use of amd64 for web files build) to build image:
   `docker buildx build --platform linux/amd64 -f Dockerfile -t jayknyn/ayam-secrets-web:2025.1.1 --push .`
8. docker login then `docker push jayknyn/ayam-secrets-web:2025.1.1`
9. git push changes and after testing on staging service merge into main-ayam via PR
<!-- 7. start colima (make sure it has at least 8 GB RAM) and then from project root run `make docker-extract`
10. this command first calls the `make docker` command which is the docker build on the default Dockerfile
11. move tar extract from docker_builds/ to artifacts/, then rsync to server web-vault dir
12. on server, `tar -xf name-of-archive.tar.bz2(gz) -C /path/to/dir` -->

### Patches to be made:

- run `patch-for-ayamsecure.sh` from project root

- in section `frontend-layout.component` manually delete 5 lines inclusive of div tags (class small) "...unofficial..." and change `@@ -1,6 +1,11 @@` to `@@ -1,6 +1,6 @@`
- in section `anon-layout.component` manually delete 6 lines from `<br/> to closing </div>` and change `@@ -55,8 +55,14 @@` to `@@ -55,8 +55,8 @@`
- there are still 22 mentions of Vaultwarden, all around billing

- verify that in file `login.component.html`, replace createAccount messaging with contactSupport from messages.json

```
    <p class="tw-m-0 tw-text-sm">
      <a href="https://ayamsecure.com/contact">{{ 'contactSupport' | i18n }}</a>
    </p>
```

- verify that in `messages.json`, replace text for `loginOrCreateNewAccount` to: `Log in to access your secure vault.`

Patch Notes:

- for v2025.1.1, login component file name changed upstream
- for v2024.1.1b, change was reverting a fix in the v2024.1.0.patch, change reflected in v2024.1.0.1.patch
- for v2024.1.1, the only change was in the Dockerfile pointing to 2024.1.1 bw client hash updates, no new patchfile

Graphics notes:

- process to make svg: create png from canva > use photoroom.com/tools/background-remover make transparent > open in Inkspace desktop app, export as svg, ensure background is transparent > edit svg, remove fixed width and height

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
docker buildx build --platform linux/amd64 -f Dockerfile -t jayknyn/ayam-secrets-web:2025.1.1 --load .
```

- old docker build: `docker build -f Dockerfile -t jayknyn/ayam-secrets-web:2025.1.1 .`
