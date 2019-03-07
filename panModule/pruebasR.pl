#!/usr/bin/perl


$k = "Pangenome86";


$R = Statistics::R->new(shared => 1);
$R->start();
$RUNPATH = getcwd();
$R->run("library(tidyverse)");



$R-> stop();
