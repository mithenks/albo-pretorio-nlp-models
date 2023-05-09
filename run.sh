#!/bin/bash

set -e

SENTENCE_MODEL="models/albo-pretorio-sentence.model"
TOKEN_MODEL="models/albo-pretorio-token.model"
NER_MODEL="models/albo-pretorio-ner.model"

SENTENCE_TRAIN="train-data/albo-pretorio-sentence.train"
TOKEN_TRAIN="train-data/albo-pretorio-token.train"
NER_TRAIN="train-data/albo-pretorio-ner.train"

SENTENCE_TEST="test-data/albo-pretorio-sentence.test"
TOKEN_TEST="test-data/albo-pretorio-token.test"
NER_TEST="test-data/albo-pretorio-ner.test"

# Train models

echo -n "Training sentence model..."
apache-opennlp-2.1.1/bin/opennlp \
    SentenceDetectorTrainer \
    -model "${SENTENCE_MODEL}" \
    -lang it \
    -encoding UTF-8 \
    -data "${SENTENCE_TRAIN}" > /dev/null 2>&1
echo "OK"

echo -n "Training token model..."
apache-opennlp-2.1.1/bin/opennlp \
    TokenizerTrainer \
    -model "${TOKEN_MODEL}" \
    -lang it \
    -encoding UTF-8 \
    -data "${TOKEN_TRAIN}" > /dev/null 2>&1
echo "OK"

echo -n "Training ner model..."
apache-opennlp-2.1.1/bin/opennlp \
    TokenNameFinderTrainer \
    -model "${NER_MODEL}" \
    -lang it \
    -encoding UTF-8 \
    -data "${NER_TRAIN}" > /dev/null 2>&1 
echo "OK"

# Evaluate models

echo -n "Evaluating sentence model..."
OUT=$(apache-opennlp-2.1.1/bin/opennlp \
    SentenceDetectorEvaluator \
    -model "${SENTENCE_MODEL}" \
    -data "${SENTENCE_TEST}" 2>/dev/null)

PRECISION=$(echo "${OUT}" | grep -i "Precision")
RECALL=$(echo "${OUT}" | grep -i "Recall")
FMEASURE=$(echo "${OUT}" | grep -i "F-Measure")


echo "OK (${PRECISION} ${RECALL} ${FMEASURE})"


echo -n "Evaluating token model..."
OUT=$(apache-opennlp-2.1.1/bin/opennlp \
    TokenizerMEEvaluator \
    -model "${TOKEN_MODEL}" \
    -data "${TOKEN_TEST}" 2>/dev/null)

PRECISION=$(echo "${OUT}" | grep -i "Precision")
RECALL=$(echo "${OUT}" | grep -i "Recall")
FMEASURE=$(echo "${OUT}" | grep -i "F-Measure")


echo "OK (${PRECISION} ${RECALL} ${FMEASURE})"

echo -n "Evaluating ner model..."
OUT=$(apache-opennlp-2.1.1/bin/opennlp \
    TokenNameFinderEvaluator \
    -model "${NER_MODEL}" \
    -data "${NER_TEST}" 2>/dev/null)

TOTAL=$(echo "${OUT}" | grep "TOTAL: ")
PRECISION=$(echo "${TOTAL}" | awk -F':' '{print $3}' | awk -F';' '{print $1}' | awk '{$1=$1};1')
RECALL=$(echo "${TOTAL}" | awk -F':' '{print $4}' | awk -F';' '{print $1}' | awk '{$1=$1};1')
FMEASURE=$(echo "${TOTAL}" | awk -F':' '{print $5}' | awk -F'.' '{print $1"."$2}' |awk '{$1=$1};1')

echo "OK (Precision: ${PRECISION} Recall: ${RECALL} F-Measure: ${FMEASURE})"

echo
echo "--------------------------"
echo "** Running NLP pipeline **"
echo 

cat albo-pretorio.test \
    | apache-opennlp-2.1.1/bin/opennlp \
        SentenceDetector \
       "${SENTENCE_MODEL}" 2>/dev/null \
    | apache-opennlp-2.1.1/bin/opennlp \
        TokenizerME \
        "${TOKEN_MODEL}" 2>/dev/null \
    | apache-opennlp-2.1.1/bin/opennlp \
        TokenNameFinder \
        "${NER_MODEL}" 2>/dev/null
