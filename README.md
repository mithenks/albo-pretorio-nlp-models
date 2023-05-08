# Albo Pretorio NLP models

## Sentence detector

[Apache OpenNLP Manual - Chapter 3 - Sentence Detector](https://opennlp.apache.org/docs/2.2.0/manual/opennlp.html#tools.sentdetect)

### Model training

```bash
apache-opennlp-2.1.1/bin/opennlp SentenceDetectorTrainer -model models/albo-pretorio-sentence.model -lang it -data train-data/albo-pretorio-sentence.train -encoding UTF-8
```

### Evaluator

```bash
apache-opennlp-2.1.1/bin/opennlp SentenceDetectorEvaluator -model models/albo-pretorio-sentence.model -data train-data/albo-pretorio-sentence.train
```

#### Compare with default IT model

```bash
apache-opennlp-2.1.1/bin/opennlp SentenceDetectorEvaluator -model apache-opennlp-models-1.9.3/opennlp-it-ud-vit-sentence-1.0-1.9.3.bin -data train-data/albo-pretorio-sentence.train
```

### Test

```bash
apache-opennlp-2.1.1/bin/opennlp SentenceDetector models/albo-pretorio-sentence.model < albo-pretorio.test
```

#### Compare with default IT model

```bash
apache-opennlp-2.1.1/bin/opennlp SentenceDetector apache-opennlp-models-1.9.3/opennlp-it-ud-vit-sentence-1.0-1.9.3.bin < albo-pretorio.test
```


## Tokenizer

[Apache OpenNLP Manual - Chapter 4 - Tokenizer](https://opennlp.apache.org/docs/2.2.0/manual/opennlp.html#tools.tokenizer)

### Model training

```bash
apache-opennlp-2.1.1/bin/opennlp TokenizerTrainer -model models/albo-pretorio-token.model -lang it -data train-data/albo-pretorio-token.train -encoding UTF-8
```

### Evaluator

```bash
apache-opennlp-2.1.1/bin/opennlp TokenizerMEEvaluator -model models/albo-pretorio-token.model -data train-data/albo-pretorio-token.train
```

#### Compare with default IT model

```bash
apache-opennlp-2.1.1/bin/opennlp TokenizerMEEvaluator -model apache-opennlp-models-1.9.3/opennlp-it-ud-vit-tokens-1.0-1.9.3.bin -data train-data/albo-pretorio-token.train
```

### Test

```bash
cat albo-pretorio.test | \
apache-opennlp-2.1.1/bin/opennlp SentenceDetector models/albo-pretorio-sentence.model | \
apache-opennlp-2.1.1/bin/opennlp TokenizerME models/albo-pretorio-token.model
```

#### Compare with default IT model

```bash
cat albo-pretorio.test | \
apache-opennlp-2.1.1/bin/opennlp SentenceDetector apache-opennlp-models-1.9.3/opennlp-it-ud-vit-sentence-1.0-1.9.3.bin | \
apache-opennlp-2.1.1/bin/opennlp TokenizerME apache-opennlp-models-1.9.3/opennlp-it-ud-vit-tokens-1.0-1.9.3.bin
```


## Name finder (NER)

[Apache OpenNLP Manual - Chapter 5 - Name Finder](https://opennlp.apache.org/docs/2.2.0/manual/opennlp.html#tools.namefind)

### Model training

```bash
apache-opennlp-2.1.1/bin/opennlp TokenNameFinderTrainer -model models/albo-pretorio-ner.model -lang it -data train-data/albo-pretorio-ner.train -encoding UTF-8
```

### Evaluator 

```bash
apache-opennlp-2.1.1/bin/opennlp TokenNameFinderEvaluator -model models/albo-pretorio-ner.model -data train-data/albo-pretorio-ner.train
```

### Test

```bash
cat albo-pretorio.test | \
apache-opennlp-2.1.1/bin/opennlp SentenceDetector models/albo-pretorio-sentence.model | \
apache-opennlp-2.1.1/bin/opennlp TokenizerME models/albo-pretorio-token.model | \
apache-opennlp-2.1.1/bin/opennlp TokenNameFinder models/albo-pretorio-ner.model
```


## Reference

- [Apache OpenNLP Project](https://opennlp.apache.org/)
- [Apache OpenNLP 2.2.0 Manual](https://opennlp.apache.org/docs/2.2.0/manual/opennlp.html)


