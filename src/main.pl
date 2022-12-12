:- consult('auxiliar.pl').
:- consult('display.pl').
:- consult('menu.pl').
:- consult('play.pl').
:- consult('logic.pl').
:-use_module(library(lists)).
:-use_module(library(system)).
:-use_module(library(random)).

play :-
    menu(3,1).