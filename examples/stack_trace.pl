#!/usr/bin/perl

# Shows use of the stack_trace() and call_trace() functions

use strict;
use warnings;

use Log::Selective;

sub A() { B(); }
sub B() { C(); }
sub C() { D(); }

sub D() {
	stack_trace();
	LOG(-3, "Call trace:");
	call_trace();
}

A();
