# List all python prebuilt whl compatible with my environment  

Many packages don’t have a prebuilt `whl` file on [PyPI](pipy.org), and `cpython` packages don’t support semvers in most cases. Also, CPUs and `OS` are different. This tool helps you find supported package versions for your environment, so you can fetch them easily.  

### Usage  
```console  
$ ./find-prebuilt-python-package.sh numpy  

HOST: https://termux-user-repository.github.io  
numpy-1.24.1-cp310-cp310-linux_aarch64.whl  
```  

Now you can easily install `numpy` from `termux-user-repository.github.io` with Python `3.10`:  

```console  
$ python3.10 -m venv venv/  
$ source venv/bin/activate  
$ pip3.10 install --extra-index-url https://termux-user-repository.github.io/pypi/ numpy  
```  

### TODO  
- [ ] Remove `pip` from dependencies  
- [ ] Add intuitive flags to select different environments (CPU/OS/Python version)  
- [ ] Improve output formatting (e.g., JSON support)  
- [ ] Rewrite in a compiled language for better Windows support and faster execution  
- [ ] Add REST API/JavaScript for web integration (easier whl file detection)  
