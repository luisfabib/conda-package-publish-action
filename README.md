# Build and Publish Anaconda Package

A Github Action to publish your software package to an Anaconda repository.

### Example workflow to publish to conda every time you make a new release

```yaml
name: publish_conda

on:
  release:
    types: [published]
    
jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: publish-to-conda
      uses: maxibor/conda-package-publish-action@v1.1
      with:
        subDir: 'conda'
        AnacondaToken: ${{ secrets.ANACONDA_TOKEN }}
        platforms: 'win osx linux'
        arch: '32 64'
```

### Example project structure

```
.
├── LICENSE
├── README.md
├── myproject
│   ├── __init__.py
│   └── myproject.py
├── conda
│   ├── build.sh
│   └── meta.yaml
├── .github
│   └── workflows
│       └── publish_conda.yml
├── .gitignore
```
### Inputs

The action takes the following 

- `AnacondaToken` - Anaconda access Token (see below)

- `subDir` - (Optional) Sub-directory with conda recipe. Default: `.`

- `platforms` - (Optional) Platforms to build and publish. Default: `win osx linux`. (`win`: WinOS, `osx`: MacOS, `linux`: Linux)

- `arch` - (Optional) Architecture to build and publish. Default: `64`. (`32`: 32-bit, `64`: 64-bit)

### ANACONDA_TOKEN

1. Get an Anaconda token (with read and write API access) at `anaconda.org/USERNAME/settings/access` 
2. Add it to the Secrets of the Github repository as `ANACONDA_TOKEN`

### Build Channels
By Default, this Github Action will search for conda build dependancies (on top of the standard channels) in `conda-forge` and `bioconda`
