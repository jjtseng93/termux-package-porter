# downloading model
- do not use llama-cli -hf ggml-org/gemma-3-1b-it-GGUF
- because it requires configuring ca certificates
- go and search for ggml hugging face

```shell
run wget --no-check-certificate https://huggingface.co/ggml-org/gemma-3-1b-it-GGUF/resolve/main/gemma-3-1b-it-Q4_K_M.gguf?download=true
# or use 4b version with enough RAM
run llama-cli -m 'gemma-3-1b-it-Q4_K_M.gguf?download=true'
```
- run is the alias of sh $PKG_PDIR/no_backup/r
- in fish use sh $shr
