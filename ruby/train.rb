#! /usr/bin/ruby
# -*- coding: utf-8 -*-
require 'jubatus/regression/client'
require 'yaml'
require 'pp'

NAME = "A"
filename = ARGV[0].to_s
puts "train by #{filename}"

File.open(filename, "r") {|f|
  f.each_line {|line|
    next if line =~ /^#/
    matched = /^([^,]+),(.*),([^,]+),([^,]+),([^,]+),([^,]+)$/.match(line).captures
    price, os, cpu, memory, hdd, ssd = *matched
    cli = Jubatus::Regression::Client::Regression.new "127.0.0.1", 19198, NAME
    datum = Jubatus::Common::Datum.new("os" => os,
                                       "cpu" => cpu.to_f,
                                       "memory" => memory.to_f,
                                       "hdd" => hdd.to_f,
                                       "ssd" => ssd.to_f)
    cli.train [[price.to_f, datum]]
    puts "train: OS->#{os}\tCPU->#{cpu.to_f}GHz\tメモリ->#{memory.to_f}GB\tHDD->#{hdd.to_f}GB\tSSD->#{ssd.to_f}GB => #{price}円"
  }
}
