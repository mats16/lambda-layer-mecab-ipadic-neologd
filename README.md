# lambda-layer-mecab-neologd

### How to use in Lambda

1. Need to unzip `neologd.zip` to tmp directory.
2. Need to specify neologd directory when creating MeCab instance.

```python
import zipfile
import MeCab

# Unzip `neologd.zip` to tmp directory.
with zipfile.ZipFile('/opt/neologd.zip') as neologd_zip:
    neologd_zip.extractall('/tmp')

# Specify neologd directory
tokenizer = MeCab.Tagger ('-d /tmp/neologd')
tokenizer.parse('')

text = '東京スカイツリーに観光に来ました。'
node = tokenizer.parseToNode(text)
while node:
    word = node.surface
    print(node.feature)
    node = node.next
```

### How to build & deploy

First, you need to build a neologd zip file.

```bash
# Build MeCab & NEologd
docker build -t lambda-layer-mecab-neologd:latest .
docker run -v $(pwd)/opt:/mnt -it lambda-layer-mecab-neologd:latest cp -fr /opt/. /mnt/

# Deploy via AWS SAM
sam build
sam deploy --guided

sam deploy --parameter-overrides Description=$(date +%Y-%m-%d)
```
