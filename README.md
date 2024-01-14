# Web Vault builds for Ayam Secure Secrets Web

- This repo is forked from bw_web_builds

### When a new vw-web-vault release has been published:

1. from terminal, `git checkout master` (ignore untracked changes) and then `git fetch upstream` and then `git merge upstream/master`
2. `git checkout release` and then `git rebase master` to bring in new changes into release branch
3. from release branch, create new version branch `git checkout -b 2023.8.2`
4. Create new patchfile based on latest patch, give it an additional decimal place (2023.8.2.1) so that when sorted it will be picked as latest, no need to update any other files
5. run SED commands on patchfile, manually verify no other changes needed
6. ensure Dockerfile copy resources is set to: `COPY --chown=node:node resources-ayam /resources`
7. start colima (make sure it has at least 8 GB RAM) and then from project root run `make docker-extract`
8. this command first calls the `make docker` command which is the docker build on the default Dockerfile
9. move tar extract from docker_builds/ to artifacts/, then rsync to server web-vault dir
10. on server, `tar -xf name-of-archive.tar.bz2(gz) -C /path/to/dir`

### Patches to be made:

```
export PATCHFILE=v2023.8.2.1.patch
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
```

- "Vaultwarden wiki" > "Ayam Secure Secrets Docs" x2
- "Vaultwarden Web" in x6 places
  - let title = "Vaultwarden Web" x1
  - class="col">Vaultwarden Web< x1
  - "A modified version..." x1

### Setup:

1. Fork `https://github.com/dani-garcia/bw_web_builds` master branch to my master branch, create a release branch off of master and keep all my patches merged into release
2. Git clone repo and in master branch set upstream with: `git remote add upstream git@github.com:dani-garcia/bw_web_builds.git` and verify with `git remote -v`

### Reference:

- in std notes: "ayam secrets vaultwarden custom, web-vault"

---

<br>

This is a repository to store the builds of the [Bitwarden web vault](https://github.com/bitwarden/clients/tree/main/apps/web) with the patches to make it work with [Vaultwarden](https://github.com/dani-garcia/vaultwarden)

To create a patch you need to modify the original sources from [Bitwarden web vault](https://github.com/bitwarden/clients/tree/main/apps/web) and execute:

```bash
git --no-pager diff --submodule=diff --no-color --minimal
```

## Building the web-vault

To build the web-vault you need either node and npm installed or use Docker.

### Using node and npm

For a quick and easy local build you could run:

```bash
make full
```

That will generate a `tar.gz` file within the `builds` directory which you can extract and use with the `WEB_VAULT_FOLDER` environment variable.

### Using a container

Or via the usage of building via a container:

```bash
make container-extract
```

That will extract the `tar.gz` and files generated via Docker into the `container_builds` directory.

#### Which container command to use, docker or podman

The default is to use `docker`, but `podman` works too.

You can force them by replacing `container` with either `docker` or `podman`, like:

```bash
make docker-extract
# Or
make podman-extract
```

You can configure the default via a `.env` file. See the `.env.template`.<br>
Or you can set it as a make argument with the make command:

```bash
make CONTAINER_CMD=podman container-extract
```

### More information

For more information see: [Install the web-vault](https://github.com/dani-garcia/vaultwarden/wiki/Building-binary#install-the-web-vault)

### Pre-build

The builds are available in the [releases page](https://github.com/dani-garcia/bw_web_builds/releases), and can be replicated with the scripts in this repo.

<br>

## Get in touch

If you spot any bugs or crashes with Vaultwarden itself, please [create an issue here](https://github.com/dani-garcia/vaultwarden/issues/). Make sure there aren't any similar issues open, though!

To ask a question, offer suggestions or new features or to get help configuring or installing the software, please use either [GitHub Discussions](https://github.com/dani-garcia/vaultwarden/discussions) or [the forum](https://vaultwarden.discourse.group/).

If you prefer to chat, we're usually hanging around at [#vaultwarden:matrix.org](https://matrix.to/#/#vaultwarden:matrix.org) room on Matrix. Feel free to join us!
