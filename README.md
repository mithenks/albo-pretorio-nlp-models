# Albo Pretorio NLP models

The purpose of this project is to build a natural language processing pipeline for data that come from [Albo Pretorio](https://it.wikipedia.org/wiki/Albo_pretorio). 

To run the pipeline, simply exec `run.sh` script:
```
$ ./run.sh 
Training sentence model...OK
Training token model...OK
Training ner model...OK
Evaluating sentence model...OK (Precision: 0.7 Recall: 0.5833333333333334 F-Measure: 0.6363636363636365)
Evaluating token model...OK (Precision: 0.9484536082474226 Recall: 0.8846153846153846 F-Measure: 0.9154228855721392)
Evaluating ner model...OK (Precision: 66.67% Recall: 100.00% F-Measure: 80.00%)

--------------------------
** Running NLP pipeline **

Procedura tramite Trattativa Diretta MEPA per il servizio di Gestione completa dei verbali CDS inclusa fornitura Software in modalità CLOUD e servizi accessori.
CIG: 9733476E7B

Rendiconto della Gestione relativo all'esercizio finanziario 2022 : Riaccertamento Ordinario dei Residui Attivi e Passivi al 31.12.2022 - <START:riferimento_legislativo> Art. 228 D.Lgs 267/2000 AREA <END> P.O.
POLIZIA MUNICIPALE

ACQUISTO DI PC PORTATILI .
ADESIONE CONVENZIONE CONSIP SPA.
LIQUIDAZIONE DI SPESA.

LAVORI DI RIGENERAZIONE DELLA PISTA DI ATLETICA STADIO DIRCEU .
CODICE CUP H25E20000410001 - <START:cig> CIG 9788571852 <END> .
IMPEGNO DI SPESA E DETERMINA A CONTRARRE AI SENSI <START:riferimento_legislativo> DELL'ARTICOLO 192 DEL D.LGS. N. 267/2000 <END> .
```

## About Apache OpenNLP

> The Apache OpenNLP library is a machine learning based toolkit for the processing of natural language text. It supports the most common NLP tasks, such as tokenization, sentence segmentation, part-of-speech tagging, named entity extraction, chunking, parsing, and coreference resolution. These tasks are usually required to build more advanced text processing services. OpenNLP also includes maximum entropy and perceptron based machine learning.


## Sentence detector

[Apache OpenNLP Manual - Chapter 3 - Sentence Detector](https://opennlp.apache.org/docs/2.2.0/manual/opennlp.html#tools.sentdetect)

> The OpenNLP Sentence Detector can detect that a punctuation character marks the end of a sentence or not. In this sense a sentence is defined as the longest white space trimmed character sequence between two punctuation marks. The first and last sentence make an exception to this rule. The first non whitespace character is assumed to be the start of a sentence, and the last non whitespace character is assumed to be a sentence end.

> Usually Sentence Detection is done before the text is tokenized and that's the way the pre-trained models on the website are trained, but it is also possible to perform tokenization first and let the Sentence Detector process the already tokenized text. The OpenNLP Sentence Detector cannot identify sentence boundaries based on the contents of the sentence. A prominent example is the first sentence in an article where the title is mistakenly identified to be the first part of the first sentence. Most components in OpenNLP expect input which is segmented into sentences.



### Model training

```bash
apache-opennlp-2.1.1/bin/opennlp \
    SentenceDetectorTrainer \
    -model models/albo-pretorio-sentence.model \
    -lang it \
    -encoding UTF-8 \
    -data train-data/albo-pretorio-sentence.train
```

### Evaluator

```bash
apache-opennlp-2.1.1/bin/opennlp \
    SentenceDetectorEvaluator \
    -model models/albo-pretorio-sentence.model \
    -data test-data/albo-pretorio-sentence.test
```

#### Compare with default IT model

```bash
apache-opennlp-2.1.1/bin/opennlp \
    SentenceDetectorEvaluator \
    -model apache-opennlp-models-1.9.3/opennlp-it-ud-vit-sentence-1.0-1.9.3.bin \
    -data test-data/albo-pretorio-sentence.test
```

### Test

```bash
apache-opennlp-2.1.1/bin/opennlp \
    SentenceDetector \
    models/albo-pretorio-sentence.model < albo-pretorio.test
```

#### Compare with default IT model

```bash
apache-opennlp-2.1.1/bin/opennlp \
    SentenceDetector \
    apache-opennlp-models-1.9.3/opennlp-it-ud-vit-sentence-1.0-1.9.3.bin < albo-pretorio.test
```


## Tokenizer

[Apache OpenNLP Manual - Chapter 4 - Tokenizer](https://opennlp.apache.org/docs/2.2.0/manual/opennlp.html#tools.tokenizer)

> The OpenNLP Tokenizers segment an input character sequence into tokens. Tokens are usually words, punctuation, numbers, etc.

### Model training

```bash
apache-opennlp-2.1.1/bin/opennlp \
    TokenizerTrainer \
    -model models/albo-pretorio-token.model \
    -lang it \
    -encoding UTF-8 \
    -data train-data/albo-pretorio-token.train 
```

### Evaluator

```bash
apache-opennlp-2.1.1/bin/opennlp \
    TokenizerMEEvaluator \
    -model models/albo-pretorio-token.model \
    -data test-data/albo-pretorio-token.test
```

#### Compare with default IT model

```bash
apache-opennlp-2.1.1/bin/opennlp \
    TokenizerMEEvaluator \
    -model apache-opennlp-models-1.9.3/opennlp-it-ud-vit-tokens-1.0-1.9.3.bin \
    -data test-data/albo-pretorio-token.test
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


## Name finder (NER - Named Entity Recognition)

[Apache OpenNLP Manual - Chapter 5 - Name Finder](https://opennlp.apache.org/docs/2.2.0/manual/opennlp.html#tools.namefind)

> To find names in raw text the text must be segmented into tokens and sentences.

> A training file can contain multiple types. If the training file contains multiple types the created model will also be able to detect these multiple types.

> The training data should contain at least 15000 sentences to create a model which performs well.



### Model training

```bash
apache-opennlp-2.1.1/bin/opennlp \
    TokenNameFinderTrainer \
    -model models/albo-pretorio-ner.model \
    -lang it \
    -encoding UTF-8 \
    -data train-data/albo-pretorio-ner.train
```

### Evaluator 

```bash
apache-opennlp-2.1.1/bin/opennlp \
    TokenNameFinderEvaluator \
    -model models/albo-pretorio-ner.model \
    -data test-data/albo-pretorio-ner.test
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


