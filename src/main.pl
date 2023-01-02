%imports and modules needed to run
:- consult('logic.pl').
:- consult('auxiliar.pl').
:- consult('display.pl').
:- consult('menu.pl').
:- consult('play.pl').
:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(random)).

%play
%start predicate, which calls the main menu
play :-
    menu(3).