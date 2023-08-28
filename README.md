# Web Vault builds for Ayam Secure Secrets

- This repo is forked from bw_web_builds
- To build and extract for AS Secrets:

1. git checkout master, sync with upstream, git checkout new ayam branch using vw version (2023.7.1), git rebase master to get new changes
2. update Dockerfile copy resources to: `COPY --chown=node:node resources-ayam /resources`
3. No need to update any other files in /scripts
4. Create new patch based on latest patch, give it an additional decimal place (2023.7.1.1) so that when sorted it will be picked as latest
5. start colima (make sure it has at least 8 GB RAM) and then run `make docker-extract`
6. this command first calls the `make docker` command which is the docker build on the default Dockerfile
7. move extract from docker_builds/ to artifacts/, then rsync to server web-vault dir
8. on server, `tar -xf name-of-archive.tar.bz2(gz) -C /path/to/dir`

Reference std note: "ayam secrets vaultwarden custom, web-vault"

---

<br>

This is a repository to store the builds of the [Bitwarden web vault](https://github.com/bitwarden/clients/tree/master/apps/web) with the patches to make it work with [vaultwarden](https://github.com/dani-garcia/vaultwarden)

To create a patch you need to modify the original sources from [Bitwarden web vault](https://github.com/bitwarden/clients/tree/master/apps/web) and execute:

```bash
git --no-pager diff --submodule=diff --no-color --minimal
```

This is needed because there are patches within the jslib submodule which with a default `git diff` are not shown.

## Building the web-vault

To build the web-vault you need either node and npm installed or use Docker.

### Using node and npm

For a quick and easy local build you could run:

```bash
make full
```

That will generate a `tar.gz` file within the `builds` directory which you can extract and use with the `WEB_VAULT_FOLDER` environment variable.

### Using Docker

Or via the usage of Docker:

```bash
make docker-extract
```

That will extract the `tar.gz` and files generated via Docker into the `docker_builds` directory.

### More information

For more information see: [Install the web-vault](https://github.com/dani-garcia/vaultwarden/wiki/Building-binary#install-the-web-vault)

### Pre-build

The builds are available in the [releases page](https://github.com/dani-garcia/bw_web_builds/releases), and can be replicated with the scripts in this repo.

<br>

## Get in touch

To ask a question, offer suggestions or new features or to get help configuring or installing the software, please [use the forum](https://vaultwarden.discourse.group/).

If you spot any bugs or crashes with vaultwarden itself, please [create an issue](https://github.com/dani-garcia/vaultwarden/issues/). Make sure there aren't any similar issues open, though!

If you prefer to chat, we're usually hanging around at [#vaultwarden:matrix.org](https://matrix.to/#/#vaultwarden:matrix.org) room on Matrix. Feel free to join us!
