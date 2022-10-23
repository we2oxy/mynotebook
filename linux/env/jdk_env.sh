#!/bin/bash

export JAVA_HOME=/opt/env/openjdk-8u292-b10
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$JAVA_HOME/bin:$PATH
