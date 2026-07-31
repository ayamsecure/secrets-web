# Web Vault builds for Ayam Secure Secrets Web

- This repo (`ayamsecure/secrets-web`) is forked from `dani-garcia/bw_web_builds` and `ayamsecure/secrets-web-source` is a fork of `vaultwarden/vw_web_builds` which is a fork of `bitwarden/clients`
- Upon new release, the flow is, in `secrets-web-source` apply patchfile (which is in secrets-web repo), copy favicon, push up, get commit hash. Then in `secrets-web`, do below steps to sync repo with `bw_web_builds` (to pickup Dockerfile changes), in Dockerfile, update `ARG VAULT_VERSION` with commit hash from `secrets-web-source`, build `secrets-web` image, then in `secrets` repo, use this image hash to build `secrets` images.

## When a new `dani-garcia/bw_web_builds` release has been published:

### First in `ayamsecure/secrets-web-source`:

1. from terminal `git fetch upstream`
2. then checkout specific upstream release branch (check which version of web build is included in latest vaultwarden release): vaultwarden/vw_web_builds/branches, `git checkout v2026.6.4`
3. create ayam specific branch `git checkout -b v2026.6.4-ayam`
4. apply patch: `git apply --reject --whitespace=fix /Users/jay/code/ayamsecure/secrets-web/resources-ayam/ayam-v5.patch`
5. if patch fails (any errors), resolve changes manually to the below 5 files, create new patch file, then apply favicon: `gacm 'applying ayam secrets patches'` then `git diff <latest-commit-hash-from-upstream-vw_web_builds> HEAD > /Users/jay/code/ayamsecure/secrets-web/resources-ayam/ayam-v6.patch`
6. Copy favicon: `cp /Users/jay/code/ayamsecure/secrets-web/resources-ayam/ayam-favicon.ico /Users/jay/code/ayamsecure/secrets-web-source/apps/web/src/favicon.ico` and `gacm 'applying favicon'`
7. Commit and push: `gacm 'applying ayam secrets patches'` then `git push`

### Then move to `ayamsecure/secrets-web`

1. from terminal, `git checkout master` (ignore untracked changes) then `git fetch upstream` then `git merge upstream/master` then `git push origin master`
2. `git checkout main-ayam` then `git merge master` to bring in new changes into main-ayam branch, resolve conflicts (accept incoming for ayam changes), `git add .` then `git commit` to conclude merge and `git push`
3. from `main-ayam` branch, create new version branch `git checkout -b 2026.6.4`
4. check for changes to Dockerfile (update commit hash of secrets-web-source) and `scripts/checkout_web_vault.sh` (ensure ayamsecure repo: ln 37, 52, 53, 54, 57)
5. use colima x86 on optimac (16GB RAM, 4 CPU) (or jibhi3) (to follow upstream use of amd64 for web files build) to build image: docker login, then `docker buildx build --platform linux/amd64 -f Dockerfile.ayam -t jayknyn/ayam-secrets-web:2026.6.4 --push .`
6. git push changes and after testing on staging service merge into main-ayam via PR
7. then move to `ayamsecure/secrets`

### Reference for files being patched in vw_web_builds

```sh
# Patch might fail if this code moves in upstream
apps/web/src/app/auth/settings/two-factor/two-factor-setup-authenticator.component.ts
- otpauth://totp/Vaultwarden > otpauth://totp/AyamSecureSecrets
- issuer=Vaultwarden > issuer=AyamSecureSecrets

apps/web/src/app/core/router.service.ts
- title = "Vaultwarden Web" > title = "Ayam Secure Secrets Web Vault"

apps/web/src/app/layouts/header/account-menu.component.html
- href="https://github.com/dani-garcia/vaultwarden" > href="https://ayamsecure.com/contact"

apps/web/src/index.html
- '<title page-title>Vaultwarden Web</title>' > '<title page-title>Ayam Secure Secrets Web Vault</title>'
- alt="Vaultwarden" > alt="Ayam Secure Secrets"

apps/web/src/manifest.json
- "name": "Vaultwarden Web" > "name": "Ayam Secure Secrets Web Vault"

```

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
