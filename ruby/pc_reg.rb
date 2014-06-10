# -*- coding: utf-8 -*-
require 'jubatus/regression/client'
require 'readline'
require 'pp'

NAME = "a"

stty_save = `stty -g`.chomp
trap("INT") { system "stty", stty_save; exit }

status = ["OS", "CPU(GHz)", "メモリ(GB)", "HDD(GB)", "SSD(GB)"]

loop do
  param = status.map{|s|
    v = Readline.readline("#{s} -> ", true)
    exit(0) if v.nil?
    v
  }
  p param
  cli = Jubatus::Regression::Client::Regression.new "127.0.0.1", 19198, NAME
  data = Jubatus::Common::Datum.new("os" => param[0],
                                    "cpu" => param[1].to_f,
                                    "memory" => param[2].to_f,
                                    "hdd" => param[3].to_f,
                                    "ssd" => param[4].to_f)
  result = cli.estimate [data]
  puts "推定値段 #{sprintf "%.2f",result[0]} 円"
  puts ""
end
