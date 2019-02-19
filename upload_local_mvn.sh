#!/bin/bash
mvn install:install-file -Dfile=/Users/aaron/Code/Java/Jinuo/ACE/local_jar/bean-utils-1.0.jar -DgroupId=com.dcb -DartifactId=bean-utils -Dversion=1.0 -Dpackaging=jar
mvn install:install-file -Dfile=/Users/aaron/Code/Java/Jinuo/ACE/local_jar/common-utils-1.0.jar -DgroupId=com.dcb -DartifactId=common-utils -Dversion=1.0 -Dpackaging=jar
