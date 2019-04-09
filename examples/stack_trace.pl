#!/usr/bin/perl

# Shows use of the stack_trace() and call_trace() functions

use strict;
use warnings;

use Log::Selective;

sub D() {
	stack_trace();
	LOG(-3, "Call trace:");
	call_trace();
}

sub C() { D(); }
sub B() { C(); }
sub A() { B(); }

A();
