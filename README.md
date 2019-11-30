# lambda-layer-mecab-python3-neologd

### How to use

```python
import zipfile
import MeCab

with zipfile.ZipFile('/opt/neologd.zip') as neologd_zip:
    neologd_zip.extractall('/tmp')

tokenizer = MeCab.Tagger ('-d /tmp/neologd')
tokenizer.parse('')

text = '東京スカイツリーに観光に来ました。'
node = tokenizer.parseToNode(text)
while node:
    word = node.surface
    print(node.feature)
    node = node.next
```

### How to build MeCab & NEologd

```bash
docker build -t lambda-layer-mecab-python3-neologd:latest .
docker run -v $(pwd)/opt:/mnt -it lambda-layer-mecab-python3-neologd:latest
```

### How to deploy via AWS SAM

```bash
sam package --output-template-file package.yaml --s3-bucket <YOUR S3 BUCKET>

sam deploy --template-file package.yaml --stack-name <YOUR STACK NAME>
```
