
export private key and connect to server:

```
tr output --raw > rsa_id
chmod 600 rsa_id
ssh -i rsa_id root@$(tr output --raw)
```
