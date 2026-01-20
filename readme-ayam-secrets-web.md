# Web Vault builds for Ayam Secure Secrets Web

- This repo (`ayamsecure/secrets-web`) is forked from `dani-garcia/bw_web_builds` and `ayamsecure/secrets-web-source` is a fork of `vaultwarden/vw_web_builds` which is a fork of `bitwarden/clients`
- Upon new release, the flow is, in `secrets-web-source` apply patchfile (which is in this repo), copy favicon, push up, get commit hash. Then in `secrets-web`, do below steps to sync repo with `bw_web_builds` (to pickup Dockerfile changes), in Dockerfile, update `ARG VAULT_VERSION` with commit hash from `secrets-web-source`, build `secrets-web` image, then in `secrets` repo, use this image hash to build `secrets` images.

### When a new dani-garcia/bw_web_builds release has been published:

in `ayamsecure/secrets-web-source`:

1. from terminal `git fetch upstream`
2. then checkout specific upstream release branch: vaultwarden/vw_web_builds/branches, `git checkout v2025.12.0`
3. create ayam specific branch `git checkout -b v2025.12.0-ayam`
4. apply patch: `git apply --reject --whitespace=fix /Users/jay/codejk/ayam-secrets-web/resources-ayam/ayam-v4.patch`
5. Copy favicon: `cp /Users/jay/codejk/ayam-secrets-web/resources-ayam/ayam-favicon.ico /Users/jay/codejk/ayam-secrets-web-source/apps/web/src/favicon.ico`
6. If patch fails, resolve changes manually and create new patch file: `gacm 'updating patch'` then `git diff cc8cb941058fea67e525e6075ff13fc1f4aa924e HEAD > /Users/jay/codejk/ayam-secrets-web/resources-ayam/ayam-v4.patch`
7. push changes up

### Then move to `ayamsecure/secrets-web`

1. from terminal, `git checkout master` (ignore untracked changes) then `git fetch upstream` then `git merge upstream/master` then `git push origin master`
2. `git checkout main-ayam` then `git merge master` to bring in new changes into main-ayam branch, resolve conflicts (accept incoming for ayam changes), `git add .` then `git commit` to conclude merge and `git push`
3. from `main-ayam` branch, create new version branch `git checkout -b 2025.10.1`
4. use colima x86 on optimac (16GB RAM, 4 CPU) (or jibhi3) (to follow upstream use of amd64 for web files build) to build image: docker login, then `docker buildx build --platform linux/amd64 -f Dockerfile -t jayknyn/ayam-secrets-web:2025.10.1-2 --push .`
5. git push changes and after testing on staging service merge into main-ayam via PR

---

### Image details

- jayknyn/ayam-secrets-web:2025.10.1-6: built on 251202, using secrets-web-source branch, logos hidden on login page, vw logos in app
- jayknyn/ayam-secrets-web:2025.10.1-7: built on 260120, using vw branch

### OLD Patches to be made:

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

- for v2025.10.1, login component file name changed upstream
- for v2024.1.1b, change was reverting a fix in the v2024.1.0.patch, change reflected in v2024.1.0.1.patch
- for v2024.1.1, the only change was in the Dockerfile pointing to 2024.1.1 bw client hash updates, no new patchfile

Graphics notes:

- process to make svg: create png from canva > use photoroom.com/tools/background-remover make transparent > open in Inkspace desktop app, export as svg, ensure background is transparent > edit svg, remove fixed width and height

Old Notes:

```
4. run SED commands (below) on patchfile, run 2 manual mulit-line deletes, then manually verify no other changes needed in `resources` dir

- verify login.component.html against upstream bitwarden-clients repos (find release, browse branch: clients/apps/web/src/app/auth/login/)
- verify locales/en/message.json against upstream (clients/apps/web/src/locales/en/messages.json)
```

### Project Setup:

1. Fork `https://github.com/dani-garcia/bw_web_builds` master branch to my master branch, create a main branch off of master and keep all my patches merged into main
2. Git clone repo and in master branch set upstream with: `git remote add upstream git@github.com:dani-garcia/bw_web_builds.git` and verify with `git remote -v`

### Reference:

- in std notes: "ayam secrets vaultwarden custom, web-vault"

### Scratch

```
docker buildx build --platform linux/amd64 -f Dockerfile -t jayknyn/ayam-secrets-web:2025.10.1 --load .
```

- old docker build: `docker build -f Dockerfile -t jayknyn/ayam-secrets-web:2025.10.1 .`

```
# Using https://github.com/ayamsecure/secrets-web-source, always use commit hash
# a469bc8: secrets-web-source/commits/ayam-v2-v2025.10.1
# ARG VAULT_VERSION=a469bc86e55ee90eda6bb897fdc7b9738566fa72
# f2fac13: secrets-web-source/commits/v2025.10.1 (default vw)
```
